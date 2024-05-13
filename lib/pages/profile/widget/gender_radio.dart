import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/provider/change_gender_provider.dart';

class GenderRadio extends StatefulWidget {
  final Function(String) onChangeFunction;
  final bool isEditing;
  const GenderRadio(
      {super.key, required this.onChangeFunction, required this.isEditing});

  @override
  State<GenderRadio> createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Radio(
                value: "male",
                groupValue: context.watch<ChangeGenderProvider>().currentGender,
                onChanged: widget.isEditing ? onCall : null),
            Text("male".getString(context)),
          ],
        ),
        Row(
          children: [
            Radio(
                value: "female",
                groupValue: context.watch<ChangeGenderProvider>().currentGender,
                onChanged: widget.isEditing ? onCall : null),
            Text("female".getString(context)),
          ],
        ),
        Row(
          children: [
            Radio(
                value: "",
                groupValue: context.watch<ChangeGenderProvider>().currentGender,
                onChanged: widget.isEditing ? onCall : null),
            Text("notSet".getString(context)),
          ],
        ),
      ],
    );
  }

  void onCall(String? value) {
    widget.onChangeFunction(value!);
    context.read<ChangeGenderProvider>().changeGender(value);
  }
}
