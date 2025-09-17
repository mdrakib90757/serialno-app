import 'package:flutter/material.dart';

import '../../utils/color.dart';

class CustomServicecenterNavigationbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  CustomServicecenterNavigationbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomServicecenterNavigationbar> createState() =>
      _CustomServicecenterNavigationbarState();
}

class _CustomServicecenterNavigationbarState
    extends State<CustomServicecenterNavigationbar> {
  @override
  Widget build(BuildContext context) {
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
        //backgroundColor: Colors.white,
        selectedItemColor: AppColor().primariColor,
        unselectedItemColor: Colors.grey[600],
        // showUnselectedLabels: true,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        elevation: 5.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 33),
            activeIcon: Icon(Icons.home, size: 33),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.corporate_fare_outlined, size: 33),
            activeIcon: Icon(Icons.corporate_fare_rounded, size: 33),
            label: "Service-Center",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined, size: 33),
            activeIcon: Icon(Icons.category, size: 33),
            label: "Service-Types",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 33),
            activeIcon: Icon(Icons.settings, size: 33),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
