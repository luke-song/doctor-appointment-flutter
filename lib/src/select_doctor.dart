import 'package:flutter/material.dart';
import '../models/doctor.dart';
import './select_time.dart';
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
    Doctor.fetchAllDoctors().then((docs){
      setState((){
        this.doctors = docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your doctor'),
      ),
      body: Column(
        children: doctors
            .map((doctor) => RaisedButton(
                  child: Text(doctor.name),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          // AppointmentForm()
                          SelectTime(selectedDoctor: doctor),
                      ),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}