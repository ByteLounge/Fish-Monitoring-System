import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'painter.dart';
import 'yolo_processor.dart';
import 'preprocessor.dart';

class CameraYOLOView extends StatefulWidget {
  @override
  _CameraYOLOViewState createState() => _CameraYOLOViewState();
}

class _CameraYOLOViewState extends State<CameraYOLOView> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  Interpreter? _interpreter;
  List<Detection> _detections = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initCamera();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('best.tflite');
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    _controller!.startImageStream((image) => _processCameraImage(image));
    setState(() {});
  }

  void _processCameraImage(CameraImage image) async {
    if (_interpreter == null) return;

    final rgbImage = convertYUV420toImageColor(image);
    final tensorImage = preprocessImage(rgbImage, 640);

    var output = List.generate(1, (i) => List.filled(25200 * 7, 0.0));
    _interpreter!.run(tensorImage.buffer, output);

    final dets = processYOLOOutput(output, 0.5, 0.45);
    setState(() {
      _detections = dets;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CameraPreview(_controller!),
        CustomPaint(
          painter: DetectionPainter(_detections),
          child: Container(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter?.close();
    super.dispose();
  }
}
