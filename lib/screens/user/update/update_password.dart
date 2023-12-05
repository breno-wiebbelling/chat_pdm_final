import 'package:chat_pdm/screens/chat/chat_list.dart';
import 'package:flutter/material.dart';
import '/screens/user/update/user_update_dto.dart';
import '/user/user_service.dart';

class UpdateUserPasswordScreen extends StatefulWidget {
    static const routeName = '/update/password';

    const UpdateUserPasswordScreen({super.key});

    @override
    State<UpdateUserPasswordScreen> createState() => _UpdateUserPasswordScreenState();
}

class _UpdateUserPasswordScreenState extends State<UpdateUserPasswordScreen> {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _currentPasswordController = TextEditingController();
    final TextEditingController _newPasswordController = TextEditingController();

    final UserService _userService = UserService();

    Future<void> _onSubmit(BuildContext context) async {
        if (_formKey.currentState!.validate()) {
            try{
                await _userService
                    .updateUserPassword( UserUpdateDTO("", "", _currentPasswordController.text, _newPasswordController.text))
                    .then((value) => {
                        if( value == true ) { 
                            if( context.mounted ) {
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil(ChatListScreen.routeName, (Route<dynamic> route) => false)
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
                    'Mudar Senha',
                    style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold ),
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), 
                    child:   TextFormField(
                        controller: _currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration( labelText: 'Senha atual', border: OutlineInputBorder() ),
                        validator: (value) => (value!.isEmpty) ? 'Adicione sua senha!' : null ,
                    ),
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), 
                    child:   TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration( labelText: 'Nova senha', border: OutlineInputBorder() ),
                        validator: (value) => _userService.validatePassword(value) 
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
