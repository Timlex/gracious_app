import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/navigation_bar_helper_service.dart';
import '../../service/search_result_data_service.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import 'all_camp_product_from_link.dart';

class CampaignCard extends StatelessWidget {
  final String title;
  final String btText;
  final Function btFunction;
  final String image;
  final bool showButton;
  int? camp;
  int? cat;

  CampaignCard(
      this.title, this.btText, this.btFunction, this.image, this.showButton,
      {this.camp, this.cat});

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.only(left: 20, top: 25),
      height: screenHight / 5,
      width: screenWidth / 1.3 < 300 ? 300 : screenWidth / 1.3,
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
                  if (showButton) const SizedBox(height: 15),
                  if (showButton)
                    ElevatedButton(
                      onPressed: () {
                        print('here');
                        print(camp);
                        print(cat);
                        if (camp != null) {
                          Navigator.of(context).pushNamed(
                              ALLCampProductFromLink.routeName,
                              arguments: [camp.toString()]);
                        }
                        if (cat != null) {
                          Provider.of<SearchResultDataService>(context,
                                  listen: false)
                              .resetSerch();
                          Provider.of<SearchResultDataService>(context,
                                  listen: false)
                              .setCategoryId(cat.toString());
                          Provider.of<SearchResultDataService>(context,
                                  listen: false)
                              .fetchProductsBy(pageNo: '1');
                          Provider.of<NavigationBarHelperService>(context,
                                  listen: false)
                              .setNavigationIndex(1);
                        }
                        btFunction;
                      },
                      child: FittedBox(
                        child: SizedBox(
                            width: screenWidth / 5,
                            child: Text(
                              btText,
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            )),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 21,
                            vertical: 11,
                          ),
                          elevation: 0,
                          primary: cc.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  const Spacer()
                ],
              ),
              const Spacer(),
              Container(
                  height: screenHight / 7,
                  width: screenHight / 6.5,
                  margin: const EdgeInsets.only(right: 3, bottom: 10),
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
