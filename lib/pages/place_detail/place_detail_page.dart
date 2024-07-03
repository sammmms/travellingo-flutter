import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/place/place_bloc.dart';
import 'package:travellingo/bloc/place/place_state.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/models/review.dart';
import 'package:travellingo/pages/home/widget/see_all.dart';
import 'package:travellingo/utils/format_currency.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/place_category_util.dart';

class PlaceDetailPage extends StatefulWidget {
  final Place place;
  const PlaceDetailPage({super.key, required this.place});

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  final bloc = PlaceBloc();
  final _selectedQuantity = BehaviorSubject<int>.seeded(0);

  @override
  void initState() {
    bloc.getPlaceById(widget.place.id);
    super.initState();
  }

  @override
  void dispose() {
    _selectedQuantity.close();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaceState>(
        stream: bloc.controller,
        builder: (context, snapshot) {
          bool isLoading =
              snapshot.data?.isLoading ?? false || !snapshot.hasData;

          bool hasError = snapshot.data?.hasError ?? false;

          Place? place = snapshot.data?.data?.first;
          bool doNotLoadBody = isLoading || hasError || place == null;
          return Scaffold(
              appBar: doNotLoadBody ? AppBar() : null,
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : hasError
                      ? MyErrorComponent(
                          onRefresh: () {
                            bloc.getPlaceById(widget.place.id);
                          },
                        )
                      : doNotLoadBody
                          ? const MyNoDataComponent()
                          : Stack(
                              children: [
                                _buildPlacePicture(place),
                                _buildPlaceDetail(place),
                              ],
                            ),
              bottomSheet: doNotLoadBody ? null : _buildBottomAppBar(place));
        });
  }

  Widget _buildBottomAppBar(Place place) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -1)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${"price".getString(context)} / ${"person".getString(context)}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  formatToIndonesiaCurrency(place.price),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                bool? proceed = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Container(
                          padding: const EdgeInsets.all(20),
                          color: Theme.of(context).colorScheme.surfaceBright,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  MyImageLoader(
                                      url: place.pictureLink,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      pictureType: PictureType.link),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(place.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium),
                                        Row(
                                          children: [
                                            _buildChip(
                                                PlaceCategoryUtil.stringOf(
                                                    place.category)),
                                            const SizedBox(width: 10),
                                            _starConstructor(
                                                place.reviewAverage),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text("quantity".getString(context),
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              const SizedBox(height: 10),
                              Row(children: [
                                IconButton(
                                  onPressed: () {
                                    if (_selectedQuantity.value > 0) {
                                      _selectedQuantity
                                          .add(_selectedQuantity.value - 1);
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                StreamBuilder<int>(
                                    stream: _selectedQuantity,
                                    builder: (context, snapshot) {
                                      return Text(snapshot.data.toString());
                                    }),
                                IconButton(
                                  onPressed: () {
                                    _selectedQuantity
                                        .add(_selectedQuantity.value + 1);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ]),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                style: ButtonStyle(
                                  elevation: const WidgetStatePropertyAll(10),
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 20)),
                                  backgroundColor: WidgetStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                                  foregroundColor: WidgetStateProperty.all(
                                      Theme.of(context).colorScheme.onPrimary),
                                ),
                                child: Text("book".getString(context)),
                              ),
                            ],
                          ),
                        ));

                if (_selectedQuantity.value <= 0 ||
                    proceed == null ||
                    !proceed) {
                  return;
                }
              },
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(10),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20)),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onPrimary),
              ),
              child: Text("bookNow".getString(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacePicture(Place place) {
    return Stack(
      children: [
        MyImageLoader(
          url: place.pictureLink,
          height: 300,
          fit: BoxFit.cover,
          pictureType: PictureType.link,
        ),
        Container(
          color: Colors.black.withAlpha(50),
        )
      ],
    );
  }

  Widget _buildPlaceDetail(Place place) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getPlaceById(widget.place.id);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const SizedBox(
                  height: 250,
                  width: double.infinity,
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Colors.grey.withOpacity(0.4)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -1)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(place.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildChip(PlaceCategoryUtil.stringOf(place.category)),
                      const SizedBox(
                        width: 10,
                      ),
                      _starConstructor(place.reviewAverage),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${place.country}, ${place.city}",
                      ),
                    ],
                  ),
                  Divider(
                    height: 50,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("reviews".getString(context),
                          style: Theme.of(context).textTheme.headlineSmall),
                      if (place.reviews.length > 8) const SeeAllButton()
                    ],
                  ),
                  _buildReview(place.reviews)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      labelStyle: const TextStyle(fontSize: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      label: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 60),
          child: Text(
            label.getString(context),
            textAlign: TextAlign.center,
          )),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildReview(List<Review> reviews) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reviews.length > 8 ? 8 : reviews.length,
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text(reviews[index].user),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _starConstructor(reviews[index].rating),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(reviews[index].review),
                  ],
                ),
              ));
        });
  }

  Widget _starConstructor(double reviewCount) {
    List<Widget> reviewStar = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= reviewCount) {
        reviewStar.add(SvgPicture.asset(
          "assets/svg/star_full_icon.svg",
          height: 18,
        ));
      }
    }

    if (reviewStar.isEmpty) {
      reviewStar.add(_buildChip("noReviewYet"));
    }
    return Row(
      children: reviewStar,
    );
  }
}
