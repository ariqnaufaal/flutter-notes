import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<String>> eventsMap = {}; // Changed to a map to store events for each date

void addEvent(BuildContext context, DateTime date) {
  TextEditingController eventController = TextEditingController(); // Controller for the text field
  String? existingEvent = eventsMap[date]?.isNotEmpty == true ? eventsMap[date]!.first : null;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(existingEvent != null ? "Event" : "Add Event"),
        content: existingEvent != null
            ? Text(existingEvent)
            : TextField(
                controller: eventController,
                decoration: const InputDecoration(hintText: "Enter event"),
              ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(existingEvent != null ? "Close" : "Add"),
            onPressed: () {
              if (existingEvent == null) {
                setState(() {
                  eventsMap[date] = [eventController.text]; // Add the event text to the list
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  void fetchNewEvents(int year, int month) async {
    Random random = Random();
    final newItems = List<DateTime>.generate(random.nextInt(40), (i) {
      return DateTime(year, month, random.nextInt(27) + 1);
    });
    setState(() {
      for (var date in newItems) {
        eventsMap[date] ??= []; // Ensure every new date has an empty list of events
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: PagedVerticalCalendar(
        addAutomaticKeepAlives: true,
        onMonthLoaded: fetchNewEvents,
        dayBuilder: (context, date) {
          final eventsThisDay = eventsMap[date] ?? []; // Get events for this date
          return GestureDetector(
            onTap: () => addEvent(context, date), // Add event on tap
            child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(DateFormat('d').format(date)),
    Wrap(
      children: [
        ...eventsThisDay.map((event) {
          return const Padding(
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
                SizedBox(height: 2),
              ],
            ),
          );
        }),
      ],
    ),
  ],
),
          );
        },
        onDayPressed: (day) {
          final eventsThisDay = eventsMap[day] ?? [];
          print('Items this day: $eventsThisDay');
        },
      ),
    );
  }
}
