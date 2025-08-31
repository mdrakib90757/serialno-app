import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import 'package:serialno_app/utils/color.dart';

class CustomDateDisplay extends StatefulWidget {
  const CustomDateDisplay({Key? key}) : super(key: key);

  @override
  _CustomDateDisplayState createState() => _CustomDateDisplayState();
}

class _CustomDateDisplayState extends State<CustomDateDisplay> {
  final DateTime _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        final servingSerial = serialProvider.currentlyServingSerial;

        final String disPlayText = servingSerial?.serialNo?.toString() ?? "0";
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy').format(_today),
                    style: TextStyle(
                      color: AppColor().primariColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: -8,
              top: -20,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColor().primariColor,
                child: Text(
                  "${disPlayText}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
