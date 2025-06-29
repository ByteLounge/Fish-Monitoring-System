
# Smart Aquarium Automation

This project is a **Smart Aquarium Management System** powered by **ESP32-CAM**, **YOLOv8 (TFLite)**, and a **Flutter app**.  
It handles:
- 🐟 Fish identification using AI (YOLOv8)
- 🌡 Automatic monitoring of temperature, pH, turbidity
- 🤖 Servo-controlled dispenser for food, acid, base
- 💧 Automated water change motor
- 🔋 Battery + inverter for backup
- 📷 ESP32-CAM for live monitoring
- 📱 Remote app control + notifications

---

## ⚙ **Components**
- ESP32-CAM AI Thinker module
- ESP32 main board
- DS18B20 temperature sensor
- pH sensor module
- Turbidity sensor
- 3x Servo motors (dispenser)
- Water pump (for water change)
- Aquarium heater/cooler
- LIPO battery + inverter module
- Flutter-based mobile app
- YOLOv8 trained model (converted to TFLite)

---

## 🛠 **ESP32 Features**
- Serves snapshot at `http://<ESP32_IP>/capture`
- Streams MJPEG at `http://<ESP32_IP>:81/stream`
- API endpoints for:
  - `dispenseFood`
  - `addAcid`
  - `addBase`
  - `waterChange`
- Periodic sensor readings + app push

---

## 📱 **Flutter App Features**
- Live ESP32-CAM stream viewer
- Fetch snapshot + run YOLOv8 detection
- Display fish info (species, thresholds, feeding habits)
- Control dispensers & motors remotely
- Detection overlays using `CustomPaint`
- Notifications on thresholds exceeded

---

## 🧠 **YOLOv8 AI**
- Custom dataset trained with YOLOv8
- Exported to TFLite:  
```

yolo export model=best.pt format=tflite

```
- Integrated with Flutter using `tflite_flutter`

---

## 🔌 **Connections**
| Component | ESP32 Pin |
|------------|-----------|
| Temp sensor | GPIO 4 |
| pH sensor | GPIO 34 (ADC) |
| Turbidity sensor | GPIO 35 (ADC) |
| Servo Food | GPIO 15 |
| Servo Acid | GPIO 13 |
| Servo Base | GPIO 12 |
| Water change motor | GPIO 14 |
| Heater/Cooler | Relay GPIO 5 |

---

## 🚀 **Setup Instructions**
### ESP32-CAM
- Upload provided `esp32_cam_snapshot.ino`
- Connect to Wi-Fi
- Note down IP address from Serial Monitor

### Flutter App
- Add your model in `assets/best.tflite`
- Update `pubspec.yaml`:
```

flutter:
assets:
\- assets/best.tflite

```
- Update ESP32 IP in code
- Run with:
```

flutter run

```

---

## 📂 **Project Structure**
```

/lib
├── main.dart
├── esp32\_stream\_view\.dart
├── painter.dart
├── yolo\_processor.dart
├── preprocessor.dart
/assets
└── best.tflite
/README.md
/esp32\_cam\_snapshot.ino

```

---

## 📌 **Notes**
✅ Uses `tflite_flutter` and `tflite_flutter_helper` for model inference  
✅ Uses `mjpeg` package for ESP32 stream  
✅ Compatible with Android and iOS  

---

## 💡 **Future Enhancements**
- Integrate cloud detection API for better scalability
- Add OTA updates for ESP32
- Implement advanced alert system (SMS / email)

---

Circuit outline

![circuit outline](https://github.com/user-attachments/assets/388d0720-fc29-4f49-b6e2-b4ed3c6afafe)

---

Prototype Image

![ChatGPT Image Jun 29, 2025, 01_47_16 PM](https://github.com/user-attachments/assets/cf494f44-c472-45ae-9333-b12630e216f2)

---

