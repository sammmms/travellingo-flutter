import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/pages/dashboard_page.dart';
import 'package:travellingo/utils/locales/locale.dart';
import 'package:travellingo/pages/login/login_page.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  AuthBloc authBloc = AuthBloc();

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
        await authBloc.checkLogin();
        FlutterNativeSplash.remove();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<AuthBloc>.value(value: authBloc)],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            title: 'Travellingo',
            theme: lightTheme,
            home: StreamBuilder<AuthState>(
              stream: authBloc.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.data?.receivedToken != null) {
                  return const DashboardPage();
                }
                return const SignInPage();
              },
            )));
  }
}
