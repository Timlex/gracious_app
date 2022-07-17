import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/browse/browse.dart';
import 'package:gren_mart/view/cart/cart_view.dart';
import 'package:gren_mart/view/home/home.dart';
import 'package:gren_mart/view/home/home_helper.dart';
import 'package:gren_mart/view/settings/setting.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../search/filter_bottom_sheeet.dart';

class HomeFront extends StatefulWidget {
  static const String routeName = 'HomeFront/';

  const HomeFront({Key? key}) : super(key: key);

  @override
  State<HomeFront> createState() => _HomeFrontState();
}

class _HomeFrontState extends State<HomeFront> {
  final ConstantColors cc = ConstantColors();

  List views = [
    Home(),
    Browse(),
    Cart(),
    SettingView(),
  ];

  int _navigationIndex = 0;

  PreferredSizeWidget? manageAppBar() {
    if (_navigationIndex == 0) {
      return helloAppBar();
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: manageAppBar(),
      body: views[_navigationIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (v) {
            setState(() {
              _navigationIndex = v;
            });
          },
          // fixedColor: cc.blackColor,
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
                  'assets/images/icons/browsing_selected.svg',
                  height: 27,
                  color: cc.primaryColor,
                ),
                icon: SvgPicture.asset(
                  'assets/images/icons/browsing.svg',
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
                icon: SvgPicture.asset(
                  'assets/images/icons/bag.svg',
                  height: 27,
                  color: cc.greyHint,
                ),
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
