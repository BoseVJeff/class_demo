import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadTextPage extends StatelessWidget {
  const ReadTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text file IO"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/readtext/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: const ReadFile(),
    );
  }
}

class ReadFile extends StatefulWidget {
  const ReadFile({super.key});

  @override
  State<ReadFile> createState() => _ReadFileState();
}

class _ReadFileState extends State<ReadFile> {
  late Future<String> fileText;

  @override
  void initState() {
    super.initState();
    fileText = rootBundle.loadString("assets/hello_world.txt");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fileText,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator(color: Colors.red));
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          case ConnectionState.done:
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error loading file!");
            } else {
              return SingleChildScrollView(
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                child: Text(snapshot.data ?? "No data available!"),
              );
            }
        }
      },
    );
  }
}
