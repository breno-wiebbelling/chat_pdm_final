import 'message_dto.dart';

class ChatDTO {
  String? id;
  String? title;
  String? lastMessage;
  List<MessageDTO>? messages;

  ChatDTO(String this.id, String this.title, String this.lastMessage);
  ChatDTO.withMessages(this.id, this.title, this.messages);
  
  factory ChatDTO.fromJson(String id, Map<dynamic, dynamic> json) {
    return ChatDTO(id, json['title'] ?? '', json['lastMessage'] ?? '');
  }

}