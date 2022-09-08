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
  int productSalePrice = 0;
  int quantity = 1;
  String? additionalInfoImage;
  List<String> selectedInventorySetIndex = [];
  List<String> inventoryKeys = [];
  Map<String, Map<String, List<String>>> allAtrributes = {};
  List selectedAttributes = [];
  Map<String, List<Map<String, dynamic>>> inventorySet = {};
  Map<String, dynamic> selecteInventorySet = {};

  setProductInventorySet(List<String>? value) {
    // print(
    //     selectedInventorySetIndex.toString() + 'inven........................');
    // print(value.toString() + 'val........................');

    if (selectedInventorySetIndex != value) {
      // if (value!.length == 1) {
      //   selectedInventorySetIndex = value;
      // print(selectedInventorySetIndex);
      // inventoryKeys.forEach((element) {
      //   if (selectedSize != null) {
      //   selectedSize =
      //       deselect(value, allAtrributes[element][selectedSize]) ? selectedSize : null;
      // }
      // });
      // if (selectedSize != null) {
      //   selectedSize =
      //       deselect(value, sizeAttributes[selectedSize]) ? selectedSize : null;
      // }
      // if (selectedColor != null) {
      //   selectedColor = deselect(value, colorAttributes[selectedColor])
      //       ? selectedColor
      //       : null;
      // }
      // if (selectedSauce != null) {
      //   selectedSauce = deselect(value, sauceAttributes[selectedSauce])
      //       ? selectedSauce
      //       : null;
      // }
      // if (selectedMayo != null) {
      //   selectedMayo =
      //       deselect(value, mayoAttributes[selectedMayo]) ? selectedMayo : null;
      // }
      // if ((selectedChese != null)) {
      //   selectedChese = deselect(value, cheeseAttributes[selectedChese])
      //       ? selectedChese
      //       : null;
      // }
      //   print('Its here');
      //   return;
      // }
      // print('Its here too');
      // selectedSize = '';
      // selectedColor = '';
      // selectedSauce = '';
      // selectedMayo = '';
      // selectedChese = '';
    }
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
        confirmingSelectedDeta.add(selecteInventorySet['hash']);
        if (!confirmingSelectedDeta.contains(e)) {
          setMatched = false;
        }
      });
      final mapData = {};

      // if (selectedSize == selectedProduct.size &&
      //     selectedColor == selectedProduct.color &&
      //     selectedSauce == selectedProduct.sauce &&
      //     selectedMayo == selectedProduct.mayo &&
      //     selectedChese == selectedProduct.cheese &&
      //     additionalInventoryInfo.isNotEmpty) {
      //   final mapData = {};
      //   if (selectedChese != null) {
      //     mapData.putIfAbsent('Cheese', () => selectedChese);
      //   }
      //   if (selectedColor != null) {
      //     mapData.putIfAbsent('Color', () => selectedColor);
      //     mapData.putIfAbsent('Color_name', () => selectedProduct.colorName);
      //   }
      //   if (selectedMayo != null) {
      //     mapData.putIfAbsent('Mayo', () => selectedMayo);
      //   }
      //   if (selectedSauce != null) {
      //     mapData.putIfAbsent('Sauce', () => selectedSauce);
      //   }
      //   if (selectedSize != null) {
      //     mapData.putIfAbsent('Size', () => selectedSize);
      //   }
      //   final key = md5.convert(utf8.encode(json.encode(mapData))).toString();
      //   productSalePrice +=
      //       productDetails!.additionalInfoStore![key]!.additionalPrice;

      //   additionalInfoImage = productDetails!.additionalInfoStore![key]!.image;
      //   additionalInfoImage =
      //       additionalInfoImage == '' ? null : additionalInfoImage;
      //   cartAble = true;
      //   notifyListeners();
      //   break;
      // }
      if (setMatched) {
        break;
      }
    }
    if (setMatched) {
      final key = selecteInventorySet['hash'];
      productSalePrice += productDetails!.additionalInfoStore![key] == null
          ? 0
          : productDetails!.additionalInfoStore![key]!.additionalPrice;
      additionalInfoImage = productDetails!.additionalInfoStore![key] == null
          ? ''
          : productDetails!.additionalInfoStore![key]!.image;
      additionalInfoImage =
          additionalInfoImage == '' ? null : additionalInfoImage;
      cartAble = true;
      selecteInventorySet.remove('hash');
      print(selecteInventorySet);
      notifyListeners();
      return;
    }
    cartAble = false;
    productSalePrice = productDetails!.product.salePrice;
    additionalInfoImage = null;
    selecteInventorySet = {};
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

  // addToList(List list, value) {
  //   if (list.contains(value)) {
  //     return;
  //   }
  //   list.add(value);
  // }

  addToMap(value, int index, Map<String, List<String>> map) {
    if (value == null || map == {}) {
      return;
    }

    // if (!map.containsKey(value)) {
    //   map.putIfAbsent(value, () => [index.toString()]);
    //   return map;
    // }
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

  clearProdcutDetails() {
    productSalePrice = 0;
    productDetails = null;
    descriptionExpand = false;
    aDescriptionExpand = false;
    reviewExpand = false;
    additionalInfoImage = null;
    quantity = 1;
    selectedInventorySetIndex = [];
    // inventoryKeys = [];
    allAtrributes = {};
    selectedAttributes = [];
    notifyListeners();
  }

  Future fetchProductDetails(id) async {
    print(id);
    inventoryKeys = [];
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
      var data = ProductDetailsModel.fromJson(jsonDecode(response.body));
      productDetails = data;
      productSalePrice = productDetails!.product.salePrice;
      final productInvenSet = productDetails!.productInventorySet;
      productInvenSet.forEach((element) {
        final keys = element.keys;
        for (var e in keys) {
          if (inventoryKeys.contains(e)) {
            return;
          }
          inventoryKeys.add(e);
        }
      });
      inventoryKeys.remove('hash');
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
    } else {
      //something went wrong
    }
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }

  final productInvenSet = {
    'color': {
      "#710404": [0, 2],
    },
    'sauce': {
      "Tartar": [0],
      "Soy": [1],
    },
    'mayo': {
      "Lime": [0],
      "Wasabi": [1],
    },
    'cheese': {
      "mozzarella": [0],
      "white": [1],
    },
  };
}
