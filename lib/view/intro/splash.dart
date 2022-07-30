import 'package:flutter/material.dart';
import 'package:gren_mart/db/database_helper.dart';
import 'package:gren_mart/model/cart_data.dart';
import 'package:gren_mart/model/favorite_data.dart';
import 'package:gren_mart/service/country_dropdown_service.dart';
import 'package:gren_mart/service/poster_slider_service.dart';
import 'package:gren_mart/service/signin_signup_service.dart';
import 'package:gren_mart/service/state_dropdown_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:gren_mart/view/intro/intro.dart';
import 'package:provider/provider.dart';

import '../../service/auth_text_controller_service.dart';
import '../utils/constant_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey _scaffold = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List databases = ['cart', 'favorite'];
    databases.map((e) => DbHelper.database(e));
    Provider.of<CartData>(context, listen: false).fetchCarts();
    Provider.of<FavoriteData>(context, listen: false).fetchFavorites();
  }

  Future<void> setData(BuildContext context) async {
    final value = Provider.of<UserProfileService>(context).userProfileData;
    print('setting datas');
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setEmail(value.email);
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setName(value.name);
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setUserName(value.username);
    await Provider.of<AuthTextControllerService>(context, listen: false)
        .setEmail(value.email);
    await Provider.of<CountryDropdownService>(context, listen: false)
        .setCountryIdAndValue(value.country.name);

    await Provider.of<StateDropdownService>(context, listen: false)
        .setStateIdAndValue(value.state!.name);
  }

  @override
  Widget build(BuildContext context) {
    initiateDeviceSize(context);

    Provider.of<SignInSignUpService>(context, listen: false)
        .getToken()
        .then((value) async {
      if (value != null) {
        try {
          await Provider.of<UserProfileService>(context, listen: false)
              .fetchProfileService(value)
              .then((value) async {
            await Provider.of<PosterSliderService>(context, listen: false)
                .fetchPosters();
            Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
          }).onError((error, stackTrace) =>
                  Navigator.of(context).pushReplacementNamed(Intro.routeName));
        } catch (error) {
          print(error);
        }
        await Provider.of<SignInSignUpService>(context, listen: false)
            .getUserData();

        // setData(Provider.of<UserProfileService>(context, listen: false)
        //     .userProfileData);
        return;
      }

      Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pushReplacementNamed(Auth.routeName);
      Provider.of<AuthTextControllerService>(context, listen: false).setEmail(
          Provider.of<SignInSignUpService>(context, listen: false).email);
      Provider.of<AuthTextControllerService>(context, listen: false).setPass(
          Provider.of<SignInSignUpService>(context, listen: false).password);
    });

    return Scaffold(
      key: _scaffold,
      body: Center(
        child: Container(
          height: 150,
          width: 300,
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/grenmart.png',
                  // fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'v1.00',
                  style: TextStyle(
                      color: Color.fromARGB(127, 158, 158, 158),
                      fontWeight: FontWeight.bold),
                )
              ]),
        ),
      ),
    );
  }
}
