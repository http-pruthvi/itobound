import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/demo_data_service.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final String matchId;
  final String otherUserId;
  final bool isIncoming;

  const VideoCallScreen({
    super.key,
    required this.matchId,
    required this.otherUserId,
    this.isIncoming = false,
  });

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  RtcEngine? _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool _muted = false;
  bool _videoEnabled = true;
  bool _speakerEnabled = true;
  bool _callConnected = false;
  Duration _callDuration = Duration.zero;
  
  // Demo mode - we'll simulate the call without actual Agora
  bool _isDemoMode = true;
  
  @override
  void initState() {
    super.initState();
    if (_isDemoMode) {
      _initializeDemoCall();
    } else {
      _initializeAgora();
    }
  }

  void _initializeDemoCall() {
    // Simulate call connection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _callConnected = true;
          _localUserJoined = true;
          _remoteUid = 12345; // Demo remote user ID
        });
        _startCallTimer();
      }
    });
  }

  void _startCallTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _callConnected) {
        setState(() {
          _callDuration = Duration(seconds: _callDuration.inSeconds + 1);
        });
        return true;
      }
      return false;
    });
  }

  Future<void> _initializeAgora() async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    // Create Agora engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: 'demo_app_id', // Replace with your Agora App ID
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
            _callConnected = true;
          });
          _startCallTimer();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableVideo();
    await _engine!.startPreview();
    await _engine!.joinChannel(
      token: '', // Use token for production
      channelId: widget.matchId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
    }
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = DemoDataService.getUsersMap()[widget.otherUserId];
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote video (full screen)
          _buildRemoteVideo(otherUser),
          
          // Local video (small overlay)
          _buildLocalVideo(),
          
          // Call info overlay
          _buildCallInfo(otherUser),
          
          // Control buttons
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildRemoteVideo(UserModel? otherUser) {
    if (_isDemoMode) {
      // Demo mode - show user's profile picture as background
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: otherUser?.profilePictureUrl != null
              ? DecorationImage(
                  image: NetworkImage(otherUser!.profilePictureUrl!),
                  fit: BoxFit.cover,
                )
              : null,
          color: Colors.grey[800],
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: _callConnected
              ? null
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Connecting...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }

    // Real Agora implementation
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.matchId),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Waiting for other user...',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }
  }

  Widget _buildLocalVideo() {
    return Positioned(
      top: 60,
      right: 20,
      child: Container(
        width: 120,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _isDemoMode
              ? Container(
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                )
              : _localUserJoined && _videoEnabled
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.videocam_off,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildCallInfo(UserModel? otherUser) {
    return Positioned(
      top: 60,
      left: 20,
      right: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            otherUser?.name ?? 'Unknown User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _callConnected
                ? _formatDuration(_callDuration)
                : widget.isIncoming
                    ? 'Incoming call...'
                    : 'Calling...',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _buildControlButton(
            icon: _muted ? Icons.mic_off : Icons.mic,
            onPressed: _toggleMute,
            backgroundColor: _muted ? Colors.red : Colors.white.withOpacity(0.2),
          ),
          
          // Video toggle button
          _buildControlButton(
            icon: _videoEnabled ? Icons.videocam : Icons.videocam_off,
            onPressed: _toggleVideo,
            backgroundColor: _videoEnabled ? Colors.white.withOpacity(0.2) : Colors.red,
          ),
          
          // End call button
          _buildControlButton(
            icon: Icons.call_end,
            onPressed: _endCall,
            backgroundColor: Colors.red,
            size: 60,
          ),
          
          // Speaker button
          _buildControlButton(
            icon: _speakerEnabled ? Icons.volume_up : Icons.volume_down,
            onPressed: _toggleSpeaker,
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
          
          // Switch camera button
          _buildControlButton(
            icon: Icons.flip_camera_ios,
            onPressed: _switchCamera,
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    double size = 50,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.4,
        ),
      ),
    );
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
    });
    if (!_isDemoMode) {
      _engine?.muteLocalAudioStream(_muted);
    }
  }

  void _toggleVideo() {
    setState(() {
      _videoEnabled = !_videoEnabled;
    });
    if (!_isDemoMode) {
      _engine?.muteLocalVideoStream(!_videoEnabled);
    }
  }

  void _toggleSpeaker() {
    setState(() {
      _speakerEnabled = !_speakerEnabled;
    });
    if (!_isDemoMode) {
      _engine?.setEnableSpeakerphone(_speakerEnabled);
    }
  }

  void _switchCamera() {
    if (!_isDemoMode) {
      _engine?.switchCamera();
    }
  }

  void _endCall() {
    Navigator.of(context).pop();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}