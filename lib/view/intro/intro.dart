import 'package:flutter/material.dart';
import 'package:gren_mart/service/state_dropdown_service.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/intro/dot_indicator.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import './intro_helper.dart';

class Intro extends StatefulWidget {
  static const routeName = 'intro';

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int selectedindex = 0;

  final PageController _controller = PageController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHight / 5),
            SizedBox(
              height: screenHight / 2,
              child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      selectedindex = index;
                    });
                  },
                  children: IntroHelper.introData
                      .map(
                        (e) => Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: screenHight / 3.5,
                                width: screenHight / 3.5,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Image.asset(e['imagePath'] as String),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                e['introTitle'] as String,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors().titleTexts,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                e['description'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: ConstantColors().greyParagraph,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _dotIdicators(),
            ),
            Expanded(child: Container()),
            customRowButton('Skip', 'Continue', () {
              Provider.of<StateDropdownService>(context, listen: false)
                  .getStates(1);
              Navigator.of(context).pushReplacementNamed(Auth.routeName);
            }, () {
              if (selectedindex < 2) {
                setState(() {
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                });
                selectedindex++;
                return;
              }
              if (selectedindex == 2) {
                Provider.of<StateDropdownService>(context, listen: false)
                    .getStates(1);
                Navigator.of(context).pushReplacementNamed(Auth.routeName);
              }
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> _dotIdicators() {
    List<Widget> list = [];
    for (int i = 0; i < IntroHelper.introData.length; i++) {
      list.add(i == selectedindex ? DotIndicator(true) : DotIndicator(false));
    }
    return list;
  }
}
