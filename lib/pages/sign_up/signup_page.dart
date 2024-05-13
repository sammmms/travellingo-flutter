import 'package:travellingo/component/change_language_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/oauth_button_component.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/pages/sign_up/setup_page.dart';
import 'package:travellingo/pages/sign_in/signin_page.dart';
import 'package:travellingo/pages/sign_up/widgets/text_label.dart';

Route _createRoute(String userEmail) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SetUpPage(email: userEmail),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

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
                      Center(child: Image.asset("assets/Signup.png")),
                      const SizedBox(
                        height: 40,
                      ),
                      const TextLabel(content: "email"),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "fieldmustbefilled".getString(context);
                          }
                          if (!emailregex.hasMatch(value)) {
                            return "emailformatwrong".getString(context);
                          }
                          return null;
                        },
                        controller: email,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z@.0-9]'))
                        ],
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                          Icons.account_circle,
                          color: Color.fromARGB(255, 62, 132, 168),
                        )),
                        style: const TextStyle(
                            color: Color(0xFF1B1446),
                            fontSize: 14,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (globalKey.currentState?.validate() ?? false) {
                              Navigator.of(context)
                                  .push(_createRoute(email.text));
                              isError = false;
                            } else {
                              showMySnackBar(context, "textFieldNotValid");
                            }
                          },
                          style: const ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(
                                  Size(double.infinity, 52)),
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFF5D161)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))))),
                          child: Text(
                            "signup".getString(context),
                            style: const TextStyle(
                                color: Colors.white,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                "orsignupwith".getString(context).toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 9,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xAA1B1446)),
                                textScaler: const TextScaler.linear(1.1))),
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
                            Text("alreadyhaveaccount".getString(context),
                                style: const TextStyle(color: Colors.black26)),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInPage()));
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
    ));
  }
}
