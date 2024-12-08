import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import '../model/user.dart';

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
      showToast("Email cannot be empty");
      return false;
    }
    if (passwordController.text.isEmpty) {
      showToast("Password cannot be empty");
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
              "Login",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Expanded(
                flex: 1,
                child: loginTextField(
                    icon: Icons.email_rounded,
                    hintText: "Email",
                    controller: emailController)),
            Expanded(
              flex: 1,
              child: loginTextField(
                  icon: Icons.password,
                  hintText: "Password",
                  controller: passwordController),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLogin = false;
                          });
                        },
                        child: const Text("Register")),
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
                              showToast("Unknown error");
                            }
                          } else if (status == LoginStatus.fail) {
                            showToast("Username or password is incorrect");
                          }
                        },
                        child: const Text("Login"))
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
              "Register",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Expanded(
                flex: 1,
                child: loginTextField(
                    icon: Icons.email_rounded,
                    hintText: "Email",
                    controller: emailController)),
            Expanded(
                flex: 1,
                child: loginTextField(
                    icon: Icons.person,
                    hintText: "Username",
                    controller: usernameController)),
            Expanded(
              flex: 1,
              child: loginTextField(
                  icon: Icons.password,
                  hintText: "Password",
                  controller: passwordController),
            ),
            Expanded(
              flex: 1,
              child: loginTextField(
                  icon: Icons.phone,
                  hintText: "Phone Number",
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
                        child: const Text("Cancel")),
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
                            showToast("Register success");
                          } else if (status == LoginStatus.exist) {
                            showToast("User already exist");
                          }
                        },
                        child: const Text("Register")),
                  ],
                ))
          ],
        ),
      );
    }
  }
}
