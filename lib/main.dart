import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sensors/sensors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheelchair Control',
      home: WheelchairControl(),
    );
  }
}

class WheelchairControl extends StatefulWidget {
  @override
  _WheelchairControlState createState() => _WheelchairControlState();
}

class _WheelchairControlState extends State<WheelchairControl> {
  BluetoothConnection? connection;
  bool isConnected = false;
  bool isGyroControl = false;
  String lastCommand = '';
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _voiceCommand = '';

  @override
  void initState() {
    super.initState();
    _connectToBluetooth();
  }

  void _connectToBluetooth() async {
    try {
      connection = await BluetoothConnection.toAddress('00:11:22:33:44:55');
      setState(() {
        isConnected = true;
      });
      connection!.input!.listen((data) {
        // Handle incoming data if necessary
      }).onDone(() {
        setState(() {
          isConnected = false;
        });
      });
    } catch (e) {
      print('Error connecting to Bluetooth: $e');
      setState(() {
        isConnected = false;
      });
    }
  }

  void _sendCommand(String command) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList(command.codeUnits));
      setState(() {
        lastCommand = command;
      });
    }
  }

  void _controlWithGyro() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (isGyroControl) {
        String command = 'Stop';
        if (event.y > 1.0) command = 'Forward';
        if (event.y < -1.0) command = 'Backward';
        if (event.x > 1.0) command = 'Right';
        if (event.x < -1.0) command = 'Left';

        if (command != lastCommand) {
          _sendCommand(command);
        }
      }
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) => setState(() {
        _voiceCommand = val.recognizedWords;
        _handleVoiceCommand(_voiceCommand);
      }));
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  void _handleVoiceCommand(String command) {
    command = command.toLowerCase();
    if (command.contains('forward')) {
      _sendCommand('Forward');
    } else if (command.contains('backward')) {
      _sendCommand('Backward');
    } else if (command.contains('left')) {
      _sendCommand('Left');
    } else if (command.contains('right')) {
      _sendCommand('Right');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wheelchair Control'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: isConnected ? Colors.blue : Colors.red,
            size: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _sendCommand('Forward'),
                child: Icon(Icons.arrow_upward),
              ),
              ElevatedButton(
                onPressed: () => _sendCommand('Left'),
                child: Icon(Icons.arrow_back),
              ),
              ElevatedButton(
                onPressed: () => _sendCommand('Right'),
                child: Icon(Icons.arrow_forward),
              ),
              ElevatedButton(
                onPressed: () => _sendCommand('Backward'),
                child: Icon(Icons.arrow_downward),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_isListening) {
                    _stopListening();
                  } else {
                    _startListening();
                  }
                },
                child: Text(_isListening ? 'Stop Listening' : 'Voice Control'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGyroControl = true;
                  });
                  _controlWithGyro();
                },
                child: Text('Gyro Control'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGyroControl = false;
                  });
                },
                child: Text('Manual Control'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    connection?.dispose();
    _speech.stop();
    super.dispose();
  }
}
