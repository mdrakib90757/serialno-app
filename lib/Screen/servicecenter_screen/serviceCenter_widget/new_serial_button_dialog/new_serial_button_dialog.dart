import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Widgets/custom_dropdown/custom_dropdown.dart';
import 'package:serialno_app/Widgets/custom_labeltext.dart';
import 'package:serialno_app/Widgets/custom_textfield.dart';
import 'package:serialno_app/model/serviceCenter_model.dart';
import 'package:serialno_app/model/service_type_model.dart';
import 'package:serialno_app/providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/newSerialButton_request/newSerialButton_request.dart';
import 'package:serialno_app/utils/color.dart';
import 'package:serialno_app/utils/date_formatter/date_formatter.dart';

import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';

class NewSerialButtonDialog extends StatefulWidget {
  final ServiceCenterModel serviceCenterModel;
  const NewSerialButtonDialog({super.key, required this.serviceCenterModel});

  @override
  State<NewSerialButtonDialog> createState() => _NewSerialButtonDialogState();
}

class _NewSerialButtonDialogState extends State<NewSerialButtonDialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController _serviceCenterController;
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _serviceDateDisplayController;

  serviceTypeModel? _selectedServiceType;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _serviceCenterController = TextEditingController(
      text: widget.serviceCenterModel.name ?? "N/A",
    );
    _nameController = TextEditingController();
    _contactController = TextEditingController();

    _serviceDateDisplayController = TextEditingController(
      text: DateFormat('yyy-MM-dd').format(_selectedDate),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _serviceCenterController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _serviceDateDisplayController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor().primariColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor().primariColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;

        _serviceDateDisplayController.text = DateFormat(
          'yyy-MM-dd',
        ).format(_selectedDate);
      });
    }
  }

  Future<void> _saveNewSerial() async {
    if (!(_dialogFormKey.currentState?.validate() ?? false)) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    if (_selectedServiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a service type.")),
      );
      return;
    }

    final serialProvider = Provider.of<NewSerialButtonProvider>(
      context,
      listen: false,
    );

    String dateForApiCreate = DateFormatter.formatForApi(_selectedDate);
    String serviceTypeId = _selectedServiceType!.id!;
    String serviceCenterId = widget.serviceCenterModel.id!;

    NewSerialButtonRequest buttonRequest = NewSerialButtonRequest(
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      serviceDate: dateForApiCreate,
      name: _nameController.text,
      contactNo: _contactController.text,
      forSelf: true,
      isAdmin: true,
    );

    final success = await serialProvider.SerialButton(
      buttonRequest,
      serviceCenterId,
    );

    if (mounted && success) {
      Navigator.pop(context, true);
    } else if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    final getAddButton_serviceType_Provider =
        Provider.of<GetAddButtonServiceType_Provider>(context);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor().primariColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

        child: Container(
          //height: 415,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _dialogFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Serial",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_sharp),
                      ),
                    ],
                  ),

                  CustomLabeltext("Service Center"),
                  SizedBox(height: 8),
                  CustomTextField(
                    enabled: false,
                    fillColor: Colors.red.shade50,
                    filled: true,
                    controller: _serviceCenterController,
                    isPassword: false,
                  ),

                  SizedBox(height: 10),
                  CustomLabeltext("Service Type"),
                  SizedBox(height: 8),
                  CustomDropdown<serviceTypeModel>(
                    items: getAddButton_serviceType_Provider.serviceTypeList,
                    value: _selectedServiceType,
                    onChanged: (serviceTypeModel? newValue) {
                      setState(() {
                        _selectedServiceType = newValue;
                      });
                      print(newValue?.name);
                    },
                    itemAsString: (serviceTypeModel item) =>
                        item.name ?? "No Name",
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedServiceType?.name ?? "Select Service Type",
                            style: TextStyle(
                              color: _selectedServiceType != null
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

                  SizedBox(height: 10),
                  CustomLabeltext("Date"),
                  SizedBox(height: 8),
                  CustomTextField(
                    onTap: _selectDate,
                    hintText: DateFormatter.formatForApi(_selectedDate),
                    textStyle: TextStyle(color: Colors.grey.shade400),
                    isPassword: false,
                    controller: _serviceDateDisplayController,
                    // readOnly: true,
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
                        if (newDate != null) {
                          setState(() {
                            _selectedDate = newDate;
                            _serviceDateDisplayController.text = DateFormat(
                              "yyyy-MM-dd",
                            ).format(_selectedDate);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  CustomLabeltext("Name"),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    hintText: "Name",
                    isPassword: false,
                  ),

                  SizedBox(height: 10),
                  CustomLabeltext("Contact No"),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: _contactController,
                    hintText: "Contact",
                    isPassword: false,
                  ),
                  SizedBox(height: 10),

                  //Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().primariColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _saveNewSerial,
                        child: Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      //cancel Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
      ),
    );
  }
}
