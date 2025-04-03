import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for $defaultTargetPlatform - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKn0yC3znS1vj5KlHphFHac2pf3gf0ZPA',
    appId: '1:16182409724:android:6ae4e7f3a6953a7f8a1a79',
    messagingSenderId: '16182409724',
    projectId: 'eventease-43d23',
    storageBucket: 'eventease-43d23.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0l9w_Mj1rNo0Y3JyUzwO8LUQZPUg_E5I',
    appId: '1:16182409724:web:5330173dc3df48078a1a79',
    messagingSenderId: '16182409724',
    projectId: 'eventease-43d23',
    authDomain: 'eventease-43d23.firebaseapp.com',
    storageBucket: 'eventease-43d23.firebasestorage.app',
    measurementId: 'G-FKPXFZQC9D',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCdsET9RDsYlW-q4DMB5ASfgvXFWo_TIW4',
    appId: '1:16182409724:ios:cfc17191e8223e238a1a79',
    messagingSenderId: '16182409724',
    projectId: 'eventease-43d23',
    storageBucket: 'eventease-43d23.firebasestorage.app',
    iosBundleId: 'com.example.eventEase',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdsET9RDsYlW-q4DMB5ASfgvXFWo_TIW4',
    appId: '1:16182409724:ios:cfc17191e8223e238a1a79',
    messagingSenderId: '16182409724',
    projectId: 'eventease-43d23',
    storageBucket: 'eventease-43d23.firebasestorage.app',
    iosBundleId: 'com.example.eventEase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB0l9w_Mj1rNo0Y3JyUzwO8LUQZPUg_E5I',
    appId: '1:16182409724:web:004bfeea7ba6ca598a1a79',
    messagingSenderId: '16182409724',
    projectId: 'eventease-43d23',
    authDomain: 'eventease-43d23.firebaseapp.com',
    storageBucket: 'eventease-43d23.firebasestorage.app',
    measurementId: 'G-N012P6DH70',
  );

}