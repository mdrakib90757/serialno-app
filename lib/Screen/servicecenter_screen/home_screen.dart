import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/custom_date_display/custom_date_display.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/new_serial_button_dialog/new_serial_button_dialog.dart';
import 'package:serialno_app/Widgets/custom_dropdown/custom_dropdown.dart';
import 'package:serialno_app/request_model/serviceCanter_request/next_button_request/next_button_request.dart';
import 'package:serialno_app/utils/date_formatter/date_formatter.dart';
import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_tabbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../model/serialService_model.dart';
import '../../model/serviceCenter_model.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../providers/serviceCenter_provider/addUser_serviceCenter_provider/SingleUserInfoProvider/singleUserInfoProvider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import '../../providers/serviceCenter_provider/nextButton_provider/nextButton_provider.dart';
import '../../utils/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _FormatedDateTime = "";
  Timer? _timer;
  ServiceCenterModel? _selectedServiceCenter;
  DateTime _selectedDate = DateTime.now();

  //TabBar List
  final List<String> tabList = ["Queue", "Served "];
  int indexNo = 0;
  late TabController tabController;
  final TextEditingController _dateController = TextEditingController();
  bool _isInitialDataLoaded = false;

  void _fetchDataForUI() {
    if (_selectedServiceCenter != null) {
      debugPrint(
        "🚀 FETCHING SERIALS for Service Center ID: ${_selectedServiceCenter!.id!}",
      );

      final formattedDate = DateFormatter.formatForApi(_selectedDate);

      Provider.of<GetNewSerialButtonProvider>(
        context,
        listen: false,
      ).fetchSerialsButton(_selectedServiceCenter!.id!, formattedDate);
    } else {
      debugPrint(
        "⚠️ _fetchDataForUI called but _selectedServiceCenter is null.",
      );
    }
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formatted = DateFormat('EEEE, dd MMMM,yyyy ').format(now);
    setState(() {
      _FormatedDateTime = formatted;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabList.length, vsync: this);
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialDataLoad();
    });
    _dateController.text = DateFormatter.formatForApi(_selectedDate);
  }

  Future<void> _initialDataLoad() async {
    final profileProvider = context.read<Getprofileprovider>();
    final serviceCenterProvider = context.read<GetAddButtonProvider>();
    final singleUserInfoProvider = context.read<SingleUserInfoProvider>();

    await profileProvider.fetchProfileData();
    final profile = profileProvider.profileData;

    if (mounted && profile != null) {
      final companyId = profile.currentCompany.id;
      final userId = profile.id;

      await Future.wait([
        serviceCenterProvider.fetchGetAddButton(companyId),
        singleUserInfoProvider.fetchUserInfo(companyId, userId),
      ]);

      if (mounted) {
        setState(() {
          _isInitialDataLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final serialProvider = context.watch<GetNewSerialButtonProvider>();
    final getProfile = context.watch<Getprofileprovider>();

    final getAddButtonProvider = context.watch<GetAddButtonProvider>();
    final singleUserInfoProvider = context.watch<SingleUserInfoProvider>();

    final profile = getProfile.profileData;
    final bool shouldShowAddButton =
        profile?.currentCompany.businessTypeId == 1;

    ServiceCenterModel? defaultSelectItem;
    if (getAddButtonProvider.serviceCenterList.isNotEmpty) {
      defaultSelectItem = getAddButtonProvider.serviceCenterList.first;
    }

    if (profile == null || getAddButtonProvider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColor().primariColor,
          ),
        ),
      );
    }
    final company = profile.currentCompany;

    if (!_isInitialDataLoaded ||
        getAddButtonProvider.isLoading ||
        singleUserInfoProvider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColor().primariColor,
          ),
        ),
      );
    }

    final userInfo = singleUserInfoProvider.userInfo;
    if (userInfo == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Could not load user's service center info.")),
      );
    }

    final allCompanyServiceCenters = getAddButtonProvider.serviceCenterList;
    final assignedCenterIds = userInfo.serviceCenterIds;
    final userAssignedServiceCenters = allCompanyServiceCenters.where((center) {
      return assignedCenterIds.contains(center.id);
    }).toList();

    if (_selectedServiceCenter == null &&
        userAssignedServiceCenters.isNotEmpty) {
      _selectedServiceCenter = userAssignedServiceCenters.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fetchDataForUI();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company.name, style: GoogleFonts.acme(fontSize: 25)),
            SizedBox(height: 10),
            CustomDateDisplay(),
            SizedBox(height: 10),

            if (shouldShowAddButton) ...[
              Container(
                height: 50,
                child: CustomDropdown<ServiceCenterModel>(
                  items: userAssignedServiceCenters,
                  value: _selectedServiceCenter,
                  onChanged: (ServiceCenterModel? newvalue) {
                    debugPrint(
                      "🔄 DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                    );
                    setState(() {
                      _selectedServiceCenter = newvalue;
                    });
                    _fetchDataForUI();
                  },
                  itemAsString: (ServiceCenterModel item) =>
                      item.name ?? "No Name",
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedServiceCenter?.name ??
                              "Select Service Center",
                          style: TextStyle(
                            color: _selectedServiceCenter != null
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "ServiceDate :",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: CustomTextField(
                      readOnly: true,
                      controller: _dateController,
                      hintText: _dateController.text,
                      textStyle: TextStyle(color: Colors.black),
                      isPassword: false,
                      suffixIcon: IconButton(
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColor().primariColor,
                                    // Header color
                                    onPrimary: Colors.white,
                                    // Header text color
                                    onSurface: Colors.black, // Body text color
                                  ),
                                  dialogTheme: DialogThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColor()
                                          .primariColor, // Button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (newDate != null && newDate != _selectedDate) {
                            setState(() {
                              _selectedDate = newDate;
                              _dateController.text = DateFormatter.formatForApi(
                                newDate,
                              );
                            });
                          }
                        },
                        icon: Icon(
                          Icons.date_range_outlined,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Serial Button
                GestureDetector(
                  onTap: () async {
                    final NewSerialButton =
                        Provider.of<NewSerialButtonProvider>(
                          context,
                          listen: false,
                        );

                    if (_selectedServiceCenter == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select a service center first.",
                          ),
                        ),
                      );
                      return;
                    }
                    final bool? wasSuccessful = await showDialog<bool?>(
                      context: context,
                      builder: (context) {
                        return NewSerialButtonDialog(
                          serviceCenterModel: _selectedServiceCenter!,
                        );
                      },
                    );

                    if (mounted) {
                      if (wasSuccessful == true) {
                        await CustomFlushbar.showSuccess(
                          context: context,
                          title: "Success",
                          message: "New serial has been booked successfully.",
                        );

                        _fetchDataForUI();
                      } else if (wasSuccessful == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            behavior: SnackBarBehavior.floating,
                            content: CustomSnackBarWidget(
                              title: "Error",
                              message:
                                  NewSerialButton.errorMessage ??
                                  "Failed to create new serial. Please try again.",
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select a service center first.",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor().primariColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 15),
                          SizedBox(width: 5),
                          Text(
                            "New Serial",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //NextButton
                GestureDetector(
                  onTap: () async {
                    final nextBtnProvider = Provider.of<nextButtonProvider>(
                      context,
                      listen: false,
                    );
                    final serialListProvider =
                        Provider.of<GetNewSerialButtonProvider>(
                          context,
                          listen: false,
                        );

                    // ২. serviceCenterId null check
                    if (_selectedServiceCenter == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select a service center first.",
                          ),
                        ),
                      );
                      return;
                    }

                    final String? serviceCenterId = _selectedServiceCenter?.id;
                    final String formattedDate = DateFormat(
                      'yyyy-MM-dd',
                    ).format(_selectedDate);
                    debugPrint(
                      "Triggering NEXT action for Service Center: $serviceCenterId on Date: $formattedDate",
                    );

                    NextButtonRequest nextRequest = NextButtonRequest(
                      date: formattedDate,
                    );
                    final success = await nextBtnProvider.NextButton(
                      nextRequest,
                      serviceCenterId!,
                    );

                    if (serviceCenterId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a service center."),
                        ),
                      );
                      return;
                    }

                    if (success && mounted) {
                      debugPrint(
                        "Next button action successful. Refreshing list...",
                      );

                      await serialListProvider.fetchSerialsButton(
                        serviceCenterId,
                        formattedDate,
                      );
                    } else if (mounted) {
                      debugPrint(" Next button action failed.");
                      final errorMessage =
                          nextButtonProvider().errorMessage ??
                          "An unknown error occurred.";

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          behavior: SnackBarBehavior.floating,
                          content: CustomSnackBarWidget(
                            title: "Error",
                            message: errorMessage,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor().primariColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey.shade600,
              labelColor: AppColor().primariColor,
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              indicatorColor: AppColor().primariColor,
              tabs: [
                Tab(text: "Queue(${serialProvider.totalQueueCount})"),
                Tab(text: "Served(${serialProvider.totalServedCount})"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [_buildQueueList(), _buildServedList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Status DialogBox
  void _showDialogBoxManage(SerialModel serial) {
    final String? serviceCenterId = _selectedServiceCenter?.id;
    final String? serviceId = serial.id;

    if (serviceCenterId == null || serviceId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error: ID is missing!")));
      return;
    }
    final String formattedDate = DateFormatter.formatForApi(_selectedDate);
    showDialog<bool?>(
      context: context,
      builder: (context) {
        return ManageSerialDialog(
          initialStatus: serial.status ?? "",
          serviceCenterId: serviceCenterId,
          serviceId: serviceId,
          date: formattedDate,
        );
      },
    ).then((wasSuccessful) {
      if (mounted) {
        if (wasSuccessful == true) {
          debugPrint("Dialog returned success. Refreshing UI...");
          _fetchDataForUI();
        }
      }
    });
  }

  Widget _buildQueueList() {
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColor().primariColor,
            ),
          );
        }
        final queueList = serialProvider.queueSerials;
        if (queueList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12),

                Text(
                  'No items in the queue',
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: queueList.length,
          itemBuilder: (context, index) {
            final serial = queueList[index];

            // S/L Time
            final String slTime = DateFormatter.formatForStatusTime(
              serial.createdTime,
            );
            // Status Time
            final String statusTime = DateFormatter.formatForStatusTime(
              serial.statusTime,
            );

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serial.name ?? "N/A",
                              style: TextStyle(
                                color: AppColor().primariColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _showDialogBoxManage(serial);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    serial.status.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.getStatusColor(
                                        serial.status,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(slTime),
                            Text(statusTime, style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        Text(serial.serviceType!.name.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // HomeScreen.dart
  Widget _buildServedList() {
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColor().primariColor,
            ),
          );
        }
        final servedList = serialProvider.servedSerials;

        if (servedList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12),

                Text(
                  'No items have been served yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: servedList.length + 1,
          itemBuilder: (context, index) {
            if (index == servedList.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ${serialProvider.totalServedCount} Person(s)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " ${serialProvider.totalServedAmount.toStringAsFixed(2)}BDT",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }
            final serial = servedList[index];
            // S/L Time
            final String slTime = DateFormatter.formatForStatusTime(
              serial.createdTime,
            );
            // Status Time
            final String statusTime = DateFormatter.formatForStatusTime(
              serial.statusTime,
            );

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              serial.name ?? "N/A",
                              style: TextStyle(
                                color: AppColor().primariColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _showDialogBoxManage(serial);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    serial.status.toString(),
                                    style: TextStyle(
                                      color: AppColor.getStatusColor(
                                        serial.status,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(slTime),
                            Text(
                              statusTime,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(serial.serviceType!.name.toString()),
                            Text("${serial.charge!.toString()} BDT"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
