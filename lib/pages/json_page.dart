import 'dart:convert';

import 'package:class_demo/src/task_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonPage extends StatelessWidget {
  const JsonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JSON Parsing"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/jsonparsing/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: JsonDemo(),
    );
  }
}

enum JsonParsingStates { loadingString, parsingString, parsingJson, done }

class JsonDemo extends StatefulWidget {
  const JsonDemo({super.key});

  @override
  State<JsonDemo> createState() => _JsonDemoState();
}

class _JsonDemoState extends State<JsonDemo> {
  JsonParsingStates parsingStates = JsonParsingStates.loadingString;
  late List<Employee> employees;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString("assets/employees_100KB.json").then((value) {
      setState(() {
        parsingStates = JsonParsingStates.parsingString;
      });
      List<dynamic> json = jsonDecode(value);
      setState(() {
        parsingStates = JsonParsingStates.parsingJson;
      });
      employees = [];
      for (var e in json) {
        // print(e);
        employees.add(Employee.fromJson(e['employee']));
      }
      setState(() {
        parsingStates = JsonParsingStates.done;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (parsingStates) {
      case JsonParsingStates.loadingString:
        return Center(child: Text("Loading String"));
      case JsonParsingStates.parsingString:
        return Center(child: Text("Parsing String"));
      case JsonParsingStates.parsingJson:
        return Center(child: Text("Parsing JSON"));
      case JsonParsingStates.done:
        return SingleChildScrollView(child: EmployeeList(employees: employees));
    }
  }
}

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;
  const EmployeeList({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      children: employees
          .map<ExpansionPanelRadio>(
            (e) => ExpansionPanelRadio(
              value: e,
              headerBuilder: (context, isExpanded) {
                return ListTile(title: Text(e.name));
              },
              body: ListView(
                shrinkWrap: true,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(title: Text("Position"), subtitle: Text(e.position)),
                  ListTile(
                    title: Text("Department"),
                    subtitle: Text(e.department.name),
                  ),
                  ListTile(
                    title: Text("Manager"),
                    subtitle: Text(e.department.manager.name),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
