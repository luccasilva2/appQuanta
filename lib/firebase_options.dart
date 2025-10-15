import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// IMPORTANT: These are placeholder values. You need to replace them with your actual Firebase project configuration.
///
/// To get your Firebase configuration:
/// 1. Go to https://console.firebase.google.com/
/// 2. Create a new project or select existing one
/// 3. Go to Project Settings > General > Your apps
/// 4. Add a web app or select existing one
/// 5. Copy the config values and replace the placeholders below
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
    apiKey: 'AIzaSyADbd_R7a8Z-Has0CtZR4JI0V-d8GHWL-k',
    appId: '1:155085356527:web:d78ca7c4747587acbc4a1a',
    messagingSenderId: '155085356527',
    projectId: 'appquanta-d0b3c',
    authDomain: 'appquanta-d0b3c.firebaseapp.com',
    storageBucket: 'appquanta-d0b3c.firebasestorage.app',
    measurementId: 'G-QRN1GWM59Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhXJwefMbXGoxova_yI4Tz-LeW4jlimV4',
    appId: '1:155085356527:android:f50d51de65b820bebc4a1a',
    messagingSenderId: '155085356527',
    projectId: 'appquanta-d0b3c',
    storageBucket: 'appquanta-d0b3c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_IOS',
    appId: '1:123456789012:ios:abcdef123456',
    messagingSenderId: '123456789012',
    projectId: 'appquanta-12345',
    storageBucket: 'appquanta-12345.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_MACOS',
    appId: '1:123456789012:macos:abcdef123456',
    messagingSenderId: '123456789012',
    projectId: 'appquanta-12345',
    storageBucket: 'appquanta-12345.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_WINDOWS',
    appId: '1:123456789012:windows:abcdef123456',
    messagingSenderId: '123456789012',
    projectId: 'appquanta-12345',
    storageBucket: 'appquanta-12345.appspot.com',
  );
}
