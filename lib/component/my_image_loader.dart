import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travellingo/utils/picture_type_util.dart';

class MyImageLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final String url;
  final PictureType pictureType;
  final BoxFit fit;
  const MyImageLoader({
    super.key,
    this.width,
    this.height,
    required this.url,
    this.fit = BoxFit.cover,
    this.pictureType = PictureType.link,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const AssetImage("assets/images/placeholder.png"),
      image: pictureType == PictureType.link
          ? NetworkImage(url)
          : MemoryImage(base64Decode(url)) as ImageProvider,
      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
          "assets/images/placeholder.png",
          fit: fit,
          width: width,
          height: height),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
