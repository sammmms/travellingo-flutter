import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/user.dart';
import 'package:travellingo/pages/profile/widget/gender_radio.dart';
import 'package:travellingo/pages/profile/widget/text_field_personal_info.dart';
import 'package:travellingo/pages/login/login_page.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final govId = TextEditingController();
  final gender = BehaviorSubject<String>();
  late UserBloc bloc;

  @override
  void initState() {
    bloc = context.read<UserBloc>();
    final user = bloc.controller.value.receivedProfile;

    if (user == null) {
      showMySnackBar(context, "tokenExpired".getString(context));
      Navigator.of(context).pushAndRemoveUntil(
          slideInFromBottom(const LoginPage()), (route) => false);
    }
    name.text = user!.name;
    email.text = user.email;
    gender.add(user.gender ?? "");
    phone.text = user.phone;
    govId.text = user.id ?? "";
    super.initState();
  }

  bool isEditing = false;
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    govId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "personalInfo".getString(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              iconTheme: const IconThemeData(),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: StreamBuilder<UserState>(
                      stream: bloc.controller,
                      builder: (context, snapshot) {
                        bool isLoading = snapshot.data?.isLoading ?? false;
                        return GestureDetector(
                            onTap: isLoading
                                ? null
                                : () async {
                                    if (isEditing) {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        _updatingUser();
                                      }
                                    }
                                    isEditing = !isEditing;
                                    setState(() {});
                                  },
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    isEditing
                                        ? "save".getString(context)
                                        : "edit".getString(context),
                                    style: const TextStyle(
                                        color: Color(0xFFF5D161),
                                        fontWeight: FontWeight.bold),
                                  ));
                      }),
                )
              ],
            ),
            body: StreamBuilder(
                stream: null,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldPersonalInfo(
                                content: "name",
                                controller: name,
                                validator: (value) {
                                  if (value == "") {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                isEnabled: isEditing),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldPersonalInfo(
                                content: "email",
                                controller: email,
                                validator: (value) {
                                  if (value == "") {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  if (!emailRegex.hasMatch(value!)) {
                                    return "emailformatwrong"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                isEnabled: isEditing),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldPersonalInfo(
                                content: "phoneNumber",
                                controller: phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value == "") {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  if (!RegExp(r'\d{5,}').hasMatch(value!)) {
                                    return "phoneformatwrong"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                isEnabled: isEditing),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldPersonalInfo(
                                content: "govId",
                                controller: govId,
                                validator: (value) {
                                  if (value == "") {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                isEnabled: isEditing),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "gender".getString(context).toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            GenderRadio(
                              gender: gender,
                              isEditing: isEditing,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }

  void _updatingUser() async {
    User lateUser = bloc.controller.value.receivedProfile!;
    User newUpdatedProfile = lateUser.copyWith(
        name: name.text,
        email: email.text,
        phone: phone.text,
        id: govId.text,
        gender: gender.value);
    var error = await bloc.updateUser(newUpdatedProfile);

    if (!mounted) return;

    if (error == null) {
      showMySnackBar(context, "profileUpdated");
      return;
    }

    showMySnackBar(context, error.message, SnackbarStatus.failed);
  }
}
