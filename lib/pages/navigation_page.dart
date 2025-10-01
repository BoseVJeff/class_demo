import 'package:flutter/material.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigation - Page 1"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/navigation/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: Center(
        child: FilledButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed("/navigation/2");
          },
          child: Text("Go to Page 2"),
        ),
      ),
    );
  }
}
