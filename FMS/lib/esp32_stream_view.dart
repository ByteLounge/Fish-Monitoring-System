import 'package:flutter/material.dart';
import 'package:mjpeg/mjpeg.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'painter.dart';
import 'yolo_processor.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ESP32StreamView extends StatefulWidget {
  final String url;
  ESP32StreamView({required this.url});

  @override
  _ESP32StreamViewState createState() => _ESP32StreamViewState();
}

class _ESP32StreamViewState extends State<ESP32StreamView> {
  late Interpreter _interpreter;
  List<Detection> _detections = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('best.tflite');
  }

  Future<void> _fetchAndRunYOLO() async {
    final response = await http.get(Uri.parse('${widget.url}/capture'));
    if (response.statusCode == 200) {
      final img.Image? image = img.decodeJpg(response.bodyBytes);
      if (image != null) {
        TensorImage tensorImage = TensorImage.fromImage(image);
        ImageProcessor processor = ImageProcessorBuilder()
          .add(ResizeOp(640, 640, ResizeMethod.BILINEAR))
          .build();
        tensorImage = processor.process(tensorImage);

        var output = List.generate(1, (i) => List.filled(25200 * 7, 0.0));
        _interpreter.run(tensorImage.buffer, output);

        var dets = processYOLOOutput(output, 0.5, 0.45);
        setState(() {
          _detections = dets;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Mjpeg(
          stream: '${widget.url}:81/stream',
          error: (context, error, stack) => Center(child: Text('Stream error')),
        ),
        CustomPaint(
          painter: DetectionPainter(_detections),
          child: Container(),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: ElevatedButton(
            onPressed: _fetchAndRunYOLO,
            child: Text("Run YOLO"),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }
}
