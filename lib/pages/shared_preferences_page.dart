import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPage extends StatelessWidget {
  const SharedPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/sharedprefs/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: SpForm(),
    );
  }
}

class SpForm extends StatefulWidget {
  const SpForm({super.key});

  @override
  State<SpForm> createState() => _SpFormState();
}

class _SpFormState extends State<SpForm> {
  final SharedPreferencesAsync _preferencesAsync = SharedPreferencesAsync();
  bool isChecked = false;

  TextEditingController _itemController = TextEditingController();
  TextEditingController _countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 24),
            child: TextFormField(
              controller: _itemController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Item Name",
                icon: Icon(Icons.badge),
              ),
              textInputAction: TextInputAction.next,
              onSaved: (newValue) async {
                print(newValue);
                if (newValue != null) {
                  await _preferencesAsync.setString("item", newValue);
                } else {
                  await _preferencesAsync.remove("item");
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 24),
            child: TextFormField(
              controller: _countController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Item Count",
                icon: Icon(Icons.numbers),
              ),

              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSaved: (newValue) async {
                print(newValue);
                int? parsedValue = int.tryParse(newValue ?? "NaN");
                if (parsedValue != null) {
                  await _preferencesAsync.setInt("count", parsedValue);
                } else {
                  await _preferencesAsync.remove("count");
                }
              },
            ),
          ),
          FormField<bool>(
            builder: (FormFieldState field) => CheckboxListTile(
              // side: BorderSide(color: Colors.black),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("Star"),
              value: isChecked,
              onChanged: (bool? value) {
                if (value != null) {
                  field.didChange(value);
                  setState(() {
                    isChecked = value;
                  });
                }
              },
            ),
            onSaved: (newValue) async {
              print(newValue);
              if (newValue != null) {
                await _preferencesAsync.setBool("star", newValue);
              } else {
                await _preferencesAsync.remove("star");
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return FilledButton.icon(
                  onPressed: () {
                    Form.of(context).save();
                  },
                  label: Text(
                    "Save to Shared Preferences",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  icon: Icon(Icons.save),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return FilledButton.icon(
                  onPressed: () async {
                    String? item = await _preferencesAsync.getString("item");
                    int? count = await _preferencesAsync.getInt("count");
                    bool? star = await _preferencesAsync.getBool("star");

                    if (item == null && count == null && star == null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No data to restore!"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                      return;
                    }

                    if (item != null) {
                      _itemController.value = _itemController.value.copyWith(
                        text: item,
                      );
                    }
                    if (count != null) {
                      _countController.value = _countController.value.copyWith(
                        text: count.toRadixString(10),
                      );
                    }
                    if (star != null) {
                      setState(() {
                        isChecked = star;
                      });
                    }
                  },
                  label: Text(
                    "Restore from Shared Preferences",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  icon: Icon(Icons.restore),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return FilledButton.icon(
                  onPressed: () async {
                    await _preferencesAsync.remove("item");
                    await _preferencesAsync.remove("count");
                    await _preferencesAsync.remove("star");
                  },
                  label: Text(
                    "Clear Shared Preferences",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  icon: Icon(Icons.clear),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
