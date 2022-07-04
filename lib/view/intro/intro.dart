import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/intro/dot_indicator.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
                                height: 250,
                                width: 250,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Image.asset(e['imagePath'] as String),
                              ),
                              SizedBox(height: 8),
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
                              const SizedBox(height: 36),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _dotIdicators(),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList()),
            ),
            Row(
              children: [
                //skip Button

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(Auth.routeName);
                  },
                  child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 50,
                      width: 180,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: ConstantColors().primaryColor,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ConstantColors().primaryColor,
                            fontWeight: FontWeight.w700),
                      )),
                ),

                //continue button

                GestureDetector(
                    onTap: () {
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
                        Navigator.of(context)
                            .pushReplacementNamed(Auth.routeName);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 50,
                      width: 180,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ConstantColors().primaryColor,
                      ),
                      child: const Text(
                        'Continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
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
