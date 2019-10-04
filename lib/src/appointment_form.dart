import 'package:flutter/material.dart';
import '../models/doctor.dart';
import './select_time.dart';

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
        title: Text("Fill out the form"),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'John Doe',
                    labelText: 'Full Name *',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
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
                    hintText: '1234567890',
                    labelText: 'Phone Number *',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your phone number';
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
                    hintText: 'Reason...',
                    labelText: 'Please enter the reason for visit',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _reason = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                    child: Text('Continue'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
