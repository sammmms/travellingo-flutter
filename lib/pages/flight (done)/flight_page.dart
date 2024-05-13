import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/pages/flight%20(done)/widget/app_bar_stack.dart';
import 'package:travellingo/pages/flight%20(done)/widget/flight_card.dart';
import 'package:travellingo/pages/flight%20(done)/widget/flight_card_image.dart';
import 'package:travellingo/pages/home/widget/label_heading.dart';
import 'package:travellingo/pages/home/widget/see_all.dart';

class FlightPage extends StatefulWidget {
  const FlightPage({super.key});

  @override
  State<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const AppBarStack(),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LabelHeading(
                    icon: Icon(Icons.history), content: "yourLastSearch"),
                Spacer(),
                SeeAllButton(),
              ],
            ),
          ), // Menambah jarak antar card
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(5, (index) => const FlightCard()),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'getAttractivePromo'.getString(context),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade100),
                      shape: const MaterialStatePropertyAll(CircleBorder())),
                  onPressed: () {
                    // Tambahkan aksi untuk tombol "See all" jika diperlukan
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Color.fromRGBO(62, 132, 168, 1),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, bottom: 20, left: 16),
            height: 175,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(
                      width: 20,
                    ),
                itemCount: 5,
                itemBuilder: (context, index) => FlightCardImage(
                      heading: "50%",
                      heading2: "discount".getString(context),
                      subheading: "forNewUsers".getString(context),
                      subheading2:
                          "*${"termsNConditionApply".getString(context)}",
                      image: "assets/flight/flight.jpg",
                    )),
          ),
        ],
      ),
    ));
  }
}
