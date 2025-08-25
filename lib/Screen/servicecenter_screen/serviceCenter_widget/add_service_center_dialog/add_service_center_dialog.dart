import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/weekly_offdays_dropdown/weekly_offdays_dropdown.dart';
import 'package:serialno_app/Widgets/custom_flushbar.dart';
import 'package:serialno_app/Widgets/custom_labeltext.dart';
import 'package:serialno_app/Widgets/custom_sanckbar.dart';
import 'package:serialno_app/Widgets/custom_textfield.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButton_provider/add_Button_serviceCanter_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/addButton_request/add_Button_request.dart';
import 'package:serialno_app/utils/color.dart';

import '../add_service_center_tab_button/add_service_center_tab_button.dart';
import '../add_service_center_time_picker/add_service_center_time_picker.dart';

class AddServiceCenterDialog extends StatefulWidget {
  const AddServiceCenterDialog({Key? key}) : super(key: key);

  @override
  _AddServiceCenterDialogState createState() => _AddServiceCenterDialogState();
}

class _AddServiceCenterDialogState extends State<AddServiceCenterDialog>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hotLineController = TextEditingController();
  final TextEditingController _customFieldTextController =
      TextEditingController();

  final TextEditingController _weekdayController = TextEditingController();
  final TextEditingController _advanceSerialController =
      TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _reservedController = TextEditingController();
  final TextEditingController _dailyQuotaController = TextEditingController();

  late final TabController _tabControllerForDialog;
  String? _selectedPolicy;
  List<String> _selectedOffDays = [];
  final List<String> _availableDays = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  Time? _dialogStartTime;
  Time? _dialogEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabControllerForDialog = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabControllerForDialog.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _hotLineController.dispose();
    _customFieldTextController.dispose();
    _dailyQuotaController.dispose();
    super.dispose();
  }

  Future<void> _saveServiceCenter() async {
    if (!_dialogFormKey.currentState!.validate()) {
      return;
    }

    final navigator = Navigator.of(context);
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;
    final addButtonProvider = Provider.of<AddButtonProvider>(
      context,
      listen: false,
    );
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
      context,
      listen: false,
    );

    if (companyId == null) {
      CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Service Center Added Successful",
      );
      return;
    }
    DateTime? finalStartTime;
    if (_dialogStartTime != null) {
      final now = DateTime.now();
      finalStartTime = DateTime(
        now.year,
        now.month,
        now.day,
        _dialogStartTime!.hour,
        _dialogStartTime!.minute,
      );
    }

    DateTime? finalEndTime;
    if (_dialogEndTime != null) {
      final now = DateTime.now();
      finalEndTime = DateTime(
        now.year,
        now.month,
        now.day,
        _dialogEndTime!.hour,
        _dialogEndTime!.minute,
      );
    }

    AddButtonRequest buttonRequest = AddButtonRequest(
      id: "",
      name: _nameController.text,
      email: _emailController.text,
      hotlineNo: _hotLineController.text,
      companyId: companyId,
      weeklyOffDays: _selectedOffDays,
      daysOfAdvanceSerial: _advanceSerialController.text,
      noOfReservedSerials: _reservedController.text,
      serialNoPolicy: _selectedPolicy,
      dailyQuota: _dailyQuotaController.text,
      workingEndTime: finalEndTime,
      workingStartTime: finalStartTime,
    );

    final success = await addButtonProvider.addButton(buttonRequest, companyId);

    if (success) {
      navigator.pop();
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Service Center Added Successfully",
      );
      await getAddButtonProvider.fetchGetAddButton(companyId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: addButtonProvider.errorMessage ?? "Failed to Add Service",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor().primariColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
          key: _dialogFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Service Center",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_sharp),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                const CustomLabeltext("Name"),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _nameController,
                  hintText: "Name",
                  isPassword: false,
                ),

                const SizedBox(height: 13),
                const CustomLabeltext("Hotline No."),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _hotLineController,
                  hintText: "HotlineNo",
                  isPassword: false,
                ),

                const SizedBox(height: 13),
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor().primariColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 13),
                const Text(
                  "Weekly off-days",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 8),
                WeeklyOff_daysDropdown(
                  availableDays: _availableDays,
                  onSelectionChanged: (selectedDays) {
                    setState(() {
                      _selectedOffDays = selectedDays;
                    });
                  },
                ),

                SizedBox(height: 13),
                CustomFieldWithTabs(
                  onEndTimeChanged: (time) {
                    setState(() {
                      _dialogEndTime = time;
                    });
                  },
                  onStartTimeChanged: (time) {
                    setState(() {
                      _dialogStartTime = time;
                    });
                  },
                  tabController: _tabControllerForDialog,
                  textController: _customFieldTextController,
                ),

                SizedBox(height: 13),
                const Text(
                  "Advance Serial",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  cursorColor: Colors.grey.shade400,
                  controller: _advanceSerialController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor().primariColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    suffixIcon: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text("Day(s)")),
                    ),
                  ),
                ),

                SizedBox(height: 13),
                Text(
                  "Serial Number Policy",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(height: 8),
                CustomTab(
                  onPolicyChanged: (policy) {
                    setState(() {
                      _selectedPolicy = policy;
                    });
                  },
                ),

                SizedBox(height: 13),
                Text(
                  "Reserved Serials",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(height: 8),
                TextFormField(
                  cursorColor: Colors.grey.shade400,
                  controller: _reservedController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor().primariColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    prefixIcon: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      child: const Center(child: Text("First")),
                    ),
                    suffixIcon: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      child: const Center(child: Text("Serial(s)")),
                    ),
                  ),
                ),
                SizedBox(height: 13),

                const Text(
                  "Daily Quota",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  cursorColor: Colors.grey.shade400,
                  controller: _dailyQuotaController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor().primariColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    suffixIcon: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      child: const Center(child: Text("Day(s)")),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: AppColor().primariColor,
                      ),

                      onPressed: _saveServiceCenter,
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: AppColor().primariColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
