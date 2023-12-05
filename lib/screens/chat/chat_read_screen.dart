import 'package:flutter/material.dart';
import '../../chat/chat_dto.dart';
import '../../chat/chat_service.dart';
import '/chat/message_dto.dart';
import '/chat/message_service.dart';

class ReadChatScreenReadMode extends StatefulWidget {
  static const routeName = '/chatScreenReadMode';

  const ReadChatScreenReadMode({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ReadChatScreenReadMode> {
  late MessageService _messageService;
  late ChatService _chatService;
  List<ChatMessage> messageList = [];
  final String _userId = "TWACXj3QBjduJIWz2LORKg1cWZK2";
  final String _chatId = "-Nkm6tnfJfdX-bjFjG2Y";
  late final String chatTitle;

  @override
  void initState() {
    super.initState();
    initMessageService();
    initChatService();
  }

  void initMessageService() {
    _messageService = MessageService(
      _userId,
      _chatId,
      (List<MessageDTO> listOfMessageDTO) {
        updateMessageList(listOfMessageDTO);
      },
    );

    _messageService.getMessages().then((value) {
      updateMessageList(value);
    });
  }

  void initChatService(){
    _chatService = ChatService(_userId, (List<ChatDTO> list){});
    chatTitle = _chatService.getChatTitle(_chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatTitle)
      ),
      body: Column(
        children: [
          Expanded(
            child: ResponseContainer(messageList: messageList),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageService.dispose();
    super.dispose();
  }

  updateMessageList(List<MessageDTO> listOfMessageDTO) {
    messageList = [];

    listOfMessageDTO.sort((a, b) => a.time.compareTo(b.time));

    for (var element in listOfMessageDTO) {
      messageList.add(ChatMessage(
        text: element.content,
        isUser: element.isUser,
      ));
    }

    setState(() {});
  }
}

class ResponseContainer extends StatelessWidget {
  final List<ChatMessage> messageList;

  const ResponseContainer({Key? key, required this.messageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff434654),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: messageList.length,
          itemBuilder: (context, index) {
            return messageList[index];
          },
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser}) : super(key: key);

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
