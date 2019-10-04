import 'package:flutter/material.dart';

class ConfirmBook extends StatelessWidget {
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your doctor'),
      ),
      body: Column(
        children: <Widget>[
          Text('confirm your booking')
        ],
      )
    );
  }
}