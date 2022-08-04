import 'package:flutter/material.dart';
import 'package:gren_mart/model/other_data.dart';
import 'package:gren_mart/service/auth_text_controller_service.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import 'package:gren_mart/service/categories_data_service.dart';
import 'package:gren_mart/service/change_password_service.dart';
import 'package:gren_mart/service/country_dropdown_service.dart';
import 'package:gren_mart/service/favorite_data_service.dart';
import 'package:gren_mart/service/manage_account_service.dart';
import 'package:gren_mart/service/poster_campaign_slider_service.dart';
import 'package:gren_mart/service/product_card_data_service.dart';
import 'package:gren_mart/service/reset_pass_otp_service.dart';
import 'package:gren_mart/service/search_result_data_service.dart';
import 'package:gren_mart/service/shipping_addresses_service.dart';
import 'package:gren_mart/service/signin_signup_service.dart';
import 'package:gren_mart/service/state_dropdown_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/auth/order_data.dart';
import 'package:gren_mart/view/auth/reset_password.dart';
import 'package:gren_mart/view/settings/shipping_addresses.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/auth/enter_otp.dart';
import 'package:gren_mart/view/auth/enter_email_reset_pass.dart';
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
import './service/navigation_bar_helper_service.dart';

import 'model/product_data.dart';

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
        ChangeNotifierProvider(create: (_) => OtherData()),
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => CartDataService()),
        ChangeNotifierProvider(create: (_) => FavoriteDataService()),
        ChangeNotifierProvider(create: (_) => OrderData()),
        ChangeNotifierProvider(create: (_) => CountryDropdownService()),
        ChangeNotifierProvider(create: (_) => StateDropdownService()),
        ChangeNotifierProvider(create: (_) => PosterCampaignSliderService()),
        ChangeNotifierProvider(create: (_) => UserProfileService()),
        ChangeNotifierProvider(create: (_) => SignInSignUpService()),
        ChangeNotifierProvider(create: (_) => AuthTextControllerService()),
        ChangeNotifierProvider(create: (_) => NavigationBarHelperService()),
        ChangeNotifierProvider(create: (_) => ResetPassOTPService()),
        ChangeNotifierProvider(create: (_) => ProductCardDataService()),
        ChangeNotifierProvider(create: (_) => CategoriesDataService()),
        ChangeNotifierProvider(create: (_) => SearchResultDataService()),
        ChangeNotifierProvider(create: (_) => ChangePasswordService()),
        ChangeNotifierProvider(create: (_) => ManageAccountService()),
        ChangeNotifierProvider(create: (_) => ShippingAddressesService()),
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
            Auth.routeName: (context) => Auth(),
            ResetPassEmail.routeName: (context) => ResetPassEmail(),
            EnterOTP.routeName: (context) => EnterOTP(),
            HomeFront.routeName: (context) => HomeFront(),
            ProductDetails.routeName: (context) => ProductDetails(),
            CartView.routeName: (context) => CartView(),
            Checkout.routeName: (context) => Checkout(),
            // SearchView.routeName: (context) => SearchView(),
            NewAddress.routeName: (context) => const NewAddress(),
            ManageAccount.routeName: (context) => ManageAccount(),
            ChangePassword.routeName: (context) => const ChangePassword(),
            ShippingAdresses.routeName: (context) => const ShippingAdresses(),
            ResetPassword.routeName: (context) => const ResetPassword(),
          },
        ),
      ),
    );
  }
}
