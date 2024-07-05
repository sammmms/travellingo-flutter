import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/success_dialog_component.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/passenger.dart';
import 'package:travellingo/pages/flight/select_seat/widget/seat_passenger_card.dart';
import 'package:travellingo/pages/dashboard_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  showSuccessDialog(
                      context, "successfullyAddToCart".getString(context),
                      onClose: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const DashboardPage()),
                        (route) => false);
                  });
                },
                child: Text('addToCart'.getString(context),
                    style: const TextStyle(fontSize: 16.0)),
              ),
            ),
          ],
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
          onTap: () {
            // Memperbarui state ketika item kursi ditekan
            setState(() {
              if (isOccupied) {
                return; // Jangan lakukan apa pun jika kursi terisi
              }

              if (selectedSeats.contains(seatNumber)) {
                widget.passengers[_currentPassenger].seat = "";
                selectedSeats.remove(seatNumber);
              } else {
                if (widget.passengers[_currentPassenger].seat.isNotEmpty) {
                  selectedSeats
                      .remove(widget.passengers[_currentPassenger].seat);
                }
                widget.passengers[_currentPassenger].seat = seatNumber;
                selectedSeats.add(seatNumber);
              }
            });
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
