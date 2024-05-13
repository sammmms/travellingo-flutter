import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travellingo/component/success_dialog_component.dart';
import 'package:travellingo/pages/checkout/widget/checkout_alert_card.dart';
import 'package:travellingo/pages/flight%20(done)/select_seat/widget/seat_passenger_card.dart';
import 'package:travellingo/pages/main_page.dart';
import 'package:travellingo/utils/dummy_data.dart';

class SelectSeatPage extends StatefulWidget {
  const SelectSeatPage({super.key});
  @override
  State<SelectSeatPage> createState() => _SelectSeatPageState();
}

class _SelectSeatPageState extends State<SelectSeatPage> {
// Contoh kursi yang terisi
  List<String> selectedSeats = [];

  // Contoh kursi terpilih
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
          'selectSeat'.getString(context),
          style: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: Color(0xFF292F2E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CheckoutAlertCard(),
            const SizedBox(
              height: 20,
            ),
            const SeatPassengerCard(),
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
                            builder: (context) => const MainPage()),
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
                selectedSeats.remove(seatNumber);
              } else {
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
