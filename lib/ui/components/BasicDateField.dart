import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// ...

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Дата начала работы',
        ),
      ),
      // Text('Basic date field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}
