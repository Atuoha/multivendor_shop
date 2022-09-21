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
        return ios;
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
    apiKey: 'AIzaSyByjSdGHCYMAT3N9Hd7PXDkTV5nrCa1-qo',
    appId: '1:775065813848:web:fffaa91511b40ff64d5b2d',
    messagingSenderId: '775065813848',
    projectId: 'multivendz',
    authDomain: 'multivendz.firebaseapp.com',
    storageBucket: 'multivendz.appspot.com',
    measurementId: 'G-ND38TEDMXQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7rOI3nl4JLGafn4Bqw84jyEeGLiiqD6c',
    appId: '1:775065813848:android:05f53a9af344590b4d5b2d',
    messagingSenderId: '775065813848',
    projectId: 'multivendz',
    storageBucket: 'multivendz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5B4opsgP-djQQFyIQQvtvx1NLMOCk72I',
    appId: '1:775065813848:ios:ce0a2c53339523d44d5b2d',
    messagingSenderId: '775065813848',
    projectId: 'multivendz',
    storageBucket: 'multivendz.appspot.com',
    iosClientId: '775065813848-gvjhqiqp8b3eam9fge2dsq6ceilbstue.apps.googleusercontent.com',
    iosBundleId: 'com.atutechs.multivendorShop',
  );
}