import 'package:flutter/material.dart';

class NavigationPage2 extends StatelessWidget {
  const NavigationPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigation - Page 2"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/navigation/2/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Go back"),
        ),
      ),
    );
  }
}
