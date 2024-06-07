import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/component/my_title.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/user.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/pages/profile/appearance/appearance_page.dart';
import 'package:travellingo/pages/profile/notifications/notifications_page.dart';
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
    return MultiProvider(
      providers: [
        Provider<UserBloc>.value(value: bloc),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "profile".getString(context),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            scrolledUnderElevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<UserState>(
                    stream: bloc.controller,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          (snapshot.data?.loading ?? false)) {
                        return const Expanded(
                            child: Center(child: CircularProgressIndicator()));
                      }
                      if (snapshot.data!.error) {
                        return Expanded(
                          child: Center(
                              child: Text("somethingWrong".getString(context))),
                        );
                      }

                      if (snapshot.data?.receivedProfile == null) {
                        return Expanded(
                          child: Center(
                              child: Text("somethingWrong".getString(context))),
                        );
                      }
                      User data = snapshot.data!.receivedProfile!;
                      // print(data.pictureLink);
                      return RefreshIndicator(
                        onRefresh: () async {
                          bloc.getUser();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      BorderedAvatar(content: data.pictureLink),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textScaler:
                                            const TextScaler.linear(1.1),
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
                                const MyTitle(title: "account"),
                                TextNavigator(
                                  needIcon: true,
                                  onTapFunction: () {
                                    Navigator.of(context).push(slideInFromRight(
                                        Provider<UserBloc>.value(
                                            value: bloc,
                                            child: const PersonalInfoPage())));
                                  },
                                  text: "personalInfo",
                                ),
                                TextNavigator(
                                  needIcon: true,
                                  onTapFunction: () {
                                    Navigator.of(context).push(slideInFromRight(
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
                                const MyTitle(title: "settings"),
                                TextNavigator(
                                  onTapFunction: () {
                                    Navigator.push(
                                        context,
                                        slideInFromRight(
                                            const NotificationPage()));
                                  },
                                  text: "notification",
                                  needIcon: true,
                                ),
                                TextNavigator(
                                  onTapFunction: () {
                                    Navigator.of(context).push(slideInFromRight(
                                        const AppearancePage()));
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
                                    context.read<UserDetailProvider>().user =
                                        null;
                                    ResetPreferences.removeToken();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        slideInFromBottom(const SignInPage()),
                                        (route) => false);
                                  },
                                  text: "logout",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ]),
                        ),
                      );
                    }),
              ],
            ),
          )),
    );
  }
}
