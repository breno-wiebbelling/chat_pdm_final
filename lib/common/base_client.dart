import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../common/local_storage.dart';

class BaseClient{
  final String _baseUrl = "https://pdm-chat-back.vercel.app/send_message";
  final LocalStorage _localStorage = LocalStorage();

  Future<Map<String, dynamic>> post(String message) async {
    debugPrint(Map<String, dynamic>.from({ 'message': message }).toString());

    var response = await http.post(
        Uri.parse(_baseUrl), 
        headers: { 'authorization':await _localStorage.getString('token') },
        body: Map<String, dynamic>.from({ 'message': message })
        
    );

    return jsonDecode(response.body);
  }
}