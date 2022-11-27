import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Find All Universities in a Country'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _futureUnis = [];
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    void sendRequest(String value) async {
      setState(() {
        _isLoading = true;
      });
      var url = "http://universities.hipolabs.com/search?country=" + value;
      var response = await http.get(Uri.parse(url));
      var jsonRes = json.decode(response.body);

      // var res = List<String>.from(jsonRes['categories'] as List);
      var res = jsonRes.map((uni) => uni["name"] as String).toList();
      setState(() {
        _futureUnis = res;
        _isLoading = false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                onSubmitted: (String value) => {sendRequest(value)},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type a country name',
                ),
              ),
            ),
            createUnis(_isLoading, _futureUnis)
          ],
        ));
  }

  Widget createUnis(bool isLoading, List<dynamic> unis) {
    if (isLoading) {
      return const SizedBox(
        height: 100.0,
        child: CircularProgressIndicator(),
      );
    } else {
      if (unis.isNotEmpty) {
        return Column(
          children: [
            for (String uni in unis)
              SizedBox(
                // <-- use a sized box and change the height
                height: 40.0,

                child: ListTile(
                  title: Text(uni),
                ),
              ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    }
  }
}
