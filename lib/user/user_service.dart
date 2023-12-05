import 'package:chat_pdm/screens/user/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '/screens/user/update/user_update_dto.dart';
import '/user/user_dto.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RegExp _upperCaseRegex = RegExp(r'^(?=.*?[A-Z])');
  final RegExp _lowerCaseRegex = RegExp(r'^(?=.*?[a-z])');
  final RegExp _specialCharRegex = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' "'" ']');
  final RegExp _numberRegex = RegExp(r'^(?=.*?[0-9])');
  final RegExp _lengthRegex = RegExp(r'^.{8,16}');
  
  Future<bool> create(UserDTO userDTO) async {
    if (userDTO.email == null || userDTO.password == null || userDTO.username == null) {
      throw Exception("Alguns dados estão faltando!");
    }

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: userDTO.email!,
      password: userDTO.password!,
    );

    if (userCredential.user != null) {
      userCredential.user!.updateDisplayName(userDTO.username);
      return true;
    } else {
      return false;
    }
  }
  
  Future<bool> login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    if(userCredential.user == null){
      throw Exception("User not found on Login");
    }

    return true;
  }

  void logout() async {
    await _auth.signOut();
  }
    
  Future<bool> updateUserCredentials(UserUpdateDTO userUpdateDTO) async {
    try{
      User user = _getFromAuth();

      if(userUpdateDTO.email != null && userUpdateDTO.email != user.email){
        await user.updateEmail(userUpdateDTO.email!);
      } 

      if(userUpdateDTO.username != null && userUpdateDTO.username != user.displayName){
        await user.updateDisplayName(userUpdateDTO.username!);
      }

      return true;
    }catch(e){
      debugPrint("Error during updateUserCredentials: $e");
      return false;
    }
  }

  Future<bool> updateUserPassword(UserUpdateDTO userUpdateDTO) async {
    try{
      User user = _getFromAuth();
      user.updatePassword(userUpdateDTO.password!);

      return true;
    }catch(e){
      debugPrint("Error during updateUserPassword: $e");
      return false;
    }
  }

  String? validatePassword(String? password) {
    if (password!.isEmpty) return "Adicione uma senha!";

    if ( !_upperCaseRegex.hasMatch(password) )   return "A senha deve possuir uma letra maiuscula.";
    if ( !_lowerCaseRegex.hasMatch(password) )   return "A senha deve possuir uma letra minuscula.";
    if ( !_numberRegex.hasMatch(password)    )   return "A senha deve possuir um numero.";
    if ( !password.contains(_specialCharRegex) ) return "A senha deve possuir um caracter especial.";
    if ( !_lengthRegex.hasMatch(password)    )   return 'Sua senha possui ${password.length} caracteres. \nPorém deve ter entre 8 e 16 caracteres.';
      
    return null;
  }

  String? emailValidator(String? value) {
    if( value!.isEmpty )       return "Ensira um email";
    if( !value.contains("@") ) return "Ensira um email válido";

    return null ;
  }

  String? usernameValidator(String? value) {
    if( value!.isEmpty ) return "Ensira um username";

    return null;
  }

  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  User _getFromAuth() {
    User? user = _auth.currentUser;

    if(user == null){ 
      logout(); 
      Get.offNamed(LoginScreen.routeName);
      throw Exception("User NOT valid!");
    }

    return user;
  }

  UserDTO get() {
    User user = _getFromAuth();
    
    return UserDTO(user.uid, user.displayName ?? "", user.email??"", '');
  }
}