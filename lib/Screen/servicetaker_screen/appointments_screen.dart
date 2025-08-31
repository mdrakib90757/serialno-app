import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/mySerials/mySerial_provider.dart';
import 'package:serialno_app/utils/color.dart';

import '../../utils/date_formatter/date_formatter.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  int pageNo = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MySerialServiceTakerProvider>(
        context,
        listen: false,
      ).MyServicesProvider(pageNo: pageNo, pageSize: pageSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final MySerialProvider = Provider.of<MySerialServiceTakerProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Serial History",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            MySerialProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primariColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : MySerialProvider.services.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 12),

                          Text(
                            'No Serial Found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: MySerialProvider.services.length + 1,
                      itemBuilder: (context, index) {
                        if (index == MySerialProvider.services.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    "End of List",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final serialData = MySerialProvider.services[index];

                        // S/L Time
                        final String slTime = DateFormatter.formatForStatus(
                          serialData.createdTime,
                        );

                        // Status Time
                        final String statusTime = DateFormatter.formatForStatus(
                          serialData.statusTime,
                        );
                        print(statusTime);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${serialData.company?.name}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${serialData.serviceCenter?.name}",
                                  style: TextStyle(
                                    color: AppColor().primariColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${serialData.serviceType?.name}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Serial No:-${serialData.serialNo}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "${serialData.status} at ${statusTime}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
