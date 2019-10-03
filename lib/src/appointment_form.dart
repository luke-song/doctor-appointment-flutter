import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AppointmentForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppointmentFormState();
  }
}

class AppointmentFormState extends State<AppointmentForm> {


  createPost(Map body) async {
  var url = "https://dnepraa36k.execute-api.us-east-1.amazonaws.com/dev/book-appointment";

  http.post(url, body: json.encode(body)).then((http.Response response) {
    final int statusCode = response.statusCode;
 
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    var data = json.decode(response.body);
    print(data);
  });
}
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
                        // TODO: get doctor id and date from user selection
                        var body = {
                          "doctorWorksheetId":0,
                          "startTime":"11:00:00",
                          "patientName": _name,
                          "phone": _phone,
                          "reason": _reason,
                          "date": "2019-10-4"
                        };
                        createPost(body);
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
