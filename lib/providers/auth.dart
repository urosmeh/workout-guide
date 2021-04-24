import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:workout_guide/db_urls.dart';
import 'package:http/http.dart' as http;
import 'package:workout_guide/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiresAt;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiresAt != null &&
        _expiresAt.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlExt) async {
    final url = Uri.parse("$FIREBASE_AUTH_URL$urlExt?$API_KEY");

    print("auth");

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        return HttpException(responseData["error"]["message"]);
      }

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiresAt = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
    } catch (error) {
      throw error;
    }
  }

  void setAutoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiresAt.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), null);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }
}
