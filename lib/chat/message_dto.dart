class MessageDTO {
  String? id;
  bool isUser;
  String content;
  DateTime time;

  MessageDTO(this.content, this.time, this.isUser);

  factory MessageDTO.fromJson(Map<dynamic, dynamic> json) {
    return MessageDTO(
      json['content'] ?? '',
      DateTime.parse(json['time']),
      json['isUser'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isUser': isUser,
      'content': content,
      'time': time.toIso8601String(),
    };
  }
}
