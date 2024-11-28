import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dropdown Search Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownSearch<String>.multiSelection(
              mode: Mode.custom,
              items: (f, cs) => [
                "Monday",
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ],
              popupProps: PopupPropsMultiSelection.menu(
                disabledItemFn: (item) => item == 'Tuesday',
              ),
              dropdownBuilder: (ctx, selectedItem) =>
                  Icon(Icons.calendar_month_outlined, size: 54),
            ),
          ),
        ),
      ),
    );
  }
}