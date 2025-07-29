import 'package:flutter/material.dart';

class RedThreadLoop extends StatelessWidget {
  final double size;
  final Widget child;
  const RedThreadLoop({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(size: Size(size, size), painter: _RedThreadLoopPainter()),
        child,
      ],
    );
  }
}

class _RedThreadLoopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB3001B)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 - 4,
      ),
    );
    // Add a knot
    path.moveTo(size.width * 0.7, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.3,
      size.width * 0.7,
      size.height * 0.4,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ProfilePage displays the user's profile
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RedThreadLoop(
              size: 140,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
              ),
            ),
            const SizedBox(height: 24),
            const Text('User profile info goes here.'),
          ],
        ),
      ),
    );
  }
}
