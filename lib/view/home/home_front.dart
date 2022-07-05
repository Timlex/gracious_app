import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/home/home.dart';
import 'package:gren_mart/view/home/navigation_helper.dart';
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

  List views = [Home()];

  int _navigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helloAppBar(),
      body: SingleChildScrollView(
        child: views[_navigationIndex],
      ),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '')
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
