import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/users.dart';
import '../widget/app_bottom_nav_bar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    print(UserService.user.toJson());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 48.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32.0, left: 16.0, right: 16.0, bottom: 32.0),
                  child: UserService.isLogin
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.grey[300],
                              foregroundImage: const AssetImage(
                                  'assets/images/background.jpg'),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${UserService.user.username}", style: textTheme.headlineSmall),
                                Text(
                                  'User ID: ${UserService.user.email}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Row(children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.grey[300],
                            ),
                            const SizedBox(width: 40),
                            ElevatedButton(
                                onPressed: () {
                                  context.pushNamed('login');
                                },
                                child: const Text("点击登录"))
                          ]),
                        ),
                )),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text('Profile', style: textTheme.titleMedium),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text('Settings', style: textTheme.titleMedium),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: Text('Logout', style: textTheme.titleMedium),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(index: 4),
    );
  }
}
