import 'package:chat_pdm/screens/chat/chat_read_screen.dart';
import 'package:chat_pdm/screens/chat/read_qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';

import 'screens/chat/chat_list.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/user/login.dart';
import 'screens/user/update/update_credentials.dart';
import 'screens/user/update/update_password.dart';
import 'screens/user/creation.dart';
import 'screens/user/profile.dart';
import 'user/user_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: userService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final initialRoute = snapshot.data ?? false
            ? ChatListScreen.routeName
            : LoginScreen.routeName;

          return GetMaterialApp(
            title: 'Your App Title',
            initialRoute: initialRoute,
            getPages: [
              GetPage(name: ChatListScreen.routeName, page: () => const ChatListScreen()),
              GetPage(name: ChatScreen.routeName, page: () => ChatScreen()),
              GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
              GetPage(name: UpdateCredentialsScreen.routeName, page: () => const UpdateCredentialsScreen()),
              GetPage(name: UpdateUserPasswordScreen.routeName, page: () => const UpdateUserPasswordScreen()),
              GetPage(name: UserCreationScreen.routeName, page: () => const UserCreationScreen()),
              GetPage(name: ProfileScreen.routeName, page: () => const ProfileScreen()),
              GetPage(name: ReadQRCodeScreen.routeName, page: () => const ReadQRCodeScreen()),
              GetPage(name: ReadChatScreenReadMode.routeName, page: () => const ReadChatScreenReadMode()),
            ],
            debugShowCheckedModeBanner: false,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
