import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:rxdart/rxdart.dart';

class GenderRadio extends StatefulWidget {
  final BehaviorSubject<String> gender;
  final bool isEditing;
  const GenderRadio({super.key, required this.isEditing, required this.gender});

  @override
  State<GenderRadio> createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.gender,
        initialData: "",
        builder: (context, snapshot) {
          String choosenData = snapshot.data!;
          return Column(
            children: [
              GestureDetector(
                onTap: () => onCall("male"),
                child: Row(
                  children: [
                    Radio(
                        value: "male",
                        groupValue: choosenData,
                        onChanged: widget.isEditing ? onCall : null),
                    Expanded(child: Text("male".getString(context))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onCall('female'),
                child: Row(
                  children: [
                    Radio(
                        value: "female",
                        groupValue: choosenData,
                        onChanged: widget.isEditing ? onCall : null),
                    Expanded(child: Text("female".getString(context))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onCall(''),
                child: Row(
                  children: [
                    Radio(
                        value: "",
                        groupValue: choosenData,
                        onChanged: widget.isEditing ? onCall : null),
                    Expanded(child: Text("notSet".getString(context))),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void onCall(String? value) {
    if (widget.isEditing) {
      widget.gender.add(value!);
    }
  }
}
