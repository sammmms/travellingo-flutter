import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travellingo/bloc/auth_bloc/auth_bloc.dart';
import 'package:travellingo/bloc/auth_bloc/auth_state.dart';
import 'package:travellingo/component/check_component.dart';
import 'package:travellingo/component/oauth_button_component.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/pages/home/home_page.dart';
import 'package:travellingo/pages/main_page.dart';
import 'package:travellingo/pages/sign_up/signup_page.dart';
import 'package:travellingo/pages/sign_in/widget/authentication_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final bloc = AuthBloc();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final emailregex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool _isObscured = true;
  bool _biometrics = false;
  bool _haveLoggedIn = false;
  final auth = LocalAuthentication();

  final _isTicked = BehaviorSubject<bool>();

  BiometricType? _biometricType;
  final globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      email.text = value.getString('email') ?? "";
      password.text = value.getString('password') ?? "";
      _isTicked.add(value.getBool('isTicked') ?? false);
      _haveLoggedIn = value.getBool('haveLoggedIn') ?? false;
    });
    auth.getAvailableBiometrics().then((value) {
      if (value.contains(BiometricType.strong)) {
        _biometrics = true;
        _biometricType = BiometricType.fingerprint;
        setState(() {});
      }
      if (value.contains(BiometricType.face)) {
        _biometrics = true;
        _biometricType = BiometricType.face;
        setState(() {});
      }
      if (value.contains(BiometricType.fingerprint)) {
        _biometrics = true;
        _biometricType = BiometricType.fingerprint;
        setState(() {});
      }
    }).catchError((error) {
      debugPrint(error.toString());
    });

    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    bloc.controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
      value: _isTicked,
      initialData: _isTicked.hasValue ? _isTicked.value : false,
      child: Builder(builder: (context) {
        //Builder is used to differentiate the context of provider
        return Center(
          child: Container(
            width: 500,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/Signin.png'),
                    width: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  StreamBuilder<AuthState>(
                      stream: bloc.controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data?.receivedToken?.isNotEmpty ?? false) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()),
                                (route) => false);
                          });
                        }
                        if (snapshot.data?.error ?? false) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showMySnackBar(
                                context,
                                snapshot.data?.errorMessage ??
                                    "somethingWrong");
                          });
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("email".getString(context),
                                style: const TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B1446)),
                                textScaler: const TextScaler.linear(1.1)),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: email,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "fieldmustbefilled".getString(context);
                                }
                                if (!emailregex.hasMatch(value)) {
                                  return "emailformatwrong".getString(context);
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z@.0-9]'))
                              ],
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  color: !(snapshot.data?.isSubmitting ?? false)
                                      ? const Color(0xFF1B1446)
                                      : Colors.grey,
                                  fontSize: 14,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                enabled:
                                    !(snapshot.data?.isSubmitting ?? false),
                                prefixIcon: const Icon(
                                  Icons.account_circle,
                                  color: Color.fromARGB(255, 62, 132, 168),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text("password".getString(context),
                                style: const TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B1446)),
                                textScaler: const TextScaler.linear(1.1)),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: password,
                              style: TextStyle(
                                  color: !(snapshot.data?.isSubmitting ?? false)
                                      ? const Color(0xFF1B1446)
                                      : Colors.grey,
                                  fontSize: 14,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                enabled:
                                    !(snapshot.data?.isSubmitting ?? false),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 62, 132, 168),
                                ),
                                suffixIcon: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Icon(
                                      _isObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color.fromARGB(
                                          255, 245, 209, 97),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isObscured = !_isObscured;
                                      });
                                    }),
                              ),
                              obscureText: _isObscured,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                CircleCheckboxComponent(
                                  onClickFunction: changeRememberMeState,
                                ),
                                InkWell(
                                    onTap: () {
                                      changeRememberMeState();
                                    },
                                    overlayColor:
                                        const MaterialStatePropertyAll(
                                            Colors.transparent),
                                    child: Text(
                                      "rememberme".getString(context),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 245, 209, 97)),
                                      textScaler: const TextScaler.linear(1.1),
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                      onPressed:
                                          snapshot.data?.isSubmitting ?? false
                                              ? null
                                              : () async {
                                                  await bloc.signIn(
                                                      context,
                                                      email.text,
                                                      password.text);
                                                },
                                      style: ButtonStyle(
                                          fixedSize:
                                              const MaterialStatePropertyAll(
                                            Size.fromHeight(52),
                                          ),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ))),
                                      child: snapshot.data?.isSubmitting ??
                                              false
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              "signin".getString(context),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.1),
                                              textScaler:
                                                  const TextScaler.linear(1.1),
                                            )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (_biometrics == true &&
                                    _haveLoggedIn == true)
                                  AuthenticationButton(
                                      biometricType: _biometricType,
                                      handleBiometrics: handleBiometrics)
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(
                    height: 40,
                  ),

                  // SIGN IN LABEL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                        height: 2,
                        color: const Color(0xFFF6F8FB),
                      )),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "orsigninwith".getString(context).toUpperCase(),
                            style: const TextStyle(
                                fontSize: 9,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xAA1B1446)),
                            textScaler: const TextScaler.linear(1.1),
                          )),
                      Expanded(
                          child: Container(
                        height: 2,
                        color: const Color(0xFFF6F8FB),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // OTHER CHOICE TO SIGN IN
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

                  // ROUTE TO REGISTER
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "donthaveaccount".getString(context),
                      style: const TextStyle(color: Colors.black26),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                        child: Text(
                          "signup".getString(context),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 245, 209, 97),
                          ),
                        ))
                  ])
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void changeRememberMeState() {
    _isTicked.add(!_isTicked.value);
  }

  void handleBiometrics(context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!context.mounted) return;
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: "authenticateToLogin".getString(context));
      if (didAuthenticate) {
        if (context.mounted) {
          await bloc.signIn(context, prefs.getString('email_authenticate')!,
              prefs.getString('password_authenticate')!);
        }
      }
    } on PlatformException {
      if (!context.mounted) return;
      showMySnackBar(context, "somethingWrongWithAuthentication");
      return;
    }
  }
}
