import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/cart/cart_bloc.dart';
import 'package:travellingo/bloc/place/place_bloc.dart';
import 'package:travellingo/bloc/place/place_state.dart';
import 'package:travellingo/bloc/wishlist/wishlist_bloc.dart';
import 'package:travellingo/bloc/wishlist/wishlist_state.dart';
import 'package:travellingo/component/my_loading_dialog.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/models/review.dart';
import 'package:travellingo/pages/home/widget/see_all.dart';
import 'package:travellingo/pages/place_detail/widget/place_category_chip.dart';
import 'package:travellingo/pages/place_detail/widget/place_review_star.dart';
import 'package:travellingo/pages/place_detail/widget/quantity_bottom_sheet.dart';
import 'package:travellingo/utils/app_error.dart';
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
  final _backKey = GlobalKey();
  final _notBackKey = GlobalKey();
  final result = BoxHitTestResult();
  late CartBloc _cartBloc;
  late PlaceBloc _bloc;
  late WishlistBloc _wishlistBloc;
  final _selectedQuantity = BehaviorSubject<int>.seeded(0);

  @override
  void initState() {
    _cartBloc = CartBloc(context.read<AuthBloc>());
    _bloc = PlaceBloc(context.read<AuthBloc>());
    _wishlistBloc = WishlistBloc(context.read<AuthBloc>());

    _wishlistBloc.getWishlist(id: widget.place.id);
    _bloc.getPlaceById(widget.place.id);

    super.initState();
  }

  @override
  void dispose() {
    _selectedQuantity.close();
    _bloc.dispose();
    _cartBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaceState>(
        stream: _bloc.controller,
        builder: (context, snapshot) {
          bool isLoading =
              snapshot.data?.isLoading ?? false || !snapshot.hasData;

          bool hasError = snapshot.data?.hasError ?? false;

          Place? place = snapshot.data?.data?.first;
          bool doNotLoadBody = isLoading || hasError || place == null;
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: doNotLoadBody ? AppBar() : null,
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : hasError
                      ? MyErrorComponent(
                          onRefresh: () {
                            _bloc.getPlaceById(widget.place.id);
                          },
                        )
                      : doNotLoadBody
                          ? const MyNoDataComponent()
                          : Listener(
                              onPointerUp: (event) {
                                RenderBox? box = _backKey.currentContext
                                    ?.findRenderObject() as RenderBox;
                                Offset boxOffset =
                                    box.globalToLocal(event.position);

                                // Detect if box has been hit
                                if (box.hitTest(result, position: boxOffset)) {
                                  RenderBox? notBackBox = _notBackKey
                                      .currentContext
                                      ?.findRenderObject() as RenderBox;

                                  Offset notBackBoxOffset =
                                      notBackBox.globalToLocal(event.position);

                                  if (!notBackBox.hitTest(result,
                                      position: notBackBoxOffset)) {
                                    Navigator.pop(context);
                                  }
                                  // Detect if container is on top of the back button
                                }
                              },
                              child: Stack(
                                children: [
                                  _buildPlacePicture(place),
                                  _buildPlaceDetail(place),
                                ],
                              ),
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
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56, minWidth: 160),
            child: ElevatedButton(
              onPressed: () async {
                bool? proceed = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => QuantityBottomSheet(
                        selectedQuantity: _selectedQuantity, place: place));

                if ((_selectedQuantity.valueOrNull ?? 0) <= 0 ||
                    proceed == null ||
                    !proceed) {
                  _selectedQuantity.add(0);
                  return;
                }

                if (!mounted) return;
                showDialog(
                    context: context,
                    builder: (context) => const MyLoadingDialog());

                AppError? error = await _cartBloc.addToCart(
                    place.id, _selectedQuantity.value);

                // Pop Loading Dialog
                if (!mounted) return;
                Navigator.pop(context);

                if (error != null) {
                  showMySnackBar(context, error.message, SnackbarStatus.failed);
                  return;
                }

                showMySnackBar(
                    context, "succesfullyAddedToCart", SnackbarStatus.success);
                _selectedQuantity.add(0);
              },
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(10),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20)),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onPrimary),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
          height: 300,
        ),
        Positioned(
          top: 28,
          left: 6,
          child: CustomPaint(
            key: _backKey,
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
        ),
      ],
    );
  }

  Widget _buildPlaceDetail(Place place) {
    return RefreshIndicator(
      onRefresh: () async {
        _bloc.getPlaceById(widget.place.id);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 200,
            ),
            Container(
              key: _notBackKey,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
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
                      PlaceDetailChip(
                          label:
                              PlaceCategoryUtil.readCategory(place.category)),
                      const SizedBox(
                        width: 10,
                      ),
                      PlaceReviewStar(reviewCount: place.reviewAverage),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      StreamBuilder<WishlistState>(
                          stream: _wishlistBloc.controller,
                          builder: (context, snapshot) {
                            bool isAdded =
                                snapshot.data?.places?.isNotEmpty ?? false;
                            return IconButton(
                                onPressed: () {
                                  if (isAdded) {
                                    _wishlistBloc.removeFromWishlist(place.id);
                                    return;
                                  }
                                  _wishlistBloc.addToWishlist(place.id);
                                },
                                icon: isAdded
                                    ? SvgPicture.asset(
                                        "assets/svg/saved_icon.svg",
                                        width: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : SvgPicture.asset(
                                        "assets/svg/wishlist_icon.svg",
                                        width: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ));
                          })
                    ],
                  ),
                  Divider(
                    height: 50,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
                  Text(
                    place.description,
                    style: Theme.of(context).textTheme.bodyLarge,
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
                    PlaceReviewStar(reviewCount: reviews[index].rating),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(reviews[index].review),
                  ],
                ),
              ));
        });
  }
}
