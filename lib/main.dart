import 'package:emi_calculator/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emi_calculator/constants.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: Color(0xFFFDFDFD),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: kPrimaryColor),
      ),
    ),
    home: EMICalculator(),
  ));
}

class EMICalculator extends StatefulWidget {
  @override
  _EMICalculatorState createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  List _tenureTypes = ['Month(s)', 'Year(s)'];
  String _tenureType = "Year(s)";
  String _emiResult = "";

  final TextEditingController _principalAmount = TextEditingController();
  final TextEditingController _interestRate = TextEditingController();
  final TextEditingController _tenure = TextEditingController();

  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EMI Calculator'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Principal Amount:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15.0),
              TextField(
                style: kTextStyle,
                controller: _principalAmount,
                onChanged: (value) {},
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Principal Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              Text(
                'Interest Rate:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15.0),
              TextField(
                style: kTextStyle,
                controller: _interestRate,
                onChanged: (value) {},
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Interest Rate',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              Text(
                'Tenure:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextField(
                      style: kTextStyle,
                      controller: _tenure,
                      onChanged: (value) {},
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Tenure',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          _tenureType,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        Switch(
                          value: _switchValue,
                          activeColor: kPrimaryColor,
                          inactiveThumbColor: Color(0xFF1E559D),
                          onChanged: (bool value) {
                            print(value);

                            if (value) {
                              _tenureType = _tenureTypes[1];
                            } else {
                              _tenureType = _tenureTypes[0];
                            }

                            setState(() {
                              _switchValue = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RoundedButton(
                      onPressed: clearText,
                      title: 'Reset',
                      colour: kPrimaryColor,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: RoundedButton(
                      onPressed: _handleCalculation,
                      title: 'Calculate',
                      colour: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              emiResultsWidget(_emiResult)
            ],
          ),
        ),
      ),
    );
  }

  void _handleCalculation() {
    double A = 0.0;
    int P = int.parse(_principalAmount.text);
    double r = int.parse(_interestRate.text) / 12 / 100;
    int n = _tenureType == "Year(s)"
        ? int.parse(_tenure.text) * 12
        : int.parse(_tenure.text);

    A = (P * r * pow((1 + r), n) / (pow((1 + r), n) - 1));

    _emiResult = A.toStringAsFixed(2);

    setState(() {});
  }

  void clearText() {
    _principalAmount.clear();
    _interestRate.clear();
    _tenure.clear();
    _emiResult = '';
  }

  Widget emiResultsWidget(emiResult) {
    bool canShow = false;
    String _emiResult = emiResult;

    if (_emiResult.length > 0) {
      canShow = true;
    }
    return Container(
        margin: EdgeInsets.only(top: 40.0),
        child: canShow
            ? Center(
                child: Column(children: [
                  Text("Your Monthly EMI is",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Container(
                      child: Text(_emiResult,
                          style: TextStyle(
                              fontSize: 50.0, fontWeight: FontWeight.bold)))
                ]),
              )
            : Container());
  }
}
