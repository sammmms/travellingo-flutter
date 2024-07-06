import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/wishlist/wishlist_bloc.dart';
import 'package:travellingo/bloc/wishlist/wishlist_state.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/pages/home/widget/home_filter_chip.dart';
import 'package:travellingo/pages/home/widget/my_search_bar.dart';
import 'package:travellingo/pages/wishlist/widget/wishlist_card.dart';
import 'package:travellingo/pages/wishlist/widget/wishlist_loading.dart';
import 'package:travellingo/utils/place_category_util.dart';

class WishlistPages extends StatefulWidget {
  const WishlistPages({super.key});

  @override
  State<WishlistPages> createState() => _WishlistPagesState();
}

class _WishlistPagesState extends State<WishlistPages> {
  final _searchController = TextEditingController();
  final _searchStream = BehaviorSubject<String>.seeded("");
  late WishlistBloc bloc;
  bool filterState = false;
  final _selecting = BehaviorSubject<PlaceCategory>.seeded(PlaceCategory.all);

  @override
  void initState() {
    bloc = WishlistBloc(context.read<AuthBloc>());
    bloc.getWishlist();

    _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {
      bloc.getWishlist(search: event, category: _selecting.value);
    });

    _selecting.debounceTime(const Duration(milliseconds: 500)).listen((event) {
      bloc.getWishlist(search: _searchController.text, category: event);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: RefreshIndicator(
            edgeOffset: 100,
            onRefresh: () async {
              await bloc.getWishlist();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAppBar(),
                if (filterState) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<PlaceCategory>(
                      stream: _selecting,
                      builder: (context, snapshot) {
                        PlaceCategory selection =
                            snapshot.data ?? PlaceCategory.all;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var category in PlaceCategory.values) ...[
                                const SizedBox(width: 10),
                                HomeFilterChip(
                                    selection: category,
                                    isSelected: selection == category,
                                    onSelected: (value) {
                                      _selecting.add(category);
                                    }),
                              ]
                            ],
                          ),
                        );
                      }),
                ],
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder<WishlistState>(
                    stream: bloc.controller,
                    builder: (context, snapshot) {
                      bool isLoading = snapshot.data?.isLoading ??
                          false || !snapshot.hasData;

                      if (isLoading) {
                        return WishlistLoading(isLoading: isLoading);
                      }

                      if (snapshot.data?.hasError ?? false) {
                        return MyErrorComponent(
                          onRefresh: () {
                            bloc.getWishlist();
                          },
                        );
                      }

                      List<Place> places = snapshot.data!.places ?? [];
                      if (places.isEmpty) {
                        return const MyNoDataComponent(
                          label: "noWishlistCurrently",
                        );
                      }

                      return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return WishlistCard(place: places[index]);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: places.length);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 10),
      child: Row(
        children: [
          Expanded(
            child: MySearchBar(
              label: "search",
              controller: _searchController,
              onChanged: (value) {
                _searchStream.add(value);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                filterState = !filterState;
              });
            },
            icon: SvgPicture.asset(
              color: Theme.of(context).colorScheme.tertiary,
              "assets/svg/filter_icon.svg",
            ),
          )
        ],
      ),
    );
  }
}
