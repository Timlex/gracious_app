import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/cupertino.dart';
import '../../model/product_details_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

import '../view/utils/constant_name.dart';

class ProductDetailsService with ChangeNotifier {
  ProductDetailsModel? productDetails;
  late Map<String, AdditionalInfoStore> additionalInventoryInfo;
  bool descriptionExpand = false;
  bool aDescriptionExpand = false;
  bool reviewExpand = false;
  bool cartAble = false;
  bool reviewing = false;
  int productSalePrice = 0;
  int quantity = 1;
  String? additionalInfoImage;
  String? selectedInventoryHash;
  List<String> selectedInventorySetIndex = [];
  List<String> inventoryKeys = [];
  Map<String, Map<String, List<String>>> allAtrributes = {};
  List selectedAttributes = [];
  Map<String, List<Map<String, dynamic>>> inventorySet = {};
  Map<String, dynamic> selecteInventorySet = {};
  bool refreshpage = false;
  int? selectedIndex;
  List<String> inventoryHash = [];
  bool loadingFailed = false;

  setProductInventorySet(List<String>? value) {
    if (selectedInventorySetIndex != value) {}
    if (selectedInventorySetIndex.isEmpty) {
      selectedInventorySetIndex = value ?? [];
      notifyListeners();
      return;
    }
    if (selectedInventorySetIndex.isNotEmpty &&
        selectedInventorySetIndex.length > value!.length) {
      selectedInventorySetIndex = value;
      notifyListeners();
      return;
    }
  }

  addSelectedAttribute(value) {
    if (selectedAttributes.contains(value)) {
      return;
    }
    selectedAttributes.add(value);

    notifyListeners();
  }

  bool isASelected(value) {
    return selectedAttributes.contains(value);
  }

  bool deselect(List<String>? value, List<String>? list) {
    bool result = false;
    for (var element in value!) {
      if ((list!.contains(element))) {
        result = true;
      }
    }
    return result;
  }

  addAdditionalPrice() {
    print(selectedInventorySetIndex);

    bool setMatched = true;
    for (int i = 0; i < selectedInventorySetIndex.length; i++) {
      setMatched = true;
      selecteInventorySet = productDetails!
          .productInventorySet[int.parse(selectedInventorySetIndex[i])];
      selecteInventorySet.values.forEach((e) {
        print(i);
        List<dynamic> confirmingSelectedDeta = selectedAttributes;
        // confirmingSelectedDeta.add(selecteInventorySet['hash']);
        // confirmingSelectedDeta.add(selecteInventorySet['Color_name']);
        if (!confirmingSelectedDeta.contains(e)) {
          setMatched = false;
        }
      });
      final mapData = {};

      if (setMatched) {
        print('Inventory..............');
        selectedIndex = i;
        print(productDetails!
            .productInventorySet[int.parse(selectedInventorySetIndex[i])]);

        break;
      }
    }
    if (setMatched) {
      selectedInventoryHash = inventoryHash[selectedIndex!];
      // print('hash..............');
      // print(selectedInventoryHash);
      // print(productDetails!.productInventorySet[selectedIndex!]);
      productSalePrice +=
          productDetails!.additionalInfoStore![selectedInventoryHash] == null
              ? 0
              : productDetails!
                  .additionalInfoStore![selectedInventoryHash]!.additionalPrice;
      additionalInfoImage =
          productDetails!.additionalInfoStore![selectedInventoryHash] == null
              ? ''
              : productDetails!
                  .additionalInfoStore![selectedInventoryHash]!.image;
      additionalInfoImage =
          additionalInfoImage == '' ? null : additionalInfoImage;
      cartAble = true;
      selecteInventorySet.remove('hash');
      // print(selecteInventorySet);
      notifyListeners();
      return;
    }
    if (selectedIndex != null) {
      print('Inventory..............');
      print(productDetails!.productInventorySet[selectedIndex!]);
    }
    print('outside..............');
    cartAble = false;
    productSalePrice = productDetails!.product.salePrice;
    additionalInfoImage = null;
    selecteInventorySet = {};
    selectedInventoryHash = null;
    notifyListeners();
  }

