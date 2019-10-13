import 'package:flutter/material.dart';
import '../models/doctor.dart';
import './select_time.dart';
import './dev.dart';

final String appBarText = isEnglish ? 'Fill out the form' : "양식을 작성해주세요";
final String continueText = isEnglish ? 'Pick Date and Time' : '날짜와 시간 정하기';

class AppointmentForm extends StatefulWidget {
  final Doctor selectedDoctor;

  AppointmentForm({Key key, @required this.selectedDoctor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new AppointmentFormState(selectedDoctor);
  }
}

class AppointmentFormState extends State<AppointmentForm> {
  final Doctor selectedDoctor;

  AppointmentFormState(this.selectedDoctor);

  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _phone = "";
  String _reason = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
      ),
      body: Container(
        padding: new EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: '홍길동',
                      labelText: '성함 *',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '성함을 입력해주세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.local_phone),
                      hintText: '01012345678',
                      labelText: '휴대폰번호 *',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '휴대폰 번호를 입력해주세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _phone = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.insert_comment),
                      hintText: '이유를 세문장 안으로 설명해주세요.',
                      labelText: '방문 이유를 입력해주세요.',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '세 문장안으로 방문하시는 이유를 설명해주세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                  SizedBox(width: 16.0, height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          this._formKey.currentState.save();
                          // Process data.
                          print('$_name, $_phone, $_reason');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectTime(
                                selectedDoctor: selectedDoctor,
                                patientName: _name,
                                phone: _phone,
                                reason: _reason,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(continueText),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
