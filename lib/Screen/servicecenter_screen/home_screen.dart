import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/custom_date_display/custom_date_display.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/new_serial_button_dialog/new_serial_button_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/queue_list_edit_dialog/queue_list_edit_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/statusDialogServiceCenter/statusDialog_serviceCenter.dart';
import '../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../global_widgets/custom_flushbar.dart';
import '../../global_widgets/custom_sanckbar.dart';
import '../../global_widgets/custom_textfield.dart';
import '../../model/serialService_model.dart';
import '../../model/serviceCenter_model.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../providers/serviceCenter_provider/addUser_serviceCenter_provider/SingleUserInfoProvider/singleUserInfoProvider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import '../../providers/serviceCenter_provider/nextButton_provider/nextButton_provider.dart';
import '../../providers/serviceCenter_provider/statusButtonProvider/status_UpdateButton_provider.dart';
import '../../request_model/serviceCanter_request/status_UpdateButtonRequest/status_updateButtonRequest.dart';
import '../../utils/color.dart';
import '../../utils/date_formatter/date_formatter.dart';

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
        " FETCHING SERIALS for Service Center ID: ${_selectedServiceCenter!.id!}",
      );

      final formattedDate = DateFormatter.formatForApi(_selectedDate);

      Provider.of<GetNewSerialButtonProvider>(
        context,
        listen: false,
      ).fetchSerialsButton(_selectedServiceCenter!.id!, formattedDate);
    } else {
      debugPrint("⚠_fetchDataForUI called but _selectedServiceCenter is null.");
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
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;
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
          child: CustomLoading(
            color: AppColor().primariColor,
            // size: 20,
            strokeWidth: 2.5,
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
          child: CustomLoading(
            color: AppColor().primariColor,
            //size: 20,
            strokeWidth: 2.5,
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
            SizedBox(height: 8),
            //customToday date and serving circle
            CustomDateDisplay(selectedDate: _selectedDate),
            SizedBox(height: 5),
            //service center dropdown
            Container(
              height: 47,
              child: CustomDropdown<ServiceCenterModel>(
                items: userAssignedServiceCenters,
                value: _selectedServiceCenter,
                onChanged: (ServiceCenterModel? newvalue) {
                  debugPrint(
                    "DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
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
                        _selectedServiceCenter?.name ?? "Select Service Center",
                        style: TextStyle(
                          color: _selectedServiceCenter != null
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            //serviceCenter date
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
                  child: Container(
                    height: 45,
                    child: CustomTextField(
                      readOnly: true,
                      controller: _dateController,
                      hintText: todayString,
                      textStyle: TextStyle(color: Colors.black),
                      isPassword: false,
                      suffixIcon: IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  useMaterial3: false,
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
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (newDate != null && newDate != _selectedDate) {
                            setState(() {
                              _selectedDate = newDate;
                              _dateController.text = DateFormatter.formatForApi(
                                newDate,
                              );
                            });
                            _fetchDataForUI();
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

            //serial button and next button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Serial Button
                GestureDetector(
                  onTap: isToday
                      ? () async {
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
                                message:
                                    "New serial has been booked successfully.",
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
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColor().primariColor
                          : Colors.grey.shade200,
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
                          Icon(
                            Icons.add,
                            color: isToday
                                ? Colors.white
                                : Colors.grey.shade400,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "New Serial",
                            style: TextStyle(
                              color: isToday
                                  ? Colors.white
                                  : Colors.grey.shade400,
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
                  onTap: isToday
                      ? () async {
                          final serialProvider =
                              Provider.of<GetNewSerialButtonProvider>(
                                context,
                                listen: false,
                              );
                          final statusUpdateProvider =
                              Provider.of<statusUpdateButton_provder>(
                                context,
                                listen: false,
                              );

                          if (statusUpdateProvider.isLoading ||
                              serialProvider.isLoading) {
                            print("Already processing a request. Please wait.");
                            return;
                          }

                          final SerialModel? nextSerial =
                              serialProvider.nextInQueue;

                          if (nextSerial == null) {
                            print(
                              "No active serial in queue. Button is disabled.",
                            );
                            return;
                          }

                          final String currentStatus =
                              nextSerial.status?.toLowerCase() ?? "";

                          if ([
                            'booked',
                            'waiting',
                            'present',
                          ].contains(currentStatus)) {
                            StatusButtonRequest servingRequest =
                                StatusButtonRequest(
                                  serviceId: nextSerial.id!,
                                  serviceCenterId: nextSerial.serviceCenterId!,
                                  status: "Serving",
                                  isPresent: true,
                                );

                            final bool servingSuccess =
                                await statusUpdateProvider.updateStatus(
                                  servingRequest,
                                  nextSerial.serviceCenterId!,
                                  nextSerial.id!,
                                );

                            if (!servingSuccess) {
                              if (mounted) {
                                CustomFlushbar.showSuccess(
                                  context: context,
                                  title: "Status Updated",
                                  message:
                                      "Serial #${nextSerial.serialNo} is now Serving.",
                                );
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    statusUpdateProvider.errorMessage ??
                                        "Failed to update status.",
                                  ),
                                ),
                              );

                              return;
                            }

                            if (mounted) {
                              await serialProvider.fetchSerialsButton(
                                _selectedServiceCenter!.id!,
                                DateFormat('yyyy-MM-dd').format(_selectedDate),
                              );

                              final nextWaitingCandidate = serialProvider
                                  .queueSerials
                                  .firstWhereOrNull(
                                    (s) =>
                                        s.serialNo! > nextSerial.serialNo! &&
                                        s.status?.toLowerCase() == 'booked',
                                  );

                              if (nextWaitingCandidate != null) {
                                StatusButtonRequest waitingRequest =
                                    StatusButtonRequest(
                                      serviceId: nextWaitingCandidate.id!,
                                      serviceCenterId:
                                          nextWaitingCandidate.serviceCenterId!,
                                      status: "Waiting",
                                      isPresent: false,
                                    );
                                await statusUpdateProvider.updateStatus(
                                  waitingRequest,
                                  nextWaitingCandidate.serviceCenterId!,
                                  nextWaitingCandidate.id!,
                                );
                              }
                              await serialProvider.fetchSerialsButton(
                                _selectedServiceCenter!.id!,
                                DateFormat('yyyy-MM-dd').format(_selectedDate),
                              );
                            }
                          } else if (currentStatus == 'serving') {
                            final navigator = Navigator.of(context);

                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return ManageSerialDialog(
                                  serialDetails: nextSerial,
                                  date: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(_selectedDate),
                                );
                              },
                            );

                            if (result == true && navigator.mounted) {
                              print(
                                "Dialog returned success. Refreshing list and triggering auto-next...",
                              );

                              await serialProvider.fetchSerialsButton(
                                _selectedServiceCenter!.id!,
                                DateFormat('yyyy-MM-dd').format(_selectedDate),
                              );

                              final newNextSerial = serialProvider.nextInQueue;

                              if (newNextSerial != null) {
                                StatusButtonRequest newServingRequest =
                                    StatusButtonRequest(
                                      serviceId: newNextSerial.id!,
                                      serviceCenterId:
                                          newNextSerial.serviceCenterId!,
                                      status: "Serving",
                                      isPresent: true,
                                    );

                                final newServingSuccess =
                                    await statusUpdateProvider.updateStatus(
                                      newServingRequest,
                                      newNextSerial.serviceCenterId!,
                                      newNextSerial.id!,
                                    );

                                if (newServingSuccess) {
                                  await serialProvider.fetchSerialsButton(
                                    _selectedServiceCenter!.id!,
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDate),
                                  );

                                  final finalNextWaiting = serialProvider
                                      .queueSerials
                                      .firstWhereOrNull(
                                        (s) =>
                                            s.serialNo! >
                                                newNextSerial.serialNo! &&
                                            s.status?.toLowerCase() == 'booked',
                                      );

                                  if (finalNextWaiting != null) {
                                    StatusButtonRequest finalWaitingRequest =
                                        StatusButtonRequest(
                                          serviceId: finalNextWaiting.id!,
                                          serviceCenterId:
                                              finalNextWaiting.serviceCenterId!,
                                          status: "Waiting",
                                          isPresent: false,
                                        );
                                    await statusUpdateProvider.updateStatus(
                                      finalWaitingRequest,
                                      finalNextWaiting.serviceCenterId!,
                                      finalNextWaiting.id!,
                                    );
                                  }

                                  await serialProvider.fetchSerialsButton(
                                    _selectedServiceCenter!.id!,
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDate),
                                  );
                                }
                              }
                            }
                          }
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: !isToday || serialProvider.queueSerials.isEmpty
                          ? Colors.grey.shade200
                          : AppColor().primariColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color:
                                  !isToday ||
                                      serialProvider.queueSerials.isEmpty
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: !isToday || serialProvider.queueSerials.isEmpty
                              ? Colors.grey.shade400
                              : Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // queue and served tabBar
            TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey.shade600,
              labelColor: AppColor().primariColor,
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              indicatorColor: AppColor().primariColor,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "Queue(${serialProvider.totalQueueCount})"),
                Tab(text: "Served(${serialProvider.totalServedCount})"),
              ],
            ),
            SizedBox(height: 8),
            //tabBar list
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
          // initialStatus: serial.status ?? "",
          // serviceCenterId: serviceCenterId,
          // serviceId: serviceId,
          date: formattedDate,
          serialDetails: serial,
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

  //queue build Widget
  Widget _buildQueueList() {
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;

    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(
            child: CustomLoading(
              color: AppColor().primariColor,
              //size: 20,
              strokeWidth: 2.5,
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

            final bool canBeEdited = serial.status?.toLowerCase() != 'serving';
            return Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              padding: EdgeInsets.all(8),
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
                    padding: const EdgeInsets.only(top: 8),
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
                            Row(
                              children: [
                                Text(
                                  serial.name ?? "N/A",
                                  style: TextStyle(
                                    color: AppColor().primariColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),

                                if (isToday && canBeEdited) ...[
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return QueueListEditDialog(
                                            serviceCenterModel:
                                                _selectedServiceCenter!,
                                            serialToEdit: serial,
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: AppColor().primariColor,
                                    ),
                                  ),
                                ],
                              ],
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

  // served build widget
  Widget _buildServedList() {
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(
            child: CustomLoading(
              color: AppColor().primariColor,
              //size: 20,
              strokeWidth: 2.5,
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
              margin: EdgeInsets.symmetric(vertical: 3),
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
