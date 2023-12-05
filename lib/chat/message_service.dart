import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'message_dto.dart';

class MessageService {
  
  late final DatabaseReference _messageListReference;
  late final StreamSubscription<DatabaseEvent> _messageListSubscription;

  MessageService(String userId, String chatId, Function listenerCallback){

    _messageListReference = FirebaseDatabase.instance.ref("chats").child(userId).child(chatId).child("messages");

    _messageListSubscription = _messageListReference.onValue.listen((DatabaseEvent event) {
      List<MessageDTO> newMessageList = [];

      if(event.snapshot.value != null){
        Map<Object?, Object?> data = event.snapshot.value as Map<Object?, Object?>;
        data.forEach((key, value) {
          newMessageList.add(MessageDTO.fromJson(value as Map<dynamic, dynamic>));
        });
      }

      listenerCallback(newMessageList);
    });
  }

  Future<List<MessageDTO>> getMessages() async {
    List<MessageDTO> messageList = [];

    try {
      DataSnapshot dataSnapshot = await _messageListReference.get();
      
      Map<Object?, Object?> data = dataSnapshot.value as Map<Object?, Object?>;

      data.forEach((key, value) {
        messageList.add(MessageDTO.fromJson(value as Map<dynamic, dynamic>));
      });
    } catch (error) {
      debugPrint("Error fetching messages: $error");
    }

    return messageList;
  }

  Future<void> createMessage(MessageDTO messageDTO) async {
    try {
      await _messageListReference
        .push()
        .set(messageDTO.toJson());
    }catch(error){
      debugPrint("Error creating message: $error");
    }
  }

  Future<void> deleteChat(MessageDTO messageDTO) async {
    try {
      await _messageListReference.child(messageDTO.id.toString()).remove();
    } catch (error) {
      debugPrint("Error deleting messages: $error");
    }
  }

  void dispose(){
    _messageListSubscription.cancel();
  }
}


