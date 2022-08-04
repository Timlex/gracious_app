import 'package:flutter/material.dart';
import 'package:gren_mart/db/database_helper.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import 'package:gren_mart/service/favorite_data_service.dart';
import 'package:gren_mart/service/poster_campaign_slider_service.dart';
import 'package:gren_mart/service/signin_signup_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:provider/provider.dart';

import '../../service/auth_text_controller_service.dart';
import '../utils/constant_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getDatabegeData(context);
    initiateDeviceSize(context);

    initiateAutoSignIn(context);

    return Scaffold(
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

  getDatabegeData(BuildContext context) {
    List databases = ['cart', 'favorite'];
    databases.map((e) => DbHelper.database(e));
    Provider.of<CartDataService>(context, listen: false).fetchCarts();
    Provider.of<FavoriteDataService>(context, listen: false).fetchFavorites();
  }

  initiateAutoSignIn(BuildContext context) {
    Provider.of<SignInSignUpService>(context, listen: false)
        .getToken()
        .then((value) async {
      if (value != null) {
        // try {
        await Provider.of<UserProfileService>(context, listen: false)
            .fetchProfileService(value)
            .then((value) async {
          await Provider.of<PosterCampaignSliderService>(context, listen: false)
              .fetchPosters();
          await Provider.of<PosterCampaignSliderService>(context, listen: false)
              .fetchCampaigns();

          Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
        });
        //   .onError((error, stackTrace) =>
        //           Navigator.of(context).pushReplacementNamed(Intro.routeName));
        // } catch (error) {
        //   print(error);
        // }
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
  }
}
