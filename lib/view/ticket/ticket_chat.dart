import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../service/ticket_chat_service.dart';
import '../../view/utils/image_view.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_name.dart';
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
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'zip', 'png', 'jpeg'],
      );
      Provider.of<TicketChatService>(context, listen: false)
          .setPickedImage(File(file!.files.single.path as String));
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
        body: tcService.ticketDetails == null
            ? loadingProgressBar()
            : Consumer<TicketChatService>(builder: (context, tcService, child) {
                return Column(
                  children: [
                    Expanded(
                      child: messageListView(tcService),
                    ),
                    SizedBox(
                      height: screenHight / 7,
                      // margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          maxLines: 4,
                          controller: _controller,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Write message',
                            hintStyle:
                                TextStyle(color: cc.greyHint, fontSize: 14),
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            'File',
                            style: TextStyle(
                                color: cc.greyHint,
                                fontWeight: FontWeight.w600),
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
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
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
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Stack(
                        children: [
                          customContainerButton(
                            tcService.isLoading ? '' : 'Send',
                            double.infinity,
                            tcService.message.isEmpty &&
                                    tcService.pickedImage == null
                                ? () {}
                                : () async {
                                    tcService.setIsLoading(true);
                                    await tcService.sendMessage(
                                        tcService.ticketDetails!.id);
                                    _controller.clear();
                                    tcService.setIsLoading(false);
                                    FocusScope.of(context).unfocus();
                                  },
                            color: tcService.message.isEmpty &&
                                    tcService.pickedImage == null
                                ? cc.greyDots
                                : cc.primaryColor,
                          ),
                          if (tcService.isLoading)
                            SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Center(
                                    child: loadingProgressBar(
                                        size: 30, color: cc.pureWhite)))
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                );
              }),
      );
    });
  }

  Widget messageListView(TicketChatService tcService) {
    if (tcService.noMessage) {
      return Center(
        child: Text(
          'No Message has been found!',
          style: TextStyle(color: cc.greyHint),
        ),
      );
    } else {
      return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          reverse: true,
          itemCount: tcService.messagesList.length,
          itemBuilder: ((context, index) {
            final element = tcService.messagesList[index];
            final usersMessage = element.type != 'admin';
            return SizedBox(
              width: screenWidth / 1.7,
              child: Column(
                crossAxisAlignment: usersMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: usersMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                          // width: screenWidth / 1.7,
                          constraints:
                              BoxConstraints(maxWidth: screenWidth / 1.7),
                          // alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
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
                          // child:
                          //  CustomPaint(
                          //   painter: usersMessage
                          //       ? UserChatBubble()
                          //       : AdminChatBubble(),
                          // child:
                          //  Padding(
                          //   padding: EdgeInsets.only(
                          //       right: usersMessage ? 20 : 10,
                          //       top: 10,
                          //       bottom: 10,
                          //       left: usersMessage ? 10 : 20),
                          //   child:
                          //   Text(
                          //     tcService.messagesList[index].message,
                          //     style: TextStyle(
                          //         color: usersMessage ? cc.pureWhite : null,
                          //         fontSize: 15),
                          //     // textAlign: usersMessage
                          //     //     ? TextAlign.right
                          //     //     : TextAlign.left,
                          //   ),
                          // ),
                          child: Text(
                            tcService.messagesList[index].message,
                            style: usersMessage
                                ? TextStyle(color: cc.pureWhite)
                                : null,
                          )),
                      // ),
                    ],
                  ),
                  if (tcService.messagesList[index].attachment != null)
                    const SizedBox(height: 5),
                  if (tcService.messagesList[index].attachment != null)
                    showFile(context, tcService.messagesList[index].attachment)
                ],
              ),
            );
          }));
    }
  }

  Widget showFile(BuildContext context, String url) {
    if (url.contains('.zip')) {
      return Container(
        margin: const EdgeInsets.only(
          right: 20,
          left: 20,
        ),
        height: 50,
        width: 50,
        child: SvgPicture.asset('assets/images/icons/zip_icon.svg'),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ImageView(url),
          ),
        );
      },
      child: Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CachedNetworkImage(
          placeholder: (context, url) {
            return Image.asset('assets/images/skelleton.png');
          },
          imageUrl: url,
          errorWidget: (context, str, some) {
            return Image.asset('assets/images/skelleton.png');
          },
        ),
      ),
    );
  }
}
