import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/route_animator_component.dart';
import 'package:travellingo/pages/flight%20(done)/select_seat/select_seat_page.dart';
import 'package:travellingo/pages/flight%20(done)/ticket_detail/widget/passenger_detail_card.dart';
import 'package:travellingo/pages/flight%20(done)/ticket_detail/widget/ticket_detail_card.dart';

class TicketDetailPage extends StatefulWidget {
  final Map<String, dynamic>? data; // Data can be null

  const TicketDetailPage(
      {super.key, this.data}); // Constructor can receive null data

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late Map<String, dynamic> ticketData; // Variable to store ticket data
  late List<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = [true];
    // If data is null or not complete, use default data
    ticketData = widget.data ??
        {
          "castleName": "Himeji Castle",
          "departure": "KOBE",
          "arrival": "HCL",
          "departureTime": "12:00 PM",
          "arrivalTime": "01:15 PM",
          "duration": "1h 15m",
          "price": 475.22,
          "ticketsLeft": "2",
          "passengerCount": 1,
          "transport": "Aircraft"
        };
  }

  void _addNewPassengerPanel() {
    setState(() {
      _isExpanded.add(false); // Add new passenger in collapsed state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ticketDetails'.getString(context),
          style: const TextStyle(
            color: Color(0xFF292F2E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  TicketDetailCard(ticketData: ticketData),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.favorite, color: Color(0xFF3E84A8)),
                          const SizedBox(width: 8),
                          Text(
                            "passengers".getString(context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF3E84A8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 8), // Add space between the containers
                      const PassengerDetailCard()
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people,
                                  color: Color(0xFF3E84A8)),
                              const SizedBox(width: 8),
                              Text(
                                "passengersDetails".getString(context),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF3E84A8),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: _addNewPassengerPanel,
                            child: Text(
                              "+ ${'addPassenger'.getString(context)}",
                              style: const TextStyle(
                                color: Color(0xFFF5D161),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 10), // Add space between the containers
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _isExpanded.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildPassengerPanel(index);
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '/PERSON',
                      style: TextStyle(
                        color: Color(0xFF6B7B78),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '\$475.22',
                      style: TextStyle(
                        color: Color(0xFF292F2E),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF5D161)), // Button background color
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFFFFFF)), // Text color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(171, 48)), // Set the button's size
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      createRouteFromBottom(
                        const SelectSeatPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Select Seat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerPanel(int index) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          shape: const Border(),
          key: ValueKey("passenger_$index"),
          initiallyExpanded: _isExpanded[index],
          title: Row(
            children: [
              const Icon(
                Icons.emoji_emotions_outlined,
                color: Color(0xFF3E84A8),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "${'passenger'.getString(context)} ${index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF3E84A8),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(height: 2.2),
                          ),
                          value: 'Passport',
                          selectedItemBuilder: (context) {
                            return ['Passport', 'ID Card', 'Driver License']
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: SizedBox(
                                        width: 40,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ))
                                .toList();
                          },
                          items: ['Passport', 'ID Card', 'Driver License']
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                      width: 80,
                                      child: Text(
                                        value,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (newValue) {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Identity number',
                            hintText: '',
                            hintStyle: TextStyle(height: 2.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      hintText: '',
                      hintStyle: TextStyle(height: 2.2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "passengerWarning".getString(context),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "passengerWarning2".getString(context),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded[index] = expanded;
            });
          },
        ),
      ),
    );
  }
}
