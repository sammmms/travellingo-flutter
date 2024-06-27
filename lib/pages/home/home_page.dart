import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/cart/cart_bloc.dart';
import 'package:travellingo/bloc/cart/cart_state.dart';
import 'package:travellingo/bloc/place/place_bloc.dart';
import 'package:travellingo/bloc/place/place_state.dart';
import 'package:travellingo/component/my_shimmer.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/pages/cart/cart_page.dart';
import 'package:travellingo/pages/home/widget/home_filter_chip.dart';
import 'package:travellingo/pages/home/widget/home_carousel.dart';
import 'package:travellingo/pages/home/widget/home_search_bar.dart';
import 'package:travellingo/pages/home/widget/label_heading.dart';
import 'package:travellingo/pages/home/widget/see_all.dart';
import 'package:travellingo/pages/home/widget/transport_button.dart';
import 'package:travellingo/pages/flight/flight_page.dart';
import 'package:travellingo/utils/dummy_data.dart';
import 'package:travellingo/utils/place_category_util.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentTime = "";
  final _filterStream =
      BehaviorSubject<PlaceCategory>.seeded(PlaceCategory.all);
  final _searchStream = BehaviorSubject<String>.seeded("");
  final _selectedCity = BehaviorSubject<String>();
  final _searchController = TextEditingController();
  final _bloc = PlaceBloc();
  final _cartBloc = CartBloc();

  @override
  void initState() {
    currentTime = timePicker(DateTime.now().hour);

    _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {
      _bloc.getPlace(filter: _filterStream.value, search: event);
    });

    _filterStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {
      _bloc.getPlace(filter: event, search: _searchStream.value);
    });

    _bloc.getPlace();
    _cartBloc.getCart();
    super.initState();
  }

  @override
  void dispose() {
    _filterStream.close();
    _searchStream.close();
    _selectedCity.close();
    _searchController.dispose();
    _bloc.dispose();
    _cartBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await _bloc.getPlace(
                filter: _filterStream.value, search: _searchStream.value);
          },
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          edgeOffset: 100,
          displacement: 10,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverAppBar(
                expandedHeight: 80,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
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
                            _buildCityDropdown()
                          ],
                        ),
                      ),
                      _buildCartIcon(),
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
                            stream: _bloc.controller,
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
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 56,
            child: StreamBuilder<PlaceCategory>(
                stream: _filterStream,
                builder: (context, snapshot) {
                  List<PlaceCategory> categories =
                      PlaceCategory.values.toList();
                  categories
                      .sort((a, b) => a.toString().compareTo(b.toString()));
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: PlaceCategory.values.length,
                    itemBuilder: (context, index) {
                      PlaceCategory category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: HomeFilterChip(
                          isSelected: snapshot.data == category,
                          selection: category,
                          onSelected: (value) {
                            _filterStream.add(value);
                          },
                        ),
                      );
                    },
                  );
                }),
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
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<PlaceState>(
              stream: _bloc.controller,
              builder: (context, snapshot) {
                List<Place> places = snapshot.data?.data ?? [];
                if (places.isEmpty) {
                  return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: MyShimmer(width: double.infinity, height: 200));
                }
                if (places.length > 5) {
                  places = places.sublist(0, 5);
                }
                return CarouselSlider.builder(
                  options: CarouselOptions(
                      enableInfiniteScroll: true,
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      animateToClosest: true,
                      pageSnapping: true),
                  itemCount: places.length,
                  itemBuilder: (context, index, realIndex) {
                    Place place = places[index];
                    return HomeCarousel(
                      place: place,
                      onTap: () {},
                    );
                  },
                );
              }),
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
          // TODO : MAKE THE NEARBY BY USING THE CITY, AND USE THE HOME RECOMMENDATION
        ]);
  }

  Widget _buildCityDropdown() {
    return StreamBuilder<String>(
        stream: _selectedCity,
        initialData: indonesiaAirport[0]["kodeBandara"],
        builder: (context, snapshot) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(10),
              isDense: true,
              onChanged: (String? value) {
                _selectedCity.add(value!);
              },
              padding: const EdgeInsets.only(top: 5),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              value: snapshot.data,
              items: indonesiaAirport
                  .map((e) => DropdownMenuItem(
                      value: e["kodeBandara"], child: Text(e["kota"]!)))
                  .toList(),
              selectedItemBuilder: (context) {
                return indonesiaAirport
                    .map((e) => Center(
                            child: Text(
                          e["kota"]!,
                          style: textStyle.headlineLarge,
                        )))
                    .toList();
              },
            ),
          );
        });
  }

  Widget _buildCartIcon() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                slideInFromRight(
                  Provider<CartBloc>.value(
                      value: _cartBloc, child: const CartPage()),
                ));
          },
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
        StreamBuilder<CartState>(
            stream: _cartBloc.controller,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              CartState state = snapshot.data!;
              bool hasError = state.hasError;
              bool noData = state.data == null;
              bool noItem = state.data?.items.isEmpty ?? false;
              bool isLoading = state.isLoading;

              if (hasError || noData || noItem || isLoading) {
                return const SizedBox();
              }
              List<CartItems> items = state.data!.items;
              return Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    items.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            })
      ],
    );
  }
}
