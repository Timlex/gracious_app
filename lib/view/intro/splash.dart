import 'package:flutter/material.dart';
import 'package:gren_mart/db/database_helper.dart';
import 'package:gren_mart/model/cart_data.dart';
import 'package:gren_mart/model/favorite_data.dart';
import 'package:gren_mart/service/poster_slider_service.dart';
import 'package:gren_mart/service/signin_signup_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:provider/provider.dart';

import '../../service/auth_text_controller_service.dart';
import '../utils/constant_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List databases = ['cart', 'favorite'];
    databases.map((e) => DbHelper.database(e));
    Provider.of<CartData>(context, listen: false).fetchCarts();
    Provider.of<FavoriteData>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    initiateDeviceSize(context);
    Provider.of<SignInSignUpService>(context, listen: false)
        .getToken()
        .then((value) async {
      if (value != null) {
        await Provider.of<UserProfileService>(context, listen: false)
            .fetchProfileService(value)
            .onError((error, stackTrace) =>
                Navigator.of(context).pushReplacementNamed(Auth.routeName));
        await Provider.of<PosterSliderService>(context, listen: false)
            .fetchPosters();
        Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
        return;
      }
      await Provider.of<SignInSignUpService>(context, listen: false)
          .getUserData();
      Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pushReplacementNamed(Auth.routeName);
      Provider.of<AuthTextControllerService>(context, listen: false).setEmail(
          Provider.of<SignInSignUpService>(context, listen: false).email);
      Provider.of<AuthTextControllerService>(context, listen: false).setPass(
          Provider.of<SignInSignUpService>(context, listen: false).password);
    });
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
}
