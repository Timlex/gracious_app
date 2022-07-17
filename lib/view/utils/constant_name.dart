import 'package:flutter/cupertino.dart';

double screenHight = 0;
double screenWidth = 0;
void initiateDeviceSize(BuildContext context) {
  screenHight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;
}
