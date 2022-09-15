import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/model/checkout_model.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/settings/manage_account.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

import '../view/utils/text_themes.dart';
import 'cart_data_service.dart';
import 'country_dropdown_service.dart';
import 'cupon_discount_service.dart';
import 'payment_gateaway_service.dart';
import 'shipping_addresses_service.dart';
import 'shipping_zone_service.dart';
import '../view/order/order_details.dart' as order;
import 'state_dropdown_service.dart';

class CheckoutService with ChangeNotifier {
  CheckoutModel? checkoutModel;
  File? pickedImage;
  bool isLoading = false;
  bool termsAcondi = false;
  String? paytmResponse;

  setTermsACondi() {
    termsAcondi = !termsAcondi;
    notifyListeners();
  }

  Future<void> imageSelector(
    BuildContext context,
  ) async {
    try {
      final pickedFile =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
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
    if (userData.city == null ||
        userData.city!.isEmpty ||
        userData.address == null ||
        userData.address.isEmpty ||
        userData.zipcode == null ||
        userData.zipcode!.isEmpty ||
        userData.phone == null ||
        userData.phone!.isEmpty ||
        userData.country == null ||
        userData.state == null) {
      print('printing account information');
      print(
          '${userData.city} ${userData.address}${userData.zipcode}${userData.phone}${userData.country}${userData.state} ');
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Insufficient data?'),
              content: Text('Pleae provide all the profile Information.'),
              actions: [
                FlatButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    child: Text(
                      'Not now',
                      style: TextStyle(color: cc.pink),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ManageAccount.routeName)
                          .then((value) {
                        Provider.of<CountryDropdownService>(context,
                                listen: false)
                            .getContries(context)
                            .then((value) {
                          final userData = Provider.of<UserProfileService>(
                              context,
                              listen: false);
                          if (userData.userProfileData.country != null) {
                            Provider.of<CountryDropdownService>(context,
                                    listen: false)
                                .setCountryIdAndValue(
                                    userData.userProfileData.country!.name);
                          }
                          if (userData.userProfileData.state != null) {
                            Provider.of<StateDropdownService>(context,
                                    listen: false)
                                .setStateIdAndValue(
                                    userData.userProfileData.state!.name);
                          }
                        });
                        Provider.of<ShippingAddressesService>(context,
                                listen: false)
                            .fetchUsersShippingAddress(context,
                                loadShippingZone: true);
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      'Add now',
                      style: TextStyle(color: cc.primaryColor),
                    ))
              ],
            );
          });
      throw '';
    }
    Map<String, dynamic> fieldss = {
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
      'coupon': cuponData.cuponText ?? '',
      'agree': 'on',
      'sub_total': subTotal,
      'products_ids': jsonEncode(cartData.cartList!.keys.toList()),
      'all_cart_items': jsonEncode(cartData.formatItems()),
    };
    print(fieldss);

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

    print(response.statusCode.toString() + '++++++++++++++');
    if (response.statusCode == 201) {
      checkoutModel = CheckoutModel.fromJson(jsonDecode(response.body));
      // if (selectedGateaway.name == 'cash_on_delivery' ||
      //     selectedGateaway.name.contains('bank_transfer') ||
      //     selectedGateaway.name.contains('cheque_payment')) {
      //   await showDialogue(context);
      // }
      if (selectedGateaway.name == 'paytm') {
        await paytmChekout(context);
      }
      print(jsonDecode(response.body));
      Provider.of<CartDataService>(context, listen: false).emptyCart();
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

  Future paytmChekout(BuildContext context) async {
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

    Map<String, dynamic> body = {
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
      'coupon': cuponData.cuponText ?? '',
      'agree': 'on',
      'sub_total': subTotal,
      'products_ids': jsonEncode(cartData.cartList!.keys.toList()),
      'all_cart_items': jsonEncode(cartData.formatItems()),
    };
    final header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $globalUserToken',
    };
    final url = Uri.parse(
        'https://zahid.xgenious.com/grenmart-api/api/v1/user/checkout-paytm');

    // try {
    var response =
        await http.post(url, headers: header, body: jsonEncode(body));

    print(response.statusCode.toString() + '++++++++++++++');
    if (response.statusCode == 201) {
      paytmResponse = response.body;
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

  Future showDialogue(BuildContext context) async {
    await showDialog(
        useSafeArea: false,
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: 300,
            child: AlertDialog(
              title: Text('Order submitted!'),
              content: SizedBox(
                width: 200,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        'Your order has been successful! You\'ll receive ordered items in 3-5 days. Your order ID  is ',
                    style: TextThemeConstrants.paragraphText,
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Provider.of<PaymentGateawayService>(context,
                                      listen: false)
                                  .setIsLoading(false);
                              Navigator.of(context)
                                  .push(MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    order.OrderDetails(
                                        checkoutModel!.id.toString()),
                              ));
                            },
                          text: ' #${checkoutModel!.id}',
                          style: TextStyle(color: cc.primaryColor)),
                    ],
                  ),
                ),
              ),
              actions: [
                Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Ok',
                    style: TextStyle(color: cc.primaryColor),
                  ),
                )
              ],
            ),
          );
        });
  }
}
