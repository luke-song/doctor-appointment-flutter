import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/doctor.dart';
import './widgets/date_picker.dart';
import './confirm_book.dart';
import './dev.dart';

final String appBarText =
    isEnglish ? 'Select a date and time' : "날짜와 시간을 선택해주세요";

const BASE_URL =
    "https://dnepraa36k.execute-api.us-east-1.amazonaws.com/dev/get-doctor-availability-for-day/";

class SelectTime extends StatefulWidget {
  final Doctor selectedDoctor;
  final String patientName;
  final String phone;
  final String reason;
  SelectTime(
      {Key key,
      @required this.selectedDoctor,
      @required this.patientName,
      @required this.reason,
      @required this.phone})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SelectTimeState(
      selectedDoctor: selectedDoctor,
      patientName: patientName,
      phone: phone,
      reason: reason,
    );
  }
}

class SelectTimeState extends State<SelectTime> {
  final Doctor selectedDoctor;
  final String patientName;
  final String phone;
  final String reason;
  String selectedDate;

  bool _loading = false;

  List<String> availableTimes = [];

  SelectTimeState(
      {@required this.selectedDoctor,
      @required this.patientName,
      @required this.reason,
      @required this.phone});

// TODO: Move this function elsewhere.
  void fetchData(String formattedDate) async {
    var url = "$BASE_URL${selectedDoctor.doctorWorksheetId}/$formattedDate";
    setState(() {
      _loading = true;
    });

    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      print(data);
      setState(() {
        availableTimes = data['availableTimes'].cast<String>();
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }

    setState(() {
      _loading = false;
    });
  }

  void _showDialog(String time) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("예약을 확인해주세요"),
          content: new Text(
              "예약을 이 날짜와 시간에 원하시는게 맞습니까? 날짜 : $selectedDate 시간 : $time."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
                // pop the current alert
                Navigator.of(context).pop();
                _showLoader(time);
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoader(String time) {
    final Map<String, dynamic> body = {
      "doctorWorksheetId": selectedDoctor.doctorWorksheetId,
      "startTime": time,
      "patientName": patientName,
      "phone": phone,
      "reason": reason,
      "date": selectedDate
    };
    Doctor.createAppointment(body).then((success) {
      // pop the loader
      Navigator.of(context).pop();
      _showSuccess();
      print('예약이 완료되었습니다');
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("예약을 신청하는중입니다"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: CircularProgressIndicator(),
                height: 24.0,
                width: 24.0,
              )
            ],
          ),
        );
      },
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("예약이 완료되었습니다!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('${selectedDoctor.name}, ${selectedDoctor.doctorWorksheetId}');
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '예약 날짜 선택하기 : ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            DatePicker((formattedDate, DateTime date) {
              print(formattedDate.toString());
              // if it's sunday
              if (date.weekday == 7) {
                setState(() {
                  availableTimes = [];
                  selectedDate = formattedDate;
                });
              } else {
                setState(() {
                  selectedDate = formattedDate;
                });
                // for every other day, lets fetch available times
                fetchData(formattedDate);
              }
            }, _loading),
            SizedBox(
              width: 16.0,
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Text(
                  '예약 시간 선택하기 : ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: this._loading
                  ? [
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          height: 24.0,
                          width: 24.0,
                        ),
                      )
                    ]
                  : availableTimes
                      .map((timeString) => RaisedButton(
                            child: Text(timeString),
                            onPressed: () {
                              _showDialog(timeString);
                            },
                          ))
                      .toList(),
            ),
            Text(!_loading && availableTimes.length == 0
                ? '병원이 쉬는날이라 예약이 불가능합니다.'
                : ''),
          ],
        ),
      ),
    );
  }
}
