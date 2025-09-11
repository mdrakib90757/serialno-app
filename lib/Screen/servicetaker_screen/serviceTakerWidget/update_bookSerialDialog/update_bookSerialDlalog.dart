import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/providers/auth_provider/auth_providers.dart';
import 'package:serialno_app/request_model/seviceTaker_request/update_bookSerialRequest/update_bookSerialRequest.dart';
import '../../../../global_widgets/MyRadio Button.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/mybooked_model.dart';

import '../../../../model/service_type_model.dart';
import '../../../../providers/serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
import '../../../../providers/serviceTaker_provider/serviceType_serialbook_provider.dart';
import '../../../../providers/serviceTaker_provider/update_bookserialProvider/update_bookserial_provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/date_formatter/date_formatter.dart';
import '../../servicetaker_homescreen.dart';

class UpdateBookSerialDlalog extends StatefulWidget {
  final MybookedModel bookingDetails;
  const UpdateBookSerialDlalog({super.key, required this.bookingDetails});

  @override
  State<UpdateBookSerialDlalog> createState() => _UpdateBookSerialDlalogState();
}

class _UpdateBookSerialDlalogState extends State<UpdateBookSerialDlalog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceCenterController =
      TextEditingController();

  serviceTypeModel? _selectedServiceType;
  UserName? _selectUserName = UserName.Self;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isInit = true;
  final Date = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  void _initializeFields() {
    final booking = widget.bookingDetails;
    _serviceCenterController.text = booking.serviceCenter?.name ?? 'N/A';
    if (_selectUserName == UserName.Self) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _contactNoController.text =
          authProvider.userModel?.user.mobileNo ?? booking.contactNo ?? '';
      _nameController.text =
          (authProvider.userModel?.user.name ?? booking.name)!;
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else {
      _contactNoController.text = booking.contactNo ?? '';
      _nameController.text = booking.name!;
    }
  }

  void _fetchInitialData() {
    final companyId = widget.bookingDetails.company?.id;
    if (companyId != null) {
      Provider.of<serviceTypeSerialbook_Provider>(
        context,
        listen: false,
      ).serviceType_serialbook(companyId).then((_) {
        if (mounted) {
          // Ensure the widget is still in the tree
          final serviceTypeProvider =
              Provider.of<serviceTypeSerialbook_Provider>(
                context,
                listen: false,
              );
          setState(() {
            if (widget.bookingDetails.serviceType?.name != null) {
              _selectedServiceType = serviceTypeProvider.serviceTypeList
                  .firstWhere(
                    (type) =>
                        type.name == widget.bookingDetails.serviceType!.name,
                    orElse: () => null!,
                  );
            } else {
              _selectedServiceType = null;
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initializeFields();
      _fetchInitialData();
      _isInit = false;
    }
  }

  Future<void> _UpdateBook_serial() async {
    if (!_dialogFormKey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }
    final updateProvider = Provider.of<UpdateBookSerialProvider>(
      context,
      listen: false,
    );

    final bookingId = widget.bookingDetails.id;
    final serviceCenterId = widget.bookingDetails.serviceCenter?.id;
    final serviceTypeId = _selectedServiceType?.id;

    if (bookingId == null || serviceCenterId == null || serviceTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            message: "Error: Missing required information to update.",
            title: "Error",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    UpdateBookSerialRequest request = UpdateBookSerialRequest(
      id: bookingId,
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      forSelf: _selectUserName == UserName.Self,
      name: _nameController.text,
      contactNo: _contactNoController.text,
    );
    final success = await updateProvider.update_bookSerial(
      request,
      bookingId,
      serviceCenterId,
    );

    if (success) {
      final isoDate = DateTime.now().toIso8601String().split('.').first;
      await Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(isoDate);

      await Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(isoDate);

      Navigator.pop(context);
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Serial booked successfully!",
      );
    } else {
      if (!mounted) return;
      final updateProvider = Provider.of<UpdateBookSerialProvider>(
        context,
        listen: false,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: updateProvider.errorMessage ?? "Booking Failed",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateProvider = Provider.of<UpdateBookSerialProvider>(
      context,
      listen: false,
    );
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
                        "Edit Book a Serial",
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
                    controller: _serviceCenterController,
                    fillColor: Colors.red,
                    filled: true,
                    isPassword: false,
                    enabled: false,
                  ),

                  SizedBox(height: 10),
                  CustomLabeltext("Service Type"),
                  SizedBox(height: 8),
                  Consumer<serviceTypeSerialbook_Provider>(
                    builder: (context, serviceTypeProvider, child) {
                      return CustomDropdown<serviceTypeModel>(
                        items: serviceTypeProvider.serviceTypeList,

                        onChanged: (serviceTypeModel? newValue) {
                          setState(() {
                            _selectedServiceType = newValue;
                          });
                          print(newValue?.name);
                        },

                        itemAsString: (serviceTypeModel item) =>
                            item.name ?? "no data",
                        selectedItem: _selectedServiceType,
                        // validator: (value) {
                        //       if (value == null)
                        //         return "Please select a business type";
                        //       return null;
                        //     },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              serviceTypeProvider.isLoading
                                  ? CustomLoading(
                                      color: AppColor().primariColor,
                                      size: 20,
                                      strokeWidth: 2.5,
                                    )
                                  : Text(
                                      _selectedServiceType?.name ??
                                          "Select ServiceType",
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
                      );
                    },
                  ),
                  SizedBox(height: 10),

                  CustomLabeltext("Date"),
                  SizedBox(height: 8),
                  CustomTextField(
                    fillColor: Colors.red.shade50,
                    filled: true,
                    enabled: false,
                    controller: _dateController,
                    hintText: todayString,
                    isPassword: false,
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
                            _dateController.text = DateFormat(
                              "yyyy-MM-dd",
                            ).format(newDate);
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

                  Text(
                    "For",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  CustomRadioGroup<UserName>(
                    groupValue: _selectUserName,
                    items: const [UserName.Self, UserName.Other],
                    onChanged: (newValue) {
                      setState(() {
                        _selectUserName = newValue;
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        if (newValue == UserName.Self) {
                          _contactNoController.text =
                              authProvider.userModel?.user.mobileNo ?? '';
                          _nameController.text =
                              authProvider.userModel?.user.name ?? '';
                        } else {
                          _contactNoController.text =
                              widget.bookingDetails.contactNo ?? '';
                          _nameController.text = widget.bookingDetails.name!;
                        }
                      });
                    },
                    itemTitleBuilder: (value) =>
                        value == UserName.Self ? "Self" : "Other",
                  ),
                  SizedBox(height: 10),

                  Visibility(
                    visible: _selectUserName == UserName.Self,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomLabeltext("Name"),
                        SizedBox(height: 10),
                        CustomTextField(
                          enabled: false,
                          filled: true,
                          isPassword: false,
                          controller: _nameController,
                        ),
                        SizedBox(height: 10),
                        CustomLabeltext("Contact No"),
                        SizedBox(height: 10),
                        CustomTextField(
                          enabled: false,
                          filled: true,
                          isPassword: false,
                          controller: _contactNoController,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10),

                  Visibility(
                    visible: _selectUserName == UserName.Other,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomLabeltext("Contact No"),
                        SizedBox(height: 10),
                        CustomTextField(
                          isPassword: false,
                          controller: _contactNoController,
                        ),
                        SizedBox(height: 15),
                        CustomLabeltext("Name"),
                        SizedBox(height: 10),
                        CustomTextField(
                          isPassword: false,
                          controller: _nameController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                        onPressed: () async {
                          _UpdateBook_serial();
                        },
                        child: updateProvider.isLoading
                            ? Text(
                                "Please wait...",
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                "Request for serial",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      SizedBox(width: 10),
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
