import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:gren_mart/view/settings/new_address.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:focused_menu/focused_menu.dart';

class ShippingAdresses extends StatefulWidget {
  static const routeName = 'shipping addresses';
  const ShippingAdresses({Key? key}) : super(key: key);

  @override
  State<ShippingAdresses> createState() => _ShippingAdressesState();
}

class _ShippingAdressesState extends State<ShippingAdresses> {
  ConstantColors cc = ConstantColors();
  String? address;
  String? addressTitle;
  String selectedId = '01';
  List addresses = [
    {
      'id': '01',
      'title': 'Home',
      'address': '6391 Elgin St. Celina, Delaware 10299'
    },
    {
      'id': '02',
      'title': 'Home',
      'address': '6391 Elgin St. Celina, Delaware 10299'
    },
  ];

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
          const SizedBox(height: 10),
          ...addresses.map(((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FocusedMenuHolder(
                  menuItems: [
                    FocusedMenuItem(
                        title: const Text('Select'),
                        onPressed: () {
                          if (e['id'] == selectedId) {
                            return;
                          }
                          setState(() {
                            selectedId = e['id'];
                          });
                        },
                        backgroundColor: cc.whiteGrey),
                    FocusedMenuItem(
                        title: const Text('Edit'),
                        onPressed: () {},
                        backgroundColor: cc.whiteGrey),
                    FocusedMenuItem(
                        title: const Text('Delete'),
                        onPressed: () {},
                        backgroundColor: cc.whiteGrey)
                  ],
                  blurBackgroundColor: Colors.white,
                  menuBoxDecoration: const BoxDecoration(boxShadow: null),
                  blurSize: 0,
                  menuWidth: screenWidth - 40,
                  openWithTap: false,
                  onPressed: () {
                    if (e['id'] == selectedId) {
                      return;
                    }
                    setState(() {
                      selectedId = e['id'];
                    });
                  },
                  child: addressBox(
                      selectedId == e['id'], e['title'], e['address']),
                ),
              ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: customContainerButton('Add new', double.infinity, () {
              Navigator.of(context).pushNamed(NewAddress.routeName);
            }),
          )
        ],
      ),
    );
  }

  Widget addressBox(bool selected, String addressTile, String address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected ? cc.lightPrimery3 : cc.whiteGrey,
          border: Border.all(
              color: selected ? cc.primaryColor : cc.greyHint, width: .5)),
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
        if (selected)
          Positioned(
              top: 10,
              right: 15,
              child: Icon(
                Icons.check_box,
                color: cc.primaryColor,
              ))
      ]),
    );
  }
}
