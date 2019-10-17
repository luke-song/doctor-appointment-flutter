import 'package:flutter/material.dart';
import './dev.dart';

final String appBarText = isEnglish ? 'pick your doctor' : '의사를 선택해주세요.';
final String bodyText = isEnglish ? 'confirm your booking' : '예약을 확인해주세요.';

class ConfirmBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pick your doctor'),
        ),
        body: Column(
          children: <Widget>[Text('confirm your booking')],
        ));
  }
}
