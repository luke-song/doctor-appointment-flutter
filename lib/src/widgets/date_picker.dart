import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  Function onDateChange;

  DatePicker(this.onDateChange);

  @override
  State<StatefulWidget> createState() {
    return new DatePickerState(onDateChange);
  }
}

class DatePickerState extends State<DatePicker> {
  DateTime _date = new DateTime.now();

  Function onDateChange;

  DatePickerState(this.onDateChange);

  String getFormatedDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2016),
      lastDate: new DateTime(2020),
    );

    if (picked != null && picked != _date) {
      print('Date selected: ${picked.toString()}');

      if (onDateChange != null) {
        this.onDateChange(getFormatedDate(picked));
      }
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = getFormatedDate(_date);
    return Center(
      child: Column(
        children: <Widget>[
          Text('선택하신 날짜: $formattedDate'),
          RaisedButton(
            child: new Text('날짜를 선택해주세요'),
            onPressed: () {
              _selectedDate(context);
            },
          ),
        ],
      ),
    );
  }
}

