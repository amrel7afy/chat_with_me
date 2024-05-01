// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBftriHBNlgLr8yz305OiFL0G7shTReHWw',
    appId: '1:293641654181:web:e2dfbf58992dd4de1da24c',
    messagingSenderId: '293641654181',
    projectId: 'chat-with-me-636e2',
    authDomain: 'chat-with-me-636e2.firebaseapp.com',
    storageBucket: 'chat-with-me-636e2.appspot.com',
    measurementId: 'G-7NW41MR74K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByI8E7fIuUl_SmpcACH0MZif6Df9PhCgE',
    appId: '1:293641654181:android:c538f3dd1d1b9ef61da24c',
    messagingSenderId: '293641654181',
    projectId: 'chat-with-me-636e2',
    storageBucket: 'chat-with-me-636e2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZG3yJiFWeUQdAEZreshajjPZOxZ3i-hc',
    appId: '1:293641654181:ios:1241cb97060308b01da24c',
    messagingSenderId: '293641654181',
    projectId: 'chat-with-me-636e2',
    storageBucket: 'chat-with-me-636e2.appspot.com',
    iosBundleId: 'com.example.chatWithMe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZG3yJiFWeUQdAEZreshajjPZOxZ3i-hc',
    appId: '1:293641654181:ios:1241cb97060308b01da24c',
    messagingSenderId: '293641654181',
    projectId: 'chat-with-me-636e2',
    storageBucket: 'chat-with-me-636e2.appspot.com',
    iosBundleId: 'com.example.chatWithMe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBftriHBNlgLr8yz305OiFL0G7shTReHWw',
    appId: '1:293641654181:web:6a2be74bc5ad43b11da24c',
    messagingSenderId: '293641654181',
    projectId: 'chat-with-me-636e2',
    authDomain: 'chat-with-me-636e2.firebaseapp.com',
    storageBucket: 'chat-with-me-636e2.appspot.com',
    measurementId: 'G-ZBRJLQXSMN',
  );
}
