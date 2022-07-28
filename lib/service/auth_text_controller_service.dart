import 'package:flutter/cupertino.dart';

class AuthTextControllerService with ChangeNotifier {
  var _email;
  var _password;
  var _name;
  var _userName;
  var _cityAddress;
  var _phoneNumber;
  var _country;
  var _state;
  var _countryCode = 'BD';

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

  setCityAddress(value) {
    _cityAddress = value;

    notifyListeners();
  }

  setPhoneNumber(String value) {
    _phoneNumber = value;

    notifyListeners();
  }

  setCountry(value) {
    _country = value;

    notifyListeners();
  }

  setState(value) {
    _state = value;

    notifyListeners();
  }

  setCountryCode(value) {
    _countryCode = value;
    print(_countryCode);

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

  dynamic get country {
    return _country;
  }

  dynamic get state {
    return _state;
  }

  String get cityAddress {
    return _cityAddress;
  }

  String get phoneNumber {
    return _phoneNumber;
  }

  String get countryCode {
    return _countryCode;
  }
}
