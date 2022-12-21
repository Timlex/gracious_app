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
  bool noData = true;
  bool fetchStates = true;
  List<DefaultShipping>? shippingOptionsList;
  DefaultShipping? selectedOption;

  setSelectedOption(DefaultShipping value) {
    selectedOption = value;
    shippingCost = selectedOption!.availableOptions.cost;
    notifyListeners();
  }

  setNoData(value) {
    noData = value;
    notifyListeners();
  }

  resetChecout({backingout}) {
    shippingCost = 0;
    taxParcentage = 0;
    isLoading = true;
    shippingOptionsList = null;
    selectedOption = null;
    if (backingout == null) {
      noData = false;
    } else {
      noData = backingout;
    }
    fetchStates = true;
    notifyListeners();
  }

  setTaxPercentage() {
    if (stateShippingZoneData!.taxPercentage == null) {
      print(countryShippingZoneData!.taxPercentage);
      taxParcentage = (countryShippingZoneData!.taxPercentage ?? 0) / 100;
      return;
    }
    print(stateShippingZoneData!.taxPercentage);
    taxParcentage = (stateShippingZoneData!.taxPercentage as double) / 100;
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

  double totalCounter(BuildContext context) {
    final subTotal = Provider.of<CartDataService>(context, listen: false)
        .calculateSubtotal();
    final discount = Provider.of<CuponDiscountService>(context).couponDiscount;
    final taxMoney = taxParcentage * (subTotal + shippingCost);
    return (subTotal - discount) + taxMoney + shippingCost;
  }

  cuponTotal(BuildContext context) {
    final subTotal = Provider.of<CartDataService>(context, listen: false)
        .calculateSubtotal();
    final discount = Provider.of<CuponDiscountService>(context).couponDiscount;
    final taxMoney = taxParcentage * (subTotal + shippingCost);
    return subTotal + taxMoney + shippingCost;
  }

  double taxMoney(BuildContext context) {
    final subTotal = Provider.of<CartDataService>(context, listen: false)
        .calculateSubtotal();
    return taxParcentage * (subTotal + shippingCost);
  }

  Future fetchContriesZone(id, stateId) async {
    final url = Uri.parse('$baseApiUrl/country-info?id=$id');

    try {
      final response = await http.get(url);
      if (response.statusCode == 201) {
        var data = CountryShippingZoneModel.fromJson(jsonDecode(response.body));
        countryShippingZoneData = data;
        print(fetchStates);
        if (fetchStates) {
          fetchStates = false;
          await fetchStatesZone(stateId);
          return;
        }
        return;
      }
      noData = true;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future fetchStatesZone(id) async {
    fetchStates = false;
    final url = Uri.parse('$baseApiUrl/state-info?id=$id');
    // try {
    print(url);
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
      isLoading = false;
      //something went wrong
    }
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }
}
