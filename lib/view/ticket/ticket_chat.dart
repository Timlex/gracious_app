import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/ticket_chat_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/constant_styles.dart';

class TicketChat extends StatelessWidget {
  String title;
  TicketChat(this.title, {Key? key}) : super(key: key);

  Future<void> imageSelector(
    BuildContext context,
  ) async {
    try {
      final pickedImage =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      Provider.of<TicketChatService>(context, listen: false)
          .setPickedImage(File(pickedImage!.path));
    } catch (error) {
      print(error);
    }
  }

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
            : Consumer<TicketChatService>(builder: (context, tcService, child) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: cc.whiteGrey,
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
                                    height: 60,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: usersMessage
                                          ? cc.primaryColor
                                          : cc.greyDots,
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Text(
                                            tcService
                                                .messagesList[index].message,
                                            style: usersMessage
                                                ? TextStyle(color: cc.pureWhite)
                                                : null,
                                          ),
                                        ),
                                        Positioned(
                                            child: Container(
                                          decoration: const BoxDecoration(
                                              // shape: BoxShape()
                                              ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })),
                      ),
                    ),
                    Container(
                      color: cc.pureWhite,
                      height: 60,
                      child: Row(
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
                              onChanged: (value) {
                                tcService.setMessage(value);
                              },
                            ),
                          ),
                          if (tcService.pickedImage != null)
                            SizedBox(
                              height: 55,
                              width: 55,
                              child: Image.file(
                                tcService.pickedImage as File,
                                fit: BoxFit.cover,
                              ),
                            ),
                          IconButton(
                              onPressed: (() {
                                imageSelector(context);
                              }),
                              icon: const Icon(
                                Icons.attach_file,
                              )),
                          IconButton(
                              onPressed: tcService.message.isEmpty
                                  ? null
                                  : (() {
                                      tcService.sendMessage(
                                          tcService.ticketDetails.id);
                                    }),
                              icon: Icon(
                                Icons.send_rounded,
                                color: tcService.message.isEmpty
                                    ? cc.greyDots
                                    : cc.primaryColor,
                              )),
                        ],
                      ),
                    )
                  ],
                );
              }),
      );
    });
  }
}
