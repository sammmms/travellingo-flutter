import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/my_confirmation_dialog.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/passenger.dart';
import 'package:travellingo/pages/flight/select_seat/widget/seat_passenger_card.dart';
import 'package:travellingo/pages/flight_checkout/flight_checkout_page.dart';
import 'package:travellingo/utils/dummy_data.dart';

class SelectSeatPage extends StatefulWidget {
  final Flight flight;
  final List<Passenger> passengers;
  const SelectSeatPage(
      {super.key, required this.passengers, required this.flight});

  @override
  State<SelectSeatPage> createState() => _SelectSeatPageState();
}

class _SelectSeatPageState extends State<SelectSeatPage> {
  int _currentPassenger = 0;
// Contoh kursi yang terisi
  List<String> selectedSeats = [];

  // Contoh kursi terpilih
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        bool? confirmExit = await showDialog(
          context: context,
          builder: (context) {
            return const MyConfirmationDialog(
              label: "seatWillBeReset",
              subLabel: "seatWillBeResetContent",
            );
          },
        );

        if (confirmExit == null || !confirmExit) return;

        for (var passenger in widget.passengers) {
          passenger.seat = "";
        }

        if (!context.mounted) return;

        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'selectSeat'.getString(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  padEnds: true,
                  height: 100,
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    _currentPassenger = index;
                  },
                ),
                itemCount: widget.passengers.length,
                itemBuilder: (context, index, _) => SeatPassengerCard(
                  flight: widget.flight,
                  passenger: widget.passengers[index],
                ),
              ),
              _buildSeatLegend(context),
              Expanded(child: _buildSeatGrid(context)),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    bool allSeatSelected = true;

                    for (var passenger in widget.passengers) {
                      if (passenger.seat.isEmpty) {
                        allSeatSelected = false;
                        break;
                      }
                    }

                    if (!allSeatSelected) {
                      showMySnackBar(context, "allPassengerMustSelectASeat",
                          SnackbarStatus.warning);
                      return;
                    }

                    Navigator.push(
                        context,
                        slideInFromRight(FlightCheckoutPage(
                          flight: widget.flight,
                          passengers: widget.passengers,
                        )));
                  },
                  child: Text('proceedToPayment'.getString(context),
                      style: const TextStyle(fontSize: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(context, Colors.grey, 'available'.getString(context)),
          _legendItem(context, const Color(0xFF57A3BB),
              'selected'.getString(context)), // Warna Selected diperbarui
          _legendItem(context, const Color(0xFF28527A),
              'filled'.getString(context)), // Warna Filled diperbarui
        ],
      ),
    );
  }

  Widget _legendItem(BuildContext context, Color color, String text) {
    return Row(
      children: [
        Icon(Icons.chair_rounded, color: color),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildSeatGrid(BuildContext context) {
    const Color selectedColor = Color(0xFF57A3BB); // Warna kursi yang dipilih
    const Color occupiedColor = Color(0xFF28527A); // Warna kursi yang terisi
    const Color availableColor = Colors.grey; // Warna kursi yang tersedia

    // Membuat baris header untuk label kursi
    List<Widget> seatHeader = [
      ...['A', 'B', 'C'].map((label) => _buildSeatLabel(label)),
      const Spacer(), // Spacer untuk tengah
      ...['D', 'E', 'F'].map((label) => _buildSeatLabel(label)),
    ];

    List<Widget> gridRows = [
      Row(children: seatHeader)
    ]; // Menambahkan header sebagai baris pertama

    // Membangun baris kursi dengan angka
    for (var i = 1; i <= 9; i++) {
      List<Widget> rowItems = [];
      for (var j = 0; j < 3; j++) {
        // Kursi A-C
        String seatNumber = '$i${String.fromCharCode('A'.codeUnitAt(0) + j)}';
        rowItems.add(_buildSeatItem(
          context,
          occupiedSeats.contains(seatNumber),
          selectedSeats.contains(seatNumber),
          availableColor,
          occupiedColor,
          selectedColor,
          seatNumber,
        ));
      }
      rowItems.add(_buildMiddleNumber(i.toString())); // Angka di tengah

      for (var j = 0; j < 3; j++) {
        // Kursi D-F
        String seatNumber = '$i${String.fromCharCode('D'.codeUnitAt(0) + j)}';
        rowItems.add(_buildSeatItem(
          context,
          occupiedSeats.contains(seatNumber),
          selectedSeats.contains(seatNumber),
          availableColor,
          occupiedColor,
          selectedColor,
          seatNumber,
        ));
      }

      gridRows.add(Row(children: rowItems));
    }

    return SingleChildScrollView(
      child: Column(
        children: gridRows,
      ),
    );
  }

// Membangun label untuk setiap kursi
  Widget _buildSeatLabel(String label) {
    return Expanded(
      child: Center(
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

// Membangun item kursi dengan warna sesuai kondisi
  Widget _buildSeatItem(
    BuildContext context,
    bool isOccupied,
    bool isSelected,
    Color availableColor,
    Color occupiedColor,
    Color selectedColor,
    String seatNumber,
  ) {
    Color seatColor;

    if (isSelected) {
      seatColor = selectedColor;
    } else if (isOccupied) {
      seatColor = occupiedColor;
    } else {
      seatColor = availableColor;
    }

    // Menggunakan AspectRatio untuk memastikan bahwa item kursi persegi
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1, // Aspek rasio 1:1 untuk membuatnya persegi
        child: InkWell(
          onTap: () async {
            // Memperbarui state ketika item kursi ditekan

            if (isOccupied) {
              return; // Jangan lakukan apa pun jika kursi terisi
            }

            // When the selected seat, is already selected (either by the same passenger or another passenger)
            if (selectedSeats.contains(seatNumber)) {
              // When other passenger are selecting this seat
              if (widget.passengers[_currentPassenger].seat != seatNumber) {
                bool? switchSeat = await showDialog(
                  context: context,
                  builder: (context) {
                    return const MyConfirmationDialog(
                      label: "changeSeatConfirmation",
                      subLabel: "changeSeatConfirmationContent",
                    );
                  },
                );

                if (switchSeat == null || !switchSeat) {
                  return;
                }

                Passenger occupyingPassenger = widget.passengers
                    .firstWhere((passenger) => passenger.seat == seatNumber);

                String temporarySeat =
                    widget.passengers[_currentPassenger].seat;

                // Switch the seat
                widget.passengers[_currentPassenger].seat =
                    occupyingPassenger.seat;

                if (temporarySeat.isNotEmpty) {
                  occupyingPassenger.seat = temporarySeat;
                } else {
                  occupyingPassenger.seat = "";
                }
              }

              // When the same passenger are deselecting the seat
              else {
                widget.passengers[_currentPassenger].seat = "";
                selectedSeats.remove(seatNumber);
              }
            } else {
              // Remove the current selected seat
              if (widget.passengers[_currentPassenger].seat.isNotEmpty) {
                selectedSeats.remove(widget.passengers[_currentPassenger].seat);
              }

              // Set the new selected seat
              widget.passengers[_currentPassenger].seat = seatNumber;
              selectedSeats.add(seatNumber);
            }

            setState(() {});
          },
          child: Icon(
            Icons.chair_rounded,
            color: seatColor,
          ),
        ),
      ),
    );
  }

// Membangun pemisah dengan angka di tengah
  Widget _buildMiddleNumber(String number) {
    return Expanded(
      child: Center(
        child:
            Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
