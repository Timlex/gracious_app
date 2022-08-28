import 'dart:io';

import 'package:flutter/cupertino.dart';

class MenualPaymentService with ChangeNotifier {
  File? pickedImage;

  setPickedImage(value) {
    pickedImage = value;
    notifyListeners();
  }
}
