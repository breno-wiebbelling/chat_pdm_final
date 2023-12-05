import 'package:chat_pdm/screens/chat/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../user/user_dto.dart';
import '../../user/user_service.dart';

class UserCreationScreen extends StatefulWidget {
  static const routeName = '/creation';

  const UserCreationScreen({super.key});

  @override
  State<UserCreationScreen> createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService();

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try{
        await _userService
          .create( UserDTO("", _usernameController.text, _emailController.text, _passwordController.text))
          .then((value) {
            if( value == true ) { 
              if( context.mounted ) {
                Get.toNamed(ChatListScreen.routeName);
              }  
            }
          });
      }catch(e){
        ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar( content: Text(e.toString()) ));
      }
    }
  }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Column(
                children: [
                    Text(
                        "Cadastro", 
                        style: TextStyle( 
                            color: Color.fromARGB(255, 255, 255, 255), 
                            fontSize: 15.0 
                        )
                    ),
                ],
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft:  Radius.circular(25)
                ),
            ),
            backgroundColor: const Color(0xFF242424),
            elevation: 0
        ),
        body: Form(
            key: _formKey,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                const Text(
                    'Mudar credenciais',
                    style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold ),
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), 
                    child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration( labelText: 'Novo username', border: OutlineInputBorder() ),
                        validator: (value) => _userService.usernameValidator(value),
                    ),
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), 
                    child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration( labelText: 'Novo email', border: OutlineInputBorder() ),
                        validator: (value) => _userService.emailValidator(value),
                    ),
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), 
                    child:  TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration( labelText: 'Insira a sua senha', border: OutlineInputBorder() ),
                        validator: (value) => _userService.validatePassword(value),
                    ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () => _onSubmit(context),
                    child: const Text('Enviar'),
                ),
            ],
            ),
        ),
        );
    }
}
