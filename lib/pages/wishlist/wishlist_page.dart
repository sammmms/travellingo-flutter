import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/wishlist/wishlist_bloc.dart';
import 'package:travellingo/bloc/wishlist/wishlist_state.dart';
import 'package:travellingo/pages/home/widget/my_search_bar.dart';

class WishlistPages extends StatefulWidget {
  const WishlistPages({super.key});

  @override
  State<WishlistPages> createState() => _WishlistPagesState();
}

class _WishlistPagesState extends State<WishlistPages> {
  final _searchController = TextEditingController();
  final _searchStream = BehaviorSubject<String>.seeded("");
  final bloc = WishlistBloc();

  @override
  void initState() {
    bloc.getWishlist();

    _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: StreamBuilder<WishlistState>(
              stream: bloc.controller,
              builder: (context, snapshot) {
                return const Text("Wishlist Page Search");
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
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
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/filter_icon.svg",
            ),
          )
        ],
      ),
    );
  }
}
