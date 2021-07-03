import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }

    final userData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    
    final expiresAt = DateTime.parse(userData["expiresAt"]);
    if (expiresAt.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData["token"];
    _userId = userData["userId"];
    _expiresAt = expiresAt;

    notifyListeners();
    setAutoLogout();
    return true;
  }

  Future<void> _authenticate(
      String email, String password, String urlExt) async {
    final url = Uri.parse("$FIREBASE_AUTH_URL$urlExt?key=$API_KEY");

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

      setAutoLogout();
      notifyListeners();

      //write data to device for autologin
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiresAt": _expiresAt.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  //logout user after expiresAt
  void setAutoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiresAt.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> logout() async {
    _token = null;
    _expiresAt = null;
    _userId = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
  }
}
