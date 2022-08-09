import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../view/settings/manage_account.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';

class SettingScreenAppBar extends StatelessWidget {
  String? image;
  SettingScreenAppBar(this.image, {Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHight / 3,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: screenHight / 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: cc.greyYellow,
              // boxShadow: const [
              //   BoxShadow(
              //       color: Colors.grey,
              //       blurRadius: 4,
              //       spreadRadius: 2,
              //       blurStyle: BlurStyle.normal)
              // ],
            ),
          ),
          Positioned(
            top: screenHight / 6,
            right: screenWidth / 2.9,
            child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(ManageAccount.routeName),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: CachedNetworkImage(
                    height: screenWidth / 3.16,
                    width: screenWidth / 3.16,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    imageUrl: image ?? '',
                    placeholder: (context, url) => Image.asset(
                      'assets/images/skelleton.png',
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
                // CircleAvatar(
                //   backgroundColor: cc.greyYellow,
                //   radius: screenWidth / 6.5,
                //   backgroundImage: image != null
                //       ? NetworkImage(
                //           image as String,
                //         )
                //       : const AssetImage('assets/images/setting_dp.png')
                //           as ImageProvider<Object>,
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
