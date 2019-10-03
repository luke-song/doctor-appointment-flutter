import 'package:flutter/material.dart';

class AppointmentForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppointmentFormState();
  }
}

class AppointmentFormState extends State<AppointmentForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fill out the form"),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter full name'),
          ),
        ],
      ),
    );
  }
}
