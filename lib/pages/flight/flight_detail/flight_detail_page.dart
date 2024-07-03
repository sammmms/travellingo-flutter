import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/pages/flight/select_seat/select_seat_page.dart';
import 'package:travellingo/pages/flight/flight_detail/widget/passenger_detail_card.dart';
import 'package:travellingo/pages/flight/flight_detail/widget/flight_detail_card.dart';
import 'package:travellingo/pages/login/login_page.dart';
import 'package:travellingo/utils/format_currency.dart';
import 'package:travellingo/utils/identity_util.dart';

class Passenger {
  String identityNumber;
  String fullName;
  IdentityType identityType;
  String seat;

  Passenger({
    this.identityNumber = "",
    this.fullName = "",
    this.identityType = IdentityType.idCard,
    this.seat = "",
  });
}

class FlightDetailPage extends StatefulWidget {
  final Flight flight;

  const FlightDetailPage(
      {super.key, required this.flight}); // Constructor can receive null data

  @override
  State<FlightDetailPage> createState() => _FlightDetailPageState();
}

class _FlightDetailPageState extends State<FlightDetailPage> {
  late AuthBloc authBloc;
  late List<bool> _isExpanded;
  late List<Passenger> _passengerControllers;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    super.initState();
    _passengerControllers = [Passenger()];
    _isExpanded = [true];
  }

  void _addNewPassengerPanel() {
    setState(() {
      _passengerControllers.add(Passenger());
      _isExpanded.add(false); // Add new passenger in collapsed state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ticketDetails'.getString(context),
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
                  FlightDetailCard(
                    flight: widget.flight,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      StreamBuilder<AuthState>(
                          stream: authBloc.controller,
                          builder: (context, snapshot) {
                            if (!(snapshot.data?.isAuthenticated ?? false)) {
                              return const SizedBox();
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.favorite,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                const SizedBox(width: 8),
                                Text(
                                  "passengers".getString(context),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            );
                          }),
                      const SizedBox(
                          height: 8), // Add space between the containers
                      PassengerDetailCard(
                        onAdd: () {},
                      )
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
                              Icon(Icons.people,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                              const SizedBox(width: 8),
                              Text(
                                "passengersDetails".getString(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.tertiary,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'price'.getString(context)} / ${'person'.getString(context)}',
                    ),
                    Text(
                      formatToIndonesiaCurrency(widget.flight.price),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFFF5D161)), // Button background color
                    foregroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFFFFFFFF)), // Text color
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(
                        const Size(171, 48)), // Set the button's size
                  ),
                  onPressed: () {
                    if (!(authBloc.controller.valueOrNull?.isAuthenticated ??
                        false)) {
                      showMySnackBar(
                          context, "loginFirst", SnackbarStatus.nothing);
                      Navigator.push(
                          context, slideInFromBottom(const LoginPage()));
                      return;
                    }

                    if (_passengerControllers.first.fullName.isEmpty ||
                        _passengerControllers.first.identityNumber.isEmpty) {
                      showMySnackBar(
                          context, "fillPassengerData", SnackbarStatus.nothing);
                      return;
                    }

                    Navigator.push(
                      context,
                      slideInFromBottom(
                        SelectSeatPage(
                          flight: widget.flight,
                          passengers: _passengerControllers
                              .where((element) =>
                                  element.fullName.isNotEmpty ||
                                  element.identityNumber.isNotEmpty)
                              .toList(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'selectSeat'.getString(context),
                    style: const TextStyle(
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
              Icon(
                Icons.emoji_emotions_outlined,
                color: Theme.of(context).colorScheme.tertiary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "${'passenger'.getString(context)} ${index + 1}",
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
                        child: DropdownButtonFormField<IdentityType>(
                          decoration: const InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(height: 2.2),
                          ),
                          value: _passengerControllers[index].identityType,
                          selectedItemBuilder: (context) {
                            return IdentityType.values
                                .map((IdentityType value) =>
                                    DropdownMenuItem<IdentityType>(
                                      value: value,
                                      child: SizedBox(
                                        width: 40,
                                        child: Text(
                                          IdentityTypeUtil.getString(value),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ))
                                .toList();
                          },
                          items: IdentityType.values
                              .map((IdentityType value) =>
                                  DropdownMenuItem<IdentityType>(
                                    value: value,
                                    child: SizedBox(
                                      width: 80,
                                      child: Text(
                                        IdentityTypeUtil.getString(value),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _passengerControllers[index].identityType =
                                  newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'identityNumber'.getString(context),
                            hintText: '',
                            hintStyle: const TextStyle(height: 2.2),
                          ),
                          onChanged: (value) {
                            _passengerControllers[index].identityNumber = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'fullName'.getString(context),
                      hintText: '',
                      hintStyle: const TextStyle(height: 2.2),
                    ),
                    onChanged: (value) {
                      _passengerControllers[index].fullName = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "passengerWarning".getString(context),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "passengerWarning2".getString(context),
                    style: const TextStyle(
                      fontSize: 12,
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
