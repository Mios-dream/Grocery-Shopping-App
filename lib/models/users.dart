import 'dart:convert';
import 'package:grocify/config.dart';
import 'package:http/http.dart' as http;

// 用户信息
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
        "username": username??"",
        "phone_number": phoneNumber??""
      });
}

enum LoginStatus {
  success,
  fail,
  error,
  exist,
}

// 用户服务
class UserService {
  static const _baseUrl = Config.baseUrl;

  //  注册用户
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
      print(e);
      return LoginStatus.error;
    }
  }

  //  用户登录
  static Future<LoginStatus> checkLogin(User user) async {
    final uri = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(uri, body: user.toJson());
      final data = jsonDecode(response.body);
      if (data['code'] == 0) {
        return LoginStatus.success;
      } else {
        return LoginStatus.fail;
      }
    } catch (e) {
      print(e);
      return LoginStatus.error;
    }
  }
}
