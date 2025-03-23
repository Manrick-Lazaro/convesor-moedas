import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  Future<Map> data = getData();

  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

Future<Map> getData() async {
  Uri apiUrl = Uri.https("api.hgbrasil.com", "/finance", {"key": "3129d9f4"});

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}

Widget BuildTextField(
  String label,
  String prefix,
  TextEditingController controller,
  ValueChanged<String> onChange,
) {
  return TextField(
    decoration: InputDecoration(
      label: Text(label),
      labelStyle: TextStyle(color: Colors.amber),
      prefix: Text(prefix),
      border: OutlineInputBorder(),
    ),
    style: TextStyle(fontSize: 25, color: Colors.white),
    controller: controller,
    onChanged: onChange,
    keyboardType: TextInputType.number,
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar = 0.0;
  double euro = 0.0;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    _clearAll(text);

    double real = double.parse(text);

    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    _clearAll(text);

    double dolar = double.parse(text);

    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    _clearAll(text);

    double euro = double.parse(text);

    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _clearAll(String text) {
    if (text.isEmpty) {
      realController.clear();
      dolarController.clear();
      euroController.clear();
    }
  }

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
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao recuperar os dados :(',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.amber),
                  ),
                );
              } else {
                dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 150,
                      ),
                      BuildTextField(
                        "Reais",
                        "R\$ ",
                        realController,
                        _realChanged,
                      ),
                      Divider(color: Colors.black26),
                      BuildTextField(
                        "Dólares",
                        "US\$ ",
                        dolarController,
                        _dolarChanged,
                      ),
                      Divider(color: Colors.black26),
                      BuildTextField(
                        "Euros",
                        "€ ",
                        euroController,
                        _euroChanged,
                      ),
                    ],
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
