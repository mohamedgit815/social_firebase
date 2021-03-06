// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBDxaBmYw0ka82nsQ65_IQIXn6b89c2Cbs',
    appId: '1:563226567420:web:253f4452c68cb18a192d79',
    messagingSenderId: '563226567420',
    projectId: 'social-app-f1fab',
    authDomain: 'social-app-f1fab.firebaseapp.com',
    storageBucket: 'social-app-f1fab.appspot.com',
    measurementId: 'G-W7FPPMMEVT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_kx2TrVxVOuOfk0vED7H1SNsI0tKzoWM',
    appId: '1:563226567420:android:c110aa3a27d687b9192d79',
    messagingSenderId: '563226567420',
    projectId: 'social-app-f1fab',
    storageBucket: 'social-app-f1fab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7Qd20L1TeeEoYSUcHqJ2ZCFOxkdAmSyw',
    appId: '1:563226567420:ios:16c897faeca38263192d79',
    messagingSenderId: '563226567420',
    projectId: 'social-app-f1fab',
    storageBucket: 'social-app-f1fab.appspot.com',
    iosClientId: '563226567420-niecr7q5p1fgp0752gs6smejut787gj6.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );
}
