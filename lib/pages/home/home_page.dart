import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/cart/cart_bloc.dart';
import 'package:travellingo/bloc/cart/cart_state.dart';
import 'package:travellingo/bloc/place/place_bloc.dart';
import 'package:travellingo/bloc/place/place_state.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/component/my_shimmer.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/pages/cart/cart_page.dart';
import 'package:travellingo/pages/home/widget/home_filter_chip.dart';
import 'package:travellingo/pages/home/widget/home_carousel.dart';
import 'package:travellingo/pages/home/widget/my_search_bar.dart';
import 'package:travellingo/pages/home/widget/label_heading.dart';
import 'package:travellingo/pages/home/widget/see_all.dart';
import 'package:travellingo/pages/home/widget/transport_button.dart';
import 'package:travellingo/pages/flight/flight_page.dart';
import 'package:travellingo/pages/login/login_page.dart';
import 'package:travellingo/pages/place_detail/place_detail_page.dart';
import 'package:travellingo/utils/dummy_data.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/place_category_util.dart';
import 'package:travellingo/utils/store.dart';
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
        resizeToAvoidBottomInset: false,
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
                        MySearchBar(
                          label: "exploreSomethingFun",
                          controller: _searchController,
                          onChanged: (value) {
                            _searchStream.add(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<String>(
                            stream: _searchStream,
                            builder: (context, search) =>
                                search.data?.isNotEmpty ?? false
                                    ? _buildSearchBody()
                                    : _buildHomeBody()),
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
          elevation: 2,
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

  Widget _buildSearchBody() {
    return StreamBuilder<PlaceState>(
        stream: _bloc.controller,
        builder: (context, snapshot) {
          bool isLoading =
              snapshot.data?.isLoading ?? false || !snapshot.hasData;
          if (isLoading) {
            // Loading shimmer
            return myListLoadingShimmer();
          }

          PlaceState state = snapshot.data!;
          if (state.hasError) {
            // Error data
            return MyErrorComponent(onRefresh: () {
              _bloc.getPlace(
                search: _searchStream.valueOrNull,
                filter: _filterStream.valueOrNull,
              );
            });
          }

          List<Place> places = state.data ?? [];

          if (places.isEmpty) {
            return MyNoDataComponent(
              onRefresh: () {
                _bloc.getPlace(
                    search: _searchStream.valueOrNull,
                    filter: _filterStream.valueOrNull);
              },
            );
          }

          return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 20),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: places.length > 8 ? 8 : places.length,
              separatorBuilder: (context, index) => const SizedBox(
                    height: 5,
                  ),
              itemBuilder: (context, index) {
                Place place = places[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context, slideInFromRight(PlaceDetailPage(place: place))),
                  child: Card(
                    key: const ValueKey(""),
                    color: Theme.of(context).colorScheme.surfaceTint,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          if (place.pictureType == PictureType.link)
                            MyImageLoader(
                              url: place.pictureLink,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  "${place.country}, ${place.city}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Widget _buildHomeBody() {
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TransportButton(icon: "assets/images/Bus.png", label: "bus"),
              TransportButton(icon: "assets/images/Car.png", label: "car"),
              TransportButton(icon: "assets/images/Train.png", label: "train"),
              TransportButton(
                icon: "assets/images/Airplane.png",
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
                return HomeCarousel(places: places);
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
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
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
          onPressed: () async {
            bool notAuthenticated = context
                    .read<AuthBloc>()
                    .controller
                    .valueOrNull
                    ?.isAuthenticated ==
                false;

            bool noToken = await Store.getToken() == null;
            if (!mounted) return;
            if (noToken || notAuthenticated) {
              Navigator.push(context, slideInFromBottom(const LoginPage()));
              return;
            }
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
