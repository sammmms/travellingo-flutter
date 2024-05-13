import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth_bloc/auth_bloc.dart';
import 'package:travellingo/bloc/auth_bloc/auth_state.dart';
import 'package:travellingo/pages/main_page.dart';
import 'package:travellingo/utils/locales/locale.dart';
import 'package:travellingo/pages/sign_in/signin_page.dart';
import 'package:travellingo/provider/user_detail_provider.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  AuthBloc bloc = AuthBloc();

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.en),
        const MapLocale('id', AppLocale.id),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = (locale) {
      setState(() {});
    };
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await bloc.checkLogin();
      },
    );
    FlutterNativeSplash.remove();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserDetailProvider())
        ],
        child: MaterialApp(
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            title: 'Travellingo',
            theme: lightTheme,
            home: StreamBuilder<AuthState>(
              stream: bloc.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.data?.receivedToken != null) {
                  return const MainPage();
                }
                return const SignInPage();
              },
            )));
  }
}
