import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  static Future<bool> createAppointment(Map body) async {
    var url =
        "https://dnepraa36k.execute-api.us-east-1.amazonaws.com/dev/book-appointment";

    var response = await http.post(url, body: json.encode(body));
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    var data = json.decode(response.body);
    print(data);
    return true;
  }
}
