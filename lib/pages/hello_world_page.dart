import 'package:flutter/material.dart';

class HelloWorldPage extends StatelessWidget {
  const HelloWorldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/helloworld/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: Center(child: Text("Hello World!")),
    );
  }
}
