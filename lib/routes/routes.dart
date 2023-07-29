import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:travel_app/widgets/bookings.dart';


import '../pages/home_page.dart';
import '../pages/navbar_state.dart';
import '../pages/setting_page.dart';


class AppPage {
  static List<GetPage> routes = [
    GetPage(name: navBar, page: () => const NavBar()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: booking, page: () => const Bookings()),
    GetPage(name: setting, page: () => const SettingPage()),
  ];

  static getNavBar() => navBar;
  static getHome() => home;
  static getBooking() => booking;
  static getSetting() => setting;

  static String navBar = '/';
  static String home = '/home';
  static String booking = '/booking';
  static String setting = '/setting';
}
