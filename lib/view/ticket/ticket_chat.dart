import 'package:flutter/material.dart';
import 'package:gren_mart/service/ticket_chat_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:provider/provider.dart';

import '../utils/constant_styles.dart';

class TicketChat extends StatelessWidget {
  String title;
  TicketChat(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketChatService>(builder: (context, tcService, child) {
      return Scaffold(
        appBar: AppBars().appBarTitled(
          title,
          () {
            tcService.clearAllMessages();
            Navigator.of(context).pop();
          },
          centerTitle: false,
        ),
        body: tcService.messagesList.isEmpty
            ? loadingProgressBar()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        itemCount: tcService.messagesList.length,
                        itemBuilder: ((context, index) {
                          final element = tcService.messagesList[index];
                          final usersMessage = element.type != 'admin';
                          return Row(
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
                                  color: usersMessage
                                      ? cc.primaryColor
                                      : cc.greyDots,
                                ),
                                child: Text(
                                  tcService.messagesList[index].message,
                                  style: usersMessage
                                      ? TextStyle(color: cc.pureWhite)
                                      : null,
                                ),
                              ),
                            ],
                          );
                        })),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Write message',
                            hintStyle: TextStyle(color: cc.greyHint),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cc.pureWhite),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cc.pureWhite),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cc.pureWhite),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: (() {}),
                          icon: const Icon(Icons.attach_file)),
                      IconButton(
                          onPressed: (() {}),
                          icon: Icon(
                            Icons.send_rounded,
                            color: cc.primaryColor,
                          )),
                    ],
                  )
                ],
              ),
      );
    });
  }
}
