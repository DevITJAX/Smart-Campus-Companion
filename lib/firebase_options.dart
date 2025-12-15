// File generated manually from google-services.json
// This replaces the FlutterFire CLI generated file

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDucB44JfcH7JhD6tshJGjaLOn03o2aOwA',
    appId: '1:895316881944:android:9c1531933bf98c59e6096d',
    messagingSenderId: '895316881944',
    projectId: 'smart-campus-companion-9b040',
    storageBucket: 'smart-campus-companion-9b040.firebasestorage.app',
  );

  // iOS configuration - you'll need to add GoogleService-Info.plist for iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDucB44JfcH7JhD6tshJGjaLOn03o2aOwA',
    appId: '1:895316881944:android:9c1531933bf98c59e6096d', // Replace with iOS app ID when available
    messagingSenderId: '895316881944',
    projectId: 'smart-campus-companion-9b040',
    storageBucket: 'smart-campus-companion-9b040.firebasestorage.app',
    iosBundleId: 'com.smart.campus.companion',
  );

  // Web configuration - uses same project as Android
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDucB44JfcH7JhD6tshJGjaLOn03o2aOwA',
    appId: '1:895316881944:web:smartcampusweb', // Web app ID placeholder
    messagingSenderId: '895316881944',
    projectId: 'smart-campus-companion-9b040',
    authDomain: 'smart-campus-companion-9b040.firebaseapp.com',
    storageBucket: 'smart-campus-companion-9b040.firebasestorage.app',
  );
}
