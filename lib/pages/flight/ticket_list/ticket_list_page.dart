import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/dummy_data.dart';
import 'ticket_list_card.dart'; // Pastikan sudah membuat dan mengimpor file ini dengan benar

class TicketListPage extends StatefulWidget {
  final String from;
  final String to;
  const TicketListPage({super.key, required this.from, required this.to});

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  int selectedDateIndex = -1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dates.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'ticketList'.getString(context),
            style: const TextStyle(
              color: Color(0xFF292F2E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.from,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF141511),
                    ),
                  ),
                  const SizedBox(
                      width:
                          8), // Tambahkan jarak sesuai dengan desain yang diinginkan
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Color(0xFF141511),
                  ),
                  const SizedBox(
                      width:
                          8), // Tambahkan jarak sesuai dengan desain yang diinginkan
                  Text(
                    widget.to,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF141511),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1 ${"passenger".getString(context)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8C8D89),
                    ),
                  ),
                  const SizedBox(
                      width:
                          8), // Tambahkan jarak sesuai dengan desain yang diinginkan
                  Container(
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF8C8D89),
                    ),
                  ),
                  const SizedBox(
                      width:
                          8), // Tambahkan jarak sesuai dengan desain yang diinginkan
                  Text(
                    'economy'.getString(context),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8C8D89),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              height: 50,
              child: TabBar(
                unselectedLabelColor: const Color(0xFF8C8D89),
                indicatorColor: const Color(0xFF3E84A8),
                labelColor: const Color(0xFF3E84A8),
                isScrollable: true,
                tabs: List.generate(
                    dates.length,
                    (index) => SizedBox(
                          width: 100,
                          child: Tab(
                            text: dates[index],
                          ),
                        )),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: List.generate(
                  dates.length,
                  (index) => ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (BuildContext context, int idx) {
                      if (tickets[idx]["origin"] == widget.from &&
                          tickets[idx]["destination"] == widget.to) {
                        return TicketListCard(data: tickets[idx]);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
