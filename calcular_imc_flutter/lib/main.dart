import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(
    home: home(),
  ));
}

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  Color maximumBlue = Color(0xff46B1C9);
  Color darkSkyBlue = Color(0xff84C0C6);
  Color cambridge = Color(0xff9FB7B9);
  Color grayx11 = Color(0xffBCC1BA);
  Color champagne = Color(0xffF2E2D2);
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  String _resp = 'Informe peso e altura';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _reset() {
    pesoController.text = '';
    alturaController.text = '';
    setState(() {
      _resp = 'Informe peso e altura';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calcularImc() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text) / 100;
      double imc = peso / (altura * altura);
      String imcPrecision = imc.toStringAsPrecision(3);
      if (imc < 18.6) {
        _resp = 'Abaixo do peso: $imcPrecision';
      } else if (imc < 25) {
        _resp = 'Peso normal: $imcPrecision';
      } else if (imc < 35) {
        _resp = 'Acima do peso: $imcPrecision';
      } else {
        _resp = 'Obesidade 1: $imcPrecision';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculador de IMC'),
          centerTitle: true,
          backgroundColor: maximumBlue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _reset,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 120,
                    color: maximumBlue,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Peso em Kilo(Kg)',
                        labelStyle: TextStyle(color: maximumBlue)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: maximumBlue, fontSize: 20),
                    controller: pesoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Insira seu peso';
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Altura(Cm)',
                        labelStyle: TextStyle(color: maximumBlue)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: maximumBlue, fontSize: 20),
                    controller: alturaController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Insira seu altura';
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      height: 60,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _calcularImc;
                          }
                        },
                        child: Text(
                          'Calcular',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: maximumBlue,
                      ),
                    ),
                  ),
                  Text(
                    _resp,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: maximumBlue),
                  )
                ],
              ),
            )));
  }
}
