import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/doctor.dart';
import './widgets/date_picker.dart';
import './appointment_form.dart';

const BASE_URL = "https://dnepraa36k.execute-api.us-east-1.amazonaws.com/dev/get-doctor-availability-for-day/";

class SelectTime extends StatefulWidget {
  final Doctor selectedDoctor;
  SelectTime({Key key, @required this.selectedDoctor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SelectTimeState(selectedDoctor: this.selectedDoctor);
  }
}

class SelectTimeState extends State<SelectTime> {
  final Doctor selectedDoctor;

  List<String> availableTimes = [];

// TODO: Move this function elsewhere. 
  void fetchData(String formattedDate) async {
    var url =
        "$BASE_URL${selectedDoctor.doctorWorksheetId}/$formattedDate";

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

  SelectTimeState({this.selectedDoctor});

  @override
  Widget build(BuildContext context) {
    print('${selectedDoctor.name}, ${selectedDoctor.doctorWorksheetId}');

    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a date and time"),
      ),
      body: Column(
        children: <Widget>[
          DatePicker((date) {
            print(date.toString());
            fetchData(date);
          }),
          Column(
            children: availableTimes
                .map((timeString) => RaisedButton(
                      child: Text(timeString),
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppointmentForm(),
                      ),
                    );
                  },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
