import 'package:flutter/cupertino.dart';

class AuthTextControllerService with ChangeNotifier {
  var _email;
  var _password;
  var _name;
  var _userName;

  setEmail(value) {
    _email = value;
    notifyListeners();
  }

  setPass(value) {
    _password = value;
    notifyListeners();
  }

  setName(value) {
    _name = value;
    notifyListeners();
  }

  setUserName(value) {
    _userName = value;
    notifyListeners();
  }

  String get email {
    return _email;
  }

  String get name {
    return _name;
  }

  String get username {
    return _userName;
  }

  String get password {
    return _password;
  }
}
