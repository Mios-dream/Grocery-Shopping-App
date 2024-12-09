import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocify/router/app_router.dart';
import 'package:oktoast/oktoast.dart';

import '../service/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late User user;

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
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final isKeyboardOpen = viewInsets.bottom > 0.0;

    return Scaffold(
      backgroundColor: colorScheme.inverseSurface,
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/register_background.jpg'),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 50.0),
                        Text(
                          'Great! Let\'s get some basic info',
                          style: GoogleFonts.ibmPlexSerif(
                            fontSize: 42.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 100.0),
                        _UserNameInput(
                          controller: usernameController,
                        ).animate().fadeIn(
                              duration: const Duration(milliseconds: 200),
                            ),
                        const SizedBox(height: 16.0),
                        _EmailInput(
                          controller: emailController,
                        )
                            .animate(delay: const Duration(milliseconds: 200))
                            .fadeIn(
                                duration: const Duration(milliseconds: 200)),
                        const SizedBox(height: 16.0),
                        _PasswordInput(
                          controller: passwordController,
                        )
                            .animate(delay: const Duration(milliseconds: 400))
                            .fadeIn(
                                duration: const Duration(milliseconds: 200)),
                        const SizedBox(height: 16.0),
                        _PhoneNumberInput(
                          controller: phoneNumberController,
                        )
                            .animate(delay: const Duration(milliseconds: 600))
                            .fadeIn(
                                duration: const Duration(milliseconds: 200)),
                        const SizedBox(height: 16.0),
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          title: Text(
                            'By joining, I agree to the Terms & Conditions and Privacy Policy',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        )
                            .animate(delay: const Duration(milliseconds: 1000))
                            .fadeIn(
                                duration: const Duration(milliseconds: 200)),
                      ],
                    ),
                  ),
                ),
              ),
              isKeyboardOpen
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 16),
                      child: FilledButton(
                        onPressed: () {
                          if (isChecked == false) {
                            showToast(
                                "Please agree to the terms and conditions");
                            return;
                          }

                          if (!checkLogin()) {
                            return;
                          }
                          user = User(
                            email: emailController.text,
                            password: passwordController.text,
                            username: usernameController.text,
                            phoneNumber: phoneNumberController.text,
                          );
                          UserService.registerUser(user).then((status) {
                            if (status == LoginStatus.success) {
                              showToast("Register success");
                              context.goNamed("login");
                            } else if (status == LoginStatus.exist) {
                              showToast("User already exist");
                            }
                          });
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48.0),
                        ),
                        child: const Text("Continue"),
                      ),
                    ),
            ],
          )),
    );
  }
}

class _UserNameInput extends StatelessWidget {
  final TextEditingController controller;
  const _UserNameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        filled: true,
        label: const Text('Username'),
        labelStyle: textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
        fillColor: colorScheme.surface.withAlpha(100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white.withAlpha(100)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  const _PasswordInput({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      keyboardType: TextInputType.name,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        label: const Text('Password'),
        labelStyle: textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
        fillColor: colorScheme.surface.withAlpha(100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white.withAlpha(100)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;
  const _EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        label: const Text('Email'),
        labelStyle: textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
        fillColor: colorScheme.surface.withAlpha(100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white.withAlpha(100)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneNumberInput({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        filled: true,
        label: const Text('Phone Number'),
        labelStyle: textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
        fillColor: colorScheme.surface.withAlpha(100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white.withAlpha(100)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
