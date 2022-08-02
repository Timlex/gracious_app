import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/model/cart_data.dart';
import 'package:gren_mart/model/favorite_data.dart';
import 'package:gren_mart/service/navigation_bar_helper_service.dart';
import 'package:gren_mart/service/product_card_data_service.dart';
import 'package:gren_mart/view/cart/cart_view.dart';
import 'package:gren_mart/view/favorite/favorite.dart';
import 'package:gren_mart/view/home/home.dart';
import 'package:gren_mart/view/search/search.dart';
import 'package:gren_mart/view/settings/setting.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../service/auth_text_controller_service.dart';
import '../../service/country_dropdown_service.dart';
import '../../service/search_result_data_service.dart';
import '../../service/state_dropdown_service.dart';
import '../../service/user_profile_service.dart';
import '../search/filter_bottom_sheeet.dart';

class HomeFront extends StatelessWidget {
  static const String routeName = 'HomeFront/';

  HomeFront({Key? key}) : super(key: key);

  final ConstantColors cc = ConstantColors();
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
        actions: [
          customIconButton('notificationIcon', 'notification_bing.svg',
              padding: 10),
          const SizedBox(
            width: 17,
          )
        ],
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

  Widget navigationWidget = const Home();
  @override
  Widget build(BuildContext context) {
    _navigationIndex =
        Provider.of<NavigationBarHelperService>(context).navigationIndex;
    if (_navigationIndex == 0) {
      navigationWidget = const Home();
    } else if (_navigationIndex == 1) {
      navigationWidget = SearchView();
    }
    // Provider.of<UserProfileService>(context, listen: false).fetchProfileService(
    //     Provider.of<SignInSignUpService>(context, listen: false).token);
    Provider.of<CountryDropdownService>(context, listen: false)
        .getContries()
        .then((value) =>
            Provider.of<StateDropdownService>(context, listen: false)
                .getStates(value ?? 1));
    Provider.of<ProductCardDataService>(context, listen: false)
        .fetchFeaturedProductCardData();
    Provider.of<ProductCardDataService>(context, listen: false)
        .fetchCapmaignCardProductData();
    return Consumer<NavigationBarHelperService>(
        builder: (context, nData, child) {
      return Scaffold(
        appBar: manageAppBar(context,
            Provider.of<UserProfileService>(context).userProfileData.name),
        body: navigationWidget,
        bottomNavigationBar: BottomNavigationBar(
            onTap: (v) {
              nData.setNavigationIndex(v);
              if (nData.navigationIndex == 0) {
                nData.setSearchText('');
                navigationWidget = const Home();

                return;
              }
              if (nData.navigationIndex == 1) {
                Provider.of<SearchResultDataService>(context, listen: false)
                    .resetSerch();
                Provider.of<SearchResultDataService>(context, listen: false)
                    .fetchProductsBy(pageNo: '1');
                navigationWidget = SearchView();
                return;
              }
              if (nData.navigationIndex == 2) {
                navigationWidget = CartView();
                return;
              }
              if (nData.navigationIndex == 3) {
                navigationWidget = FavoriteView();
                return;
              }
              if (nData.navigationIndex == 4) {
                navigationWidget = const SettingView();
                return;
              }
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
    });
  }

  Future<void> setData(BuildContext context) async {
    final value = Provider.of<UserProfileService>(context).userProfileData;
    print('setting datas');
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setEmail(value.email);
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setName(value.name);
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setUserName(value.username);
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setEmail(value.email);
    await Provider.of<CountryDropdownService>(context, listen: false)
        .setCountryIdAndValue(value.country.name);

    await Provider.of<StateDropdownService>(context, listen: false)
        .setStateIdAndValue(value.state);
  }
}
