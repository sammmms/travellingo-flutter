import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/pages/home/home_page.dart';
import 'package:travellingo/pages/login/login_page.dart';
import 'package:travellingo/pages/transaction/transaction_page.dart';
import 'package:travellingo/pages/wishlist/wishlist_page.dart';
import 'package:travellingo/pages/notification_page.dart';
import 'package:travellingo/pages/profile/profile_page.dart';
import 'package:travellingo/splash_page.dart';
import 'package:travellingo/utils/store.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _pageController = PageController(initialPage: 0);
  final _dashboardPage = BehaviorSubject<int>.seeded(0);
  late List<Map<String, dynamic>> navigationItem;
  late AuthBloc authBloc;
  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    navigationItem = [
      {"title": "home", "page": const HomePage()},
      {"title": "transaction", "page": const TransactionPage()},
      {"title": "notification", "page": const NotificationPage()},
      {"title": "wishlist", "page": const WishlistPages()},
      {"title": "profile", "page": const ProfilePage()}
    ];
    if (kDebugMode) {
      print("Add listener to page controller");
    }
    _pageController.addListener(
        () => _dashboardPage.add(_pageController.page?.round() ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          body: StreamBuilder<AuthState>(
              stream: authBloc.controller,
              builder: (context, snapshot) {
                AuthState authState = snapshot.data ?? AuthState();
                if (!snapshot.hasData || authState.isAuthenticating) {
                  return const SplashPage();
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: PageView(
                    controller: _pageController,
                    children: navigationItem
                        .map((entry) =>
                            ChangeNotifierProvider<PageController>.value(
                              value: _pageController,
                              child: entry["page"] as Widget,
                            ))
                        .toList(),
                  ),
                );
              }),
          resizeToAvoidBottomInset: false,
          bottomSheet: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
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
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: StreamBuilder<int>(
                    stream: _dashboardPage,
                    builder: (context, snapshot) {
                      int index = snapshot.data ?? 0;
                      return BottomNavigationBar(
                          unselectedItemColor: Colors.grey,
                          showUnselectedLabels: false,
                          showSelectedLabels: false,
                          currentIndex: snapshot.data ?? 0,
                          elevation: 0,
                          type: BottomNavigationBarType.shifting,
                          onTap: (value) async {
                            bool notAuthenticated = authBloc
                                    .controller.valueOrNull?.isAuthenticated ==
                                false;
                            bool noToken = await Store.getToken() == null;
                            if (value > 0 && (notAuthenticated || noToken)) {
                              if (!context.mounted) return;
                              Navigator.push(context,
                                  slideInFromBottom(const LoginPage()));
                              return;
                            }
                            _pageController.jumpToPage(value);
                            _dashboardPage.add(value);
                          },
                          items: navigationItem.map((entry) {
                            String title = entry["title"];
                            return BottomNavigationBarItem(
                              label: title,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              icon: _buildIcon(title,
                                  index == navigationItem.indexOf(entry)),
                            );
                          }).toList());
                    })),
          )),
    );
  }

  Widget _buildIcon(String fileName, bool selected) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SvgPicture.asset(
        "assets/svg/${fileName}_icon.svg",
        width: selected ? 25 : 18,
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
