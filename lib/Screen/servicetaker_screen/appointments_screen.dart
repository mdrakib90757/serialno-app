import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/mySerials/mySerial_provider.dart';
import 'package:serialno_app/utils/color.dart';
import 'package:shimmer/shimmer.dart';

import '../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
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
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MySerialServiceTakerProvider>(
        context,
        listen: false,
      ).fetchMyServices(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        Provider.of<MySerialServiceTakerProvider>(
          context,
          listen: false,
        ).fetchMyServices();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mySerialProvider = Provider.of<MySerialServiceTakerProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: (mySerialProvider.isLoading)
          ? CustomShimmerList(itemCount: 10)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Serial History",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: _buildBody(mySerialProvider)),
                ],
              ),
            ),
    );
  }

  Widget _buildBody(MySerialServiceTakerProvider provider) {
    // if (provider.isLoading) {
    //   return CustomShimmerList(itemCount: 10,);
    // }

    if (provider.sortedDates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No Serial Found',
              style: TextStyle(fontSize: 16, color: Colors.grey[300]),
            ),
          ],
        ),
      );
    }
    if (provider.sortedDates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
            SizedBox(height: 12),
            Text(
              'No Serial Found',
              style: TextStyle(fontSize: 16, color: Colors.grey[300]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,

      itemCount: provider.sortedDates.length + (provider.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= provider.sortedDates.length) {
          return provider.hasMore
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CustomLoading(
                      color: AppColor().primariColor,
                      // size: 20,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
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
                              style: TextStyle(color: Colors.grey.shade600),
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
                    ),
                  ),
                );
        }

        final dateKey = provider.sortedDates[index];

        final servicesForDate = provider.groupedServices[dateKey]!;
        String formattedDate;
        try {
          final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateKey);
          formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
        } catch (e) {
          print("Could not parse date: $dateKey. Error: $e");
          formattedDate = dateKey;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor().primariColor,
                  ),
                ),
              ),

              Column(
                children: servicesForDate.map((serialData) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 3),
                    // padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      title: Text(
                        serialData.company?.name ?? 'N/A',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serialData.serviceCenter?.name ?? 'N/A',
                            style: TextStyle(
                              color: AppColor().primariColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(serialData.serviceType?.name ?? 'N/A'),
                          Text(
                            "Serial No :- ${serialData.serialNo.toString()}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          Text(
                            'Booked at ${DateFormatter.formatForStatus(serialData.createdTime)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
