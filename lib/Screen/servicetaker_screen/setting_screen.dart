import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
         body:  Column(
           children: [
             Center(
              child: Text("Setting Screen"),

                 ),
           ],
         ),
       );
  }
}
