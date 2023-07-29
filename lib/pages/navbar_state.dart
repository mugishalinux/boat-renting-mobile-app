import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/setting_page.dart';
import 'package:travel_app/widgets/bookings.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../widgets/navbar_contoller.dart';
import 'home_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(
      builder: (context) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: const [HomePage(), Bookings(), SettingPage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            currentIndex: controller.tabIndex,
            onTap: controller.changeTabOIndex,
            items: [
              _bottomBarItem(Icons.home, "Home"),
              _bottomBarItem(Icons.menu_book_outlined, "Booking"),
              _bottomBarItem(Icons.settings, "Settings"),
            ],
          ),
        );
      },
    );
  }
}

_bottomBarItem(IconData icon, String label) {
  return BottomNavigationBarItem(icon: Icon(icon), label: label);
}
