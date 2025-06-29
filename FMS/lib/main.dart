import 'package:flutter/material.dart';
import 'esp32_stream_view.dart';

void main() {
  runApp(MaterialApp(
    title: 'Smart Aquarium Detector',
    home: Scaffold(
      appBar: AppBar(title: Text('Aquarium Live Detection')),
      body: ESP32StreamView(url: 'http://YOUR_ESP32_IP'),
    ),
  ));
}
