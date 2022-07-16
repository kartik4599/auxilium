import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_demo/models/user.dart';
import 'package:instagram_demo/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod _authMethod = AuthMethod();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User usr = await _authMethod.getUserDetails();
    _user = usr;
    notifyListeners();
  }
}
