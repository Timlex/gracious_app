import 'package:flutter/material.dart';
import '../../service/add_new_ticket_service.dart';
import '../../service/search_result_data_service.dart';
import '../../view/ticket/add_new_ticket.dart';
import '../../view/ticket/ticket_tile.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_name.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../service/ticket_service.dart';
import '../utils/constant_colors.dart';

class AllTicketsView extends StatelessWidget {
  static const routeName = 'all tickets';
  AllTicketsView({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double cardWidth = screenWidth / 3.3;
    double cardHeight = screenHight / 4.9;
    // controller.addListener((() => scrollListener(context)));

    // final routeData =
    //     ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
        appBar: AppBars().appBarTitled('All tickets', () {
          Provider.of<TicketService>(context, listen: false).clearTickets();
          Navigator.of(context).pop();
        }),
        body:
            Consumer<TicketService>(builder: (context, ticketsService, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ticketsService.ticketsList.isNotEmpty
                    ? ticketsListView(cardWidth, cardHeight, ticketsService)
                    : FutureBuilder(
                        future: showTimout(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loadingProgressBar();
                          }
                          snackBar(context, 'Timeout!');
                          return Center(
                            child: Text(
                              'Something went wrong!',
                              style: TextStyle(color: cc.greyHint),
                            ),
                          );
                        }),
                      ),
              ),
              if (ticketsService.isLoading) loadingProgressBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: customContainerButton('Add new address', double.infinity,
                    () {
                  Provider.of<AddNewTicketService>(context, listen: false)
                      .fetchDepartments()
                      .onError((error, stackTrace) =>
                          snackBar(context, 'Could not load department data!'));
                  Navigator.of(context)
                      .pushNamed(AddNewTicket.routeName)
                      .then((value) {
                    Provider.of<AddNewTicketService>(context, listen: false)
                        .clearAllData();
                    ticketsService.fetchTickets();
                  });
                }),
              ),
              const SizedBox(height: 40),
              // if (srData.resultMeta!.lastPage < pageNo)
              // CustomPaint(
              //   size: Size(MediaQuery.of(context).size.width, 300),
              //   painter: CustomShapePainter(),
              // ),
            ],
            // ),
          );
        }));
  }

  Widget ticketsListView(
      double cardWidth, double cardHeight, TicketService ticketsService) {
    if (ticketsService.noProduct) {
      return Center(
        child: Text(
          'No data has been found!',
          style: TextStyle(color: cc.greyHint),
        ),
      );
    } else {
      return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // controller: controller,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: ticketsService.ticketsList.length,
          itemBuilder: (context, index) {
            return TicketTile(
              ticketsService.ticketsList[index].title,
              ticketsService.ticketsList[index].id,
              ticketsService.ticketsList[index].createdAt,
              ticketsService.ticketsList[index].priority,
              ticketsService.ticketsList[index].status,
              ticketsService.ticketsList[index].id !=
                  ticketsService.ticketsList.last.id,
            );
          });
    }
  }

  scrollListener(BuildContext context) {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      Provider.of<SearchResultDataService>(context, listen: false)
          .setIsLoading(true);

      Provider.of<TicketService>(context, listen: false)
          .fetchTickets()
          .then((value) {
        if (value != null) {
          snackBar(context, value);
        }
      });
      Provider.of<TicketService>(context, listen: false).setPageNo();
    }
  }

  Future<bool> showTimout() async {
    await Future.delayed(const Duration(seconds: 10));
    return true;
  }
}
