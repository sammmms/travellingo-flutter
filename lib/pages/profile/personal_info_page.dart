import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/models/user.dart';
import 'package:travellingo/pages/profile/widget/gender_radio.dart';
import 'package:travellingo/pages/profile/widget/text_field_personal_info.dart';
import 'package:travellingo/pages/sign_in/signin_page.dart';
import 'package:travellingo/provider/change_gender_provider.dart';
import 'package:travellingo/provider/user_detail_provider.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final govId = TextEditingController();
  late String gender;
  late UserBloc bloc;

  @override
  void initState() {
    final user = context.read<UserDetailProvider>().user;

    if (user == null) {
      showMySnackBar(context, "tokenExpired".getString(context));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false);
    }
    name.text = user!.name;
    email.text = user.email;
    gender = user.gender.toString();
    phone.text = user.phone;
    govId.text = user.id ?? "";
    bloc = context.read<UserBloc>();
    super.initState();
  }

  bool isEditing = false;
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
        stream: bloc.controller.stream,
        builder: (context, snapshot) {
          if (snapshot.data?.error ?? false) {
            showMySnackBar(
                context, snapshot.data?.errorMessage ?? "somethingWrong");
          }
          if (snapshot.data?.receivedMessage != null) {
            showMySnackBar(context, snapshot.data!.receivedMessage!);
          }
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "personalInfo".getString(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                iconTheme: const IconThemeData(),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                        onTap: snapshot.data?.loading ?? false
                            ? null
                            : () async {
                                if (isEditing) {
                                  User newUpdatedProfile = User(
                                      email: email.text,
                                      name: name.text,
                                      gender: gender,
                                      id: govId.text,
                                      phone: phone.text,
                                      objectId: context
                                          .read<UserDetailProvider>()
                                          .user!
                                          .objectId,
                                      birthday: context
                                          .read<UserDetailProvider>()
                                          .user!
                                          .birthday);
                                  context
                                      .read<UserDetailProvider>()
                                      .updateUser(newUpdatedProfile);
                                  await bloc.updateUser(newUpdatedProfile);
                                  await bloc.getUser();
                                }
                                isEditing = !isEditing;
                                setState(() {});
                              },
                        child: snapshot.data?.loading ?? false
                            ? const CircularProgressIndicator()
                            : Text(
                                isEditing
                                    ? "save".getString(context)
                                    : "edit".getString(context),
                                style: const TextStyle(
                                    color: Color(0xFFF5D161),
                                    fontWeight: FontWeight.bold),
                              )),
                  )
                ],
              ),
              body: StreamBuilder(
                  stream: null,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
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
                            ChangeNotifierProvider<ChangeGenderProvider>(
                              create: (context) =>
                                  ChangeGenderProvider(currentGender: gender),
                              child: GenderRadio(
                                onChangeFunction: changeGender,
                                isEditing: isEditing,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }));
        });
  }

  void changeGender(String newGender) {
    gender = newGender;
    setState(() {});
  }
}
