// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDuZUg_74tXN0QeGIfXjliMZLg8HO2IfT0',
    appId: '1:9100577788:web:38ff64efb6cb9b610f4079',
    messagingSenderId: '9100577788',
    projectId: 'flutter-2408c',
    authDomain: 'flutter-2408c.firebaseapp.com',
    storageBucket: 'flutter-2408c.appspot.com',
    measurementId: 'G-SGZ6QGBB2N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmZVWZFPDvGkeD0V8GU7oVdos0dPFR5mk',
    appId: '1:9100577788:android:775fc9c4acd3ca000f4079',
    messagingSenderId: '9100577788',
    projectId: 'flutter-2408c',
    storageBucket: 'flutter-2408c.appspot.com',
  );
}
