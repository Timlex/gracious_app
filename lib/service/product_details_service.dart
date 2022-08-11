import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/product_details_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class ProductDetailsService with ChangeNotifier {
  ProductDetailsModel? productDetails;
  bool descriptionExpand = false;
  bool aDescriptionExpand = false;
  List<String> selectedInventorySetIndex = [];
  String? selectedSize = '';
  String? selectedColor = '';
  String? selectedSauce = '';
  String? selectedMayo = '';
  String? selectedChese = '';
  List sizeList = [];
  List colorList = [];
  List sauceList = [];
  List mayoList = [];
  List cheeseList = [];
  // bool showSize = false;
  // bool showColor = false;
  // bool showSauce = false;
  // bool showMayo = false;
  // bool showCheese = false;
  Map<String, List<String>> sizeAttributes = {};
  Map<String, List<String>> colorAttributes = {};
  Map<String, List<String>> sauceAttributes = {};
  Map<String, List<String>> mayoAttributes = {};
  Map<String, List<String>> cheeseAttributes = {};

  setProductInventorySet(List<String>? value) {
    // print(
    //     selectedInventorySetIndex.toString() + 'inven........................');
    // print(value.toString() + 'val........................');

    if (selectedInventorySetIndex != value) {
      // if (value!.length == 1) {
      //   selectedInventorySetIndex = value;
      // print(selectedInventorySetIndex);
      if (selectedSize != '') {
        selectedSize =
            deselect(value, sizeAttributes[selectedSize]) ? selectedSize : '';
      }
      if (selectedColor != '') {
        selectedColor = deselect(value, colorAttributes[selectedColor])
            ? selectedColor
            : '';
      }
      if (selectedSauce != '') {
        selectedSauce = deselect(value, sauceAttributes[selectedSauce])
            ? selectedSauce
            : '';
      }
      if (selectedMayo != '') {
        selectedMayo =
            deselect(value, mayoAttributes[selectedMayo]) ? selectedMayo : '';
      }
      if ((selectedChese != '')) {
        selectedChese = deselect(value, cheeseAttributes[selectedChese])
            ? selectedChese
            : '';
      }
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

  bool deselect(List<String>? value, List<String>? list) {
    bool result = false;
    for (var element in value!) {
      if ((list!.contains(element))) {
        result = true;
      }
    }
    return result;
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
    selectedSize = '';
    selectedColor = '';
    selectedSauce = '';
    selectedMayo = '';
    selectedChese = '';
    selectedInventorySetIndex = [];
  }

  setSelectedSauce(value) {
    selectedSauce = value;
    notifyListeners();
  }

  setSelectedMayo(value) {
    selectedMayo = value;
    notifyListeners();
  }

  setSelectedCheese(value) {
    selectedChese = value;
    notifyListeners();
  }

  setSelectedColor(value) {
    selectedColor = value;
    print(selectedColor);
    notifyListeners();
  }

  setSelectedSize(value) {
    selectedSize = value;
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
    if (!map.containsKey(value)) {
      map.putIfAbsent(value, () => [index.toString()]);
      return;
    }
    map.update(value, (valuee) {
      valuee.add(index.toString());
      return valuee;
    });
  }

  Map<String, String> setAditionalInfo() {
    Map<String, String> data = {};
    for (var element in productDetails!.product.additionalInfo) {
      data.putIfAbsent(element.title, () => element.text);
    }
    return data;
  }

  clearProdcutDetails() {
    productDetails = null;
    descriptionExpand = false;
    bool aDescriptionExpand = false;
    sizeAttributes = {};
    colorAttributes = {};
    sauceAttributes = {};
    mayoAttributes = {};
    cheeseAttributes = {};
    selectedSize = '';
    selectedColor = '';
    selectedSauce = '';
    selectedMayo = '';
    selectedChese = '';
    selectedInventorySetIndex = [];
    print(mayoAttributes);

    notifyListeners();
  }

  Future fetchProductDetails(id) async {
    print(id);
    final url = Uri.parse('$baseApiUrl/product/$id');

    // try {
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = ProductDetailsModel.fromJson(jsonDecode(response.body));
      productDetails = data;
      int index = 0;
      for (var element in productDetails!.productInventorySet) {
        addToMap(productDetails!.productInventorySet[index].size, index,
            sizeAttributes);
        addToMap(productDetails!.productInventorySet[index].color, index,
            colorAttributes);
        addToMap(productDetails!.productInventorySet[index].sauce, index,
            sauceAttributes);
        addToMap(productDetails!.productInventorySet[index].mayo, index,
            mayoAttributes);
        addToMap(productDetails!.productInventorySet[index].cheese, index,
            cheeseAttributes);
        // addToList(sizeList, element.size);
        // addToList(colorList, element.color);
        // addToList(sauceList, element.sauce);
        // addToList(mayoList, element.mayo);
        // addToList(cheeseList, element.cheese);
        index++;
      }
      // showSize = productDetails!.productInventorySet[0].size != null;
      // showColor = productDetails!.productInventorySet[0].color != null;
      // showSauce = productDetails!.productInventorySet[0].sauce != null;
      // showMayo = productDetails!.productInventorySet[0].mayo != null;
      // showCheese = productDetails!.productInventorySet[0].cheese != null;
      // // setSelectedSauce(productDetails!.productInventorySet[0].sauce);
      // setSelectedCheese(productDetails!.productInventorySet[0].cheese);
      print(productDetails!.productInventorySet[0].mayo);

      print(productDetails!.product.title);
      // print(productDetails!.availableAttributes!.mayo);
      // print(productDetails!.availableAttributes!.sauce);
      // print(productDetails!.availableAttributes!.cheese);

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
    'size': {
      "m": [0, 1],
    },
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
