import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/service/ticket_service.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../service/ticket_chat_service.dart';
import 'ticket_chat.dart';

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
      margin: const EdgeInsets.all(8),
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
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) =>
                      [const PopupMenuItem(child: Text(''))])
            ],
          )),
          const SizedBox(height: 30),
          // const Divider(
          //   thickness: 1.5,
          // ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Priority:'),
              const SizedBox(width: 5),
              PopupMenuButton(
                  child: Container(
                    padding: const EdgeInsets.only(left: 7, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffBFB55A),
                    ),
                    child: Row(
                      children: [
                        Text(
                          priority,
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
                  itemBuilder: (context) =>
                      [const PopupMenuItem(child: Text('priority'))]),
              const SizedBox(width: 25),
              const Text('Status:'),
              const SizedBox(width: 5),
              PopupMenuButton(
                  child: Container(
                    padding: const EdgeInsets.only(left: 7, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff6BB17B),
                    ),
                    child: Row(
                      children: [
                        Text(
                          ticketItem.status,
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
                  itemBuilder: (context) =>
                      [const PopupMenuItem(child: Text('priority'))]),
              const Spacer(),
              GestureDetector(
                onTap: (() {
                  Provider.of<TicketChatService>(context, listen: false)
                      .fetchSingleTickets(ticketId);
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => TicketChat(title),
                  ));
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff17A2B8),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/icons/chat_view.svg',
                    height: 20,
                  ),
                ),
              ),
            ],
          )

          // ListTile(
          //   dense: true,
          //   visualDensity: const VisualDensity(vertical: -3),
          //   onTap: () {
          //     Provider.of<TicketChatService>(context, listen: false)
          //         .fetchSingleTickets(ticketId);
          //     Navigator.of(context).push(MaterialPageRoute<void>(
          //       builder: (BuildContext context) => TicketChat(title),
          //     ));
          //   },
          //   title: Text(
          //     title,
          //     style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          //   ),
          //   subtitle: Row(
          //     children: [
          //       Text(
          //         '#$ticketId',
          //         style: TextStyle(
          //             color: cc.primaryColor, fontWeight: FontWeight.w600),
          //       ),
          //       const SizedBox(width: 10),
          //       Text(
          //         DateFormat.yMMMd().format(submitDate),
          //         style: TextStyle(color: cc.greyHint),
          //       )
          //     ],
          //   ),
          //   trailing: SizedBox(
          //     width: screenWidth / 2.5,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Container(
          //           width: screenWidth / 4,
          //           padding:
          //               const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: cc.whiteGrey,
          //           ),
          //           child: Text(
          //             priority,
          //             style: TextStyle(
          //                 color: cc.blackColor, fontWeight: FontWeight.w600),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //         const SizedBox(width: 15),
          //         Badge(
          //           child: const Icon(
          //             Icons.arrow_forward_ios,
          //             size: 20,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // if (divider) const Divider()
        ],
      ),
    );
  }
}
