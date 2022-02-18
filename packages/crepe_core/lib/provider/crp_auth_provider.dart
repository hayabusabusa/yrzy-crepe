import 'package:firebase_auth/firebase_auth.dart';

class CRPAuthProvider {

  static CRPAuthProvider? _instance;

  static CRPAuthProvider get instance {
    final instance = _instance;
    if (instance != null) {
      return instance;
    }

    final newInstance = CRPAuthProvider._();
    _instance = newInstance;
    return newInstance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CRPAuthProvider._();

  bool isSignIn() {
    return _auth.currentUser != null;
  }

  Future<void> signInAsAnonymousUser() {
    return _auth.signInAnonymously();
  }
}