import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/models/user.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/pages/profile/appearance/appearance_page.dart';
import 'package:travellingo/pages/profile/personal_info_page.dart';
import 'package:travellingo/bloc/preferences/reset_preferences.dart';
import 'package:travellingo/pages/profile/privacy_sharing/privacy_sharing_page.dart';
import 'package:travellingo/pages/profile/widget/avatar.dart';
import 'package:travellingo/pages/profile/widget/text_navigator.dart';
import 'package:travellingo/provider/user_detail_provider.dart';
import 'package:travellingo/pages/sign_in/signin_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bloc = UserBloc();

  @override
  void initState() {
    bloc.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "profile".getString(context),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          scrolledUnderElevation: 0,
        ),
        body: StreamBuilder<UserState>(
            stream: bloc.controller.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || (snapshot.data?.loading ?? false)) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(child: CircularProgressIndicator()));
              }
              if (snapshot.data!.error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showMySnackBar(
                      context, snapshot.data?.errorMessage ?? "somethingWrong");
                });
              }

              if (snapshot.data?.receivedProfile == null) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(child: CircularProgressIndicator()));
              }
              User data = snapshot.data!.receivedProfile!;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<UserDetailProvider>(context, listen: false)
                    .updateUser(data);
              });
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BorderedAvatar(content: data.pictureLink),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                data.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                textScaler: const TextScaler.linear(1.1),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(data.email)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "account".getString(context).toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, letterSpacing: 1),
                            textScaler: const TextScaler.linear(0.9),
                          ),
                        ),
                        TextNavigator(
                          needIcon: true,
                          onTapFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Provider<UserBloc>.value(
                                    value: bloc,
                                    child: const PersonalInfoPage())));
                          },
                          text: "personalInfo",
                        ),
                        TextNavigator(
                          needIcon: true,
                          onTapFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacySharingPage()));
                          },
                          text: "privacyNSharing",
                        ),
                        const Divider(
                          height: 1,
                          color: Color(0xFFF6F8FB),
                          indent: 20,
                          endIndent: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "settings".getString(context).toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, letterSpacing: 1),
                            textScaler: const TextScaler.linear(0.9),
                          ),
                        ),
                        TextNavigator(
                          onTapFunction: () {},
                          text: "notification",
                          needIcon: true,
                        ),
                        TextNavigator(
                          onTapFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AppearancePage()));
                          },
                          text: "appearance",
                          needIcon: true,
                        ),
                        TextNavigator(
                          onTapFunction: () {},
                          text: "purchaseHistory",
                        ),
                        TextNavigator(
                          onTapFunction: () {},
                          text: "review",
                        ),
                        TextNavigator(
                          onTapFunction: () {
                            context.read<UserDetailProvider>().user = null;
                            ResetPreferences.removeToken();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage()),
                                (route) => false);
                          },
                          text: "logout",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ]),
                ),
              );
            }));
  }
}
