import 'package:flutter/material.dart';
import '../models/doctor.dart';
import './appointment_form.dart';

class SelectDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SelectDoctorState();
  }
}

// screen 1
class _SelectDoctorState extends State<SelectDoctor> {
  List<Doctor> doctors = [];
  @override
  initState() {
    super.initState();
    // fetching doctors and setting state
    // TODO: Add a loader while loading data
    Doctor.fetchAllDoctors().then((docs) {
      setState(() {
        this.doctors = docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약하고 싶으신 의사를 선택해주세요'),
      ),
      body: Column(
        children: doctors
            .map((doctor) => RaisedButton(
          child: Text(doctor.name),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentForm(
                  selectedDoctor: doctor,
                ),
              ),
            );
          },
        ))
            .toList(),
      ),
    );
  }
}
