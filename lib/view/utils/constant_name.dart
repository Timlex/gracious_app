import 'package:flutter/cupertino.dart';

double screenHight = 0;
double screenWidth = 0;
String? globalUserToken;
void initiateDeviceSize(BuildContext context) {
  screenHight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

void setToken(value) {
  globalUserToken = value;
}
