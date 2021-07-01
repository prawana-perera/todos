import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FuelForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FuelState();
}

class _FuelState extends State<FuelForm> {
  final _currencies = ['Dollars', 'Euro', 'Pounds'];
  final double _formDistance = 5.0;

  var _distanceController = TextEditingController();
  var _avgController = TextEditingController();
  var _priceController = TextEditingController();

  String _result = '';
  String _currency = 'Dollars';

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Cost Calculator'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: _formDistance, bottom: _formDistance),
                child: TextField(
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: 'Distance',
                      hintText: 'e.g. 123',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  keyboardType: TextInputType.number,
                  controller: _distanceController,
                )),
            Padding(
                padding:
                    EdgeInsets.only(top: _formDistance, bottom: _formDistance),
                child: TextField(
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: 'Distance per unit',
                      hintText: 'e.g. 17',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  keyboardType: TextInputType.number,
                  controller: _avgController,
                )),
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                        labelStyle: textStyle,
                        labelText: 'Price',
                        hintText: 'e.g. 16.5',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                  )),
                  Container(width: 5 * _formDistance),
                  Expanded(
                      child: DropdownButton<String>(
                    value: _currency,
                    items: _currencies.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _currency = value ?? '';
                      });
                    },
                  ))
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: ElevatedButton(
                  child: Text(
                    'Submit',
                    textScaleFactor: 1.5,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColorDark,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                      )),
                  onPressed: () {
                    setState(() {
                      _result = _calculateCost();
                    });
                  },
                )),
                Expanded(
                    child: ElevatedButton(
                  child: Text(
                    'Reset',
                    textScaleFactor: 1.5,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).buttonColor,
                      textStyle: TextStyle(
                        color: Colors.black,
                      )),
                  onPressed: () {
                    setState(() {
                      _reset();
                    });
                  },
                )),
              ],
            ),
            Text(_result)
          ],
        ),
      ),
    );
  }

  String _calculateCost() {
    double _distance = double.parse(_distanceController.text);
    double _fuelCost = double.parse(_priceController.text);
    double _consumption = double.parse(_avgController.text);
    double _totalCost = _distance / _consumption * _fuelCost;

    return "The total cost of your trip is ${_totalCost.toStringAsFixed(2)} $_currency";
  }

  void _reset() {
    _distanceController.text = '';
    _priceController.text = '';
    _avgController.text = '';
    _result = '';
  }
}
