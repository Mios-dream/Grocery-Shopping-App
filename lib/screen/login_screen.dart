import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import '../models/users.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(child: LoginCard())),
    );
  }
}

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late User user;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();

  }

  // 登录文本框组件，用于快速构建文本框
  Widget loginTextField(
      {required IconData icon,
      required String hintText,
      required TextEditingController controller}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(5),
      child: TextField(
          controller: controller,
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ))),
    );
  }

  bool checkLogin() {
    if (emailController.text.isEmpty) {
      showToast("邮箱不能为空");
      return false;
    }
    if (passwordController.text.isEmpty) {
      showToast(
        "密码不能为空",
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        height: 270,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "登录",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Expanded(
                flex: 1,
                child: loginTextField(
                    icon: Icons.email_rounded,
                    hintText: "邮箱",
                    controller: emailController)),
            Expanded(
              flex: 1,
              child: loginTextField(
                  icon: Icons.password,
                  hintText: "密码",
                  controller: passwordController),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: const Text("取消")),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLogin = false;
                          });
                        },
                        child: const Text("注册")),
                    TextButton(
                        onPressed: () async {
                          if (!checkLogin()) {
                            return;
                          }
                          user = User(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          LoginStatus status =
                              await UserService.checkLogin(user);
                          if (status == LoginStatus.success) {
                            if (context.mounted) {
                              context.goNamed("home");
                            } else {
                              showToast("未知错误");
                            }
                          } else if (status == LoginStatus.fail) {
                            showToast("用户名或密码错误");
                          }
                        },
                        child: const Text("登录"))
                  ],
                ))
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        height: 360,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "注册",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Expanded(
                flex: 1,
                child: loginTextField(
                    icon: Icons.person,
                    hintText: "用户名",
                    controller: usernameController)),
            Expanded(
                flex: 1,
                child: loginTextField(
                    icon: Icons.email_rounded,
                    hintText: "邮箱",
                    controller: emailController)),
            Expanded(
              flex: 1,
              child: loginTextField(
                  icon: Icons.password,
                  hintText: "密码",
                  controller: passwordController),
            ),
            Expanded(
              flex: 1,
              child: loginTextField(
                  icon: Icons.phone,
                  hintText: "手机号",
                  controller: phoneNumberController),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = true;
                          });
                        },
                        child: const Text("取消")),
                    TextButton(
                        onPressed: () async {
                          if (!checkLogin()) {
                            return;
                          }
                          user = User(
                            email: emailController.text,
                            password: passwordController.text,
                            username: usernameController.text,
                            phoneNumber: phoneNumberController.text,
                          );
                          LoginStatus status =
                              await UserService.registerUser(user);
                          if (status == LoginStatus.success) {
                            showToast("注册成功");
                          } else if (status == LoginStatus.exist) {
                            showToast("用户名或邮箱已存在");
                          }
                        },
                        child: const Text("注册")),
                  ],
                ))
          ],
        ),
      );
    }
  }
}
