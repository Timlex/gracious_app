import 'package:flutter/material.dart';
import 'package:gren_mart/view/settings/new_address.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../service/shipping_addresses_service.dart';

class ShippingAdresses extends StatefulWidget {
  static const routeName = 'shipping addresses';
  const ShippingAdresses({Key? key}) : super(key: key);

  @override
  State<ShippingAdresses> createState() => _ShippingAdressesState();
}

class _ShippingAdressesState extends State<ShippingAdresses> {
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('Shipping addresses', () {
        Navigator.of(context).pop();
      }),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          const SizedBox(height: 25),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25),
          //   child: CustomTextField(
          //     'enter new address',
          //     controller: TextEditingController(),
          //     leadingImage: 'assets/images/icons/location.png',
          //     onFieldSubmitted: (value) {
          //       if (value.length <= 10) {
          //         ScaffoldMessenger.of(context)
          //             .showSnackBar(snackBar('Enter a valid address'));
          //         return;
          //       }
          //       address = value;
          //       showDialog<String>(
          //         context: context,
          //         builder: (BuildContext context) => AlertDialog(
          //           title: const Text('Enter address name'),
          //           content: CustomTextField(
          //             'Enter address name',
          //             onChanged: (value) {
          //               addressTitle = value;
          //               print(addressTitle);
          //             },
          //           ),
          //           actions: <Widget>[
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context, 'Cancel');
          //               },
          //               child: const Text('Cancel'),
          //             ),
          //             TextButton(
          //               onPressed: () {
          //                 setState(() {
          //                   addresses.add({
          //                     'id': (addresses.length + 1).toString(),
          //                     'title': addressTitle,
          //                     'address': address,
          //                   });
          //                 });
          //                 print(addresses.length);
          //                 Navigator.pop(context, 'OK');
          //               },
          //               child: const Text('OK'),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
          if (Provider.of<ShippingAddressesService>(context)
              .shippingAddresseList
              .isEmpty)
            loadingProgressBar(),
          ...Provider.of<ShippingAddressesService>(context)
              .shippingAddresseList
              .map(((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Dismissible(
                        key: Key(e.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {},
                        child: addressBox(e.name, e.address)),
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child:
                customContainerButton('Add new address', double.infinity, () {
              Navigator.of(context).pushNamed(AddNewAddress.routeName);
            }),
          )
        ],
      ),
    );
  }

  Widget addressBox(String addressTile, String address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cc.whiteGrey,
          border: Border.all(color: cc.greyHint, width: .5)),
      child: Stack(children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(addressTile),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(address),
          ),
        ),
      ]),
    );
  }
}
