import "package:travellingo/component/change_language_component.dart";
import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:travellingo/component/change_theme_component.dart";
import "package:travellingo/pages/login/widget/login_form.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return const Center(
        child: SizedBox(
          width: 500,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    scrolledUnderElevation: 0,
                    centerTitle: true,
                    actions: [
                      ChangeThemeSwitchComponent(),
                      SizedBox(
                        width: 10,
                      ),
                      ChangeLanguageComponent(),
                    ],
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate.fixed([
                    LoginForm(),
                  ]))
                ],
              )),
        ),
      );
    });
  }
}
