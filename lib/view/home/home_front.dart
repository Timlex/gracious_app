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

  int _navigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helloAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Home(),
        ),
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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
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
