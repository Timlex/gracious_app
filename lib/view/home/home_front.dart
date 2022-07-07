import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/cart/cart_view.dart';
import 'package:gren_mart/view/home/home.dart';
import 'package:gren_mart/view/home/home_helper.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

class HomeFront extends StatefulWidget {
  static const String routeName = 'HomeFront/';

  HomeFront({Key? key}) : super(key: key);

  @override
  State<HomeFront> createState() => _HomeFrontState();
}

class _HomeFrontState extends State<HomeFront> {
  final ConstantColors cc = ConstantColors();

  List views = [Home(), Cart()];

  int _navigationIndex = 0;

  PreferredSizeWidget manageAppBar() {
    if (_navigationIndex == 0) {
      return helloAppBar();
    }
    return AppBar(
      elevation: 1,
      title: Center(
        child: Text(
          'My cart',
          style: TextStyle(
              color: cc.blackColor, fontSize: 19, fontWeight: FontWeight.w700),
        ),
      ),
    );
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
          backgroundColor: cc.blackColor,
          selectedItemColor: cc.primaryColor,
          unselectedItemColor: cc.greyHint,
          currentIndex: _navigationIndex,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
                icon: _navigationIndex == 0
                    ? SvgPicture.asset(
                        'assets/images/icons/home_selected.svg',
                        height: 27,
                        color: cc.primaryColor,
                      )
                    : SvgPicture.asset(
                        'assets/images/icons/home.svg',
                        height: 27,
                        color: cc.greyHint,
                      ),
                label: ''),
            BottomNavigationBarItem(
                icon: _navigationIndex == 1
                    ? SvgPicture.asset(
                        'assets/images/icons/bag_fill.svg',
                        height: 27,
                        color: cc.primaryColor,
                      )
                    : SvgPicture.asset(
                        'assets/images/icons/bag.svg',
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
