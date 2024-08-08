Wheelchair Control App
A Flutter-based mobile application designed to control a wheelchair via Bluetooth. The app offers multiple control options including manual (using arrow keys), gyro-based control (using the phone's gyroscope), and voice control (using Google Voice Assistant).

Features
Bluetooth Connectivity: Connects to a wheelchair or any other Bluetooth-enabled device.
Manual Control: Control the wheelchair using on-screen arrow buttons.
Gyro Control: Use the phone's gyroscope to control the wheelchair by tilting the device.
Voice Control: Issue voice commands such as "forward", "backward", "left", and "right" to control the wheelchair.
Setup Instructions
Prerequisites
Flutter SDK installed on your machine.
A Bluetooth-enabled wheelchair or device.
Basic knowledge of Flutter and Dart.
Dependencies
Ensure the following dependencies are added to your pubspec.yaml file:

yaml
Copy code
dependencies:
flutter:
sdk: flutter
flutter_bluetooth_serial: ^0.4.0
speech_to_text: ^5.4.0
sensors: ^2.0.0
Firebase Setup (Optional)
For voice control using Google Voice Assistant, ensure you have the speech_to_text package integrated. No Firebase setup is required for this specific implementation.

Installation
Clone the Repository:


Copy code
git clone https://github.com/your-repo/wheelchair-control-app.git
cd wheelchair-control-app
Install Dependencies:

Copy code
flutter pub get
Connect to Bluetooth:

Replace the placeholder MAC address (00:11:22:33:44:55) in the main.dart file with the actual MAC address of your Bluetooth-enabled device.
Run the App:


Copy code
flutter run
Usage
Connecting to Bluetooth
The app automatically attempts to connect to the Bluetooth device specified by its MAC address.
The Bluetooth connection status is indicated by an icon at the top of the screen.
Manual Control
Use the arrow buttons on the main screen to control the wheelchair's direction.
Gyro Control
Activate gyro control by tapping the "Gyro Control" button.
Control the wheelchair by tilting your phone in the desired direction.
Voice Control
Activate voice control by tapping the "Voice Control" button.
Issue voice commands such as "forward", "backward", "left", or "right" to control the wheelchair.
Tap the "Stop Listening" button to stop voice control.
Customization
Changing the Bluetooth Device
To connect to a different Bluetooth device, modify the MAC address in the _connectToBluetooth() method within the main.dart file.

Adding More Voice Commands
You can expand the _handleVoiceCommand() method to recognize additional voice commands and map them to new actions.

Troubleshooting
Bluetooth Connection Issues: Ensure the correct MAC address is specified and that the Bluetooth device is powered on and in range.
Voice Recognition Not Working: Make sure the microphone permissions are granted for the app. Test the speech_to_text package independently to ensure proper configuration.
Gyro Control Issues: Ensure that the gyroscope is functioning correctly on your device.
License