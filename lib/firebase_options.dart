// This file contains placeholder configuration
// IMPORTANT: Replace these values with your actual Firebase project configuration
// 
// To get these values:
// 1. Go to Firebase Console: https://console.firebase.google.com/
// 2. Select your project
// 3. Go to Project Settings (gear icon) → General
// 4. Scroll down to "Your apps"
// 5. Click on your Android app
// 6. You'll see the configuration values there
//
// OR you can also find these in the google-services.json file:
// - apiKey: "current_key" field
// - appId: "mobilesdk_app_id" field  
// - messagingSenderId: "project_number" field
// - projectId: "project_id" field
// - storageBucket: "storage_bucket" field

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import firebase_options.dart;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfRYoZT9c4O0flc39iROdgC1bTQkUXq88',
    appId: '1:770401014858:android:6e54d94733670491e542b3',
    messagingSenderId: '770401014858',
    projectId: 'gen-lang-client-0579320558',
    storageBucket: 'gen-lang-client-0579320558.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAfRYoZT9c4O0flc39iROdgC1bTQkUXq88',
    appId: '1:770401014858:web:PLACEHOLDER',  // You can register a web app in Firebase Console to get the real appId
    messagingSenderId: '770401014858',
    projectId: 'gen-lang-client-0579320558',
    storageBucket: 'gen-lang-client-0579320558.firebasestorage.app',
    authDomain: 'gen-lang-client-0579320558.firebaseapp.com',
  );
}
