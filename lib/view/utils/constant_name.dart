import 'package:flutter/cupertino.dart';

double screenHight = 0;
double screenWidth = 0;
String? globalUserToken;
void initiateDeviceSize(BuildContext context) {
  screenHight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;
}

void setToken(value) {
  globalUserToken = value;
}
