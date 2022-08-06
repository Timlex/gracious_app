import 'package:flutter/material.dart';
import 'package:gren_mart/service/signin_signup_service.dart';
import 'package:gren_mart/service/ticket_chat_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:provider/provider.dart';

import '../utils/constant_styles.dart';

class TicketChat extends StatelessWidget {
  const TicketChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<SignInSignUpService>(context, listen: false).userId;
    return Consumer<TicketChatService>(builder: (context, tcService, child) {
      final usersMessage =
          tcService.ticketDetails.userId == int.parse(userId as String);
      return Scaffold(
        appBar: AppBars().appBarTitled(tcService.ticketDetails.title, () {
          Navigator.of(context).pop();
        }),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemCount: tcService.messagesList.length,
                  itemBuilder: ((context, index) => Row(
                        mainAxisAlignment: usersMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: cc.primaryColor,
                            ),
                            child: Text(tcService.messagesList[index].message),
                          ),
                        ],
                      ))),
            ),
            Row()
          ],
        ),
      );
    });
  }
}
