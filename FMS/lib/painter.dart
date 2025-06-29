import 'package:flutter/material.dart';
import 'yolo_processor.dart';

class DetectionPainter extends CustomPainter {
  final List<Detection> detections;
  DetectionPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final textStyle = TextStyle(color: Colors.red, fontSize: 12);

    for (var det in detections) {
      final left = det.x - det.w / 2;
      final top = det.y - det.h / 2;
      final rect = Rect.fromLTWH(left, top, det.w, det.h);
      canvas.drawRect(rect, paint);
      final textSpan = TextSpan(
        text: 'Class ${det.classIndex} ${(det.confidence * 100).toStringAsFixed(1)}%',
        style: textStyle,
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(left, top - 12));
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) {
    return oldDelegate.detections != detections;
  }
}
