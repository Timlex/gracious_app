import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/service/signin_signup_service.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/settings/change_password.dart';
import 'package:gren_mart/view/settings/manage_account.dart';
import 'package:gren_mart/view/order/orders.dart';
import 'package:gren_mart/view/settings/setting_screen_appbar.dart';
import 'package:gren_mart/view/settings/shipping_addresses.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool login = true;

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
        settingItem('assets/images/icons/orders.svg', 'My Orders', onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) => MyOrders(),
          ));
        }),
        settingItem(
            'assets/images/icons/shipping_address.svg', 'Shipping Address',
            onTap: () {
          Navigator.of(context).pushNamed(ShippingAdresses.routeName);
        }),
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
            Provider.of<SignInSignUpService>(context, listen: false).signOut();
            Provider.of<SignInSignUpService>(context, listen: false)
                .toggleLaodingSpinner();
            Provider.of<SignInSignUpService>(context, listen: false)
                .getUserData();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Auth()),
                (Route<dynamic> route) => false);
          }),
        ),
        const SizedBox(height: 40),
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
                visualDensity: const VisualDensity(vertical: -3),
                dense: false,
                leading: icon
                    ? SvgPicture.asset(
                        imagePath,
                        height: 35,
                      )
                    : SizedBox(height: 35, child: Image.asset(imagePath2!)),
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
            const Divider()
          ],
        ),
      ),
    );
  }
}
