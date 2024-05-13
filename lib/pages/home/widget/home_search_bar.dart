import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "exploreSomethingFun".getString(context),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFF5D161), width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFF5D161), width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFF5D161), width: 2)),
        prefixIcon: Image.asset("assets/Search.png"),
      ),
    );
  }
}
