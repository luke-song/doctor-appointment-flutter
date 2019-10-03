import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

// types to be used with api.
class Doctor {
  String name;
  int doctorWorksheetId;

  Doctor({this.name, this.doctorWorksheetId});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        name: json['name'], doctorWorksheetId: json['doctorWorksheetId']);
  }

  static Future<List<Doctor>> fetchAllDoctors() async {
    var url =
        "https://dnepraa36k.execute-api.us-east-1.amazonaws.com/dev/get-all-doctors";

    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
        
        var json = convert.jsonDecode(response.body);
        List<Doctor> doctors = json['doctors']
          .map((doctor) => new Doctor.fromJson(doctor))
          .toList()
          .cast<Doctor>();

        return doctors;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return [];
    }
  }
}
