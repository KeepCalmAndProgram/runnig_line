import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Running-Line',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Running-Line Home Page',
        text: " ",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
    required this.title,
    required this.text,
  });
  final String title;
  String text;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController controller;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        child: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: RichText(
              text: TextSpan(
                text: widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 1.15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final text = await openDialog();
          setState(() => widget.text = text ?? '');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("What you want to say"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter you message"),
            controller: controller,
            onSubmitted: (_) => submitButton(),
          ),
          actions: [
            TextButton(
              child: Text("SUBMIT"),
              onPressed: submitButton,
            ),
          ],
        ),
      );

  void submitButton() {
    Navigator.of(context).pop(controller.text);
    _controller
      ..jumpTo(0)
      ..animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: widget.text.length),
        curve: Curves.easeInSine,
      );
    controller.clear();
  }
}
