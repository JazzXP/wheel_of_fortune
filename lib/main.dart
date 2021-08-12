import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheel of Fortune',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Wheel of Fortune'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    _getPrefs();
  }
  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tempList = prefs.getStringList('items');

    if (tempList == null || tempList.length == 0) {
      tempList = [
        'Star Player Award',
        'Bottle of Wine',
        'Book Voucher',
        'Uber Eats Voucher',
        '6 pack of Beer',
        '30 min with Steve',
        'Star Player Award',
        'Bottle of Wine',
        'Book Voucher',
        'Uber Eats Voucher',
        '6 pack of Beer',
        'Odds & Evens 2.0 Business Case',
      ];
      prefs.setStringList('items', tempList);
    }
    setState(() {
      items.addAll(tempList!);
    });
  }

  StreamController<int> controller = StreamController<int>();
  final List<String> items = [];

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) {
      return Container();
    }
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      setState(() {
                        controller.add(Random().nextInt(items.length));
                      });
                    },
                    child: Text('Spin')),
              ),
            ],
          ),
          Expanded(
            child: FortuneWheel(
                indicators: [
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: TriangleIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
                items: items
                    .map(
                      (item) => FortuneItem(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 50.0, right: 20.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 30.0),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                selected: controller.stream,
                onFling: () {
                  controller.add(Random().nextInt(items.length));
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => Settings(),
          );
          items.clear();
          _getPrefs();
        },
        tooltip: 'Settings',
        child: Icon(Icons.settings),
      ),
    );
  }
}

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
