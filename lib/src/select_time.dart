import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/doctor.dart';
import './widgets/date_picker.dart';
import './confirm_book.dart';

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

  List<String> availableTimes = [];

  SelectTimeState(
      {@required this.selectedDoctor,
        @required this.patientName,
        @required this.reason,
        @required this.phone});

// TODO: Move this function elsewhere.
  void fetchData(String formattedDate) async {
    var url = "$BASE_URL${selectedDoctor.doctorWorksheetId}/$formattedDate";

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
  }

  @override
  Widget build(BuildContext context) {
    print('${selectedDoctor.name}, ${selectedDoctor.doctorWorksheetId}');

    return Scaffold(
      appBar: AppBar(
        title: Text("날짜와 시간을 선택해주세요"),
      ),
      body: Column(
        children: <Widget>[
          DatePicker((date) {
            print(date.toString());
            fetchData(date);
            setState(() {
              selectedDate = date;
            });
          }),
          Column(
            children: availableTimes
                .map((timeString) => RaisedButton(
              child: Text(timeString),
              onPressed: () {
                final Map<String, dynamic> body = {
                  "doctorWorksheetId": selectedDoctor.doctorWorksheetId,
                  "startTime": timeString,
                  "patientName": patientName,
                  "phone": phone,
                  "reason": reason,
                  "date": selectedDate
                };
                Doctor.createAppointment(body).then((success) {
                  print('Appointment created');
                });
                // TODO: Add the confirm appointment screen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ConfirmBook(),
                //   ),
                // );
              },
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}