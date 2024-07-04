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
import 'package:travellingo/component/my_oauth_button.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/pages/sign_up/register_page.dart';
import 'package:travellingo/pages/login/widget/authentication_button.dart';
import 'package:travellingo/pages/sign_up/widgets/password_text_field.dart';
import 'package:travellingo/pages/sign_up/widgets/text_label.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/store.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  final emailregex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
        _emailTEC.text = loginPreferences["email"];
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
    _emailTEC.dispose();
    _passwordTEC.dispose();
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
                image: AssetImage('assets/images/Signin.png'),
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
                        const TextLabel(content: "email"),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _emailTEC,
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
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Colors.grey,
                              fontSize: 14,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            enabled: !isAuthenticating,
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const TextLabel(content: "password"),
                        const SizedBox(
                          height: 10,
                        ),
                        PasswordTextField(
                            enabled: !isAuthenticating,
                            controller: _passwordTEC),
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
                                  onPressed:
                                      isAuthenticating ? null : _tryLogin,
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
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
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
                        ),
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
          _tryLogin(prefs.getString("email"), prefs.getString("password"));
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

  Future<void> _tryLogin([String? email, String? password]) async {
    AppError? error = await bloc.login(
        context, email ?? _emailTEC.text, password ?? _passwordTEC.text);

    if (!mounted) return;

    if (error != null) {
      showMySnackBar(context, error.message, SnackbarStatus.failed);
      return;
    }

    String? token = await Store.getToken();

    await Store.saveLoginPreferences(_isTicked.value, email ?? _emailTEC.text,
        password ?? _passwordTEC.text);

    if (!mounted) return;

    if (token == null) {
      showMySnackBar(
          context, "somethingWrongWithAuthentication", SnackbarStatus.failed);
      return;
    }

    Navigator.pop(context);
  }
}
