import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

import '../auth/custom_text_field.dart';
import '../utils/constant_styles.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = 'change password';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  ConstantColors cc = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _newPasswordController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nPFN = FocusNode();
  final _reFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('Change Password', () {
        Navigator.of(context).pop();
      }, hasButton: true),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textFieldTitle('Current password'),
                            // const SizedBox(height: 8),
                            CustomTextField(
                              'Enter current password',
                              controller: _passwordController,
                              validator: (emailText) {
                                if (emailText!.isEmpty) {
                                  return 'Enter at least 6 charechters';
                                }
                                if (emailText.length <= 5) {
                                  return 'Enter at least 6 charechters';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_nPFN);
                              },
                            ),
                            textFieldTitle('New password'),
                            // const SizedBox(height: 8),
                            CustomTextField(
                              'Enter new password',
                              focusNode: _nPFN,
                              controller: _newPasswordController,
                              validator: (emailText) {
                                if (emailText!.isEmpty) {
                                  return 'Enter at least 6 charechters';
                                }
                                if (emailText.length <= 5) {
                                  return 'Enter at least 6 charechters';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_reFN);
                              },
                            ),
                            textFieldTitle('Re enter new password'),
                            // const SizedBox(height: 8),
                            CustomTextField(
                              'Re enter new password',
                              focusNode: _reFN,
                              validator: (emailText) {
                                if (emailText == _passwordController.text) {
                                  return 'Enter the same password';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {},
                            ),
                          ]),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: customContainerButton(
                        'Save Changes', double.infinity, () {
                      Navigator.of(context).pop();
                    }),
                  ),
                  const SizedBox(height: 45)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
