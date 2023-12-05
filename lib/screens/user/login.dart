import 'package:chat_pdm/screens/chat/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/screens/user/creation.dart';
import '/user/user_service.dart';

class LoginScreen extends StatelessWidget {
    static const routeName = '/login';

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final UserService _userService = UserService();
    
    LoginScreen({super.key});

    void _onSubmit(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        try{
          await _userService.login(_usernameController.text, _passwordController.text);
          
          Get.offNamed(ChatListScreen.routeName, arguments: _userService.get());
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
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), 
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration( labelText: 'Email', border: OutlineInputBorder() ),
                  validator: (value) => (value!.isEmpty) ? 'Adicione um email!' : null,
                )
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), 
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration( labelText: 'Password', border: OutlineInputBorder()),
                  validator: (value) => (value!.isEmpty) ? 'Adicione uma senha!' : null,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _onSubmit(context),
                child: const Text('Enviar'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400], 
                  foregroundColor: Colors.white, 
                ),
                onPressed: () => Get.toNamed(UserCreationScreen.routeName),
                child: const Text('Criar usuário'),
              ),
            ],
          ),
        ),
      );
    }
}
