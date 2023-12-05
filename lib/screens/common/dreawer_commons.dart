import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat/read_qr_code_screen.dart';
import '/user/user_dto.dart';
import '/screens/user/profile.dart';
import 'package:chat_pdm/screens/user/login.dart';

class DrawerCommons{

  static UserAccountsDrawerHeader getUserDisplay(UserDTO userDTO){
    return UserAccountsDrawerHeader(
      accountName: Text(userDTO.username!),
      accountEmail: Text(userDTO.email!),
      decoration: const BoxDecoration( color: Color(0xff343541)),
      onDetailsPressed: () => Get.toNamed(ProfileScreen.routeName),
      currentAccountPicture: const CircleAvatar( child: Icon(Icons.person, color: Color.fromARGB(255, 255, 255, 255)),),
    );
  }

  static Drawer getDefaultDrawer(UserDTO userDTO){
    return Drawer(
      child: Column(
        children: [
          getUserDisplay(userDTO),
          ListTile(
            title:    const Text('Perfil', style: TextStyle(color: Colors.grey)),
            leading:  const Icon(Icons.person, color: Colors.grey),
            onTap:    () => Get.toNamed(ProfileScreen.routeName),
          ),
          ListTile(
            title:    const Text('Ler QR Code', style: TextStyle(color: Colors.grey)),
            leading:  const Icon(Icons.qr_code, color: Colors.grey),
            onTap:    () => Get.toNamed(ReadQRCodeScreen.routeName),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading:  const Icon(Icons.exit_to_app, color: Colors.grey),
            title:    const Text('Logout', style: TextStyle(color: Colors.grey)),
            onTap:    () => Get.offNamed(LoginScreen.routeName),
          ),
        ],
      ),
    );
  }
}