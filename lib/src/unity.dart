import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
// import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class UnityScreen extends StatefulWidget {
  const UnityScreen({super.key});

  @override
  State<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;
  // double _sliderValue = 0.0;

  // gyroscope
  // ignore: prefer_final_fields
  Map<String, double> _absolutePos = {
    'X': 0.0,
    'Y': 0.0,
    'Z': 0.0,
  };

  //timer
  Duration duration = Duration();
  Timer? timer;

  void addTime() {
    const addSeconds = 1;
    setState(
      () {
        final seconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: seconds);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _unityWidgetController?.postMessage(
      'Player',
      'Reset',
      '',
    );
    _unityWidgetController?.postMessage(
      'Floor',
      'Reset',
      '',
    );
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());

    // Listen to gyroscope data stream
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _absolutePos['X'] = _absolutePos['X']! + event.x;
        _absolutePos['Y'] = _absolutePos['Y']! + event.y;
        _absolutePos['Z'] = _absolutePos['Z']! + event.z;
      });
      _unityWidgetController?.postMessage(
        'Floor',
        'SetX',
        _absolutePos['X'].toString(),
      );
      _unityWidgetController?.postMessage(
        'Floor',
        'SetZ',
        _absolutePos['Y'].toString(),
      );
    });
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            "${twoDigits(duration.inMinutes)} : ${twoDigits(duration.inSeconds.remainder(60))}"),
        // Text('X: ${_absolutePos['X']!.toStringAsFixed(4)}, Y: ${_absolutePos['Y']!.toStringAsFixed(4)}, Z: ${_absolutePos['Z']!.toStringAsFixed(4)}'),
        actions: [
          PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
            },
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _unityWidgetController?.postMessage(
                  'Player',
                  'Reset',
                  '',
                );
                _unityWidgetController?.postMessage(
                  'Floor',
                  'Reset',
                  '',
                );
                Navigator.pop(context, -1);
              },
            ),
          ),
        ],
      ),
      body: Card(
        margin: const EdgeInsets.all(0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: onUnityMessage,
              // onUnitySceneLoaded: onUnitySceneLoaded,
              useAndroidViewSurface: false,
              borderRadius: const BorderRadius.all(Radius.circular(70)),
            ),
          ],
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(message) {
    if (message == "reset") {
      _absolutePos['X'] = 0;
      _absolutePos['Y'] = 0;
      _absolutePos['Z'] = 0;
    } else if (message == "done") {
      Navigator.pop(context, duration.inSeconds);
    } else {
      //print('Received message from unity: ${message.toString()}');
      // Show a simple popup message to the user in Flutter
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Message from Unity'),
            content: Text(message.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
}
