import 'package:flutter/material.dart';
import 'package:travellingo/bloc/place/place_bloc.dart';
import 'package:travellingo/bloc/place/place_state.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/component/picture_loader_component.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/models/place.dart';

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
          bool isLoading = snapshot.data?.isLoading ?? false;

          bool hasError = snapshot.data?.hasError ?? false;

          Place? place = snapshot.data?.data?.first;
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.place.name),
              ),
              body: Builder(builder: (context) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (hasError) {
                  return MyErrorComponent(
                    onRefresh: () {
                      bloc.getPlaceById(widget.place.id);
                    },
                  );
                }

                if (place == null) {
                  return const MyNoDataComponent();
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyImageLoader(
                          url: place.pictureLink,
                          pictureType: place.pictureType),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(place.name,
                          style: Theme.of(context).textTheme.headlineLarge),
                    ],
                  ),
                );
              }));
        });
  }
}
