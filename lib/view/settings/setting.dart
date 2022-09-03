import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/signin_signup_service.dart';
import '../../service/user_profile_service.dart';
import '../../view/auth/auth.dart';
import '../../view/settings/change_password.dart';
import '../../view/settings/manage_account.dart';
import '../../view/order/orders.dart';
import '../../view/settings/setting_screen_appbar.dart';
import '../../view/settings/shipping_addresses.dart';
import '../../view/ticket/all_ticket_view.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../service/auth_text_controller_service.dart';
import '../../service/ticket_service.dart';
import '../utils/text_themes.dart';

class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);

  bool login = true;

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileService>(builder: (context, uData, child) {
      return ListView(
        padding: const EdgeInsets.all(0),
        children: [
          SettingScreenAppBar(uData.userProfileData.profileImageUrl),
          const SizedBox(height: 20),
          Center(
            child: Text(
              uData.userProfileData.name,
              style: TextThemeConstrants.titleText,
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: Text(
                (uData.userProfileData.phone == null
                        ? ''
                        : uData.userProfileData.phone.toString() + '.') +
                    uData.userProfileData.email.toString(),
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
            Provider.of<ShippingAddressesService>(context, listen: false)
                .fetchUsersShippingAddress(context);
            Navigator.of(context).pushNamed(ShippingAdresses.routeName).then(
                (value) => Provider.of<ShippingAddressesService>(context,
                        listen: false)
                    .setNoData(false));
          }),
          settingItem(
              'assets/images/icons/manage_profile.svg', 'Manage Account',
              onTap: () async {
            // setData(context);
            Navigator.of(context).pushNamed(ManageAccount.routeName);
          }),
          settingItem(
              'assets/images/icons/support_ticket.svg', 'Support Ticket',
              icon: true,
              imagePath2: 'assets/images/change_pass.png', onTap: () {
            Provider.of<TicketService>(context, listen: false).fetchTickets();
            Navigator.of(context).pushNamed(AllTicketsView.routeName);
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
              Provider.of<SignInSignUpService>(context, listen: false)
                  .signOut();
              Provider.of<AuthTextControllerService>(context, listen: false)
                      .setEmail(Provider.of<SignInSignUpService>(context,
                              listen: false)
                          .email) ??
                  '';
              Provider.of<AuthTextControllerService>(context, listen: false)
                  .setPass(
                      Provider.of<SignInSignUpService>(context, listen: false)
                              .password ??
                          '');
              Provider.of<SignInSignUpService>(context, listen: false)
                  .toggleLaodingSpinner(value: false);
              Provider.of<SignInSignUpService>(context, listen: false)
                  .getUserData();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Auth()),
                  (Route<dynamic> route) => false);
            }),
          ),
          const SizedBox(height: 20),
          const Text(
            'v1.0',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(127, 158, 158, 158),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
        ],
      );
    });
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

//   Future<void> setData(BuildContext context) async {
//     final uData =
//         Provider.of<UserProfileService>(context, listen: false).userProfileData;
//     final controllers =
//         Provider.of<AuthTextControllerService>(context, listen: false);
//     await controllers.setEmail(uData.email);
//     await controllers.setName(uData.name);
//     await controllers.setUserName(uData.username);
//     await controllers.setEmail(uData.email);
//     await controllers.setZipCode(uData.zipcode);
//     await Provider.of<CountryDropdownService>(context, listen: false)
//         .setCountryIdAndValue(uData.country.name);
//     if (uData.state != null) {
//       await Provider.of<StateDropdownService>(context, listen: false)
//           .setStateIdAndValue(uData.state!.name);
//     }
//     if (uData.state == null) {
//       print('state is null');
//       Provider.of<StateDropdownService>(context, listen: false)
//           .setStateIdAndValueDefault();
//     }
//   }
}
