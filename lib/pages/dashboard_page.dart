import 'package:flutter/material.dart';
import 'package:travellingo/pages/home/home_page.dart';
import 'package:travellingo/pages/insight_page.dart';
import 'package:travellingo/pages/notification_page.dart';
import 'package:travellingo/pages/profile/profile_page.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
        "title": "notification",
        "icon": const Icon(Icons.notifications_none_outlined),
        "page": const NotificationPage()
      },
      {
        "title": "insights",
        "icon": const Icon(Icons.insights_outlined),
        "page": const InsightsPages()
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
    return SafeArea(
      top: false,
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: navigationItem[_currentPage]["page"],
          ),
          resizeToAvoidBottomInset: false,
          bottomSheet: Container(
            decoration: BoxDecoration(
              color: colorScheme.background,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -1)),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: colorScheme.background,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                  unselectedItemColor: Colors.grey,
                  // selectedItemColor: Colors.teal,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  currentIndex: _currentPage,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
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
                  }).toList()),
            ),
          )),
    );
  }
}
