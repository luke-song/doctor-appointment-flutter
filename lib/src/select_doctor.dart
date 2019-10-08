import 'package:flutter/material.dart';
import '../models/doctor.dart';
import './appointment_form.dart';
import './dev.dart';

final String appBarText = isEnglish ? 'Select a doctor' : '송현민';

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
          title: Text(appBarText),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: doctors
              .map((doctor) => InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor)),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Text(doctor.name),
                            Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 24.0,
                            ),
                          ],
                        )),
                    onTap: () {
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
        )

        // Column(
        // children:
        // ),
        );
  }
}
