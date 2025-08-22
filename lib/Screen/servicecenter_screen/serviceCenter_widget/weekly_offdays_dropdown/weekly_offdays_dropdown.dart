import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class WeeklyOff_daysDropdown extends StatefulWidget {
  final List<String> availableDays;
  final Function(List<String> selectedDays) onSelectionChanged;

  const WeeklyOff_daysDropdown({
    Key? key,
    required this.availableDays,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _WeeklyOff_daysDropdownState createState() => _WeeklyOff_daysDropdownState();
}

class _WeeklyOff_daysDropdownState extends State<WeeklyOff_daysDropdown> {
  final List<String> _selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          'Select day(s)',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        items: widget.availableDays.map((day) {
          return DropdownMenuItem<String>(
            value: day,
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final isSelected = _selectedDays.contains(day);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDays.remove(day);
                      } else {
                        _selectedDays.add(day);
                      }

                      widget.onSelectionChanged(_selectedDays);
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(
                            Icons.check_box_outlined,
                            color: Colors.blue,
                          )
                        else
                          const Icon(Icons.check_box_outline_blank),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            day,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),

        value: _selectedDays.isEmpty ? null : _selectedDays.first,
        onChanged: (value) {},

        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),

        selectedItemBuilder: (context) {
          return widget.availableDays.map((item) {
            return Wrap(
              spacing: 6.0,
              runSpacing: 4.0,
              children: _selectedDays.map((day) {
                return Chip(
                  label: Text(day, style: const TextStyle(color: Colors.black)),
                  deleteIconColor: Colors.black.withOpacity(0.7),
                  onDeleted: () {
                    setState(() {
                      _selectedDays.remove(day);
                      widget.onSelectionChanged(_selectedDays);
                    });
                  },
                );
              }).toList(),
            );
          }).toList();
        },

        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        ),

        menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.zero),
      ),
    );
  }
}
