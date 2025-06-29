import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

/// Converts YUV420 camera image to RGB image for inference
img.Image convertYUV420toImageColor(CameraImage image) {
  final int width = image.width;
  final int height = image.height;
  final img.Image imgRGB = img.Image(width, height);

  final yPlane = image.planes[0];
  final uPlane = image.planes[1];
  final vPlane = image.planes[2];

  final yBuffer = yPlane.bytes;
  final uBuffer = uPlane.bytes;
  final vBuffer = vPlane.bytes;

  int uvRowStride = uPlane.bytesPerRow;
  int uvPixelStride = uPlane.bytesPerPixel!;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
      final int index = y * width + x;

      final int yVal = yBuffer[index];
      final int uVal = uBuffer[uvIndex];
      final int vVal = vBuffer[uvIndex];

      int r = (yVal + (1.370705 * (vVal - 128))).round();
      int g = (yVal - (0.698001 * (vVal - 128)) - (0.337633 * (uVal - 128))).round();
      int b = (yVal + (1.732446 * (uVal - 128))).round();

      r = r.clamp(0, 255);
      g = g.clamp(0, 255);
      b = b.clamp(0, 255);

      imgRGB.setPixelRgb(x, y, r, g, b);
    }
  }

  return imgRGB;
}

/// Preprocess the RGB image for YOLO model (resize + normalize)
TensorImage preprocessImage(img.Image rgbImage, int inputSize) {
  TensorImage tensorImage = TensorImage.fromImage(rgbImage);

  final ImageProcessor processor = ImageProcessorBuilder()
      .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
      .build();

  tensorImage = processor.process(tensorImage);

  return tensorImage;
}
