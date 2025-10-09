import 'dart:convert';

import 'package:class_demo/src/github.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ApiPage extends StatelessWidget {
  const ApiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Demo"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/apiparsing/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: GhApi(),
    );
  }
}

class GhApi extends StatefulWidget {
  const GhApi({super.key});

  @override
  State<GhApi> createState() => _GhApiState();
}

class _GhApiState extends State<GhApi> {
  final Uri apiUri = Uri.parse(
    "https://api.github.com/repos/bosevjeff/class_demo/commits",
  );
  late Client client;
  late Future<List<GhCommitItem>> commitsFuture;

  @override
  void initState() {
    super.initState();
    client = Client();
    commitsFuture = getCommits();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<List<GhCommitItem>> getCommits() async {
    Response response = await client.get(apiUri);
    String resRaw = response.body;
    List<dynamic> json = jsonDecode(resRaw);
    List<GhCommitItem> items = json
        .map((e) => GhCommitItem.fromJson(e))
        .toList(growable: false);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GhCommitItem>>(
      future: commitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "${snapshot.error!.toString()}\n${snapshot.stackTrace}",
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(child: Text("No Data recieved!"));
        } else {
          List<GhCommitItem> items = snapshot.data!;
          return SingleChildScrollView(child: GhCommitsView(items: items));
        }
      },
    );
  }
}

class GhCommitsView extends StatelessWidget {
  final List<GhCommitItem> items;
  const GhCommitsView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      children: items
          .map<ExpansionPanelRadio>(
            (c) => ExpansionPanelRadio(
              value: c,
              headerBuilder: (_, _) => ListTile(
                title: Text(
                  c.commit.message,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
              body: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text("Message"),
                    subtitle: Text(c.commit.message),
                  ),
                  ListTile(
                    title: Text("Author"),
                    subtitle: Text(c.author.login),
                  ),
                  ListTile(title: Text("Commit SHA"), subtitle: Text(c.sha)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
