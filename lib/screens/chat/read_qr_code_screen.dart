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
  bool scanning = true;

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
                  Get.toNamed(ReadChatScreenReadMode.routeName);
                },
                child: Text(
                  scanning ? 'Scanning for QR Code...' : 'QR Code Found!',
                  style: const TextStyle(fontSize: 16),
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
        scanning = false;
        Get.toNamed(ReadChatScreenReadMode.routeName);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
