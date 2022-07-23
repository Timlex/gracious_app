import 'package:flutter/material.dart';
import 'package:gren_mart/db/database_helper.dart';
import 'package:gren_mart/model/carts.dart';
import 'package:gren_mart/model/favorites.dart';
import 'package:gren_mart/view/intro/intro.dart';
import 'package:provider/provider.dart';

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
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacementNamed(Intro.routeName),
    );
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
