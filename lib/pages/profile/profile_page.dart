import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/component/my_shimmer.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/pages/review/review_page.dart';
import 'package:travellingo/utils/store.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/component/my_title.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/user.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/pages/profile/appearance/appearance_page.dart';
import 'package:travellingo/pages/profile/notifications/notifications_page.dart';
import 'package:travellingo/pages/profile/personal_info_page.dart';
import 'package:travellingo/pages/profile/privacy_sharing/privacy_sharing_page.dart';
import 'package:travellingo/pages/profile/widget/border_avatar.dart';
import 'package:travellingo/pages/profile/widget/text_navigator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserBloc bloc;

  @override
  void initState() {
    bloc = context.read<UserBloc>();
    bloc.getUser();

    bloc.controller.listen((event) {
      if (event.hasError) {
        showMySnackBar(context, event.error?.message ?? "somethingWrong",
            SnackbarStatus.failed);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
                RefreshIndicator(
                  onRefresh: () async {
                    await bloc.getUser();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<UserState>(
                              stream: bloc.controller,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    (snapshot.data?.isLoading ?? false)) {
                                  return myProfileLoadingShimmer();
                                }

                                bool hasError = snapshot.data!.hasError ||
                                    snapshot.data!.receivedProfile == null;

                                if (hasError) {
                                  return _myErrorProfileShimmer();
                                }

                                User profile = snapshot.data!.receivedProfile!;

                                // print(data.pictureLink);
                                return Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      BorderedAvatar(
                                          content: profile.pictureLink),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        profile.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textScaler:
                                            const TextScaler.linear(1.1),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(profile.email)
                                    ],
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          const MyTitle(title: "account"),
                          TextNavigator(
                            needIcon: true,
                            onTapFunction: () {
                              if (bloc.controller.valueOrNull
                                      ?.receivedProfile ==
                                  null) {
                                showMySnackBar(context, "pleaseRefreshPage",
                                    SnackbarStatus.failed);
                                return;
                              }
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
                              Navigator.of(context).push(
                                  slideInFromRight(const PrivacySharingPage()));
                            },
                            text: "privacyNSharing",
                          ),
                          const Divider(
                            height: 40,
                            color: Color(0xFFF6F8FB),
                            indent: 20,
                            endIndent: 20,
                          ),
                          const MyTitle(title: "settings"),
                          TextNavigator(
                            onTapFunction: () async {
                              Map<String, UserNotificationPreference> result =
                                  await Store.getNotificationPreferences();

                              if (!context.mounted) return;
                              Navigator.push(
                                  context,
                                  slideInFromRight(NotificationPreferencesPage(
                                      specialTipsAndOffers:
                                          result['specialTipsAndOffers']!,
                                      activity: result['activity']!,
                                      reminders: result['reminders']!)));
                            },
                            text: "notification",
                            needIcon: true,
                          ),
                          TextNavigator(
                            onTapFunction: () {
                              Navigator.of(context).push(
                                  slideInFromRight(const AppearancePage()));
                            },
                            text: "appearance",
                            needIcon: true,
                          ),
                          TextNavigator(
                            onTapFunction: () {
                              Navigator.push(context,
                                  slideInFromRight(const ReviewPage()));
                            },
                            text: "review",
                          ),
                          TextNavigator(
                            onTapFunction: () async {
                              await context.read<AuthBloc>().logout();
                              await context.read<UserBloc>().resetStream();
                              if (!context.mounted) return;
                              context.read<PageController>().jumpToPage(0);
                            },
                            text: "logout",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _myErrorProfileShimmer() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: DottedBorder(
                strokeWidth: 3,
                color: const Color(0xFFF6F8FB),
                dashPattern: const [9, 7],
                borderType: BorderType.Circle,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceTint,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      )),
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "-",
            style: TextStyle(fontWeight: FontWeight.bold),
            textScaler: TextScaler.linear(1.1),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("-")
        ],
      ),
    );
  }
}
