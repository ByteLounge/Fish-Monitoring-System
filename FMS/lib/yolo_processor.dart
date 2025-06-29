import 'dart:math';

class Detection {
  double x, y, w, h, confidence;
  int classIndex;
  Detection(this.x, this.y, this.w, this.h, this.confidence, this.classIndex);
}

List<Detection> processYOLOOutput(List output, double confThreshold, double iouThreshold) {
  List<Detection> detections = [];

  for (var i = 0; i < output[0].length ~/ 7; i++) {
    var row = output[0].sublist(i * 7, (i + 1) * 7);
    double conf = row[4];
    if (conf < confThreshold) continue;

    List<double> classScores = row.sublist(5);
    int classIdx = classScores.indexWhere((score) => score == classScores.reduce(max));
    double classConf = classScores[classIdx] * conf;

    if (classConf > confThreshold) {
      detections.add(Detection(
        row[0], row[1], row[2], row[3],
        classConf, classIdx
      ));
    }
  }

  return nonMaxSuppression(detections, iouThreshold);
}

List<Detection> nonMaxSuppression(List<Detection> dets, double iouThreshold) {
  dets.sort((a, b) => b.confidence.compareTo(a.confidence));
  List<Detection> result = [];

  while (dets.isNotEmpty) {
    Detection best = dets.removeAt(0);
    result.add(best);
    dets = dets.where((d) => iou(best, d) < iouThreshold).toList();
  }

  return result;
}

double iou(Detection a, Detection b) {
  double x1 = max(a.x - a.w / 2, b.x - b.w / 2);
  double y1 = max(a.y - a.h / 2, b.y - b.h / 2);
  double x2 = min(a.x + a.w / 2, b.x + b.w / 2);
  double y2 = min(a.y + a.h / 2, b.y + b.h / 2);

  double interArea = max(0, x2 - x1) * max(0, y2 - y1);
  double unionArea = a.w * a.h + b.w * b.h - interArea;

  return interArea / unionArea;
}
