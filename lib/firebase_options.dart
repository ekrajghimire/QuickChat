import 'package:firebase_core/firebase_core.dart';

/// Replace the placeholder values with your Firebase project's config.
/// These values come from your Firebase console (Web app) after creation.
/// Alternatively, run `flutterfire configure` to generate this file automatically.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: 'YOUR_API_KEY',
        appId: 'YOUR_APP_ID',
        messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
        projectId: 'YOUR_PROJECT_ID',
        authDomain: 'YOUR_AUTH_DOMAIN',
        storageBucket: 'YOUR_STORAGE_BUCKET',
      );
}
