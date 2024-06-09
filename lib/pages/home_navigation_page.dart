import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pharmacy_app/pages/favorite_page.dart';
import 'package:pharmacy_app/pages/home_page.dart';
import 'package:pharmacy_app/pages/my_orders_page.dart';
import 'package:pharmacy_app/pages/settings_page.dart';

class HomeNavigationPage extends StatefulWidget {
  const HomeNavigationPage({super.key});

  @override
  State<HomeNavigationPage> createState() => _HomeNavigationPageState();
}

double screenHeight = 0.0;
double screenWidth = 0.0;
TextEditingController _searchMedicineController = TextEditingController();

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  int currentPageIndex = 0;

  static final List<Widget> _NavScreens = <Widget>[
    // TempPage(),
    const HomePage(),
    const FavouritePage(),
    const MyOrdersPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffe3f6f5),
      body: Center(child: _NavScreens.elementAt(currentPageIndex)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          top: 8,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GNav(
              color: Color(0xff042A3B),
              curve: Curves.easeIn,
              activeColor: Colors.white,
              tabBackgroundColor: Color(0xff042A3B),
              tabBorderRadius: 8,
              gap: 6,
              padding: const EdgeInsets.all(10),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.favorite,
                  text: "Favorite",
                ),
                GButton(
                  icon: Icons.library_books_rounded,
                  text: "My Orders",
                ),
                GButton(
                  icon: Icons.settings,
                  text: "settings",
                ),
              ],
              selectedIndex: currentPageIndex,
              onTabChange: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}


 // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: ,
      //   currentIndex: currentPageIndex,
      //   onTap: (int newIndex) {
      //     setState(() {
      //       currentPageIndex = newIndex;
      //     });
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       label: "Home",
      //       icon: Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "Cart",
      //       icon: Icon(Icons.shopping_cart_rounded),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "Settings",
      //       icon: Icon(Icons.settings),
      //     ),
      //   ],
      // ),
