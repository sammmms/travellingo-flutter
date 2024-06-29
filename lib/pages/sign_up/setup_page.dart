import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/pages/sign_up/widgets/text_label.dart';
import 'package:travellingo/utils/country_code_list.dart';

class SetUpPage extends StatefulWidget {
  final String email;
  const SetUpPage({super.key, required this.email});

  @override
  State<SetUpPage> createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final confirmEmail = TextEditingController();
  final currentNumber = TextEditingController();
  final password = TextEditingController();
  final birthday = TextEditingController(text: "2000-01-01");
  late AuthBloc authBloc;
  String currentCountry = "62";
  bool isObstructed = true;
  bool isAgreeing = false;
  String numberError = "";
  final globalKey = GlobalKey<FormState>();
  final emailregex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    confirmEmail.dispose();
    currentNumber.dispose();
    password.dispose();
    birthday.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: 500,
      height: MediaQuery.of(context).size.height,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "setupyouraccount".getString(context).toUpperCase(),
            ),
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFFF5D161)),
            foregroundColor: const Color(0xFF1B1446),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: globalKey,
                  child: StreamBuilder<AuthState>(
                      stream: authBloc.controller.stream,
                      builder: (context, snapshot) {
                        AuthState authState = snapshot.data ?? AuthState();
                        bool isAuthenticating = authState.isAuthenticating;

                        if (isAuthenticating) {
                          showMySnackBar(context, "pleaseWait");
                        }

                        //Interface
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //First Name Section
                            const TextLabel(content: "firstName"),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                                enabled: !isAuthenticating,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                controller: firstName,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z ]')),
                                ],
                                style: const TextStyle(
                                    color: Color(0xFF1B1446),
                                    letterSpacing: 1.1)),
                            const SizedBox(
                              height: 20,
                            ),

                            // Last Name Section
                            const TextLabel(content: "lastName"),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                                enabled: !isAuthenticating,
                                controller: lastName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z ]')),
                                ],
                                style: const TextStyle(
                                    color: Color(0xFF1B1446),
                                    letterSpacing: 1.1)),
                            const SizedBox(
                              height: 20,
                            ),

                            // Email Section
                            const TextLabel(content: "email"),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                                decoration: InputDecoration(
                                  enabled: false,
                                  hintText: widget.email,
                                  fillColor: const Color(0xFFF6F8FB),
                                ),
                                style: const TextStyle(
                                    color: Color(0xFF1B1446),
                                    letterSpacing: 1.1)),
                            const SizedBox(
                              height: 20,
                            ),

                            // Confirm Email Section
                            const TextLabel(content: "confirmEmail"),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                                enabled: !isAuthenticating,
                                controller: confirmEmail,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  if (!emailregex.hasMatch(value)) {
                                    return "emailformatwrong"
                                        .getString(context);
                                  }
                                  if (value != widget.email) {
                                    return "emailisdifferent"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z@.0-9]'))
                                ],
                                style: const TextStyle(
                                    color: Color(0xFF1B1446),
                                    letterSpacing: 1.1)),
                            const SizedBox(
                              height: 20,
                            ),

                            // Phone Number Section
                            const TextLabel(content: "phoneNumber"),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 60,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          canvasColor: const Color.fromRGBO(
                                              246, 248, 251, 1)),
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color(0xFFF6F8FB),
                                        ),
                                        child: Center(
                                          child: DropdownButton(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              value: currentCountry,
                                              isExpanded: true,
                                              iconEnabledColor:
                                                  const Color(0xFF0768FD),
                                              dropdownColor: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              underline: Container(
                                                  color: Colors.transparent),
                                              items: listCountry.keys.map<
                                                      DropdownMenuItem<String>>(
                                                  (items) {
                                                return DropdownMenuItem(
                                                  value: listCountry[items]
                                                      .toString(),
                                                  child: Row(
                                                    children: [
                                                      Text(listCountry[items]
                                                          .toString()),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Image.asset(
                                                        "assets/$items.png",
                                                        height: 23,
                                                        width: 18,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: isAuthenticating
                                                  ? null
                                                  : (value) {
                                                      setState(() {
                                                        currentCountry =
                                                            value.toString();
                                                      });
                                                    }),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        minLines: null,
                                        maxLines: null,
                                        expands: true,
                                        enabled: !isAuthenticating,
                                        controller: currentNumber,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value == "") {
                                            numberError = "fieldmustbefilled";
                                            return null;
                                          }
                                          if (value.length < 6) {
                                            numberError = "phoneformatwrong";
                                            return null;
                                          }
                                          numberError = "";
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(11),
                                        ],
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF6F8FB),
                                            prefix: Text(
                                              "$currentCountry - ",
                                            )),
                                      ),
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (numberError != "")
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  numberError.getString(context),
                                  style: TextStyle(
                                      color: Colors.red.shade900, fontSize: 12),
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),

                            // Birthday Section
                            const TextLabel(content: "birthday"),
                            const SizedBox(
                              height: 10,
                            ),

                            GestureDetector(
                              onTap: isAuthenticating
                                  ? null
                                  : () {
                                      showDatePicker(
                                              initialDate:
                                                  DateTime.parse(birthday.text),
                                              context: context,
                                              firstDate: DateTime(1950),
                                              lastDate: DateTime.now())
                                          .then((value) {
                                        if (value == null ||
                                            value.toString() == "") {
                                          return;
                                        }
                                        birthday.text =
                                            value.toString().split(' ')[0];
                                      });
                                    },
                              child: TextFormField(
                                enabled: false,
                                controller: birthday,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(Icons.calendar_month),
                                    ),
                                    suffixIconColor: Color(0xFFF5D161)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            // Password section
                            const TextLabel(content: "password"),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                                enabled: !isAuthenticating,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  if (value.length < 8) {
                                    return "passwordformatwrong"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                controller: password,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF6F8FB),
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isObstructed = !isObstructed;
                                          });
                                        },
                                        overlayColor:
                                            const WidgetStatePropertyAll(
                                                Colors.transparent),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: isObstructed
                                              ? const Icon(Icons.visibility,
                                                  color: Color(0xFFF5D161))
                                              : const Icon(Icons.visibility_off,
                                                  color: Color(0xFFF5D161)),
                                        ))),
                                obscureText: isObstructed,
                                style: const TextStyle(
                                    color: Color(0xFF1B1446),
                                    letterSpacing: 1.1)),
                            const SizedBox(
                              height: 20,
                            ),

                            // Terms and Agreement Section
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: isAgreeing,
                                      onChanged: (value) {
                                        setState(() {
                                          isAgreeing = !isAgreeing;
                                        });
                                      },
                                      shape: const CircleBorder(),
                                      fillColor: const WidgetStatePropertyAll(
                                          Colors.transparent),
                                      checkColor: const Color(0xFFF5D161),
                                      side: WidgetStateBorderSide.resolveWith(
                                          (states) => const BorderSide(
                                              width: 2.0,
                                              color: Color.fromARGB(
                                                  255, 245, 209, 97)))),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isAgreeing = !isAgreeing;
                                      });
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "travellingoterms"
                                                .getString(context),
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1B1446)),
                                            textScaler:
                                                const TextScaler.linear(1.1),
                                          ),
                                          if (!isAgreeing)
                                            Text(
                                              "termsagree".getString(context),
                                              style: const TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 10),
                                            )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                            const SizedBox(
                              height: 40,
                            ),

                            // Continue button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  onPressed: isAuthenticating
                                      ? null
                                      : () async {
                                          if (globalKey.currentState!
                                                  .validate() ==
                                              false) {
                                            return;
                                          }
                                          if (!isAgreeing) {
                                            showMySnackBar(
                                                context, "termsAgree");
                                            return;
                                          }
                                          String fullName =
                                              "${firstName.text} ${lastName.text}";
                                          await authBloc.register(
                                              context,
                                              fullName,
                                              widget.email,
                                              password.text,
                                              birthday.text,
                                              "$currentCountry${currentNumber.text}");
                                        },
                                  child: isAuthenticating
                                      ? Text("pleaseWait".getString(context),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              letterSpacing: 1.1),
                                          textScaler:
                                              const TextScaler.linear(1.1))
                                      : Text("continue".getString(context),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              letterSpacing: 1.1),
                                          textScaler:
                                              const TextScaler.linear(1.1))),
                            )
                          ],
                        );
                      }),
                ),
              ),
            ),
          ]))
        ],
      ),
    ));
  }
}
