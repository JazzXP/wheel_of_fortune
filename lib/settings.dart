import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<String> items = [];
  bool loading = false;

  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tempList = prefs.getStringList('items');
    print(tempList);
    setState(() {
      items.addAll(tempList!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0 && !loading) {
      _getPrefs();
      loading = true;
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  primary: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setStringList('items', items);
                },
                child: Text('Save'),
              ),
              SizedBox(
                width: 20.0,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      items.add('');
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Add Row'),
                  )),
              Expanded(
                child: Container(),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    primary: Colors.white,
                  ),
                  onPressed: () async {
                    setState(() {
                      items.clear();
                    });
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setStringList('items', items);
                    Navigator.pop(context);
                  },
                  child: Text('Reset')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Row(
                children: [
                  Expanded(
                    key: ObjectKey(items[index]),
                    child: TextFormField(
                        initialValue: items[index],
                        decoration: InputDecoration(labelText: 'Item'),
                        onChanged: (text) {
                          items[index] = text;
                        }),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
