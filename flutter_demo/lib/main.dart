import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'strings.dart';
import 'LocalStorage.dart';
void main() => runApp(new GHFlutterApp());
class GHFlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.appTitle,
      home: new GHFlutter(),
    );
  }
}

class GHFlutter extends StatefulWidget {
  @override
  createState() => new GHFlutterState();
}
class GHFlutterState extends State<GHFlutter> {
  var _members = [];
  var appTitle = "";
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text(appTitle),
      ),
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _members.length,
          itemBuilder: (BuildContext context, int position) {
            return _buildRow(position);
          }),
    );
  }
  @override
  Widget _buildRow(int i) {
    return new ListTile(
        title: new Text("${_members[i]["login"]}", style: _biggerFont),
      onTap: (){
        LocalStorage.save("title", "${_members[i]["login"]}");
      },
    );
  }

  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    String dataURL = "https://api.github.com/orgs/raywenderlich/members";
    http.Response response = await http.get(dataURL);
    var v = await LocalStorage.get("title");
    setState(() {
      _members = jsonDecode(response.body);
      appTitle = v??Strings.appTitle;
    });
  }
}