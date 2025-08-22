import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serialno_app/utils/color.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>  with
SingleTickerProviderStateMixin {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 11,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TimelineTile(
              alignment: TimelineAlign.start,


              // লাইনের স্টাইল
              beforeLineStyle: LineStyle(
                color:AppColor().primariColor,
                thickness: 1.5,

              ),
              afterLineStyle: LineStyle(
                color: AppColor().primariColor.withOpacity(0.5),
                thickness: 2,
              ),

              indicatorStyle: IndicatorStyle(
                indicatorXY: 0.9,
                width: 15,
                padding: const EdgeInsets.all(8),
                indicator: Container(
                  decoration: BoxDecoration(
                    color: AppColor().primariColor,
                    shape: BoxShape.circle,
                  ),),),



              endChild: Container(
                constraints: const BoxConstraints(
                  minHeight: 120,
                ),

                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Data"),
                    SizedBox(height: 4),
                    Text("Data"),
                    SizedBox(height: 4),
                    Text("Data"),
                    SizedBox(height: 4),
                    Text("Data"),
                    SizedBox(height: 8),
                    Text("Data", style: TextStyle(color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  }

