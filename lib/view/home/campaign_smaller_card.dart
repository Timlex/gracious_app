import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/text_themes.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CampaignSmallerCard extends StatelessWidget {
  CampaignSmallerCard({Key? key}) : super(key: key);
  final cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    initiateDeviceSize(context);
    return Container(
      height: (screenHight / 3.4 < 221 ? 195 : screenHight / 3.4),
      width: screenWidth / 2.5,
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: cc.lightPrimery3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            SizedBox(
              height: (screenHight / 3.4 < 221 ? 195 : screenHight / 3.4),
              width: screenWidth / 2.5,
              child: Image.network(
                'https://zahid.xgenious.com/grenmart-api/assets/uploads/media-uploader/011642229673.png',
                fit: BoxFit.fill,
                // color: cc.pureWhite.withOpacity(.5),
                // colorBlendMode: BlendMode.luminosity,
              ),
            ),
            Container(
              height: (screenHight / 3.4 < 221 ? 195 : screenHight / 3.4),
              width: screenWidth / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      cc.pureWhite.withOpacity(.1),
                      cc.blackColor.withOpacity(1),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    // stops: [.1, .3, 1],
                    tileMode: TileMode.mirror),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      child: SlideCountdownSeparated(
                    showZeroValue: true,
                    separator: '',
                    decoration: BoxDecoration(color: cc.primaryColor),
                    duration: Duration(days: 150),
                  )),
                  SizedBox(height: 5),
                  Text('New year sale',
                      style: TextStyle(
                        color: cc.pureWhite,
                        fontSize: screenWidth / 24,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: 5),
                  Text(
                    'New Year\'s Eve Sale',
                    style: TextThemeConstrants.paragraphText
                        .copyWith(color: cc.pureWhite.withOpacity(.8)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
