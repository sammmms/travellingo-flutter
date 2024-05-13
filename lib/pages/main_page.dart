import 'package:flutter/material.dart';
import 'package:travellingo/pages/home/home_page.dart';
import 'package:travellingo/pages/profile/profile_page.dart';
import 'package:travellingo/pages/basket%20(done)/basket_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;
  late List<Map<String, dynamic>> navigationItem;
  @override
  void initState() {
    navigationItem = [
      {
        "title": "home",
        "icon": const Icon(Icons.home_outlined),
        "page": const HomePage()
      },
      {
        "title": "transaction",
        "icon": const Icon(Icons.confirmation_num_outlined),
        "page": const BasketPage()
      },
      {
        "title": "favorite",
        "icon": const Icon(Icons.bookmark_added_outlined),
        "page": const Text("Favorite")
      },
      {
        "title": "profile",
        "icon": const Icon(Icons.person_outline),
        "page": const ProfilePage()
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: navigationItem[_currentPage]["page"],
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            // selectedItemColor: Colors.teal,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            currentIndex: _currentPage,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            items: navigationItem.map((entry) {
              String title = entry["title"];
              return BottomNavigationBarItem(
                label: title,
                icon: entry["icon"],
              );
            }).toList()));
  }
}
