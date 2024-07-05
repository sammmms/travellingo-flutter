import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/recent_flight_search.dart';
import 'package:travellingo/pages/flight/flight_list/flight_list_page.dart';
import 'package:travellingo/pages/flight/widget/app_bar_stack.dart';
import 'package:travellingo/pages/flight/widget/recent_flight_card.dart';
import 'package:travellingo/pages/flight/widget/flight_card_image.dart';
import 'package:travellingo/pages/home/widget/label_heading.dart';
import 'package:travellingo/pages/home/widget/see_all.dart';
import 'package:travellingo/utils/store.dart';

class FlightPage extends StatefulWidget {
  const FlightPage({super.key});

  @override
  State<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  final _recentFlightSearch =
      BehaviorSubject<List<RecentFlightSearch>>.seeded([]);

  @override
  void initState() {
    Store.getRecentFlightSearch().then((value) {
      _recentFlightSearch.add(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        List<RecentFlightSearch> recentFlightSearch =
            await Store.getRecentFlightSearch();
        _recentFlightSearch.add(recentFlightSearch);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const AppBarStack(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const LabelHeading(
                      icon: Icon(Icons.history), content: "yourLastSearch"),
                  const Spacer(),
                  SeeAllButton(
                    onTap: () {
                      Store.clearRecentFlightSearch();
                    },
                  ),
                ],
              ),
            ), // Menambah jarak antar card
            StreamBuilder<List<RecentFlightSearch>>(
                stream: _recentFlightSearch,
                builder: (context, snapshot) {
                  List<RecentFlightSearch> recentFlightSearch =
                      snapshot.data ?? [];

                  bool isEmpty = recentFlightSearch.isEmpty;

                  if (isEmpty) {
                    return const MyNoDataComponent(
                      label: "noRecentSearch",
                    );
                  }

                  return SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: false,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          pageSnapping: true,
                          animateToClosest: true,
                          viewportFraction: 0.8),
                      itemCount: recentFlightSearch.length,
                      itemBuilder: (context, index, _) {
                        RecentFlightSearch recentFlight =
                            recentFlightSearch[index];
                        return RecentFlightCard(
                          recentFlight: recentFlight,
                          onTap: () {
                            Navigator.push(
                                context,
                                slideInFromRight(FlightListPage(
                                  from: recentFlight.from,
                                  to: recentFlight.to,
                                  startDate: recentFlight.date,
                                  passengerCount: recentFlight.passengerCount,
                                  flightClass: recentFlight.flightClass,
                                )));
                          },
                        );
                      },
                    ),
                  );
                }),
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
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.surfaceTint),
                        shape: const WidgetStatePropertyAll(CircleBorder())),
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
            CarouselSlider.builder(
              options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  initialPage: 0,
                  padEnds: true,
                  enableInfiniteScroll: true,
                  pageSnapping: true,
                  viewportFraction: 0.8),
              itemCount: 5,
              itemBuilder: (context, __, _) => FlightCardImage(
                heading: "50%",
                heading2: "discount".getString(context),
                subheading: "forNewUsers".getString(context),
                subheading2: "*${"termsNConditionApply".getString(context)}",
                image: "assets/flight/flight.jpg",
              ),
            )
          ],
        ),
      ),
    ));
  }
}
