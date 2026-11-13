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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBFmiTeVJ56pgjh7dkQTmvQS-QRRBX5GMM',
    appId: '1:553395030501:android:3a3c29ac7b12831692c70c',
    messagingSenderId: '553395030501',
    projectId: 'task-manager-be612',
    storageBucket: 'task-manager-be612.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFmiTeVJ56pgjh7dkQTmvQS-QRRBX5GMM',
    appId: '1:553395030501:android:3a3c29ac7b12831692c70c',
    messagingSenderId: '553395030501',
    projectId: 'task-manager-be612',
    storageBucket: 'task-manager-be612.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFmiTeVJ56pgjh7dkQTmvQS-QRRBX5GMM',
    appId: '1:553395030501:android:3a3c29ac7b12831692c70c',
    messagingSenderId: '553395030501',
    projectId: 'task-manager-be612',
    storageBucket: 'task-manager-be612.firebasestorage.app',
  );
}
