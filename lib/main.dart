import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/pages/dashboard_page.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/splash_page.dart';
import 'package:travellingo/utils/locales/locale.dart';
import 'package:travellingo/utils/store.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // dotenv
  await dotenv.load(fileName: ".env");

  if (kDebugMode) {
    print('BASE_URL: ${dotenv.env['BASE_URL']}');
  }

  // AUTH BLOC
  final authBloc = AuthBloc();

  await authBloc.checkLogin();

  FlutterNativeSplash.remove();

  Widget app = MultiProvider(
    providers: [
      Provider<AuthBloc>.value(
        value: authBloc,
      ),
      Provider<String>.value(
        value: await Store.getLanguage() ?? 'en',
      )
    ],
    child: const MyApp(),
  );

  runApp(app);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final localization = FlutterLocalization.instance;

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.en),
        const MapLocale('id', AppLocale.id),
      ],
      initLanguageCode: context.read<String>(),
    );
    localization.onTranslatedLanguage = (locale) async {
      if (kDebugMode) {
        print('Language has been changed to $locale');
      }
      await Store.saveLanguage(locale!.languageCode);
      setState(() {});
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();
    return MaterialApp(
        navigatorKey: navigatorKey,
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        title: 'Travellingo',
        theme: lightTheme,
        home: StreamBuilder<AuthState>(
            stream: authBloc.controller.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SplashPage();
              }

              return const DashboardPage();
            }));
  }
}