  setQuantity({bool plus = true}) {
    if (plus) {
      quantity++;
      notifyListeners();
      return;
    }
    if (quantity == 1) {
      return;
    }
    quantity--;
    notifyListeners();
  }

  bool isInSet(List<String>? list) {
    bool result = false;
    if (selectedInventorySetIndex.isEmpty) {
      result = true;
    }
    for (var element in list ?? ['0']) {
      if (selectedInventorySetIndex.contains(element)) {
        result = true;
      }
    }
    return result;
  }

  clearSelection() {
    selectedAttributes = [];
    additionalInfoImage = null;
    cartAble = false;
    productSalePrice = productDetails!.product.salePrice;
    selectedInventorySetIndex = [];
    selectedAttributes = [];
    notifyListeners();
  }

  toggleDescriptionExpande() {
    descriptionExpand = !descriptionExpand;
    notifyListeners();
  }

  toggleADescriptionExpande() {
    aDescriptionExpand = !aDescriptionExpand;
    notifyListeners();
  }

  toggleReviewExpand() {
    reviewExpand = !reviewExpand;
    notifyListeners();
  }

  addToMap(value, int index, Map<String, List<String>> map) {
    if (value == null || map == {}) {
      return;
    }
    if (!map[value]!.contains(index.toString())) {
      map.update(value, (valuee) {
        valuee.add(index.toString());
        return valuee;
      });
    }

    return map;
  }

  Map<String, String> setAditionalInfo() {
    Map<String, String> data = {};
    for (var element in productDetails!.product.additionalInfo) {
      data.putIfAbsent(element.title, () => element.text);
    }
    return data.isEmpty ? {'1': 'No additional information available.'} : data;
  }

  clearProdcutDetails({pop = false}) {
    print('clearing product details');
    productDetails = null;
    reviewing = false;
    productSalePrice = 0;
    productDetails = null;
    descriptionExpand = false;
    aDescriptionExpand = false;
    reviewExpand = false;
    additionalInfoImage = null;
    quantity = 1;
    selectedInventorySetIndex = [];
    cartAble = false;
    // inventoryKeys = [];
    allAtrributes = {};
    selectedAttributes = [];
    reviewing = false;
    refreshpage = false;
    // productDetails!.product.productGalleryImage = [];

    // notifyListeners();
  }

  resetDetails() {
    productDetails = null;
  }

  setRefresPage(value) {
    refreshpage = true;
    notifyListeners();
  }

  setReviewing(value) {
    reviewing = value;
  }

  Future fetchProductDetails({id, bool nextProduct = false}) async {
    if (nextProduct) {
      clearProdcutDetails();
    }
    if (reviewing) {
      return;
    }
    print(id);
    inventoryKeys = [];
    inventoryHash = [];
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer $globalUserToken",
    };
    final url = Uri.parse('$baseApiUrl/product/$id');

    // try {
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      reviewing = true;
      var data = ProductDetailsModel.fromJson(jsonDecode(response.body));
      productDetails = data;
      productSalePrice = productDetails!.product.salePrice;
      final productInvenSet = productDetails!.productInventorySet;
      productInvenSet.forEach((element) {
        inventoryHash.add(element['hash']);
        element.remove('Color_name');
        element.remove('hash');
        final keys = element.keys;
        for (var e in keys) {
          if (inventoryKeys.contains(e)) {
            return;
          }
          inventoryKeys.add(e);
        }
      });

      {
        inventoryKeys.forEach((e) {
          int index = 0;
          List<String> list;
          Map<String, List<String>> map = {};
          for (dynamic element in productInvenSet) {
            if (element.containsKey(e)) {
              map.putIfAbsent(element[e], () => []);
              // print(map);
              if (allAtrributes.containsKey(e)) {
                allAtrributes.update(
                    e, (value) => addToMap(element[e], index, value));
              }
              allAtrributes.putIfAbsent(e, () {
                return addToMap(element[e], index, map);
              });
            }

            // addToList(cheeseList, element.cheese);
            index++;
          }
        });
      }

      additionalInventoryInfo = productDetails!.additionalInfoStore ?? {};
      if (productDetails!.additionalInfoStore == null) {
        cartAble = true;
      }

      notifyListeners();
      return;
    }
    loadingFailed = true;
    notifyListeners();
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }
}
