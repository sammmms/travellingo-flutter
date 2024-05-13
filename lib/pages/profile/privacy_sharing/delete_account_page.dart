import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/country_code_list.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  String? livingLocation;
  final reason = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("requestPersonalData".getString(context)),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: 500,
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "deleteAccountDetail".getString(context),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 128, 128, 128),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 248, 251),
                      border: Border.all(
                          color: const Color.fromARGB(15, 1, 34, 118),
                          width: 2),
                      borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    children: [
                      Text(
                        "whereDoYouLive".getString(context).toUpperCase(),
                        style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 11,
                            color: Color.fromARGB(255, 128, 128, 128),
                            fontWeight: FontWeight.bold),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                            padding: const EdgeInsets.only(top: 18),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            iconEnabledColor:
                                const Color.fromARGB(255, 245, 209, 97),
                            isExpanded: true,
                            menuMaxHeight: 400,
                            dropdownColor:
                                const Color.fromARGB(255, 246, 248, 251),
                            isDense: true,
                            borderRadius: BorderRadius.circular(16),
                            value: livingLocation,
                            items: countries
                                .map((country) => DropdownMenuItem(
                                    value: country.toLowerCase(),
                                    child: Text(
                                      country,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 27, 20, 70),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                livingLocation = value;
                              });
                            }),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "whyAreYouDeletingYourAccount".getString(context),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 27, 20, 70),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(children: [
                  SizedBox(
                      height: 150,
                      child: TextFormField(
                        controller: reason,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            counterText: "",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(15, 1, 34, 118),
                                    width: 2)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(15, 1, 34, 118),
                                    width: 2))),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 128, 128, 128),
                        ),
                        maxLength: 150,
                        textAlignVertical: TextAlignVertical.top,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                      )),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: Text(
                        "${reason.text.length}/150",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 128, 128, 128)),
                      )),
                ]),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            side: const MaterialStatePropertyAll(BorderSide(
                                color: Color.fromRGBO(7, 104, 253, 0.1)))),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            Text(
                              "deleteAccount".getString(context),
                              style: const TextStyle(color: Colors.redAccent),
                            )
                          ],
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
