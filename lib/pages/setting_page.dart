import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/pages/terms_and_conditions_page.dart';

import '../models/login_response.dart';
import '../services/shared_service.dart';
import '../widgets/bottom_nav.dart';
import 'about_screen.dart';
import 'login_page.dart';
import 'navbar_state.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _status = 0;
  @override
  Widget build(BuildContext context) {
    final bottomNav = context.findAncestorWidgetOfExactType<BottomNav>();
    bool _isLoggedIn = false;
    void _checkLoggedInStatus() async {
      try {
        bool loggedIn = await SharedService.isLoggedIn();
        setState(() {
          _isLoggedIn = loggedIn;
        });
        if (!_isLoggedIn) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

    Future<void> _fetchUserInfo() async {
      try {
        LoginResponseModel? userDetails = await SharedService.loginDetails();
        if (userDetails != null) {
          setState(() {});
        }
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
      }
    }

    @override
    void initState() {
      super.initState();
      _checkLoggedInStatus();
      _fetchUserInfo();
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 10),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // IconButton(
                      //   color: Colors.white,
                      //   onPressed: () {
                      //     Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const NavBar()),
                      //       (Route<dynamic> route) => false,
                      //     );
                      //   },
                      //   icon: const Icon(
                      //     Icons.dashboard,
                      //     size: 30,
                      //   ),
                      // ),
                      // IconButton(
                      //   color: Colors.white,
                      //   onPressed: () {
                      //     Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const NotificationPage()),
                      //       (Route<dynamic> route) => false,
                      //     );
                      //   },
                      //   icon: const Icon(
                      //     Icons.notifications,
                      //     size: 30,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // const Circle(),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: const [
                Icon(Icons.person, color: Colors.white),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOption(
              context,
              "About",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              ),
            ),
            buildAccountOption(
              context,
              "Terms & Conditions",
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsAndConditions()),
              ),
            ),
            buildAccountOption(
              context,
              "Logout",
              () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                try {
                  // Remove data for the 'counter' key.
                  await prefs.remove('token');
                  await SharedService.logout(context);
                } catch (err) {
                  if (kDebugMode) {
                    print(err);
                  }
                }
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const BottomNav(),
    );
  }

  GestureDetector buildAccountOption(
      BuildContext context, String title, VoidCallback onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
