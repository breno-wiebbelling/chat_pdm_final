import 'package:chat_pdm/chat/chat_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/chat/chat_dto.dart';
import '/chat/message_dto.dart';
import '/chat/message_service.dart';
import '/common/base_client.dart';
import '/user/user_dto.dart';
import '/user/user_service.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chatScreen';
  
  final ChatDTO chat = Get.arguments as ChatDTO;
  ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late final BaseClient _baseClient;
  late final UserService _userService;
  late MessageService _messageService;
  late ChatService _chatService;
  
  late TextEditingController titleController;
  late final TextEditingController promptController;
  late final ScrollController scrollController;

  String responseTxt = '';
  late var chat = widget.chat;
  List<ChatMessage> messageList = [];
  bool isEditingTitle = false;

  @override
  void initState() {
    promptController = TextEditingController();
    scrollController = ScrollController();
    _userService = UserService();
    _baseClient = BaseClient();
    titleController = TextEditingController(text: widget.chat.title);

    initMessageService();
    initChatService();
    
    super.initState();
  }

  void initMessageService(){
    UserDTO userDTO = _userService.get();

    _messageService = MessageService(
      userDTO.id,
      widget.chat.id!, 
      (List<MessageDTO> listOfMessageDTO){
        updateMessageList(listOfMessageDTO);
      }
    );

    _messageService
      .getMessages()
      .then((value){
        updateMessageList(value);
      });
  }

  void initChatService(){
    _chatService = ChatService(_userService.get().id, (List<ChatDTO> list){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343541),
      appBar: AppBar(
        backgroundColor: const Color(0xff343541),
        title: GestureDetector(
          onTap: () {
            setState(() {
              isEditingTitle = true;
            });
          },
          child: isEditingTitle
              ? TextFormField(
                  controller: titleController,
                  style: const TextStyle(color: Color(0xff343541)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Escreva o novo título',
                    hintStyle: TextStyle(color: Color.fromARGB(255, 196, 196, 196)),
                  ),
                  onFieldSubmitted: updateChatTitle,
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(chat.title ?? "Conversa sem título", style: const TextStyle(fontSize: 25, color: Colors.white)),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Chat QR Code", style: TextStyle(fontSize: 25, color: Colors.white)),
                            backgroundColor: const Color(0xff434654), 
                            content: Center(
                              child: QrImageView(
                                data: {'id': chat.id!, 'userId': _userService.get().id}.toString(),
                                version: QrVersions.auto,
                                size: 200.0,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Fechar"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.qr_code),
                    ),
                  ],
                ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ResponseContainer(
              responseTxt: responseTxt,
              messageList: messageList,
              scrollController: scrollController,
            ),
          ),
          TextFormCustomWidget(
            promptController: promptController,
            btnSubmit: completeSubmit,
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    promptController.dispose();
    scrollController.dispose();
    titleController.dispose();
    _messageService.dispose();
    super.dispose();
  }

  completeSubmit() async {
    setState(() { responseTxt = 'Loading...'; });

    MessageDTO promptMessage = MessageDTO(promptController.text, DateTime.now(), true);
    saveMessage(promptMessage);

    _baseClient
      .post(promptController.text)
      .then((value){
        saveMessage(MessageDTO(
          value['content'], 
          DateTime.now(), 
          false
        ));
      });
   
    promptController.clear();
  }

  saveMessage(MessageDTO newMessage) async {
    await _messageService.createMessage(newMessage);
  }

  updateMessageList(List<MessageDTO> listOfMessageDTO){
    messageList = [];
  
    listOfMessageDTO.sort((a,b) => a.time.compareTo(b.time));
    
    for (var element in listOfMessageDTO) {
      messageList.add(ChatMessage(
        text: element.content,
        isUser: element.isUser,
      ));
    }

    setState(() { 
      responseTxt=""; 
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });  
    });
  }

  updateChatTitle(String newChatTitle) async {
    await _chatService.updateChatTitle(chat.id!, newChatTitle);

    setState(() {
      isEditingTitle = false;
      chat.title = newChatTitle;
    });
  }
}

class ResponseContainer extends StatelessWidget {
  const ResponseContainer({
    Key? key,
    required this.responseTxt,
    required this.messageList,
    required this.scrollController,
  }) : super(key: key);

  final String responseTxt;
  final List<ChatMessage> messageList;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.35,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xff434654),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return messageList[index];
                },
              ),
            ),
            Text(
              responseTxt,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormCustomWidget extends StatelessWidget {
  const TextFormCustomWidget({
    Key? key,
    required this.promptController,
    required this.btnSubmit,
  }) : super(key: key);

  final TextEditingController promptController;
  final Function btnSubmit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                cursorColor: Colors.white,
                controller: promptController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff444653)),
                    borderRadius: BorderRadius.circular(5.5),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff444653)),
                  ),
                  filled: true,
                  fillColor: const Color(0xff444653),
                  hintText: 'Ask me anything!',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.5),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xff19bc99),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () => btnSubmit(),
                    icon: const Icon(Icons.send, color: Colors.white)
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          const SizedBox(width: 8.0),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xff19bc99) : const Color.fromARGB(255, 33, 35, 48),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
