import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../service/ticket_service.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../service/ticket_chat_service.dart';
import 'ticket_chat.dart';
import '../utils/constant_name.dart';

class TicketTile extends StatelessWidget {
  final String title;
  final int ticketId;
  final DateTime submitDate;
  final String priority;
  final bool divider;
  TicketTile(
    this.title,
    this.ticketId,
    this.submitDate,
    this.priority,
    this.divider, {
    Key? key,
  }) : super(key: key);
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    final ticketItem = Provider.of<TicketService>(context, listen: false)
        .ticketsList
        .firstWhere((element) => element.id == ticketId);
    return Container(
      // height: screenHight / 10,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cc.greyBorder2),
      ),
      child: Column(
        children: [
          SizedBox(
              // height: 60,
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              const SizedBox(height: 5),
              Text(
                '#$ticketId',
                style: TextStyle(color: cc.primaryColor, fontSize: 13),
              ),
              const SizedBox(width: 10),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                    color: cc.blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
              //   ],
              ,

              const Spacer(),
              // PopupMenuButton(
              //     icon: const Icon(Icons.more_vert),
              //     itemBuilder: (context) =>
              //         [const PopupMenuItem(child: Text(''))])
            ],
          )),
          const SizedBox(height: 45),
          // const Divider(
          //   thickness: 1.5,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (screenWidth - 40) / 3,
                child: Consumer<TicketService>(
                    builder: (context, tService, child) {
                  return FittedBox(
                    child: Row(
                      children: [
                        const Text('Priority:'),
                        const SizedBox(width: 5),
                        PopupMenuButton(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 7, top: 3, bottom: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: manageColor(priority),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    priority.capitalize(),
                                    style: TextStyle(
                                        color: cc.pureWhite,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: cc.pureWhite,
                                  )
                                ],
                              ),
                            ),
                            onSelected: (value) {
                              // tService.setPriority(value);
                            },
                            itemBuilder: (context) => tService.priorityList
                                .map((e) => PopupMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList()),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: (screenWidth - 40) / 3,
                child: FittedBox(
                  child: Row(
                    children: [
                      const Text('Status:'),
                      const SizedBox(width: 5),
                      PopupMenuButton(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 7, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ticketItem.status == 'open'
                                  ? const Color(0xff6BB17B)
                                  : const Color(0xffC66060),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  ticketItem.status.capitalize(),
                                  style: TextStyle(
                                      color: cc.pureWhite,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: cc.pureWhite,
                                )
                              ],
                            ),
                          ),
                          itemBuilder: (context) => [
                                const PopupMenuItem(
                                  child: Text('Open'),
                                  value: 'open',
                                ),
                                const PopupMenuItem(
                                    child: Text('Close'), value: 'close'),
                              ]),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                child: GestureDetector(
                  onTap: (() {
                    Provider.of<TicketChatService>(context, listen: false)
                        .fetchSingleTickets(ticketId)
                        .then((value) {
                      if (value != null) {
                        snackBar(context, value);
                      }
                    }).onError((error, stackTrace) {
                      snackBar(context, 'Could not load any messages');
                    });
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => TicketChat(title),
                    ));
                  }),
                  child: Container(
                    height: 30,
                    width: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff17A2B8),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/icons/chat_view.svg',
                      height: 20,
                      width: 30,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Color manageColor(value) {
    if (value == 'low') {
      return const Color(0xff6BB17B);
    }
    if (value == 'medium') {
      return const Color(0xff70B9AE);
    }
    if (value == 'high') {
      return const Color(0xffC66060);
    }
    return const Color(0xffBFB55A);
  }
}
