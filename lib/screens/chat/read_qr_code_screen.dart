import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'chat_read_screen.dart';

class ReadQRCodeScreen extends StatefulWidget {
  static const routeName = '/readQRCode';

  const ReadQRCodeScreen({super.key});

  @override
  ReadQRCodeScreenState createState() => ReadQRCodeScreenState();
}

class ReadQRCodeScreenState extends State<ReadQRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Get.offNamed(ReadChatScreenReadMode.routeName);
                },
                child: const Text(
                  'Scanning for QR Code...',
                  style: TextStyle(fontSize: 16),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        Get.offNamed(ReadChatScreenReadMode.routeName);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
