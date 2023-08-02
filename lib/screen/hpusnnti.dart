import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateTimePickerExample extends StatefulWidget {
  @override
  _DateTimePickerExampleState createState() => _DateTimePickerExampleState();
}

class _DateTimePickerExampleState extends State<DateTimePickerExample> {
  DateTime _dateTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Time Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_dateTime.toString()),
            InkWell(
              onTap: _showDatePicker,
              child: Text('Select Date and Time'),
            ),
          ],
        ),
      ),
    );
  }
}
// class DateTimePickerExample extends StatefulWidget {
//   @override
//   _DateTimePickerExampleState createState() => _DateTimePickerExampleState();
// }

// class _DateTimePickerExampleState extends State<DateTimePickerExample> {
//   TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);

//   void _showDatePicker() {
//     showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     ).then((value) {
//       setState(() {
//         _timeOfDay = value!;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Date Time Picker Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_timeOfDay.format(context).toString()),
//             InkWell(
//               onTap: _showDatePicker,
//               child: Text('Select Date and Time'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// Column(children: [
//   Row(
//     mainAxisAlignment:
//         MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Text(
//         '$jadwal["guru"]',
//         style: GoogleFonts.nunito(
//             fontSize: 20,
//             color: bluePrimary,
//             fontWeight: FontWeight.w700),
//       ),
//     ],
//   )
// ]),