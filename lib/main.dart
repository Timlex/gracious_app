import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gren_mart/model/products.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/cart/cart_view.dart';
import 'package:gren_mart/view/cart/checkout.dart';
import 'package:gren_mart/view/details/product_details.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:gren_mart/view/intro/intro.dart';
import 'package:gren_mart/view/intro/splash.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

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
    return
        // MultiProvider(
        //   providers: [
        //     ChangeNotifierProvider<Products>(
        //       create: (context) => Products(),
        //     )
        //   ],
        //   child:
        //  Consumer<Products>(
        //   builder: (context, value, child) =>
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrenMart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: ConstantColors().pureWhite,
        appBarTheme: AppBarTheme(backgroundColor: ConstantColors().pureWhite),
        // bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //     backgroundColor: ConstantColors().blackColor),
        buttonTheme:
            ButtonThemeData(buttonColor: ConstantColors().primaryColor),
      ),
      home: SplashScreen(),
      routes: {
        Intro.routeName: (context) => Intro(),
        Auth.routeName: (context) => Auth(),
        HomeFront.routeName: (context) => HomeFront(),
        ProductDetails.routeName: (context) => ProductDetails(),
        Cart.routeName: (context) => Cart(),
        Checkout.routeName: (context) => Checkout()
      },
      // ),
      // ),
    );
  }
}
