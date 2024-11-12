import 'package:flutter/material.dart';

class RCCustomUploadButton extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Gradient gradient;
  final Path? customShape;
  final double? borderRadius;

  const RCCustomUploadButton(
      {super.key,
        required this.child,
        this.strokeWidth = 2.0,
        required this.gradient,
        this.customShape,
        this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoundedRectangleBorderPainter(
        strokeWidth: strokeWidth,
        gradient: gradient,
        customShape: customShape,
        borderRadius: borderRadius,
      ),
      child: ClipPath(
        clipper: _RoundedRectangleBorderClipper(
          customShape: customShape,
          strokeWidth: strokeWidth,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class _RoundedRectangleBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;
  final Path? customShape;
  final double? borderRadius;

  _RoundedRectangleBorderPainter(
      {required this.strokeWidth,
        required this.gradient,
        this.customShape,
        this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = customShape ?? getDefaultShape(size);
    canvas.drawPath(path, paint);
  }

  Path getDefaultShape(Size size) {
    final rect = Offset.zero & size;
    final borderRadiusValue = BorderRadius.circular(borderRadius ?? 16.0);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, borderRadiusValue.topLeft));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoundedRectangleBorderClipper extends CustomClipper<Path> {
  final double strokeWidth;
  final Path? customShape;
  final double? borderRadius;

  _RoundedRectangleBorderClipper(
      {required this.strokeWidth, this.customShape, this.borderRadius});

  @override
  Path getClip(Size size) {
    return customShape ?? getDefaultShape(size);
  }

  Path getDefaultShape(Size size) {
    final rect = Offset.zero & size;
    final borderRadiusValue = BorderRadius.circular(borderRadius ?? 16);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, borderRadiusValue.topLeft));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}