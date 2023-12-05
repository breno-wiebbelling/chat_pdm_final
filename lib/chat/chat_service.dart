import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'chat_dto.dart';
import 'message_dto.dart';

class ChatService {
  
  late final DatabaseReference _chatListReference;
  late final StreamSubscription<DatabaseEvent> _chatListSubscription;

  ChatService(String userId, Function listenerCallback){
    userId = userId;
    _chatListReference = FirebaseDatabase.instance.ref("chats").child(userId);
    _chatListSubscription = _chatListReference.onValue.listen((DatabaseEvent event) {
      List<ChatDTO> newChatList = [];

      if(event.snapshot.value != null){
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

        if (data.isNotEmpty) {
          data.forEach((key, value) {
            newChatList.add(ChatDTO.fromJson(key, value));
          });
        }
      }

      listenerCallback(newChatList);
    });
  }

  Future<List<ChatDTO>> getChats() async {
    List<ChatDTO> chatList = [];

    try {
      DataSnapshot dataSnapshot = await _chatListReference.get();

      if(dataSnapshot.value == Null){ return List.empty(); }
      Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;

      if(data.isEmpty){ return List.empty(); }
      data.forEach((key, value) { chatList.add(ChatDTO.fromJson(key, value)); });
    } catch (error) {
      debugPrint("Error fetching chats: $error");
    }

    return chatList;
  }

  Future<ChatDTO?> createChat() async {
    try {
      var newChatReference = _chatListReference.push();
      newChatReference.set({
        'title': "Novo chat! :)", 
        'lastMessage': "No que posso lhe ajudar?!",
      });

      DataSnapshot snap = await newChatReference.get();
      newChatReference.child("messages")
        .push()
        .set(
          MessageDTO("No que posso lhe ajudar?!", DateTime.now(), false).toJson()
        );

      return ChatDTO.fromJson(newChatReference.key!, snap.value as Map<dynamic, dynamic>);
    } catch (error) {
      debugPrint("Error creating chat: $error");
    }

    return null;
  }

  Future<void> updateChatTitle(String chatId, String newTitle) async {
    try {
      Map<dynamic, dynamic> prevChat = (await _chatListReference.child(chatId).get()).value as Map<dynamic, dynamic>;
      prevChat['title'] = newTitle;

      await _chatListReference.child(chatId).set(prevChat);
    } catch (error) {
      debugPrint("Error updating chat title: $error");
    }
  }

  Future<void> deleteChat(ChatDTO chatDTO) async {
    try {
      await _chatListReference.child(chatDTO.id.toString()).remove();
    } catch (error) {
      debugPrint("Error deleting chat: $error");
    }
  }

  void dispose(){
    _chatListSubscription.cancel();
  }

  String getChatTitle(String chatId) {
    Map<dynamic, dynamic> chat = _chatListReference.child(chatId).get() as Map<dynamic, dynamic>;

    return ChatDTO.fromJson("id", chat).title ?? "Chat sem título!";
  }
}


