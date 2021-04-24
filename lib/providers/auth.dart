import 'dart:async';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime expiresAt;
  Timer _authTimer;

  Future<void> signIn(String email, String password) async {
    try {} catch (e) {}
  }
}
