import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';

class ChooseImageSource extends StatelessWidget {
  const ChooseImageSource({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        ListTile(
          leading: const Icon(Icons.camera),
          title: Text('camera'.getString(context)),
          onTap: () {
            Navigator.pop(context, ImageSource.camera);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo),
          title: Text('gallery'.getString(context)),
          onTap: () {
            Navigator.pop(context, ImageSource.gallery);
          },
        ),
        ListTile(
          leading: const Icon(Icons.close),
          title: Text('cancel'.getString(context)),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
