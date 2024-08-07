import 'package:travellingo/component/change_language_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/change_theme_component.dart';
import 'package:travellingo/component/my_oauth_button.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/pages/sign_up/setup_page.dart';
import 'package:travellingo/pages/login/login_page.dart';
import 'package:travellingo/pages/sign_up/widgets/text_label.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  final globalKey = GlobalKey<FormState>();
  final email = TextEditingController();
  var isError = false;
  final emailregex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  scrolledUnderElevation: 0,
                  centerTitle: true,
                  actions: [
                    ChangeThemeSwitchComponent(),
                    SizedBox(
                      width: 10,
                    ),
                    ChangeLanguageComponent()
                  ],
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    width: 500,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: globalKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child:
                                      Image.asset("assets/images/Signup.png")),
                              const SizedBox(
                                height: 40,
                              ),
                              const TextLabel(content: "email"),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "fieldmustbefilled"
                                        .getString(context);
                                  }
                                  if (!emailregex.hasMatch(value)) {
                                    return "emailformatwrong"
                                        .getString(context);
                                  }
                                  return null;
                                },
                                controller: email,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z@.0-9]'))
                                ],
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.account_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                                style: const TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (globalKey.currentState?.validate() ??
                                        false) {
                                      Navigator.push(
                                        context,
                                        slideInFromRight(
                                          SetUpPage(email: email.text),
                                        ),
                                      );
                                      isError = false;
                                    } else {
                                      showMySnackBar(
                                          context, "textFieldNotValid");
                                    }
                                  },
                                  style: const ButtonStyle(
                                      minimumSize: WidgetStatePropertyAll(
                                          Size(double.infinity, 52)),
                                      backgroundColor: WidgetStatePropertyAll(
                                          Color(0xFFF5D161)),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16))))),
                                  child: Text(
                                    "signup".getString(context),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1),
                                    textScaler: const TextScaler.linear(1.1),
                                  )),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(children: [
                                Expanded(
                                    child: Container(
                                  height: 2,
                                  color: const Color(0xFFF6F8FB),
                                )),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                        "orsignupwith"
                                            .getString(context)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textScaler:
                                            const TextScaler.linear(1.1))),
                                Expanded(
                                    child: Container(
                                  height: 2,
                                  color: const Color(0xFFF6F8FB),
                                )),
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OAuthButtonComponent(content: "Facebook.png"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  OAuthButtonComponent(content: "Google.png"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  OAuthButtonComponent(content: "Apple.png")
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("alreadyhaveaccount"
                                        .getString(context)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage()));
                                        },
                                        child: Text("signin".getString(context),
                                            style: const TextStyle(
                                                color: Color(0xFFF5D161))))
                                  ])
                            ]),
                      ),
                    ),
                  )
                ]))
              ],
            )),
      ),
    );
  }
}
