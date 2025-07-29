import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import 'register_page.dart';
import '../../../chat/application/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  void _afterLogin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final notificationService = NotificationService();
      await notificationService.requestPermission();
      await notificationService.saveTokenToFirestore(uid);
    }
  }

  void _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final auth = ref.read(authControllerProvider);
    final result = await auth.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _loading = false);
    if (result == null) {
      setState(() => _error = 'Login failed. Please check your credentials.');
    } else {
      _afterLogin();
    }
    // On success, navigation is handled by auth state listener in main app
  }

  void _loginWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final auth = ref.read(authControllerProvider);
    final result = await auth.signInWithGoogle();
    setState(() => _loading = false);
    if (result == null) {
      setState(() => _error = 'Google sign-in failed.');
    } else {
      _afterLogin();
    }
  }

  void _loginWithPhone() async {
    // For demo: show dialog to enter phone, then OTP
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    String? verificationId;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phone Sign-In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: 'OTP'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final auth = ref.read(authControllerProvider);
              await auth.signInWithPhone(
                phoneController.text.trim(),
                (vId, _) {
                  verificationId = vId;
                  // Show OTP field
                },
                (e) {
                  setState(() => _error = e.message);
                },
              );
            },
            child: const Text('Send OTP'),
          ),
          TextButton(
            onPressed: () async {
              if (verificationId != null) {
                final credential = PhoneAuthProvider.credential(
                  verificationId: verificationId!,
                  smsCode: otpController.text.trim(),
                );
                await FirebaseAuth.instance.signInWithCredential(credential);
                if (!mounted) return;
                Navigator.pop(context);
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login to ItoBound')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _loginWithGoogle,
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _loginWithPhone,
              child: const Text('Sign in with Phone'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
