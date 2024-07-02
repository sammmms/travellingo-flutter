import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
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

  @override
  void initState() {
    bloc.getPlaceById(widget.place.id);
    super.initState();
  }

  @override
  void dispose() {
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
                            ));
        });
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
        Positioned(
          top: 20,
          left: 10,
          child: IconButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.grey.withOpacity(0.4)),
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
            const SizedBox(
              height: 250,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    formatToIndonesiaCurrency(place.price),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Divider(
                    height: 30,
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
                      const SeeAllButton()
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
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return Card(
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
