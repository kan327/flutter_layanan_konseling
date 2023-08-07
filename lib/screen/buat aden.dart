import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyDateAndTimePicker(),
    );
  }
}

class MyDateAndTimePicker extends StatefulWidget {
  @override
  _MyDateAndTimePickerState createState() => _MyDateAndTimePickerState();
}

class _MyDateAndTimePickerState extends State<MyDateAndTimePicker> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();

    // String input
    String dateTimeString = "2023-06-14 14:54:00";

    // Parse tanggal dan waktu dari string
    List<String> dateTimeParts = dateTimeString.split(" ");
    String datePart = dateTimeParts[0]; // "2023-06-14"
    String timePart = dateTimeParts[1]; // "14:54"

    // Ubah ke dalam bentuk DateTime
    DateTime parsedDate = DateTime.parse(datePart + " " + timePart);

    // Simpan tanggal dan waktu yang telah di-parse
    selectedDate = parsedDate;
    selectedTime = TimeOfDay(hour: parsedDate.hour, minute: parsedDate.minute);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date and Time Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Selected Date: ${selectedDate.toLocal()}'.split(' ')[0],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Selected Time: ${selectedTime.format(context)}',
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select time'),
            ),
          ],
        ),
      ),
    );
  }
}
