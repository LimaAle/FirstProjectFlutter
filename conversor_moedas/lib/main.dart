import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=29eb7597';
const plum = Color(0xff7e3f8f);
const lavender = Color(0xff81559B);
const grayblue = Color(0xff8C86AA);

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: lavender,
      primaryColor: plum,
    ),
  ));
}

Future<Map> getResponse() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar = 0.0;
  double euro = 0.0;
 void _clearText(){
   realController.text='';
   dolarController.text='';
   euroController.text='';
 }
  void _realChanged(String value) {
    if(value.isEmpty){
      _clearText();
      return;
    }
    double real = double.parse(value);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String value) {
    if(value.isEmpty){
      _clearText();
      return;
    }
    double dolar = double.parse(value);
    realController.text = (dolar * this.dolar).toStringAsPrecision(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsPrecision(2);
  }

  void _euroChanged(String value) {
    if(value.isEmpty){
      _clearText();
      return;
    }
    double euro = double.parse(value);
    realController.text = (euro * this.euro).toStringAsPrecision(2);
    dolarController.text=(euro*this.euro/dolar).toStringAsPrecision(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor'),
        backgroundColor: plum,
      ),
      body: FutureBuilder(
        future: getResponse(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando'),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro'),
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150, color: lavender),
                      buildTextField(
                          'Real', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextField(
                          'Dolar', 'US\$', dolarController, _dolarChanged),
                      Divider(),
                      buildTextField('Euro', '€', euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    onChanged: f,
    controller: controller,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    style: TextStyle(fontSize: 25, color: lavender),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: lavender, fontSize: 25),
      border: OutlineInputBorder(borderSide: const BorderSide(color: lavender)),
      prefixText: prefix,
      prefixStyle: TextStyle(color: lavender, fontSize: 25),
    ),
  );
}
