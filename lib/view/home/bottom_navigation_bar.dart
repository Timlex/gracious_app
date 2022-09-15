import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../service/cart_data_service.dart';
import '../../service/favorite_data_service.dart';
import '../../service/navigation_bar_helper_service.dart';

class CustomNavigationBar extends StatelessWidget {
  CustomNavigationBar({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationBarHelperService>(
        builder: (context, nData, child) {
      return BottomNavigationBar(
          onTap: (v) {
            Navigator.of(context).pop();
            nData.setNavigationIndex(v);
            return;
          },
          // fixedColor: cc.blackColor,

          type: BottomNavigationBarType.fixed,
          backgroundColor: cc.blackColor,
          selectedItemColor: cc.blackColor,
          unselectedItemColor: cc.blackColor,
          currentIndex: nData.navigationIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: items);
    });
  }

  List<BottomNavigationBarItem> get items => [
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
              'assets/images/icons/search_navi.svg',
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
            icon:
                Consumer<CartDataService>(builder: (context, cartData, child) {
              return Badge(
                showBadge: cartData.cartList!.isEmpty ? false : true,
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
            icon: Consumer<FavoriteDataService>(
                builder: (context, favoriteData, child) {
              return Badge(
                showBadge: favoriteData.favoriteItems.isEmpty ? false : true,
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
      ];
}
