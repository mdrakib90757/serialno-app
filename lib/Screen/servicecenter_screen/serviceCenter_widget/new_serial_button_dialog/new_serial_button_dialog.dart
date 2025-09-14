import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:serialno_app/model/serviceCenter_model.dart';
import 'package:serialno_app/model/service_type_model.dart';
import 'package:serialno_app/providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/newSerialButton_request/newSerialButton_request.dart';
import 'package:serialno_app/utils/color.dart';
import 'package:serialno_app/utils/date_formatter/date_formatter.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';

class NewSerialButtonDialog extends StatefulWidget {
  final ServiceCenterModel serviceCenterModel;
  const NewSerialButtonDialog({super.key, required this.serviceCenterModel});

  @override
  State<NewSerialButtonDialog> createState() => _NewSerialButtonDialogState();
}

class _NewSerialButtonDialogState extends State<NewSerialButtonDialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final _serviceTypeKey = GlobalKey<FormFieldState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController _serviceCenterController;
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _serviceDateDisplayController;

  serviceTypeModel? _selectedServiceType;
  DateTime _selectedDate = DateTime.now();
  bool _serviceTypeHasError = false;

  @override
  void initState() {
    super.initState();
    _serviceCenterController = TextEditingController(
      text: widget.serviceCenterModel.name ?? "N/A",
    );
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    //
    _serviceDateDisplayController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companyId = widget.serviceCenterModel.companyId;
      if (companyId != null && companyId.isNotEmpty) {
        Provider.of<GetAddButtonServiceType_Provider>(
          context,
          listen: false,
        ).fetchGetAddButton_ServiceType(companyId);
      } else {
        print("Error: Company ID is missing, cannot fetch service types.");
      }
    });
  }

  @override
  void dispose() {
    _serviceCenterController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _serviceDateDisplayController.dispose();
    super.dispose();
  }

  Future<void> _saveNewSerial() async {
    if (!(_dialogFormKey.currentState?.validate() ?? false)) {
      setState(() {
        _autovalidateMode = AutovalidateMode.disabled;
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

    final getSerialProvider = Provider.of<GetNewSerialButtonProvider>(
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
      forSelf: false,
      isAdmin: true,
    );

    final success = await serialProvider.SerialButton(
      buttonRequest,
      serviceCenterId,
    );

    if (success) {
      await getSerialProvider.fetchSerialsButton(
        serviceCenterId,
        dateForApiCreate,
      );
      Navigator.of(context);
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: " Add NewSerial Successfully",
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: serialProvider.errorMessage ?? "Failed to Add User",
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
    final getAddButton_serviceType_Provider =
        Provider.of<GetAddButtonServiceType_Provider>(context);
    final serialProvider = Provider.of<NewSerialButtonProvider>(context);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: AppColor().primariColor),
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
            autovalidateMode: _autovalidateMode,
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
                  const SizedBox(height: 8),
                  CustomTextField(
                    enabled: false,
                    fillColor: Colors.red.shade50,
                    filled: true,
                    controller: _serviceCenterController,
                    isPassword: false,
                  ),

                  const SizedBox(height: 10),
                  CustomLabeltext("Service Type"),
                  const SizedBox(height: 8),
                  Form(
                    key: _serviceTypeKey,
                    child: Consumer<GetAddButtonServiceType_Provider>(
                      builder: (context, serviceTypeProvider, child) {
                        return FormField<serviceTypeModel>(
                          validator: (value) {
                            if (_selectedServiceType == null) {
                              return "Please select a service type";
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 45,
                                  child: CustomDropdown<serviceTypeModel>(
                                    items: getAddButton_serviceType_Provider
                                        .serviceTypeList,
                                    value: _selectedServiceType,
                                    onChanged: (serviceTypeModel? newvalue) {
                                      debugPrint(
                                        "DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                                      );
                                      setState(() {
                                        _selectedServiceType = newvalue;
                                        formFieldState.didChange(newvalue);
                                      });
                                    },
                                    itemAsString: (serviceTypeModel item) =>
                                        item.name ?? "No Name",
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                      ),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          serviceTypeProvider.isLoading
                                              ? Align(
                                                  alignment: Alignment.center,
                                                  child: CustomLoading(
                                                    color:
                                                        AppColor().primariColor,
                                                    size: 20,
                                                    strokeWidth: 2.5,
                                                  ),
                                                )
                                              : Text(
                                                  _selectedServiceType?.name ??
                                                      "Select Service Center",
                                                  style: TextStyle(
                                                    color:
                                                        _selectedServiceType !=
                                                            null
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
                                if (formFieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      formFieldState.errorText!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  CustomLabeltext("Date"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "Select Date",
                    isPassword: false,
                    controller: _serviceDateDisplayController,
                    readOnly: true,
                    suffixIcon: IconButton(
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

                  const SizedBox(height: 10),
                  CustomLabeltext("Name"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    hintText: "Name",
                    isPassword: false,
                  ),

                  const SizedBox(height: 10),
                  CustomLabeltext("Contact No"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _contactController,
                    hintText: "Contact",
                    isPassword: false,
                  ),
                  const SizedBox(height: 10),

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
                        child: serialProvider.isLoading
                            ? Text(
                                "Please wait",
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                "save",
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
