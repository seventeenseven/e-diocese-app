import 'package:ediocese_app/screens/dashboard/news_tab/news_router.dart';
import 'package:ediocese_app/screens/dashboard/activity_tab/activity_router.dart';
import 'package:ediocese_app/screens/dashboard/pray_tab/pray_router.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/profile_router.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/home_router.dart';
import 'package:ediocese_app/screens/dashboard/router_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomTabNavigator extends StatefulWidget {
  const BottomTabNavigator({super.key});

  @override
  BottomTabNavigatorState createState() => BottomTabNavigatorState();
}

class BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _selectedIndex = 0;
  bool _bottomTabNavigatorVisible = true;
  bool _prayMenuItemVisible = false;
  static const activeColor = colorBlueLittleDark;
  static const normalColor = Colors.grey;

  hideBottomTabNavigator() {
    setState(() {
      _bottomTabNavigatorVisible = false;
    });
  }

  showBottomTabNavigator() {
    setState(() {
      _bottomTabNavigatorVisible = true;
    });
  }

  showPrayMenu() {
    _addPrayRouter();
    setState(() {
      _prayMenuItemVisible = true;
    });
  }

  void _addPrayRouter() {
    if (_widgetOptions.length < 5) {
      _widgetOptions.insert(3, PrayRouter());
    }
  }

  hidePrayMenu() {
    _removePrayRouter();
    setState(() {
      _prayMenuItemVisible = false;
    });
  }

  void _removePrayRouter() {
    _widgetOptions.removeAt(3);
  }

  final List _widgetOptions = <dynamic>[
    HomeRouter(),
    ActivityRouter(),
    NewsRouter(),
    // PrayRouter(),
    ProfileRouter()
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onBackPressed() async {
    if (_widgetOptions[_selectedIndex] is RouterPage) {
      final RouterPage page = _widgetOptions[_selectedIndex] as RouterPage;
      return !await page.navigatorKey.currentState!.maybePop();
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: _bottomTabNavigatorVisible
            ? Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFFF9F5F0), // Beige clair
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.church,
                    color: Color(0xFF5D4037), // Brun chaud
                    size: 24.0,
                  ),
                  icon: Icon(
                    Icons.church,
                    color: Color(0xFFA1887F), // Taupe clair
                    size: 24.0,
                  ),
                  label: 'Églises',
                ),
                const BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.calendar_month,
                    color:  Color(0xFF5D4037),
                    size: 24.0,
                  ),
                  icon: Icon(
                    Icons.calendar_month,
                    color:  Color(0xFFA1887F),
                    size: 24.0,
                  ),
                  label: 'Activités',
                ),
                const BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.speaker,
                    color:  Color(0xFF5D4037),
                    size: 24.0,
                  ),
                  icon: Icon(
                    Icons.speaker,
                    color:  Color(0xFFA1887F),
                    size: 24.0,
                  ),
                  label: 'Nouvelles',
                ),
                if (_prayMenuItemVisible)
                  const BottomNavigationBarItem(
                    activeIcon: Icon(
                      FontAwesomeIcons.handsPraying,
                      color:  Color(0xFF5D4037),
                      size: 20.0,
                    ),
                    icon: Icon(
                      FontAwesomeIcons.handsPraying,
                      color:  Color(0xFFA1887F),
                      size: 20.0,
                    ),
                    label: 'Prières',
                  ),
                const BottomNavigationBarItem(
                  activeIcon: Icon(
                    FontAwesomeIcons.user,
                    color:  Color(0xFF5D4037),
                    size: 20.0,
                  ),
                  icon: Icon(
                    FontAwesomeIcons.user,
                    color:  Color(0xFFA1887F),
                    size: 20.0,
                  ),
                  label: 'Profil',
                )
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xFF5D4037), // Brun chaud
              unselectedItemColor: const Color(0xFFA1887F), // Taupe clair
              onTap: onItemTapped,
            ),
          ),
        )
            : null,
      ),
    );
  }
}
