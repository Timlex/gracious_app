import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/model/cart_data.dart';
import 'package:gren_mart/model/favorite_data.dart';
import 'package:gren_mart/view/cart/cart_view.dart';
import 'package:gren_mart/view/favorite/favorite.dart';
import 'package:gren_mart/view/home/home.dart';
import 'package:gren_mart/view/search/search.dart';
import 'package:gren_mart/view/settings/setting.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../service/user_profile_service.dart';
import '../search/filter_bottom_sheeet.dart';

class HomeFront extends StatefulWidget {
  static const String routeName = 'HomeFront/';

  const HomeFront({Key? key}) : super(key: key);

  @override
  State<HomeFront> createState() => _HomeFrontState();
}

class _HomeFrontState extends State<HomeFront> {
  final ConstantColors cc = ConstantColors();
  final TextEditingController _textEditingController = TextEditingController();

  // List views = [
  //   Home(),
  //   SearchView(_textEditingController),
  //   Cart(),
  //   const FavoriteView(),
  //   SettingView(),
  // ];

  int _navigationIndex = 0;

  PreferredSizeWidget? manageAppBar(BuildContext context, String name) {
    if (_navigationIndex == 0) {
      return helloAppBar(name);
    }
    if (_navigationIndex == 1) {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: const FilterBottomSheet(),
                ),
              );
            },
            icon: SvgPicture.asset('assets/images/icons/filter_setting.svg')),
        // actions: [
        //   customIconButton('notificationIcon', 'notification_bing.svg',
        //       padding: 10),
        //   const SizedBox(
        //     width: 17,
        //   )
        // ],
      );
    }
    if (_navigationIndex == 2) {
      return AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My cart',
          style: TextStyle(
              color: cc.blackColor, fontSize: 19, fontWeight: FontWeight.w700),
        ),
      );
    }
    if (_navigationIndex == 3) {
      return AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My favorite',
          style: TextStyle(
              color: cc.blackColor, fontSize: 19, fontWeight: FontWeight.w700),
        ),
      );
    }
    return null;
  }

  void searchHelper() {
    setState(() {
      _navigationIndex = 1;
    });
  }

  Widget navigationWidget = Home();
  @override
  Widget build(BuildContext context) {
    if (_navigationIndex == 0) {
      navigationWidget = Home(
        searchController: _textEditingController,
        onFieldSubmitted: searchHelper,
      );
    } else if (_navigationIndex == 1) {
      navigationWidget = SearchView(_textEditingController);
    }
    return Scaffold(
      appBar: manageAppBar(context,
          Provider.of<UserProfileService>(context).userProfileData.name),
      body: navigationWidget,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (v) {
            setState(() {
              _navigationIndex = v;
              if (v == 0) {
                _textEditingController.clear();
                navigationWidget = Home(
                  searchController: _textEditingController,
                );

                return;
              }
              if (v == 1) {
                navigationWidget = SearchView(_textEditingController);
                return;
              }
              if (v == 2) {
                navigationWidget = CartView();
                return;
              }
              if (v == 3) {
                navigationWidget = FavoriteView();
                return;
              }
              if (v == 4) {
                navigationWidget = const SettingView();
                return;
              }
            });
          },
          // fixedColor: cc.blackColor,

          type: BottomNavigationBarType.fixed,
          backgroundColor: cc.blackColor,
          selectedItemColor: cc.blackColor,
          unselectedItemColor: cc.blackColor,
          currentIndex: _navigationIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/images/icons/home_selected.svg',
                  height: 27,
                  color: cc.primaryColor,
                ),
                icon: SvgPicture.asset(
                  'assets/images/icons/home.svg',
                  height: 27,
                  color: cc.greyHint,
                ),
                label: ''),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/images/icons/search_fill.svg',
                  height: 27,
                  color: cc.primaryColor,
                ),
                icon: SvgPicture.asset(
                  'assets/images/icons/search.svg',
                  height: 27,
                  color: cc.greyHint,
                ),
                label: ''),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/images/icons/bag_fill.svg',
                  height: 27,
                  color: cc.primaryColor,
                ),
                icon: Consumer<CartData>(builder: (context, cartData, child) {
                  return Badge(
                    showBadge: cartData.cartList.isEmpty ? false : true,
                    badgeContent: Text(
                      cartData.totalQuantity().toString(),
                      style: TextStyle(color: cc.pureWhite),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/icons/bag.svg',
                      height: 27,
                      color: cc.greyHint,
                    ),
                  );
                }),
                label: ''),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/images/icons/heart_fill.svg',
                  height: 27,
                  color: cc.primaryColor,
                ),
                icon: Consumer<FavoriteData>(
                    builder: (context, favoriteData, child) {
                  return Badge(
                    showBadge:
                        favoriteData.favoriteItems.isEmpty ? false : true,
                    badgeContent: Text(
                      favoriteData.favoriteItems.length.toString(),
                      style: TextStyle(color: cc.pureWhite),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/icons/heart.svg',
                      height: 27,
                      color: cc.greyHint,
                    ),
                  );
                }),
                label: ''),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/images/icons/setting_fill.svg',
                  height: 27,
                  color: cc.primaryColor,
                ),
                icon: SvgPicture.asset(
                  'assets/images/icons/setting_unfill.svg',
                  height: 27,
                  color: cc.greyHint,
                ),
                label: ''),
          ]
          //
          // BNHelper.bottomNavigationIconData
          //     .map(
          //       (e) => BottomNavigationBarItem(
          //           icon: SvgPicture.asset(
          //               'assets/images/icons/${e['iconPath']}'),
          //           label: e['iconName'] as String),
          //     )
          //     .toList()),
          ),
    );
  }
}
