import 'package:flutter/material.dart';
import '../../utils/color.dart';

class CustomServicetakerNavigationbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomServicetakerNavigationbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomServicetakerNavigationbar> createState() =>
      _CustomServicetakerNavigationbarState();
}

class _CustomServicetakerNavigationbarState
    extends State<CustomServicetakerNavigationbar> {
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
        elevation: 50,
        selectedItemColor: AppColor().primariColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 33),
            activeIcon: Icon(Icons.home, size: 33),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync, size: 33),
            activeIcon: Icon(Icons.cloud_sync, size: 33),
            label: "My Serials",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 33),
            activeIcon: Icon(Icons.settings, size: 33),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 33),
            activeIcon: Icon(Icons.person, size: 33),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
