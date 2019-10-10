import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final Function onDateChange;
  final bool disabled;

  DatePicker(this.onDateChange, this.disabled);

  @override
  State<StatefulWidget> createState() {
    return new DatePickerState(onDateChange, disabled);
  }
}

class DatePickerState extends State<DatePicker> {
  DateTime _date = new DateTime.now();
  bool disabled;
  Function onDateChange;

  DatePickerState(this.onDateChange, this.disabled);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (onDateChange != null) {
        this.onDateChange(getFormatedDate(_date), _date);
      }
    });

    super.initState();
  }

  String getFormatedDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: new DateTime(2050),
    );

    if (picked != null && picked != _date) {
      print('Date selected: ${picked.toString()}');

      if (onDateChange != null) {
        this.onDateChange(getFormatedDate(picked), picked);
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
          RaisedButton(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '$formattedDate  ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.calendar_today),
            ]),
            onPressed: () {
              if (widget.disabled == true) {
                return;
              }
              _selectedDate(context);
            },
          ),
        ],
      ),
    );
  }
}
