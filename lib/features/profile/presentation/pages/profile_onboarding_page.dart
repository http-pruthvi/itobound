import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/profile_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ProfileOnboardingPage collects user info after registration
class ProfileOnboardingPage extends ConsumerStatefulWidget {
  const ProfileOnboardingPage({super.key});

  @override
  ConsumerState<ProfileOnboardingPage> createState() =>
      _ProfileOnboardingPageState();
}

class _ProfileOnboardingPageState extends ConsumerState<ProfileOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();
  String? _gender;
  List<XFile> _photos = [];
  XFile? _videoIntro;
  String? _zodiac;
  final List<String> _interests = [];
  final Map<String, dynamic> _preferences = {};
  String? _error;
  File? _photo;
  File? _video;
  bool _uploading = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _zodiacs = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];
  final List<String> _allInterests = [
    'Music',
    'Movies',
    'Sports',
    'Travel',
    'Art',
    'Tech',
    'Books',
    'Food',
    'Fitness',
    'Gaming',
    'Pets',
    'Nature',
  ];

  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => _photos = picked);
    }
  }

  Future<void> _pickVideoIntro() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _videoIntro = picked);
    }
  }

  Future<String?> _uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _video = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _uploading = true);
    if (_photo != null) {
      await _uploadFile(
        _photo!,
        'profile_photos/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    }
    if (_video != null) {
      await _uploadFile(
        _video!,
        'profile_videos/${DateTime.now().millisecondsSinceEpoch}.mp4',
      );
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await ref.read(profileControllerProvider).saveProfile(
            name: _nameController.text.trim(),
            bio: _bioController.text.trim(),
            age: int.tryParse(_ageController.text.trim()) ?? 0,
            gender: _gender ?? 'Other',
            photos: _photo != null ? [_photo!] : [],
            videoIntro: _video,
            voiceIntro: null,
            zodiacSign: _zodiac ?? '',
            interests: _interests,
            preferences: _preferences,
          );
    }
    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_photo != null)
                Image.file(_photo!, width: 120, height: 120, fit: BoxFit.cover),
              ElevatedButton(
                onPressed: _pickPhoto,
                child: const Text('Pick Profile Photo'),
              ),
              if (_video != null)
                const Icon(Icons.videocam, size: 48, color: Colors.red),
              ElevatedButton(
                onPressed: _pickVideo,
                child: const Text('Pick Video Intro'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name required' : null,
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Bio required' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Age required';
                  final age = int.tryParse(v);
                  if (age == null || age < 18) return 'Must be 18+';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                items: _genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v),
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (v) => v == null ? 'Gender required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _zodiac,
                items: _zodiacs
                    .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                    .toList(),
                onChanged: (v) => setState(() => _zodiac = v),
                decoration: const InputDecoration(labelText: 'Zodiac Sign'),
                validator: (v) => v == null ? 'Zodiac required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickPhotos,
                child: Text(_photos.isEmpty ? 'Pick Photos' : 'Change Photos'),
              ),
              if (_photos.isNotEmpty)
                Wrap(
                  children: _photos
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.file(
                            File(p.path),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ElevatedButton(
                onPressed: _pickVideoIntro,
                child: Text(
                  _videoIntro == null
                      ? 'Upload Video Intro'
                      : 'Change Video Intro',
                ),
              ),
              const SizedBox(height: 16),
              Text('Interests'),
              Wrap(
                spacing: 8,
                children: _allInterests
                    .map(
                      (interest) => FilterChip(
                        label: Text(interest),
                        selected: _interests.contains(interest),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _interests.add(interest);
                            } else {
                              _interests.remove(interest);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              // Preferences (for demo, just a text field)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Preferences (optional)',
                ),
                onChanged: (v) => _preferences['custom'] = v,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              _uploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveProfile();
                        }
                      },
                      child: const Text('Save Profile'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
