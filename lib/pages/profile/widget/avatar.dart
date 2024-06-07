import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';

class BorderedAvatar extends StatefulWidget {
  final String? content;
  const BorderedAvatar({super.key, required this.content});

  @override
  State<BorderedAvatar> createState() => _BorderedAvatarState();
}

class _BorderedAvatarState extends State<BorderedAvatar> {
  final _pickedImage = BehaviorSubject<File?>();
  late UserBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<UserBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: StreamBuilder<File?>(
          stream: _pickedImage,
          builder: (context, snapshot) {
            bool hasImage = snapshot.hasData;
            return InkWell(
              onTap: hasImage
                  ? () async {
                      String base64Image =
                          base64Encode(snapshot.data!.readAsBytesSync());
                      await _bloc.changePicture(base64Image);
                    }
                  : _pickImage,
              borderRadius: BorderRadius.circular(90),
              child: Badge(
                  alignment: Alignment.bottomRight,
                  smallSize: 34,
                  backgroundColor: Colors.yellow,
                  label: hasImage
                      ? const Icon(Icons.check, color: Colors.white)
                      : const Icon(Icons.edit, color: Colors.white),
                  largeSize: 30,
                  child: DottedBorder(
                      strokeWidth: 3,
                      color: const Color(0xFFF6F8FB),
                      dashPattern: const [9, 7],
                      borderType: BorderType.Circle,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: hasImage
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor: const Color(0xFFF6F8FB),
                                backgroundImage: FileImage(snapshot.data!),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: const Color(0xFFF6F8FB),
                                backgroundImage: widget.content != ""
                                    ? MemoryImage(base64Decode(widget.content!))
                                    : null,
                              ),
                      ))),
            );
          }),
    );
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImage != null) {
      _pickedImage.add(File(pickedImage.path));
    }
  }
}
