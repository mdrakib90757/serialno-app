import 'package:flutter/material.dart';
import 'package:serialno_app/utils/color.dart';

class CustomTab extends StatefulWidget {
  final TextEditingController? tabbarController;
  const CustomTab({super.key, this.tabbarController});

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          // "Combined" Button
          _buildTabItem(
            0,
            'Combined',
            const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
            ),
          ),
          Container(width: 1, color: Colors.grey.shade400),
          // "Service type wise" Button
          _buildTabItem(
            1,
            'Service type wise',
            const BorderRadius.only(
              topRight: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String text, BorderRadius borderRadius) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColor().primariColor : Colors.white,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
