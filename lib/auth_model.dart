import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  User? _user;

  final FirebaseAuth? _auth = FirebaseAuth.instance;

  AuthModel() {

    if(_auth != null){
      final User? _currentUser = _auth!.currentUser;

      if (_currentUser != null) {
        _user = _currentUser;
        // print(_user!.uid);
        notifyListeners();
      } else{
        _user = null;
        notifyListeners();
      }
    }else{
      _user = null;
      notifyListeners();
    }


  }

  User? get user => _user;
  bool get loggedIn => _user != null;


}