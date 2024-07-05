import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/pages/flight/flight_list/flight_list_page.dart';
import 'package:travellingo/pages/flight/widget/button_choice.dart';
import 'package:travellingo/pages/flight/widget/location_choice.dart';
import 'package:travellingo/utils/flight_class_util.dart';
import 'package:travellingo/utils/date_converter.dart';
import 'package:travellingo/utils/dummy_data.dart';

class FlightChoice extends StatefulWidget {
  const FlightChoice({super.key});

  @override
  State<FlightChoice> createState() => _FlightChoiceState();
}

class _FlightChoiceState extends State<FlightChoice> {
  final _departureCity = BehaviorSubject<String>();
  final _arrivalCity = BehaviorSubject<String>();
  final pickedDate = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final passengerCount = BehaviorSubject<int>.seeded(1);
  final flightClass = BehaviorSubject<FlightClass>.seeded(FlightClass.economy);

  @override
  void initState() {
    // _departureCity.add(indonesiaAirport.first["kodeBandara"]!);
    // _arrivalCity.add(indonesiaAirport.last["kodeBandara"]!);

    _departureCity.add("KNO");
    _arrivalCity.add("HLP");
    _arrivalCity.listen((event) {
      _departureCity.add(_departureCity.value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 350),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<String>(
              stream: _departureCity,
              builder: (context, snapshot) {
                String from =
                    snapshot.data ?? indonesiaAirport.first["kodeBandara"]!;
                String to = _arrivalCity.valueOrNull ??
                    indonesiaAirport.last["kodeBandara"]!;

                return FlightLocationChoice(
                  from: from,
                  to: to,
                  onChangedDeparture: (String? departureCity) {
                    if (departureCity == _arrivalCity.valueOrNull) {
                      _arrivalCity.add(_departureCity.value);
                    }
                    _departureCity.add(departureCity!);
                  },
                  onChangedArrival: (String? arrivalCity) {
                    if (arrivalCity == _departureCity.valueOrNull) {
                      _departureCity.add(_arrivalCity.value);
                    }
                    _arrivalCity.add(arrivalCity!);
                  },
                );
              }),
          const SizedBox(height: 12),
          _buildDropdownDatetime(),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<int>(
                    stream: passengerCount,
                    builder: (context, snapshot) =>
                        _buildDropdownPassenger(snapshot.data ?? 1)),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder<FlightClass>(
                    stream: flightClass,
                    builder: (context, snapshot) => _buildDropdownClass(
                        snapshot.data ?? FlightClass.economy)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFFF5D161)),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      slideInFromBottom(FlightListPage(
                        from: indonesiaAirport.firstWhere((element) =>
                            element["kodeBandara"] ==
                            _departureCity.valueOrNull!)["kota"]!,
                        to: indonesiaAirport.firstWhere((element) =>
                            element["kodeBandara"] ==
                            _arrivalCity.valueOrNull!)["kota"]!,
                        startDate: pickedDate.valueOrNull!,
                        passengerCount: passengerCount.valueOrNull!,
                        flightClass: flightClass.valueOrNull!,
                      )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'search'.getString(context),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textScaler: const TextScaler.linear(1.2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDropdownDatetime() {
    return StreamBuilder<DateTime>(
        stream: pickedDate,
        builder: (context, snapshot) {
          DateTime date = snapshot.data ?? DateTime.now();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ButtonChoice(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                  );

                  if (picked == null) return;
                  pickedDate.add(picked);
                },
                content: DateConverter.fullReadableDate(date),
                icon: Image.asset("assets/flight/calendar.png"),
              ),
            ),
          );
        });
  }

  Widget _buildDropdownPassenger(count) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/flight/passenger.png"),
            DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: count,
                iconSize: 0,
                elevation: 16,
                borderRadius: BorderRadius.circular(10),
                dropdownColor: Theme.of(context).colorScheme.surfaceTint,
                padding: EdgeInsets.zero,
                menuMaxHeight: 300,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Poppins'),
                onChanged: (int? newValue) {
                  passengerCount.add(newValue!);
                },
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      "$value ${'passenger'.getString(context)}",
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownClass(FlightClass chosen) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/flight/flight_class.png"),
            DropdownButtonHideUnderline(
              child: DropdownButton<FlightClass>(
                value: chosen,
                iconSize: 0,
                elevation: 16,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.zero,
                menuMaxHeight: 300,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Poppins'),
                onChanged: (FlightClass? newValue) {
                  flightClass.add(newValue!);
                },
                items: FlightClass.values.map((FlightClass value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(FlightClassUtil.stringFromClass(value)
                        .getString(context)),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
