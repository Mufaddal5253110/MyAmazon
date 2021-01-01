import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _idToken;
  DateTime _expiryData;
  String _userId;
  Timer _timer;

  bool get isAuthenticated {
    return token != null;
  }

  String get userId {
    if (_userId != null) {
      return _userId;
    }
    return null;
  }

  String get token {
    if (_idToken != null &&
        _expiryData.isAfter(DateTime.now()) &&
        _expiryData != null) {
      return _idToken;
    }
    return null;
  }

  Future<void> authentication(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB_z_9tXE5MN551HRtSKE5xEMA7FGbjaHc';
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      // final responseData = json.decode(response.body);
      final Map<String, dynamic> _responseBody = json.decode(response.body);

      if (_responseBody.containsKey('error')) {
        switch (_responseBody['error']['message']) {
          case 'EMAIL_NOT_FOUND':
            throw 'Email not found! Please Signup first';
            break;

          case 'EMAIL_EXISTS':
            throw 'Email Already Exist!';
            break;

          case 'INVALID_EMAIL':
            throw 'Please Enter Valid Email.';
            break;

          case 'INVALID_PASSWORD':
            throw 'Please Enter Valid Password.';
            break;

          case 'WEAK_PASSWORD':
            throw 'Password is too weak.';
            break;

          default:
            throw 'Some error occured. Please try again later!';
            break;
        }
      } else {
        _idToken = _responseBody['idToken'];
        _userId = _responseBody['localId'];
        _expiryData = DateTime.now().add(
          Duration(
            seconds: int.parse(
              _responseBody['expiresIn'],
            ),
          ),
        );
        tryToAutoLogout();
        notifyListeners();
        final pref = await SharedPreferences.getInstance();
        final userData = json.encode({
          'userId': _userId,
          'idToken': _idToken,
          'expiryDate': _expiryData.toIso8601String(),
        });
        pref.setString("userData", userData);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _userId = null;
    _idToken = null;
    _expiryData = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void tryToAutoLogout() {
    if (_timer != null) {
      _timer.cancel();
    }
    final expireDiff = _expiryData.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: expireDiff), logout);
  }

  Future<bool> tryToAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey("userData")) {
      return false;
    }

    final Map<String, Object> userData =
        json.decode(pref.getString("userData"));
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _idToken = userData['idToken'];
    _userId = userData['userId'];
    _expiryData = expiryDate;
    notifyListeners();
    tryToAutoLogout();
    return true;
  }
}
