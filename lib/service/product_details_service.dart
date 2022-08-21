import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/cupertino.dart';
import '../../model/product_details_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

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
  String? selectedSize;
  String? selectedColor;
  String? selectedColorName;
  String? selectedSauce;
  String? selectedMayo;
  String? selectedChese;
  // List sizeList = [];
  // List colorList = [];
  // List sauceList = [];
  // List mayoList = [];
  // List cheeseList = [];
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
      if (selectedSize != null) {
        selectedSize =
            deselect(value, sizeAttributes[selectedSize]) ? selectedSize : null;
      }
      if (selectedColor != null) {
        selectedColor = deselect(value, colorAttributes[selectedColor])
            ? selectedColor
            : null;
      }
      if (selectedSauce != null) {
        selectedSauce = deselect(value, sauceAttributes[selectedSauce])
            ? selectedSauce
            : null;
      }
      if (selectedMayo != null) {
        selectedMayo =
            deselect(value, mayoAttributes[selectedMayo]) ? selectedMayo : null;
      }
      if ((selectedChese != null)) {
        selectedChese = deselect(value, cheeseAttributes[selectedChese])
            ? selectedChese
            : null;
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

  addAdditionalPrice() {
    for (int i = 0; i < selectedInventorySetIndex.length; i++) {
      final selectedProduct = productDetails!
          .productInventorySet[int.parse(selectedInventorySetIndex[i])];

      if (selectedSize == selectedProduct.size &&
          selectedColor == selectedProduct.color &&
          selectedSauce == selectedProduct.sauce &&
          selectedMayo == selectedProduct.mayo &&
          selectedChese == selectedProduct.cheese &&
          additionalInventoryInfo.isNotEmpty) {
        final mapData = {};
        if (selectedChese != null) {
          mapData.putIfAbsent('Cheese', () => selectedChese);
        }
        if (selectedColor != null) {
          mapData.putIfAbsent('Color', () => selectedColor);
          mapData.putIfAbsent('Color_name', () => selectedProduct.colorName);
        }
        if (selectedMayo != null) {
          mapData.putIfAbsent('Mayo', () => selectedMayo);
        }
        if (selectedSauce != null) {
          mapData.putIfAbsent('Sauce', () => selectedSauce);
        }
        if (selectedSize != null) {
          mapData.putIfAbsent('Size', () => selectedSize);
        }
        final key = md5.convert(utf8.encode(json.encode(mapData))).toString();
        productSalePrice +=
            productDetails!.additionalInfoStore![key]!.additionalPrice;

        additionalInfoImage = productDetails!.additionalInfoStore![key]!.image;
        additionalInfoImage =
            additionalInfoImage == '' ? null : additionalInfoImage;
        cartAble = true;
        notifyListeners();
        break;
      }

      cartAble = false;
      productSalePrice = productDetails!.product.salePrice;
      notifyListeners();
    }
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
    selectedSize = null;
    selectedColor = null;
    selectedSauce = null;
    selectedMayo = null;
    selectedChese = null;
    additionalInfoImage = null;
    cartAble = false;
    productSalePrice = productDetails!.product.salePrice;
    selectedInventorySetIndex = [];
    notifyListeners();
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
    selectedColorName = productDetails!.productInventorySet
        .firstWhere((element) => element.color == value)
        .colorName;
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
    return data.isEmpty ? {'1': 'No additional information available.'} : data;
  }

  clearProdcutDetails() {
    productDetails = null;
    descriptionExpand = false;
    aDescriptionExpand = false;
    reviewExpand = false;
    sizeAttributes = {};
    colorAttributes = {};
    sauceAttributes = {};
    mayoAttributes = {};
    cheeseAttributes = {};
    selectedSize = null;
    selectedColor = null;
    selectedSauce = null;
    selectedMayo = null;
    selectedChese = null;
    additionalInfoImage = null;
    quantity = 1;
    selectedInventorySetIndex = [];
    print(mayoAttributes);
    notifyListeners();
  }

  Future fetchProductDetails(id) async {
    print(id);
    final url = Uri.parse('$baseApiUrl/product/$id');

    // try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = ProductDetailsModel.fromJson(jsonDecode(response.body));
      print(data.product.rating);
      productDetails = data;
      int index = 0;
      productSalePrice = productDetails!.product.price;
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
        // addToList(cheeseList, element.cheese);
        index++;
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
