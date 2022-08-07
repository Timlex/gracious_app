import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/ticket_chat_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/constant_styles.dart';

class TicketChat extends StatelessWidget {
  String title;
  TicketChat(this.title, {Key? key}) : super(key: key);
  Key textFieldKey = const Key('key');
  final TextEditingController _controller = TextEditingController();

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
          centerTitle: true,
        ),
        body: tcService.messagesList.isEmpty
            ? loadingProgressBar()
            : Consumer<TicketChatService>(builder: (context, tcService, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
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
                                    // height: 60,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomLeft: usersMessage
                                            ? const Radius.circular(20)
                                            : Radius.zero,
                                        bottomRight: usersMessage
                                            ? Radius.zero
                                            : const Radius.circular(20),
                                      ),
                                      color: usersMessage
                                          ? cc.primaryColor
                                          : const Color(0xffEFEFEF),
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
                      SizedBox(
                        height: screenHight / 7,
                        // margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          maxLines: 4,
                          controller: _controller,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Write message',
                            hintStyle: TextStyle(color: cc.greyHint),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: cc.greyBorder2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cc.greyBorder2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cc.greyBorder2),
                            ),
                          ),
                          onChanged: (value) {
                            tcService.setMessage(value);
                          },
                        ),
                      ),
                      // Container(
                      //   color: cc.pureWhite,
                      //   height: 60,
                      //   child: Row(
                      //     children: [
                      //       // Expanded(
                      //       //   child: TextField(
                      //       //     decoration: InputDecoration(
                      //       //       hintText: 'Write message',
                      //       //       hintStyle: TextStyle(color: cc.greyHint),
                      //       //       enabledBorder: OutlineInputBorder(
                      //       //         borderSide: BorderSide(color: cc.pureWhite),
                      //       //       ),
                      //       //       focusedBorder: OutlineInputBorder(
                      //       //         borderSide: BorderSide(color: cc.pureWhite),
                      //       //       ),
                      //       //       errorBorder: OutlineInputBorder(
                      //       //         borderSide: BorderSide(color: cc.pureWhite),
                      //       //       ),
                      //       //     ),
                      //       //     onChanged: (value) {
                      //       //       tcService.setMessage(value);
                      //       //     },
                      //       //   ),
                      //       // ),
                      //       if (tcService.pickedImage != null)
                      //         SizedBox(
                      //           height: 55,
                      //           width: 55,
                      //           child: Image.file(
                      //             tcService.pickedImage as File,
                      //             fit: BoxFit.cover,
                      //           ),
                      //         ),
                      //       IconButton(
                      //           onPressed: (() {
                      //             imageSelector(context);
                      //           }),
                      //           icon: const Icon(
                      //             Icons.attach_file,
                      //           )),
                      //       IconButton(
                      //           onPressed: tcService.message.isEmpty
                      //               ? null
                      //               : (() {
                      //                   tcService.sendMessage(
                      //                       tcService.ticketDetails.id);
                      //                 }),
                      //           icon: Icon(
                      //             Icons.send_rounded,
                      //             color: tcService.message.isEmpty
                      //                 ? cc.greyDots
                      //                 : cc.primaryColor,
                      //           )),
                      //     ],
                      //   ),
                      // ),

                      Row(
                        children: [
                          const Text(
                            'File',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              imageSelector(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: cc.greyBorder2)),
                              child: Text(
                                'Choose file',
                                style: TextStyle(color: cc.greyHint),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: screenWidth / 3,
                            child: Text(
                              tcService.pickedImage == null
                                  ? 'No file choosen'
                                  : tcService.pickedImage!.path.split('/').last,
                              style: TextStyle(
                                  color: cc.greyHint,
                                  fontSize: 13,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.3,
                            child: Checkbox(

                                // splashRadius: 30,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(
                                  width: 1,
                                  color: cc.greyBorder,
                                ),
                                activeColor: cc.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      width: 1,
                                      color: cc.greyBorder,
                                    )),
                                value: tcService.notifyViaMail,
                                onChanged: (value) {
                                  tcService.toggleNotifyViaMail(value);
                                }),
                          ),
                          const SizedBox(width: 5),
                          RichText(
                            softWrap: true,
                            text: TextSpan(
                              text: 'Notify via mail',
                              style: TextStyle(color: cc.greyHint, fontSize: 13
                                  // fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      customContainerButton(
                        'Add new address',
                        double.infinity,
                        tcService.message.isEmpty &&
                                tcService.pickedImage == null
                            ? () {}
                            : () {
                                tcService
                                    .sendMessage(tcService.ticketDetails.id);
                                _controller.clear();
                                FocusScope.of(context).unfocus();
                              },
                        color: tcService.message.isEmpty &&
                                tcService.pickedImage == null
                            ? cc.greyDots
                            : cc.primaryColor,
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                );
              }),
      );
    });
  }
}
