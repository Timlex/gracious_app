import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

class DODCard extends StatelessWidget {
  final String title;
  final String btText;
  final Function btFunction;
  final String image;

  DODCard(
    this.title,
    this.btText,
    this.btFunction,
    this.image,
  );

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.only(left: 20, top: 25),
      height: screenHight / 5.5,
      width: screenWidth / 1.6,
      // color: Color.fromARGB(110, 9, 154, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cc.lightPrimery2,
      ),

      child: Stack(children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth / 4.5,
                    child: FittedBox(
                      child: Text(
                        'Deal of the Day',
                        style: TextStyle(
                          color: cc.orange,
                          fontSize: screenWidth / 27,
                          // fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: screenWidth / 5,
                    child: SafeArea(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: cc.blackColor,
                          fontSize: screenWidth / 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     btFunction;
                  //   },
                  //   child: Text(btText),
                  //   style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 21,
                  //         vertical: 11,
                  //       ),
                  //       elevation: 0,
                  //       primary: cc.orange,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12))),
                  // ),
                  const Spacer()
                ],
              ),
              const Spacer(),
              Container(
                  height: screenHight / 7,
                  width: screenHight / 6.5,
                  margin: const EdgeInsets.only(right: 3),
                  child: Image.network(
                    image,
                    fit: BoxFit.fill,
                  )),
            ]),
        // Positioned(
        //   right: 0,
        //   bottom: 0,
        //   child:
        // ),
      ]),
    );
  }
}
