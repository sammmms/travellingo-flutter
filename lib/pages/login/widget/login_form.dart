import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/component/check_component.dart';
import 'package:travellingo/component/oauth_button_component.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/pages/dashboard_page.dart';
import 'package:travellingo/pages/sign_up/register_page.dart';
import 'package:travellingo/pages/login/widget/authentication_button.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/store.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final emailregex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _isObscured = BehaviorSubject<bool>.seeded(true);
  final _biometricsAvailable = BehaviorSubject<bool>.seeded(false);
  final _isTicked = BehaviorSubject<bool>.seeded(false);
  bool _haveLoggedIn = false;

  final auth = LocalAuthentication();
  BiometricType? _biometricType;

  final globalKey = GlobalKey<FormState>();

  late AuthBloc bloc;

  @override
  void initState() {
    bloc = context.read<AuthBloc>();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Get the email from shared preferences
      Map<String, dynamic> loginPreferences = await Store.getLoginPreferences();
      if (loginPreferences["isTicked"]) {
        email.text = loginPreferences["email"];
        _haveLoggedIn = loginPreferences["haveLoggedIn"];
        _isTicked.add(true);
      }

      await _checkBiometrics();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    AuthState authState = snapshot.data ?? AuthState.initial();
                    bool isAuthenticating = authState.isAuthenticating;
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z@.0-9]'))
                          ],
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color: !isAuthenticating
                                  ? const Color(0xFF1B1446)
                                  : Colors.grey,
                              fontSize: 14,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            enabled: !isAuthenticating,
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
                        StreamBuilder<bool>(
                            stream: _isObscured,
                            initialData: false,
                            builder: (context, snapshot) {
                              bool isObscured = snapshot.data ?? false;
                              return TextFormField(
                                controller: password,
                                style: TextStyle(
                                    color: !isAuthenticating
                                        ? const Color(0xFF1B1446)
                                        : Colors.grey,
                                    fontSize: 14,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  enabled: !isAuthenticating,
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 62, 132, 168),
                                  ),
                                  suffixIcon: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Icon(
                                        isObscured
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: const Color.fromARGB(
                                            255, 245, 209, 97),
                                      ),
                                      onTap: () =>
                                          _isObscured.add(!isObscured)),
                                ),
                                obscureText: isObscured,
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<bool>(
                            stream: _isTicked,
                            initialData: false,
                            builder: (context, snapshot) {
                              bool isTicked = snapshot.data ?? false;
                              return Row(
                                children: [
                                  CircleCheckboxComponent(
                                    isChecked: isTicked,
                                    onClickFunction: () =>
                                        _isTicked.add(!_isTicked.value),
                                  ),
                                  InkWell(
                                      onTap: () =>
                                          _isTicked.add(!_isTicked.value),
                                      overlayColor:
                                          const WidgetStatePropertyAll(
                                              Colors.transparent),
                                      child: Text(
                                        "rememberme".getString(context),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 245, 209, 97)),
                                        textScaler:
                                            const TextScaler.linear(1.1),
                                      ))
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                  onPressed: isAuthenticating
                                      ? null
                                      : () async {
                                          try {
                                            await bloc.login(context,
                                                email.text, password.text);

                                            String? token =
                                                await Store.getToken();

                                            if (token == null) {
                                              if (!context.mounted) return;
                                              showMySnackBar(
                                                  context,
                                                  "somethingWrongWithAuthentication",
                                                  SnackbarStatus.failed);
                                              return;
                                            }

                                            await Store.saveLoginPreferences(
                                                _isTicked.value,
                                                email.text,
                                                password.text);
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                          } catch (err) {
                                            var error = err as AppError?;
                                            if (!context.mounted) return;
                                            showMySnackBar(
                                                context,
                                                error?.message ??
                                                    "somethingWrong",
                                                SnackbarStatus.failed);
                                          }
                                        },
                                  style: ButtonStyle(
                                      fixedSize: const WidgetStatePropertyAll(
                                        Size.fromHeight(52),
                                      ),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ))),
                                  child: isAuthenticating
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
                            StreamBuilder<bool>(
                                stream: _biometricsAvailable,
                                initialData: false,
                                builder: (context, snapshot) {
                                  if (snapshot.data == false ||
                                      !_haveLoggedIn) {
                                    return const SizedBox();
                                  }
                                  return AuthenticationButton(
                                      biometricType: _biometricType,
                                      handleBiometrics: handleBiometrics);
                                })
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
  }

  void handleBiometrics(context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!context.mounted) return;
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: "authenticateToLogin".getString(context));
      if (didAuthenticate) {
        if (context.mounted) {
          await bloc.login(
            context,
            prefs.getString("email") ?? "",
            prefs.getString("password") ?? "",
          );

          String? token = await Store.getToken();

          if (token == null) {
            if (!context.mounted) return;
            showMySnackBar(context, "somethingWrongWithAuthentication");
            return;
          }

          await Store.saveLoginPreferences(
              _isTicked.value,
              prefs.getString("email") ?? "",
              prefs.getString("password") ?? "");

          if (!context.mounted) return;
          Navigator.pop(context);
        }
      }
    } on PlatformException {
      if (!context.mounted) return;
      showMySnackBar(context, "somethingWrongWithAuthentication");
      return;
    }
  }

  Future _checkBiometrics() async {
    bool isBiometricAvailable =
        await auth.isDeviceSupported() && await auth.canCheckBiometrics;
    if (!isBiometricAvailable) {
      return;
    }
    List<BiometricType> availableBiometricsType =
        await auth.getAvailableBiometrics();
    bool isFingerprintAvailable =
        availableBiometricsType.contains(BiometricType.fingerprint) ||
            availableBiometricsType.contains(BiometricType.strong);
    bool isFaceAvailable = availableBiometricsType.contains(BiometricType.face);
    if (isFaceAvailable) {
      _biometricsAvailable.add(true);
      _biometricType = BiometricType.face;
    } else if (isFingerprintAvailable) {
      _biometricsAvailable.add(true);
      _biometricType = BiometricType.fingerprint;
    }
  }
}
