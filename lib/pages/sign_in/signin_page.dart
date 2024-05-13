import "package:travellingo/component/change_language_component.dart";
import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:travellingo/pages/sign_in/sign_in_form.dart";

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "changeLanguage".getString(context),
              style: const TextStyle(color: Colors.black26),
            ),
            scrolledUnderElevation: 0,
            centerTitle: true,
            actions: const [ChangeLanguageComponent()],
          ),
          const SliverList(
              delegate: SliverChildListDelegate.fixed([
            SignInForm(),
          ]))
        ],
      ));
    });
  }
}
