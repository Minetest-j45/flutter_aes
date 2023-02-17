import 'dart:io';

import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AES',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Flutter AES Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("RSA"),
            TextButton(
              child: const Text('Generate new pair'),
              onPressed: () async {
                //Generate a new key pair
                var pair = await RSA.generate(4096);

                await Storage().writePub(pair.publicKey);
                await Storage().writePriv(pair.privateKey);
              },
            ),
            TextButton(
              child: const Text('Display saved pair'),
              onPressed: () async {
                var pub = await Storage().readPub();
                var priv = await Storage().readPriv();

                //set page to display keys
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _DisplayKeyPairState(pub, priv),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DisplayKeyPairState extends StatefulWidget {
  final String pub;
  final String priv;

  _DisplayKeyPairState(this.pub, this.priv);

  @override
  State<StatefulWidget> createState() => _DisplayKeyPairStateState(pub, priv);
}

class _DisplayKeyPairStateState extends State<_DisplayKeyPairState> {
  final String pub;
  final String priv;

  _DisplayKeyPairStateState(this.pub, this.priv);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Key Pair"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(pub),
              Text(priv),
            ],
          ),
        ),
      ),
    );
  }
}

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _pubFile async {
    final path = await _localPath;
    return File('$path/public.txt');
  }

  Future<File> writePub(String text) async {
    final file = await _pubFile;

    return file.writeAsString(text);
  }

  Future<String> readPub() async {
    try {
      final file = await _pubFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> get _privFile async {
    final path = await _localPath;
    return File('$path/priv.txt');
  }

  Future<File> writePriv(String text) async {
    final file = await _privFile;

    return file.writeAsString(text);
  }

  Future<String> readPriv() async {
    try {
      final file = await _privFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }
}
