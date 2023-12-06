import 'package:chat_pdm/chat/chat_service.dart';
import 'package:chat_pdm/user/user_dto.dart';
import 'package:chat_pdm/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../chat/chat_dto.dart';
import '/screens/common/dreawer_commons.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chatList';

  const ChatListScreen({super.key});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {

  late ScrollController scrollController;
  final UserService userService = UserService();
  late ChatService chatService;
  late List<ChatDTO> chatList = [];
  late final UserDTO userDTO;

  @override
  void initState() {
    scrollController = ScrollController();
    userDTO = userService.get();
    chatService = ChatService(
      userDTO.id, 
      (List<ChatDTO> listOfChatDTO){
        chatList = listOfChatDTO;
        setState(() {});
      }
    );

    chatService
      .getChats()
      .then((value){ 
        chatList = value; 
        
        setState(() {});
      });

    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    chatService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343541),
      appBar: AppBar(title: const Text('iChat'), backgroundColor: const Color(0xff343541)),
      drawer: DrawerCommons.getDefaultDrawer(userDTO),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.15,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xff434654),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return ChatItem(chat: chatList[index], chatService: chatService);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          chatService
            .createChat()
            .then((value){
              debugPrint(value.toString());
              Get.toNamed(
                '/chatScreen', 
                arguments: value
              );
            });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final ChatDTO chat;
  final ChatService chatService;
  const ChatItem({Key? key, required this.chat, required this.chatService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/chatScreen', arguments: chat);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(59, 7, 7, 7), 
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  chat.lastMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(112, 255, 255, 255)),
              onPressed: () => chatService.deleteChat(chat),
            ),
          ],
        ),
      ),
    );
  }
}
