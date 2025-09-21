import 'package:flutter/material.dart';

import '../../utils/color.dart';

class CustomServicecenterNavigationbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isExtraScreen;
  CustomServicecenterNavigationbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isExtraScreen = false,
  });

  @override
  State<CustomServicecenterNavigationbar> createState() =>
      _CustomServicecenterNavigationbarState();
}

class _CustomServicecenterNavigationbarState
    extends State<CustomServicecenterNavigationbar> {
  @override
  Widget build(BuildContext context) {
    // Define colors based on whether it's an extra screen
    final Color selectedColor = widget.isExtraScreen
        ? Colors.grey.shade600
        : AppColor().primariColor;
    final Color unselectedColor = Colors.grey.shade600;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 3),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: widget.currentIndex >= 0 ? widget.currentIndex : 0,
        onTap: widget.onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        elevation: 5.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : null,
            ), // Explicitly set color if extra screen
            activeIcon: Icon(
              Icons.home,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : selectedColor,
            ), // Active icon also grey if extra
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.corporate_fare_outlined,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : null,
            ),
            activeIcon: Icon(
              Icons.corporate_fare_rounded,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : selectedColor,
            ),
            label: "Service-Center",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category_outlined,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : null,
            ),
            activeIcon: Icon(
              Icons.category,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : selectedColor,
            ),
            label: "Service-Types",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : null,
            ),
            activeIcon: Icon(
              Icons.settings,
              size: 33,
              color: widget.isExtraScreen ? unselectedColor : selectedColor,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
