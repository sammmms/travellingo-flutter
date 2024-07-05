import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/flight/flight_bloc.dart';
import 'package:travellingo/bloc/flight/flight_state.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/pages/flight/flight_list/flight_list_card.dart';
import 'package:travellingo/pages/flight/flight_list/flight_list_loading.dart';
import 'package:travellingo/utils/flight_class_util.dart';

class FlightListPage extends StatefulWidget {
  final String from;
  final String to;
  final DateTime startDate;
  final int passengerCount;
  final FlightClass flightClass;
  const FlightListPage(
      {super.key,
      required this.from,
      required this.to,
      required this.startDate,
      required this.passengerCount,
      required this.flightClass});

  @override
  State<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  late List<DateTime> dates;
  late FlightBloc bloc;

  @override
  void initState() {
    bloc = FlightBloc(context.read<AuthBloc>());
    dates = List.generate(14, (index) {
      return widget.startDate.add(Duration(days: index));
    });

    bloc.getFlight(
        departure: widget.from,
        arrival: widget.to,
        startDate: widget.startDate,
        flightClass: widget.flightClass);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dates.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('ticketList'.getString(context)),
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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.to,
                    style: Theme.of(context).textTheme.headlineMedium,
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
                    '${widget.passengerCount} ${"passenger".getString(context)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    FlightClassUtil.stringFromClass(widget.flightClass)
                        .getString(context),
                    style: Theme.of(context).textTheme.titleSmall,
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
                            text:
                                DateFormat("MMMM d, yyyy").format(dates[index]),
                          ),
                        )),
              ),
            ),
            StreamBuilder<FlightState>(
                stream: bloc.controller,
                builder: (context, snapshot) {
                  bool isLoading =
                      snapshot.data?.isLoading ?? false || !snapshot.hasData;

                  if (isLoading) {
                    return const Expanded(
                      child: FlightListLoading(),
                    );
                  }

                  List<Flight> flights = snapshot.data?.flights ?? [];

                  List<Widget> columnList = [];

                  for (var date in dates) {
                    List<Flight>? filteredFlights = flights.where((flight) {
                      return flight.departureTime.year == date.year &&
                          flight.departureTime.month == date.month &&
                          flight.departureTime.day == date.day;
                    }).toList();

                    if (filteredFlights.isEmpty) {
                      columnList.add(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'noFlightAvailable'.getString(context),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                      continue;
                    }

                    columnList.add(
                      Column(
                        children: filteredFlights
                            .map((e) => FlightListCard(
                                  flight: e,
                                  passengerCount: widget.passengerCount,
                                ))
                            .toList(),
                      ),
                    );
                  }

                  return Expanded(
                    child: TabBarView(
                      children: columnList,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
