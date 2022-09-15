import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/service/paypal_service.dart';
import 'package:gren_mart/service/product_details_service.dart';
import 'package:gren_mart/view/details/product_details.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../service/favorite_data_service.dart';
import '../../service/language_service.dart';
import '../../view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../utils/constant_styles.dart';
import '../utils/text_themes.dart';

class FavoriteTile extends StatelessWidget {
  final int id;

  FavoriteTile(this.id, {Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDataService>(
        builder: (context, favoriteData, child) {
      final favoriteItem = favoriteData.favoriteItems.values
          .toList()
          .firstWhere((element) => element.id == id);
      return Dismissible(
        dragStartBehavior: DragStartBehavior.start,
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: cc.pink,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Spacer(),
              Text(
                'Delete',
                style: TextStyle(color: cc.pureWhite, fontSize: 17),
              ),
              const SizedBox(width: 15),
              SvgPicture.asset(
                'assets/images/icons/trash.svg',
                height: 22,
                width: 22,
                color: cc.pureWhite,
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          favoriteData.deleteFavoriteItem(id, context);
        },
        key: Key(id.toString()),
        child: SizedBox(
          height: 75,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ProductDetails.routeName, arguments: [id]);
                },
                leading: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      //  const BorderRadius.only(
                      //     topLeft: Radius.circular(10),
                      //     topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: favoriteItem.imgUrl,
                        placeholder: (context, url) =>
                            SvgPicture.asset('assets/images/image_empty.svg'),
                        errorWidget: (context, url, error) =>
                            SvgPicture.asset('assets/images/image_empty.svg'),
                      ),
                    )),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth / 2.5,
                            child: Text(
                              favoriteItem.title,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          const SizedBox(height: 13),
                          Text(
                            '\$${favoriteItem.price}',
                            style: TextThemeConstrants.primary13,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (() async {
                        if (!favoriteItem.attribute) {
                          print(favoriteItem.attribute);
                          showMaterialModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              builder: (context) {
                                bool fetchAttribute = true;
                                return Consumer<ProductDetailsService>(
                                  builder: (context, pdService, child) {
                                    return SingleChildScrollView(
                                      child: FutureBuilder(
                                        future: pdService.fetchProductDetails(
                                            id: id,
                                            nextProduct: fetchAttribute),
                                        builder: (context, snapshot) {
                                          fetchAttribute = false;
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox(
                                                height: 60,
                                                child: loadingProgressBar());
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  child: Text(
                                                    'Select attributes:',
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children:
                                                        pdService.inventoryKeys
                                                            .map(
                                                                (e) =>
                                                                    Container(
                                                                      alignment: LanguageService().rtl
                                                                          ? Alignment
                                                                              .centerRight
                                                                          : Alignment
                                                                              .centerLeft,
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              15),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                              '${e.replaceFirst('_', ' ')}:',
                                                                              style: ProductDetails().attributeTitleTheme),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          Expanded(
                                                                            child:
                                                                                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ProductDetails().generateDynamicAttrribute(pdService, pdService.allAtrributes[e]))),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ))
                                                            .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              });
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.only(left: 7),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset(
                          'assets/images/icons/send_to_cart.svg',
                          height: 26,
                          color: cc.primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (() async {
                        bool deleteItem = false;
                        await confirmDialouge(context,
                            onPressed: () => deleteItem = true);
                        if (deleteItem) {
                          favoriteData.deleteFavoriteItem(id, context);
                        }
                      }),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: SvgPicture.asset(
                          'assets/images/icons/trash.svg',
                          height: 22,
                          width: 22,
                          color: cc.pink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // if (!(CartData().cartList.last == ele)) const Divider(),
            ],
          ),
        ),
      );
    });
  }

  Future confirmDialouge(BuildContext context,
      {required void Function() onPressed}) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('This Item will be Deleted.'),
              actions: [
                FlatButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    child: Text(
                      'No',
                      style: TextStyle(color: cc.primaryColor),
                    )),
                FlatButton(
                    onPressed: () {
                      onPressed();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: cc.pink),
                    ))
              ],
            ));
  }
}
