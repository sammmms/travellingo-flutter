import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/place/place_bloc.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/pages/home/choices/all/home_all_recommendation.dart';
import 'package:travellingo/pages/home/choices/all/home_all_nearby.dart';
import 'package:travellingo/pages/home/widget/home_filter_chip.dart';
import 'package:travellingo/pages/home/widget/home_search_bar.dart';
import 'package:travellingo/pages/home/widget/label_heading.dart';
import 'package:travellingo/pages/home/widget/see_all.dart';
import 'package:travellingo/pages/home/widget/transport_button.dart';
import 'package:travellingo/pages/flight%20(done)/flight_page.dart';
import 'package:travellingo/utils/dummy_data.dart';
import 'package:travellingo/utils/place_category_util.dart';
import 'package:travellingo/utils/theme_data/color_scheme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentCity = japanCities.first;
  String currentTime = "";
  final _filterStream =
      BehaviorSubject<PlaceCategory>.seeded(PlaceCategory.all);
  final _searchStream = BehaviorSubject<String>.seeded("");
  final _searchController = TextEditingController();
  final bloc = PlaceBloc();

  @override
  void initState() {
    currentTime = timePicker(DateTime.now().hour);

    bloc.getPlace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await bloc.getPlace(_filterStream.value);
          },
          color: colorScheme.primary,
          backgroundColor: colorScheme.background,
          edgeOffset: 100,
          displacement: 10,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverAppBar(
                expandedHeight: 80,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentTime.getString(context).toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: currentCity,
                                  // isDense: true,
                                  focusColor: Colors.transparent,
                                  menuMaxHeight: 200,
                                  borderRadius: BorderRadius.circular(16),
                                  padding: const EdgeInsets.only(top: 0),
                                  dropdownColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  elevation: 0,
                                  items: japanCities
                                      .map(
                                        (entry) => DropdownMenuItem(
                                            value: entry,
                                            child: Text(
                                                "${entry["city"]}, ${entry["country"]}")),
                                      )
                                      .toList(),
                                  selectedItemBuilder: (context) {
                                    return japanCities
                                        .map(
                                          (entry) => DropdownMenuItem(
                                              value: entry,
                                              child: Text(
                                                "${entry["city"]}, ${entry["country"]}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        27, 20, 70, 1),
                                                    fontSize: 20),
                                              )),
                                        )
                                        .toList();
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      currentCity = value!;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      Badge(
                        smallSize: 10,
                        largeSize: 10,
                        backgroundColor: const Color.fromRGBO(255, 145, 65, 1),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Color.fromRGBO(62, 132, 168, 1),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        HomeSearchBar(
                          controller: _searchController,
                          onChanged: (value) {
                            _searchStream.add(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder(
                            stream: bloc.controller,
                            builder: (context, snap) {
                              List<Place> places = snap.data?.data ?? [];
                              return StreamBuilder<String>(
                                  stream: _searchStream,
                                  builder: (context, snapshot) =>
                                      snapshot.data?.isNotEmpty ?? false
                                          ? const SizedBox()
                                          : _buildHomeBody(places));
                            })
                      ],
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFF5D161),
          elevation: 10,
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(
            Icons.map,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String timePicker(int time) {
    if (time < 12) {
      return "goodMorning";
    } else if (time < 15) {
      return "goodAfternoon";
    } else if (time < 18) {
      return "goodEvening";
    } else {
      return "goodNight";
    }
  }

  void changeFilterSelection(PlaceCategory value) {
    setState(() {
      _filterStream.add(value);
    });
  }

  Widget _buildHomeBody(List<Place> places) {
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const LabelHeading(
              icon: Icon(
                Icons.commute,
                color: Color.fromRGBO(62, 132, 168, 1),
              ),
              content: "transportationType"),
          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TransportButton(icon: "assets/Bus.png", label: "bus"),
              TransportButton(icon: "assets/Car.png", label: "car"),
              TransportButton(icon: "assets/Train.png", label: "train"),
              TransportButton(
                icon: "assets/Airplane.png",
                label: "airplane",
                routeTo: FlightPage(),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: PlaceCategory.values.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 10,
                );
              },
              itemBuilder: (context, index) {
                return HomeFilterChip(
                    controller: _filterStream,
                    label:
                        PlaceCategoryUtil.stringOf(PlaceCategory.values[index]),
                    onSelected: changeFilterSelection);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelHeading(
                  icon: Icon(Icons.star_border,
                      color: Color.fromRGBO(255, 145, 65, 1)),
                  content: "recommendation"),
              SeeAllButton(),
            ],
          ),
          const HomeAllRecommendation(),
          const SizedBox(
            height: 15,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelHeading(
                  icon: Icon(Icons.near_me_outlined,
                      color: Color.fromRGBO(255, 145, 65, 1)),
                  content: "nearby"),
              SeeAllButton(),
            ],
          ),
          const HomeAllNearby(),
          const SizedBox(
            height: 15,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelHeading(
                  icon: Icon(Icons.insights,
                      color: Color.fromRGBO(255, 145, 65, 1)),
                  content: "insights"),
              SeeAllButton(),
            ],
          ),
          const HomeAllNearby(),
        ]);
  }
}
