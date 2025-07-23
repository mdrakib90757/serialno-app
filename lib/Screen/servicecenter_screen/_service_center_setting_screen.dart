import 'package:flutter/material.dart';

class ServiceCenterSetiingScreen extends StatefulWidget {
  const ServiceCenterSetiingScreen({super.key});

  @override
  State<ServiceCenterSetiingScreen> createState() => _ServiceCenterSetiingScreenState();
}

class _ServiceCenterSetiingScreenState extends State<ServiceCenterSetiingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("ServiceCenterSetiingScreen "),
      ),
    );
  }
}
