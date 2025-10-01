import 'package:class_demo/utils/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class CodePageTemplate extends StatefulWidget {
  final Widget title;
  final String page;
  const CodePageTemplate({super.key, required this.title, required this.page});

  @override
  State<CodePageTemplate> createState() => _CodePageTemplateState();
}

class _CodePageTemplateState extends State<CodePageTemplate> {
  late Highlighter highlighter;
  late Future<String> code;
  ClipboardData? codeText;

  @override
  void initState() {
    super.initState();
    code = rootBundle.loadString(widget.page);
    code.then((value) {
      setState(() {
        codeText = ClipboardData(text: value);
      });
    });
  }

  @override
  void didChangeDependencies() {
    highlighter = AppGlobals.of(context).highlighter;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _codeEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        actions: [
          IconButton(
            onPressed: codeText != null
                ? () async {
                    await Clipboard.setData(codeText!);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Code copied to clipboard!"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  }
                : null,
            icon: Icon(Icons.copy),
            tooltip: "Copy",
          ),
        ],
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: FutureBuilder(
          future: code,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              case ConnectionState.active:
                return Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text("Error loading code!");
                } else {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(8),
                    scrollDirection: Axis.vertical,
                    child: RichText(
                      text: highlighter.highlight(snapshot.data!),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
