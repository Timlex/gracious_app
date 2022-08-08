import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

class PosterCard extends StatelessWidget {
  final String title;
  final String btText;
  final String description;
  final Function btFunction;
  final String image;

  PosterCard(
    this.title,
    this.btText,
    this.description,
    this.btFunction,
    this.image,
  );

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //   // padding: const EdgeInsets.only(left: 20, top: 25),
        //   height: 15,
        //   width: 320,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Stack(
        //     children: [
        //       ClipRRect(
        //         borderRadius: BorderRadius.circular(20),
        //         child: SizedBox(
        //           height: double.infinity,
        //           width: 320,
        //           child: Image.network(
        //             image,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        Container(
      // margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
      // height: 15,
      width: screenWidth / 5,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          stops: [.6, 1],
          colors: [
            // Color.fromARGB(242, 220, 255, 222),
            Color(0xffDCFFDE),
            Color.fromARGB(107, 220, 255, 222),
          ],
        ),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth / 2.9,
              child: Text(
                title,
                style: TextStyle(
                  color: cc.blackColor,
                  fontSize: screenWidth / 25,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: screenWidth / 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    description,
                    style: TextStyle(
                      color: cc.greyParagraph,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 3,
                  ),
                )),
            // const SizedBox(height: 15),
            // ElevatedButton(
            //   onPressed: () {
            //     btFunction;
            //   },
            //   child: Text(btText),
            //   style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 22,
            //         vertical: 12,
            //       ),
            //       elevation: 0,
            //       primary: cc.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12))),
            // ),
            // const Spacer()
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SizedBox(
              height: screenHight / 7,
              width: screenWidth / 3.7,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              )),
        ),
      ]),
      //     ),
      //   ],
      // ),
    );
  }
}

class PosterCartSkelleton extends StatelessWidget {
  PosterCartSkelleton({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth / 5,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 45,
                width: screenWidth / 2.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: cc.greyDots,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 35,
                width: screenWidth / 3,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: cc.greyDots,
                ),
              ),
              Container(
                height: 35,
                width: screenWidth / 3,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: cc.greyDots,
                ),
              ),
              Container(
                height: 35,
                width: screenWidth / 3,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: cc.greyDots,
                ),
              ),
            ],
          ),
          Container(
            height: screenHight / 7,
            width: screenWidth / 3.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cc.greyDots,
            ),
          )
        ],
      ),
    );
  }
}
