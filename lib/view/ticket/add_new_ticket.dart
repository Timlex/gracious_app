import 'package:flutter/material.dart';
import 'package:gren_mart/service/ticket_service.dart';
import '../../service/add_new_ticket_service.dart';
import '../../view/auth/custom_text_field.dart';
import '../../view/intro/custom_dropdown.dart';
import 'package:provider/provider.dart';

import '../utils/app_bars.dart';
import '../utils/constant_styles.dart';

class AddNewTicket extends StatelessWidget {
  static const routeName = 'add new ticket';
  AddNewTicket({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _subjectFN = FocusNode();

  Future _onSubmit(BuildContext context, AddNewTicketService ntService) async {
    final validated = _formKey.currentState!.validate();
    if (!validated) {
      snackBar(context, "Please give all the data properly",
          backgroundColor: cc.orange);
      return;
    }
    ntService.setIsLoading(true);
    await ntService.addNewToken().then((value) {
      if (value != null) {
        ntService.setIsLoading(false);
        snackBar(context, value);
        return;
      }
      ntService.setIsLoading(false);
      Provider.of<TicketService>(context, listen: false)
          .fetchTickets(noForceFetch: false);
      Navigator.of(context).pop();
      return;
    }).onError((error, stackTrace) =>
        snackBar(context, 'Couldn\'t add Ticket', backgroundColor: cc.orange));
    ntService.setIsLoading(false);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(snackBar('Invalid email/password'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars().appBarTitled(context, 'Add new ticket', () {
          Navigator.of(context).pop();
        }, hasButton: true),
        body:
            Consumer<AddNewTicketService>(builder: (context, ntService, child) {
          return ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFieldTitle('Title'),
                        // const SizedBox(height: 8),
                        CustomTextField(
                          'Enter a title',
                          onChanged: (value) {
                            ntService.setTitle(value);
                          },
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
                          focusNode: _subjectFN,
                          onChanged: (value) {
                            ntService.setSubject(value);
                          },
                          validator: (name) {
                            if (name!.isEmpty) {
                              return 'Enter a valid subject';
                            }
                            if (name.length <= 5) {
                              return 'Enter a subject with more then 5 charecter';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) async {
                            ntService.setIsLoading(false);
                          },
                        ),
                        textFieldTitle('Priority'),
                        // const SizedBox(height: 8),
                        CustomDropdown(
                          ntService.selectedPriority as String,
                          ntService.priority,
                          (newValue) {
                            ntService.setSelectedPriority(newValue as String);
                          },
                          value: ntService.selectedPriority,
                        ),

                        textFieldTitle('Department'),
                        ntService.allDepartment.isEmpty
                            ? loadingProgressBar()
                            : CustomDropdown(
                                ntService.selectedDepartment.name,
                                ntService.departmentNames,
                                (newValue) {
                                  ntService.setSelectedDepartment(newValue);
                                },
                                value: ntService.selectedDepartment.name,
                              ),

                        textFieldTitle('Description'),
                        // const SizedBox(height: 8),
                        CustomTextField(
                          'Describe your issue',
                          onChanged: (value) {
                            ntService.setDescription(value);
                          },
                          validator: (address) {
                            if (address == null) {
                              return 'You have to give some description';
                            }
                            if (address.isEmpty) {
                              return 'You have to give some description';
                            }

                            return null;
                          },
                          onFieldSubmitted: (_) {
                            _onSubmit(context, ntService);
                          },
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Stack(
                    children: [
                      customContainerButton(
                          ntService.isLoading ? '' : 'Add Ticket',
                          double.infinity,
                          ntService.isLoading
                              ? () {}
                              : () {
                                  _onSubmit(context, ntService);
                                }),
                      if (ntService.isLoading)
                        SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Center(
                                child: loadingProgressBar(
                                    size: 30, color: cc.pureWhite)))
                    ],
                  )),
              const SizedBox(height: 45)
            ],
          );
        }));
  }
}
