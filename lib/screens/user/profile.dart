import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/screens/user/update/update_credentials.dart';
import '/screens/user/update/update_password.dart';
import '/user/user_dto.dart';
import '/user/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final bool isCurrent = true;
  static const routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  
  UserDTO? userDTO;
  UserService userService = UserService();

  @override
  void initState(){
    super.initState();

    loadCredentials().then((value) => setState(() {}));
  }

  Future<void> loadCredentials() async {
    if(await userService.isLoggedIn()){
      userDTO = userService.get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff343541),
        elevation: 0,
        title: const Column(
          children: [
            Text("Perfil", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 15.0)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 60),
              child: Text('Nome: ${userDTO?.username}')
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 60),
              child: Text('Email: ${userDTO?.email}')
            ),
            const SizedBox(height: 18),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Colors.white),
                onPressed: () => Get.toNamed(UpdateCredentialsScreen.routeName ),
                child: const Text('Alterar dados'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Colors.white),
                onPressed: () => Get.toNamed(UpdateUserPasswordScreen.routeName ),
                child: const Text('Alterar senha'),
              )
            ),
          ],
        ),
      )
    );
  }
}
