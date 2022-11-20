import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fast_rsa/fast_rsa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter aes',
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
                print(pub);
                print(priv);
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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

    // Write the file
    return file.writeAsString(text);
  }

  Future<String> readPub() async {
    try {
      final file = await _pubFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  Future<File> get _privFile async {
    final path = await _localPath;
    return File('$path/priv.txt');
  }

  Future<File> writePriv(String text) async {
    final file = await _privFile;

    // Write the file
    return file.writeAsString(text);
  }

  Future<String> readPriv() async {
    try {
      final file = await _privFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }
}
