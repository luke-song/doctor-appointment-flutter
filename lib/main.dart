import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(MaterialApp(
      title: 'Navigation Basics',
      home: PickDoctors(),
    ));

class PickDoctors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PickDoctorsState();
  }
}

// types to be used with api.
class Doctor {
  String name;
  int doctorWorksheetId;

  Doctor({this.name, this.doctorWorksheetId});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        name: json['name'], doctorWorksheetId: json['doctorWorksheetId']);
  }
}

class DoctorsList {
  List<Doctor> doctors;

  DoctorsList({this.doctors});

  factory DoctorsList.fromJson(Map<String, dynamic> json) {
    return DoctorsList(
      doctors: json['doctors']
          .map((doctor) => new Doctor.fromJson(doctor))
          .toList()
          .cast<Doctor>(),
    );
  }
}

// screen 1
class PickDoctorsState extends State<PickDoctors> {
  DoctorsList doctors = new DoctorsList(doctors: []);

  void fetchData(List<String> arguments) async {
    var url =
        "https://dnepraa36k.execute-api.us-east-1.amazonaws.com/dev/get-all-doctors";

    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        doctors = DoctorsList.fromJson(convert.jsonDecode(response.body));
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  initState() {
    super.initState();
    fetchData([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your doctor'),
      ),
      body: Column(
        children: doctors.doctors
            .map((doctor) => RaisedButton(
                  child: Text(doctor.name),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecondRoute(selectedDoctor: doctor),
                      ),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}

// page 2
class SecondRoute extends StatefulWidget {
  final Doctor selectedDoctor;
  SecondRoute({Key key, @required this.selectedDoctor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SecondRouteState(selectedDoctor: this.selectedDoctor);
  }
}

class SecondRouteState extends State<SecondRoute> {
  Doctor selectedDoctor;

  DateTime _date = new DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2016),
      lastDate: new DateTime(2020),
    );

    if (picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  SecondRouteState({this.selectedDoctor});

  @override
  Widget build(BuildContext context) {
    print('${selectedDoctor.name}, ${selectedDoctor.doctorWorksheetId}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Date selected: ${_date.toString()}'),
            RaisedButton(
              child: new Text('Press me'),
              onPressed: () {
                _selectedDate(context);
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
