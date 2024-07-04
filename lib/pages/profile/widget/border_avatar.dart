import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/component/choose_image_source.dart';
import 'package:travellingo/component/my_confirmation_dialog.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

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
                      bool? showConfirmationDialog = await showDialog(
                        context: context,
                        builder: (context) => MyConfirmationDialog(
                            label: "${"saveImage".getString(context)}?",
                            positiveLabel: "Yes",
                            negativeLabel: "Cancel"),
                      );

                      if (showConfirmationDialog == null ||
                          !showConfirmationDialog) return;

                      String base64Image =
                          base64Encode(snapshot.data!.readAsBytesSync());
                      await _bloc.changePicture(base64Image);
                    }
                  : _pickImage,
              borderRadius: BorderRadius.circular(90),
              child: Stack(
                children: [
                  DottedBorder(
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
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: colorScheme.secondary),
                        width: 30,
                        height: 30,
                        child: hasImage
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            : SvgPicture.asset(
                                "assets/svg/edit_icon.svg",
                                color: Colors.white,
                              )),
                  )
                ],
              ),
            );
          }),
    );
  }

  void _pickImage() async {
    ImageSource? source = await showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.surface,
        useSafeArea: true,
        context: context,
        builder: (context) => const ChooseImageSource());

    if (source == null) return;

    final pickedImage = await ImagePicker()
        .pickImage(source: source, imageQuality: 50, maxWidth: 150);

    if (pickedImage != null) {
      if (await pickedImage.length() / 1024 / 1024 > 3) {
        if (!mounted) return;
        showMySnackBar(context, "fileSizeExceeds3MB".getString(context),
            SnackbarStatus.failed);
        return;
      }
      _pickedImage.add(File(pickedImage.path));
    }
  }
}
