import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/checkout_model.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

import 'cart_data_service.dart';
import 'cupon_discount_service.dart';
import 'payment_gateaway_service.dart';
import 'shipping_addresses_service.dart';
import 'shipping_zone_service.dart';

class CheckoutService with ChangeNotifier {
  late CheckoutModel checkoutModel;
  File? pickedImage;
  bool isLoading = false;
  bool termsAcondi = false;

  setTermsACondi() {
    termsAcondi = !termsAcondi;
    notifyListeners();
  }

  Future<void> imageSelector(BuildContext context,
      {ImageSource imageSource = ImageSource.camera}) async {
    try {
      final pickedFile =
          await ImagePicker.platform.pickImage(source: imageSource);
      pickedImage = File(pickedFile!.path);
      notifyListeners();
    } catch (error) {
      print('error occured------------------------------------');
      print(error.toString());
    }
  }

  Future proccessCheckout(BuildContext context) async {
    print('Edit in proccess');

    final userData =
        Provider.of<UserProfileService>(context, listen: false).userProfileData;
    final cartData = Provider.of<CartDataService>(context, listen: false);
    final shippingAddress =
        Provider.of<ShippingAddressesService>(context, listen: false);
    final shippingZone =
        Provider.of<ShippingZoneService>(context, listen: false);
    final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    final selectedGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final taxAmount = shippingZone.taxMoney(context);
    final clist = Provider.of<CartDataService>(context, listen: false).cartList;
    Map<String, List<Map<String, Object?>>>? formatedCartItem = clist;
    final subTotal = cartData.calculateSubtotal().toString();

    Map<String, String> fieldss = {
      'name': userData.name,
      'email': userData.email,
      'country':
          userData.country == null ? '' : userData.country!.id.toString(),
      'address': userData.address,
      'city': userData.city ?? '',
      'state': userData.state == null ? '' : userData.state!.id.toString(),
      'zipcode': userData.zipcode ?? '',
      'phone': userData.phone ?? '',
      'shipping_address_id': shippingAddress.selectedAddress!.id.toString(),
      'tax_amount': taxAmount.toString(),
      'coupon': cuponData.cuponText ?? 'null',
      'agree': 'on',
      'sub_total': subTotal,
      'products_ids': cartData.cartList!.keys.toList().toString(),
      'all_cart_items': cartData.formatItems().toString(),
    };
    // print(fieldss);

    final url = Uri.parse('$baseApiUrl/user/checkout');
    var request = http.MultipartRequest('POST', url);

    fieldss.forEach((key, value) {
      request.fields[key] = value;
    });
    request.headers.addAll(
      {
        "Accept": "application/json",
        "Authorization": "Bearer $globalUserToken",
      },
    );
    print(pickedImage);
    if (pickedImage != null &&
        (selectedGateaway.name.contains('bank_transfer') ||
            selectedGateaway.name.contains('cheque_payment'))) {
      print('pickedImage!.path');
      var multiport = await http.MultipartFile.fromPath(
        selectedGateaway.name.contains('bank_transfer')
            ? 'bank_payment_input'
            : 'check_payment_input',
        pickedImage!.path,
      );

      request.files.add(multiport);
    }
    var streamedResponse = await request.send();
    // try {
    var response = await http.Response.fromStream(streamedResponse);

    // var header = {
    //   //if header type is application/json then the data should be in jsonEncode method
    //   "Accept": "application/json",
    //   "Authorization": "Bearer $token",
    // };
    // // try {
    // final response = await http.post(url, headers: header, body: {
    //   'name': name,
    //   'email': email,
    //   'phone': phoneNumber,
    //   'country_code': countryCode,
    //   'country': countryId,
    //   'state': stateId,
    //   'city': city,
    //   'zip_code': zipCode,
    //   'address': address,
    //   'file': pickedImage,
    // });
    print(response.statusCode.toString() + '++++++++++++++');
    if (response.statusCode == 201) {
      checkoutModel = CheckoutModel.fromJson(jsonDecode(response.body));
      print(jsonDecode(response.body));
      notifyListeners();
      return;
    }
    if (response.statusCode == 500) {
      print(jsonDecode(response.body));
      throw 'Connection failed';
    }

    return;
    // throw '';
    // } catch (error) {
    //   // print(error);

    //   rethrow;
    // }
  }
}
