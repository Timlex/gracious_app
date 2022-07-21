import 'package:flutter/material.dart';
import 'package:gren_mart/model/favorites.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/auth/enter_otp.dart';
import 'package:gren_mart/view/auth/reset_password.dart';
import 'package:gren_mart/view/cart/cart_view.dart';
import 'package:gren_mart/view/cart/checkout.dart';
import 'package:gren_mart/view/details/product_details.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:gren_mart/view/intro/intro.dart';
import 'package:gren_mart/view/intro/splash.dart';
import 'package:gren_mart/view/settings/change_password.dart';
import 'package:gren_mart/view/settings/manage_account.dart';
import 'package:gren_mart/view/settings/new_address.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

import 'model/carts.dart';
import 'model/products.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: CartData(),
        ),
        ChangeNotifierProvider.value(
          value: FavoriteData(),
        ),
      ],
      child: Consumer<Products>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GrenMart',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: ConstantColors().pureWhite,
            appBarTheme:
                AppBarTheme(backgroundColor: ConstantColors().pureWhite),
            // bottomNavigationBarTheme: BottomNavigationBarThemeData(
            //     backgroundColor: ConstantColors().blackColor),
            buttonTheme:
                ButtonThemeData(buttonColor: ConstantColors().primaryColor),
          ),
          home: const SplashScreen(),
          routes: {
            Intro.routeName: (context) => Intro(),
            Auth.routeName: (context) => const Auth(),
            ResetPassEmail.routeName: (context) => ResetPassEmail(),
            EnterOTP.routeName: (context) => EnterOTP(),
            HomeFront.routeName: (context) => const HomeFront(),
            ProductDetails.routeName: (context) => ProductDetails(),
            CartView.routeName: (context) => CartView(),
            Checkout.routeName: (context) => Checkout(),
            // SearchView.routeName: (context) => SearchView(),
            NewAddress.routeName: (context) => const NewAddress(),
            ManageAccount.routeName: (context) => ManageAccount(),
            ChangePassword.routeName: (context) => const ChangePassword(),
          },
        ),
      ),
    );
  }
}
