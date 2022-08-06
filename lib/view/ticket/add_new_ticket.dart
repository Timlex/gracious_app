import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/view/intro/custom_dropdown.dart';
import 'package:provider/provider.dart';

import '../../service/ticket_service.dart';
import '../home/home_front.dart';
import '../utils/app_bars.dart';
import '../utils/constant_styles.dart';

class AddNewTicket extends StatelessWidget {
  static const routeName = 'add new ticket';
  AddNewTicket({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _subjectFN = FocusNode();

  void _onSubmit(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomeFront.routeName);

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(snackBar('Invalid email/password'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars().appBarTitled('Add new address', () {
          Navigator.of(context).pop();
        }, hasButton: true),
        body: Consumer<TicketService>(builder: (context, tService, child) {
          return ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFieldTitle('Title'),
                        // const SizedBox(height: 8),
                        CustomTextField(
                          'Enter a title',
                          onChanged: (value) {},
                          validator: (name) {
                            if (name!.isEmpty) {
                              return 'Enter your name';
                            }
                            if (name.length <= 2) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_subjectFN);
                          },
                        ),
                        textFieldTitle('Subjct'),
                        // const SizedBox(height: 8),
                        CustomTextField(
                          'Enter a subject',
                          onChanged: (value) {},
                          validator: (name) {
                            if (name!.isEmpty) {
                              return 'Enter a valid subject';
                            }
                            if (name.length <= 5) {
                              return 'Enter a subject with more then 5 charecter';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {},
                        ),
                        textFieldTitle('Country'),
                        // const SizedBox(height: 8),
                        CustomDropdown(
                          'Country',
                          tService.priorityList,
                          (newValue) {
                            tService.setPriority(newValue as String);
                          },
                          value: tService.priority,
                        ),

                        textFieldTitle('State'),
                        CustomDropdown(
                          'State',
                          tService.departmentsList,
                          (newValue) {
                            tService.setDepartment(newValue);
                          },
                          value: tService.department,
                        ),

                        textFieldTitle('Description'),
                        // const SizedBox(height: 8),
                        CustomTextField(
                          'Describe your issue',
                          onChanged: (value) {},
                          validator: (address) {
                            if (address == null) {
                              return 'You have to give an address';
                            }
                            if (address.length < 5) {
                              return 'Enter a valid address';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {},
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child:
                    customContainerButton('Save Changes', double.infinity, () {
                  final validated = _formKey.currentState!.validate();
                  if (!validated) {
                    return;
                  }
                  Navigator.of(context).pop();
                }),
              ),
              const SizedBox(height: 45)
            ],
          );
        }));
  }
}
