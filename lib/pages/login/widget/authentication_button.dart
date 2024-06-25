import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationButton extends StatelessWidget {
  final BiometricType? biometricType;
  final Function(BuildContext context) handleBiometrics;
  const AuthenticationButton(
      {super.key, required this.biometricType, required this.handleBiometrics});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => handleBiometrics(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          minimumSize: const Size(40, 52),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: biometricType == BiometricType.face
            ? Image.asset("assets/Faceid.png")
            : biometricType == BiometricType.fingerprint
                ? const Icon(
                    Icons.fingerprint,
                    color: Color(0xFFF5D161),
                    size: 35,
                  )
                : const Icon(Icons.password,
                    color: Color(0xFFF5D161), size: 35));
  }
}
