import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../service/cart_data_service.dart';
import '../../service/favorite_data_service.dart';
import '../../service/navigation_bar_helper_service.dart';
import '../../service/product_card_data_service.dart';
import '../../view/cart/cart_view.dart';
import '../../view/favorite/favorite.dart';
import '../../view/home/home.dart';
import '../../view/search/search.dart';
import '../../view/settings/setting.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_styles.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

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
    final values = Provider.of<SearchResultDataService>(context, listen: false);
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
            icon: SvgPicture.asset(
              'assets/images/icons/filter_setting.svg',
              color: Provider.of<SearchResultDataService>(context).finterOn
                  ? cc.primaryColor
                  : null,
            )),
        actions: [
          PopupMenuButton<String>(
              icon: Icon(
                Icons.sort,
                color: cc.blackColor,
              ),
              onSelected: (value) {
                print(value);
                Provider.of<SearchResultDataService>(context, listen: false)
                  ..setSortBy(value)
                  ..resetSerch()
                  ..fetchProductsBy();
                // Provider.of<SearchResultDataService>(context, listen: false)
                //     .fetchProductsBy(pageNo: '1');
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Popularity'),
                      value: values.sortOption[0],
                    ),
                    PopupMenuItem(
                      child: const Text('Letest'),
                      value: values.sortOption[1],
                    ),
                    PopupMenuItem(
                      child: const Text('Lower price'),
                      value: values.sortOption[2],
                    ),
                    PopupMenuItem(
                      child: const Text('Higher price'),
                      value: values.sortOption[3],
                    ),
                  ]),
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
    searchHelper(context);

    return Consumer<NavigationBarHelperService>(
        builder: (context, nData, child) {
      return Scaffold(
        appBar: manageAppBar(context,
            Provider.of<UserProfileService>(context).userProfileData.name),
        body: navigationWidget,
        bottomNavigationBar: BottomNavigationBar(
            onTap: (v) {
              ontapIndexManager(context, v, nData);
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
            items: items),
      );
    });
  }

  countryStateInitiate(BuildContext context) {
    Provider.of<CountryDropdownService>(context, listen: false)
        .getContries()
        .then((value) =>
            Provider.of<StateDropdownService>(context, listen: false)
                .getStates(value ?? 1));
  }

  productsGetter(BuildContext context) {
    Provider.of<ProductCardDataService>(context, listen: false)
        .fetchFeaturedProductCardData();
    Provider.of<ProductCardDataService>(context, listen: false)
        .fetchCapmaignCardProductData();
  }

  ontapIndexManager(
    BuildContext context,
    int v,
    NavigationBarHelperService nData,
  ) {
    nData.setNavigationIndex(v);
    if (nData.navigationIndex == 0) {
      nData.setSearchText('');
      navigationWidget = const Home();

      return;
    }
    if (nData.navigationIndex == 1) {
      Provider.of<SearchResultDataService>(context, listen: false).resetSerch();
      Provider.of<SearchResultDataService>(context, listen: false)
          .resetSerchFilters();
      Provider.of<SearchResultDataService>(context, listen: false)
          .setSearchText('');
      nData.setSearchText('');
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
      navigationWidget = SettingView();
      return;
    }
  }

  searchHelper(BuildContext context) {
    _navigationIndex =
        Provider.of<NavigationBarHelperService>(context).navigationIndex;
    if (_navigationIndex == 0) {
      countryStateInitiate(context);
      productsGetter(context);
      navigationWidget = const Home();
    }
    if (_navigationIndex == 1) {
      navigationWidget = SearchView();
    }
    if (_navigationIndex == 2) {
      navigationWidget = CartView();
    }
    if (_navigationIndex == 3) {
      navigationWidget = FavoriteView();
    }
    if (_navigationIndex == 4) {
      navigationWidget = SettingView();
    }
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
