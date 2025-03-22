import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  Future<Map> data = getData();

  runApp(MaterialApp(home: Home()));
}

Future<Map> getData() async {
  Uri apiUrl = Uri.https("api.hgbrasil.com", "/finance", {"key": "3129d9f4"});

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('conversor coin'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.amber),
                ),
              );
            default:
              if(snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao recuperar os dados :(',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.amber),
                  ),
                );
              }
          }
        },
      ),
      backgroundColor: Colors.black26,
    );
  }
}
