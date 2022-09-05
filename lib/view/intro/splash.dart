import 'package:flutter/material.dart';
import 'package:gren_mart/service/navigation_bar_helper_service.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/database_helper.dart';
import '../../service/cart_data_service.dart';
import '../../service/favorite_data_service.dart';
import '../../service/poster_campaign_slider_service.dart';
import '../../service/signin_signup_service.dart';
import '../../service/user_profile_service.dart';
import '../../view/auth/auth.dart';
import '../../view/home/home_front.dart';
import '../../service/auth_text_controller_service.dart';
import '../utils/constant_name.dart';
import 'intro.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> initialize() async {
    await getDatabegeData(context);
    initiateDeviceSize(context);

    await initiateAutoSignIn(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    // getDatabegeData(context);
    // initiateDeviceSize(context);

    // initiateAutoSignIn(context);

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: cc.pureWhite,
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/images/splash.png',
        fit: BoxFit.fill,
      ),
    );
  }

  getDatabegeData(BuildContext context) {
    List databases = ['cart', 'favorite'];
    databases.map((e) => DbHelper.database(e));
    Provider.of<CartDataService>(context, listen: false).fetchCarts();
    Provider.of<FavoriteDataService>(context, listen: false).fetchFavorites();
    Provider.of<CartDataService>(context, listen: false).fetchCarts();
  }

  initiateAutoSignIn(BuildContext context) async {
    await Provider.of<SignInSignUpService>(context, listen: false)
        .getToken()
        .then((value) async {
      if (value != null || value != '') {
        // try {
        await Provider.of<UserProfileService>(context, listen: false)
            .fetchProfileService(value)
            .then((value) async {
          if (value == null) {
            snackBar(context, 'Connection failed!');
            return;
          }
          Provider.of<PosterCampaignSliderService>(context, listen: false)
              .fetchPosters();
          print('here');
          Provider.of<PosterCampaignSliderService>(context, listen: false)
              .fetchCampaigns();
          print('here2');
          print('here2');

          FlutterNativeSplash.remove();
          Provider.of<NavigationBarHelperService>(context, listen: false)
              .setNavigationIndex(0);
          Navigator.of(context).pushReplacementNamed(HomeFront.routeName);

          return;
        }).onError(
                (error, stackTrace) => snackBar(context, "Connection failed!"));
        // } catch (error) {
        //   print(error);
        // }
        await Provider.of<SignInSignUpService>(context, listen: false)
            .getUserData();

        // setData(Provider.of<UserProfileService>(context, listen: false)
        //     .userProfileData);
        return;
      }
      Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
      return;

      // Future.delayed(const Duration(seconds: 1));
    }).onError((error, stackTrace) async {
      snackBar(context, 'Connection failed!');
      final ref = await SharedPreferences.getInstance();
      if (ref.containsKey('intro')) {
        FlutterNativeSplash.remove();
        Navigator.of(context).pushReplacementNamed(Auth.routeName);
        Provider.of<AuthTextControllerService>(context, listen: false).setEmail(
            Provider.of<SignInSignUpService>(context, listen: false).email);
        Provider.of<AuthTextControllerService>(context, listen: false).setPass(
            Provider.of<SignInSignUpService>(context, listen: false).password);
        return;
      }
      Navigator.of(context).pushReplacementNamed(Intro.routeName);
      return;
    });

    if (globalUserToken == null) {
      final ref = await SharedPreferences.getInstance();
      FlutterNativeSplash.remove();
      if (ref.containsKey('intro')) {
        FlutterNativeSplash.remove();
        Navigator.of(context).pushReplacementNamed(Auth.routeName);
        Provider.of<AuthTextControllerService>(context, listen: false).setEmail(
            Provider.of<SignInSignUpService>(context, listen: false).email);
        Provider.of<AuthTextControllerService>(context, listen: false).setPass(
            Provider.of<SignInSignUpService>(context, listen: false).password);
        return;
      }
      Navigator.of(context).pushReplacementNamed(Intro.routeName);
    }
    // Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
    return;
  }
}
