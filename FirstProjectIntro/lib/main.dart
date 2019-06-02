import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'Contador de pessoas',
      home: home() ));
}
class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _cont=0;
  String _info='get in';
  void _changeCont(int num){
    setState(() {
      _cont+=num;
      if(_cont<0){
        _info='???';
      }else if(_cont<=10){
        _info='get in';
      }else{
        _info='get out';
      }
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
        Image.asset('images/tristana.jpg',fit: BoxFit.cover,height: 800,),
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Pessoas: $_cont',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  child: Text(
                    '+1',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  onPressed: () {_changeCont(1);},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  child: Text(
                    '-1',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  onPressed: () {_changeCont(-1);},
                ),
              ),
            ],
          ),
          Text(
            _info,
            style: TextStyle(color: Colors.white),
          )
        ],
      )
      ],);
  }
}