import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HelloYou extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HelloYouSate();
}

class _HelloYouSate extends State<HelloYou> {
  final _currencies = ['Dollars', 'Euro', 'Pounds'];

  String _name = '';
  String _currency = 'Dollars';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Please enter your nam'),
              onChanged: (String value) => {
                setState(() {
                  _name = value;
                })
              },
            ),
            DropdownButton<String>(
              value: _currency,
              items: _currencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? value){
                setState(() {
                  _currency = value ?? '';
                });
              },
            ),
            Text("Hello $_name!")
          ],
        ),
      ),
    );
  }
}
