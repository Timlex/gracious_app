import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/settings/change_password.dart';
import 'package:gren_mart/view/settings/manage_account.dart';
import 'package:gren_mart/view/settings/setting_screen_appbar.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        SettingScreenAppBar(),
        const Center(
          child: Text(
            'Cameron Williamson',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Text(
              '(480) 555-0103 · savannah.nguyen@example.com',
              style: TextStyle(
                fontSize: 14,
                color: cc.greyHint,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        settingItem('assets/images/icons/orders.svg', 'My Orders'),
        settingItem(
            'assets/images/icons/shipping_address.svg', 'Shipping Address'),
        settingItem('assets/images/icons/manage_profile.svg', 'Manage Account',
            onTap: () {
          Navigator.of(context).pushNamed(ManageAccount.routeName);
        }),
        settingItem('assets/images/icons/change_pass.svg', 'Change Password',
            icon: false,
            imagePath2: 'assets/images/change_pass.png', onTap: () {
          Navigator.of(context).pushNamed(ChangePassword.routeName);
        }),
        const SizedBox(height: 70),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: customContainerButton('Log Out', double.infinity, () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Auth()),
                (Route<dynamic> route) => false);
          }),
        )
      ],
    );
  }

  Widget settingItem(String imagePath, String itemText,
      {void Function()? onTap, bool icon = true, String? imagePath2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        child: Column(
          children: [
            SizedBox(
              child: ListTile(
                onTap: onTap,
                visualDensity: VisualDensity(vertical: -3),
                dense: false,
                leading: icon
                    ? SvgPicture.asset(
                        imagePath,
                        height: 40,
                      )
                    : Image.asset(imagePath2!),
                title: Text(
                  itemText,
                  style: TextStyle(
                    fontSize: 16,
                    color: cc.blackColor,
                  ),
                ),
                trailing:
                    SvgPicture.asset('assets/images/icons/arrow_right.svg'),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
