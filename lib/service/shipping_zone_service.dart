import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/country_shipping_zone_model.dart';
import 'package:gren_mart/model/state_shipping_zone_model.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import 'package:gren_mart/service/cupon_discount_service.dart';
import 'package:provider/provider.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class ShippingZoneService with ChangeNotifier {
  CountryShippingZoneModel? countryShippingZoneData;
  StateShippingZoneModel? stateShippingZoneData;
  int shippingCost = 0;
  double taxParcentage = 0;
  bool isLoading = true;
  List<DefaultShipping>? shippingOptionsList;
  DefaultShipping? selectedOption;

  setSelectedOption(DefaultShipping value) {
    selectedOption = value;
    shippingCost = selectedOption!.availableOptions.cost;
    notifyListeners();
  }

  resetChecout() {
    shippingCost = 0;
    taxParcentage = 0;
    isLoading = true;
    shippingOptionsList = null;
    selectedOption = null;
    notifyListeners();
  }

  setTaxPercentage() {
    if (stateShippingZoneData!.taxPercentage == null) {
      taxParcentage = (countryShippingZoneData!.taxPercentage ?? 0) / 100;
      return;
    }
    taxParcentage = (stateShippingZoneData!.taxPercentage as int) / 100;
  }

  setShippingOptionList() {
    if (stateShippingZoneData!.shippingOptions.isNotEmpty) {
      shippingOptionsList = stateShippingZoneData!.shippingOptions;
      selectedOption = stateShippingZoneData!.defaultShipping;
      shippingOptionsList!
          .removeWhere((element) => element.id == selectedOption!.id);
      shippingOptionsList!.add(selectedOption!);
      return;
    }
    if (countryShippingZoneData!.shippingOptions.isNotEmpty) {
      shippingOptionsList = countryShippingZoneData!.shippingOptions;
      selectedOption = countryShippingZoneData!.defaultShipping;
      shippingOptionsList!
          .removeWhere((element) => element.id == selectedOption!.id);
      shippingOptionsList!.add(selectedOption!);

      return;
    }
    shippingOptionsList = [countryShippingZoneData!.defaultShipping];
    selectedOption = countryShippingZoneData!.defaultShipping;
  }

  Future fetchContriesZone(id) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseApiUrl/country-info?id=$id');

    try {
      final response = await http.get(url);
      if (response.statusCode == 201) {
        var data = CountryShippingZoneModel.fromJson(jsonDecode(response.body));
        countryShippingZoneData = data;
        notifyListeners();
        return;
      } else {
        //something went wrong
      }
    } catch (error) {
      print(error);

      rethrow;
    }
  }

  double totalCounter(BuildContext context) {
    final subTotal =
        Provider.of<CartDataService>(context, listen: false).subTotal;
    final discount = Provider.of<CuponDiscountService>(context).cuponDiscount;
    final taxMoney = taxParcentage * subTotal;
    return (subTotal + taxMoney + shippingCost - discount);
  }

  cuponTotal(BuildContext context) {
    final subTotal =
        Provider.of<CartDataService>(context, listen: false).subTotal;
    final taxMoney = taxParcentage * subTotal;
    return subTotal + taxMoney + shippingCost;
  }

  taxMoney(BuildContext context) {
    final subTotal =
        Provider.of<CartDataService>(context, listen: false).subTotal;
    return taxParcentage * subTotal;
  }

  Future fetchSatesZone(id) async {
    final url = Uri.parse('$baseApiUrl/state-info?id=$id');

    // try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = StateShippingZoneModel.fromJson(jsonDecode(response.body));
      stateShippingZoneData = data;
      if (stateShippingZoneData!.defaultShippingCost != 0) {
        shippingCost = stateShippingZoneData!.defaultShippingCost;
        setShippingOptionList();
        setTaxPercentage();
        isLoading = false;
        notifyListeners();
        return;
      }
      shippingCost = countryShippingZoneData!.defaultShippingCost;
      setShippingOptionList();

      setTaxPercentage();
      isLoading = false;
      notifyListeners();
      return;
    } else {
      //something went wrong
    }
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }
}
