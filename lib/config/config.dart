class Config {
  static const String appName = "boat";
  static const String appUrl = "http://192.168.1.67:8000";
  static const String loginApiUser = "$appUrl/user/auth/login/user";
  static const String registerApiUser = "$appUrl/user/createClient";
  static const String resetPasswordApi = "$appUrl/user/forget/password";
  static const String getAllLocation = "$appUrl/location";
  static const String getAllBoats = "$appUrl/boat/test";
  static const String bookingApi = "$appUrl/booking/creation";
  static const String bookingListApi = "$appUrl/booking/userbookings";
}
