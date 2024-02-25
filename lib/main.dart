import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NFC Availability Checker'),
        ),
        body: const NFCChecker(),
      ),
    );
  }
}

class NFCChecker extends StatefulWidget {
  const NFCChecker({Key? key}) : super(key: key);

  @override
  _NFCCheckerState createState() => _NFCCheckerState();
}

class _NFCCheckerState extends State<NFCChecker> {
  String _nfcStatus = "Checking NFC availability...";
  String _tagInfo = ""; // NFCタグ情報を保持する変数

  @override
  void initState() {
    super.initState();
    checkNFC();
  }

  Future<void> checkNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    setState(() {
      _nfcStatus = isAvailable ? "NFC is available" : "NFC is not available";
    });
    print(_nfcStatus);
  }

  Future<void> startNFCSession() async {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        print(tag);
        setState(() {
          _tagInfo = tag.data.toString(); // タグの情報を取得して状態を更新
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_nfcStatus),
          if (_nfcStatus == "NFC is available") ...[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // NFCセッションを開始してタグを読み取る
                startNFCSession();
              },
              child: const Text('Start NFC Session'),
            ),
          ],
          SizedBox(height: 20),
          Text(_tagInfo), // NFCタグの情報を表示
        ],
      ),
    );
  }
}
