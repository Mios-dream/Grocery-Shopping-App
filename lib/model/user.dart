import 'dart:convert';
import 'package:grocify/config.dart';
import 'package:http/http.dart' as http;

class User {
  String email;
  String password;
  String? username;
  String? phoneNumber;

  User(
      {required this.email,
      required this.password,
      this.username,
      this.phoneNumber});
  String toJson() => jsonEncode({
        "email": email,
        "password_hash": password,
        "username": username ?? "",
        "phone_number": phoneNumber ?? ""
      });
}

enum LoginStatus {
  success,
  fail,
  error,
  exist,
}

class UserService {
  static const _baseUrl = Config.baseUrl;
  static bool isLogin = false;

  static User user = User(email: "", username: "", password: "");

  static Future<LoginStatus> registerUser(User user) async {
    final uri = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(uri, body: user.toJson());
      final data = jsonDecode(response.body);
      if (data['code'] == 0) {
        return LoginStatus.success;
      } else {
        return LoginStatus.exist;
      }
    } catch (e) {
      return LoginStatus.error;
    }
  }

  static Future<LoginStatus> checkLogin(User user) async {
    final uri = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(uri, body: user.toJson());
      final data = jsonDecode(response.body);
      if (data['code'] == 0) {
        isLogin = true;
        UserService.user.email = data['message']['email'];
        UserService.user.username = data['message']['username'];
        UserService.user.password = data['message']['password_hash'];
        UserService.user.phoneNumber = data['message']['phone_number'];
        return LoginStatus.success;
      } else {
        return LoginStatus.fail;
      }
    } catch (e) {
      return LoginStatus.error;
    }
  }

  static Future<void> logout() async {
    isLogin = false;
    user = User(
      email: "",
      password: "",
      username: "",
    );
  }
}
