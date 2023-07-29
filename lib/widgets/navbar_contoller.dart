import 'package:get/get.dart';

class NavBarController extends GetxController {
  var tabIndex = 0;
  void changeTabOIndex(int index) {
    tabIndex = index;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Helper.checkStatus();
  }
}
