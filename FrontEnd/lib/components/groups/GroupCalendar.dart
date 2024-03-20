import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:front/const/colors/Colors.dart';

class GroupCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final Function onDaySelected;
  final Function onRangeSelected;

  const GroupCalendar({
    Key? key,
    required this.focusedDay,
    this.selectedDay,
    this.rangeStart,
    this.rangeEnd,
    required this.onDaySelected,
    required this.onRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay ,
      firstDay: DateTime(2024),
      lastDay: DateTime(2025),
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) =>
          onDaySelected(selectedDay, focusedDay),
      rangeStartDay: rangeStart,
      rangeEndDay: rangeEnd,
      onRangeSelected: (start, end, focusedDay) =>
          onRangeSelected(start, end, focusedDay),
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        todayDecoration: const BoxDecoration(
          color: FOCUS_COLOR,
          shape: BoxShape.circle,
        ),
        rangeHighlightColor: RANGE_COLOR,
        rangeStartDecoration: const BoxDecoration(
          color: BUTTON_COLOR,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: const BoxDecoration(
          color: BUTTON_COLOR,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
