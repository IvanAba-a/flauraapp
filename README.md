# flauraapp

# FLAURA
**Project Title: **FLAURA: An Indoor Plant Monitoring App

**Description:** FLAURA is an IoT-enabled mobile application designed to help plant owners maintain optimal health for their indoor plants. By integrating real-time sensors with cloud computing, the app acts as a "digital voice" for plants, monitoring two critical survival factors: Soil Moisture and UV Sunlight Exposure.
The system utilizes an ESP32 microcontroller to transmit environmental data to Firebase, where it is instantly synced to a Flutter-based mobile dashboard. The app provides real-time visualizations, historical logs, and intelligent alerts (e.g., "Your Fern is thirsty!") based on specific plant requirements.

**Technologies Used: **
Mobile Application (Frontend)
Framework: Flutter (Dart)
State Management: StreamBuilder / Provider
Charts/Visuals: flutter_local_notifications (for alerts)
IoT & Hardware (Embedded)
Microcontroller: ESP32 Development Board

Sensors:
Capacitive Soil Moisture Sensor v1.2
GUVA-S12SD Analog UV Sensor
Language: C++ (Arduino Framework)
Libraries: Firebase_ESP_Client, ArduinoJson
Cloud Computing (Backend)
Platform: Google Firebase
Database: Firebase Realtime Database (NoSQL)
Authentication: Firebase Auth (Email/Password)

Features: 
🔐 User Authentication: Secure login and registration system to keep plant data private.
📊 Real-Time Dashboard: Live circular gauges displaying current Soil Moisture (%) and UV Index values with color-coded status indicators (Green=Healthy, Red=Critical).
🌿 Smart Plant Logic: Automatically compares sensor data against a "Plant Library" to determine if the specific plant (e.g., Cactus vs. Fern) is happy.
🔔 Intelligent Alerts: Triggers local push notifications when moisture drops below 35% or UV levels exceed safe limits.
📜History Logs: A detailed audit trail (ListView) showing timestamped readings of past environmental conditions.
☁️ Dual-Sensor Analysis: Simultaneous monitoring of hydration and sunlight to prevent both underwatering and sun-scorching.

**Installation Instructions: **
Hardware Setup
Connect the Capacitive Soil Moisture Sensor to GPIO 34 (Analog).

Connect the BH1750 UV/Light Sensor to I2C pins (SDA: GPIO 21, SCL: GPIO 22).

Flash the firmware using VS Code + PlatformIO.

Software Setup
Clone the repository:

Bash
git clone https://github.com/yourusername/flaura.git
Install Flutter dependencies:

Bash
flutter pub get
Firebase Configuration:

Create a Firebase project.

Enable Realtime Database.

Run flutterfire configure to link the app to your project.

Run the app:
Bash
flutter run

**Setup:** Instructions for setting up IoT devices and cloud services.
