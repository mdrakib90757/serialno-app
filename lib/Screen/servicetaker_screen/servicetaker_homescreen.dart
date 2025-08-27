import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/api/auth_api/auth_api.dart';
import 'package:serialno_app/model/mybooked_model.dart';
import 'package:serialno_app/model/organization_model.dart';

import 'package:serialno_app/model/serviceCenter_model.dart';
import 'package:serialno_app/model/service_type_model.dart';

import 'package:serialno_app/providers/serviceTaker_provider/bookSerialButton_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/ServiceCenterByTypeProvider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/commentCancelButton_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/getBookSerial_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/serviceCenter_serialBook.dart';
import 'package:serialno_app/providers/serviceTaker_provider/serviceType_serialbook_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/update_bookserial_provider.dart';
import '../../Widgets/MyRadio Button.dart';
import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../model/user_model.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../providers/serviceTaker_provider/organization_provider.dart';

import '../../utils/color.dart';

class ServicetakerHomescreen extends StatefulWidget {
  final String businessTypeId;
  const ServicetakerHomescreen({super.key, required this.businessTypeId});

  @override
  State<ServicetakerHomescreen> createState() => _ServicetakerHomescreenState();
}

enum UserName { Self, Other }

class _ServicetakerHomescreenState extends State<ServicetakerHomescreen> {
  List<Businesstype> _businessTypes = [];
  Businesstype? _selectedBusinessType;
  bool _isLoadingBusinessTypes = false;
  String? _businessTypeError;

  DateTime date = DateTime(2022, 12, 24);
  bool _isInit = true;
  bool _controllersInitialized = false;

  String _FormatedDateTime = "";
  Timer? _timer;
  DateTime _selectedDate = DateTime.now();

  void _updateTime() {
    if (mounted) {
      final DateTime now = DateTime.now();
      final String formatted = DateFormat('EEE, dd MMMM, yyyy ').format(now);
      setState(() {
        _FormatedDateTime = formatted;
      });
    }
  }

  // BusinessType LoadIng
  Future<void> _loadBusinessTypes() async {
    try {
      final types = await AuthApi().fetchBusinessType();
      setState(() {
        _businessTypes = types;
        _selectedBusinessType = null;
        print("Loaded Business Types: ${types.length}");
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _businessTypeError = e.toString();
          _businessTypeError = "Failed to load business types";
          debugPrint('Error loading business types: $e');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBusinessTypes = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(today);

      Provider.of<OrganizationProvider>(
        context,
        listen: false,
      ).get_Organization(businessTypeId: widget.businessTypeId);
      _loadBusinessTypes();
      _updateTime();
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<AuthProvider>(context, listen: false).loadUserFromToken();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  TextEditingController contactNoController = TextEditingController();
  TextEditingController NameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Timedate = _FormatedDateTime;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final authProvider = Provider.of<AuthProvider>(context);

    final bookSerialButton = Provider.of<GetBookSerialProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          if (authProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor().primariColor,
                strokeWidth: 2.5,
              ),
            );
          }
          if (authProvider.userModel == null) {
            return Center(child: Text("No User Data found. Please try again."));
          }
          ;
          if (!_controllersInitialized) {
            contactNoController.text = authProvider.userModel!.user.mobileNo;
            NameController.text = authProvider.userModel!.user.name;
            _controllersInitialized = true;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Timedate,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDialogBox(context);
                        },
                        child: Container(
                          width: 130,
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
                                SizedBox(width: 7),
                                Text(
                                  "Book Serial",
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
                    ],
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    child: Consumer<GetBookSerialProvider>(
                      builder: (context, bookSerialProvider, child) {
                        if (bookSerialProvider.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor().primariColor,
                              strokeWidth: 2.5,
                            ),
                          );
                        }

                        if (bookSerialProvider.bookSerialList.isEmpty) {
                          return Center(
                            child: Text("No appointments found for today."),
                          );
                        }

                        return ListView.builder(
                          itemCount: bookSerialButton.bookSerialList.length,
                          itemBuilder: (context, index) {
                            final bookSerial =
                                bookSerialProvider.bookSerialList[index];

                            return Container(
                              //padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          bookSerial.company?.name ??
                                              "No Company Name",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              bookSerial.status.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.getStatusColor(
                                                  bookSerial.status,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          bookSerial.serviceCenter?.name ??
                                              "No serviceCenter Name",
                                          style: TextStyle(
                                            color: AppColor().primariColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),

                                        Visibility(
                                          visible:
                                              bookSerial.status !=
                                                  "Cancelled" &&
                                              bookSerial.status != "Serving",
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 17,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                _showEdit_ialogBox(
                                                  context,
                                                  bookSerial,
                                                );
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                size: 19,
                                                color: AppColor().primariColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: bookSerial.forSelf == false,
                                      child: Text(
                                        "For ${bookSerial.name ?? "Other"}",
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              bookSerial.serviceType?.name ??
                                                  "No ServiceType Name",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "(${bookSerial.serialNo})",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible:
                                              bookSerial.status !=
                                                  "Cancelled" &&
                                              bookSerial.status != "Serving",
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 17,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                _showCommentDialogBox(
                                                  context,
                                                  bookSerial,
                                                );
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size: 19,
                                                color: AppColor().primariColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Book Serial DialogBox
  void _showDialogBox(BuildContext context) {
    final Timedate = _FormatedDateTime;
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime selectedDialogDate = DateTime.now();

    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    TextEditingController DateController = TextEditingController();

    AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
    UserName? _SelectUserName = UserName.Self;

    Businesstype? _dialogSelectedBusinessType = _selectedBusinessType;
    OrganizationModel? _selectedOrganization;
    ServiceCenterModel? _selectServiceCenter;
    serviceTypeModel? _selectedServiceType;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColor().primariColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
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
                                "Book a Serial",
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

                          SizedBox(height: 10),
                          CustomLabeltext("ServiceType Provider Type"),
                          SizedBox(height: 10),
                          DropdownSearch<Businesstype>(
                            popupProps: PopupProps.menu(
                              menuProps: MenuProps(
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(maxHeight: 170),
                            ),

                            itemAsString: (Businesstype type) => type.name,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Select",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: _isLoadingBusinessTypes
                                    ? Container(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: AppColor().primariColor,
                                          ),
                                        ),
                                      )
                                    : null,
                                enabled: !_isLoadingBusinessTypes,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: AppColor().primariColor,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),

                            selectedItem: _dialogSelectedBusinessType,

                            //_selectedBusinessType,
                            items: _businessTypes,

                            onChanged: (newValue) {
                              dialogSetState(() {
                                _dialogSelectedBusinessType = newValue;
                                _selectedOrganization = null;
                                _selectServiceCenter = null;
                                _selectedServiceType = null;

                                context
                                    .read<OrganizationProvider>()
                                    .clearData();
                                context
                                    .read<serviceCenter_serialBookProvider>()
                                    .clearData();
                                context
                                    .read<ServiceCenterByTypeProvider>()
                                    .clearData();
                                context
                                    .read<serviceTypeSerialbook_Provider>()
                                    .clearData();
                              });
                              if (newValue == null) return;

                              if (newValue.id == 1) {
                                print(
                                  "Fetching organizations for Business Type ID: ${newValue.id}",
                                );

                                context
                                    .read<OrganizationProvider>()
                                    .get_Organization(
                                      businessTypeId: newValue.id.toString(),
                                    );
                              } else {
                                context
                                    .read<ServiceCenterByTypeProvider>()
                                    .fetchServiceCenters(
                                      newValue.id.toString(),
                                    );
                              }
                            },

                            autoValidateMode: _autovalidateMode,
                            validator: (value) {
                              if (value == null)
                                return "Please select a business type";
                              return null;
                            },
                          ),

                          SizedBox(height: 10),

                          if (_dialogSelectedBusinessType?.id == 1) ...[
                            CustomLabeltext("Organization"),
                            SizedBox(height: 8),
                            Consumer<OrganizationProvider>(
                              builder: (context, OrgProvider, child) {
                                return DropdownSearch<OrganizationModel>(
                                  selectedItem: _selectedOrganization,

                                  autoValidateMode: _autovalidateMode,
                                  validator: (value) {
                                    if (value == null) return "Requird";
                                    return null;
                                  },

                                  popupProps: PopupProps.menu(
                                    menuProps: MenuProps(
                                      backgroundColor: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(maxHeight: 150),

                                    emptyBuilder: (context, searchEntry) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 24.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.inbox_outlined,
                                                size: 60,
                                                color: Colors.grey[300],
                                              ),
                                              SizedBox(height: 12),

                                              Text(
                                                'No data',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  itemAsString: (OrganizationModel item) =>
                                      item.name ?? "No name",
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              hintText: "Organization",
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade400,
                                              ),
                                              suffixIcon: Icon(Icons.search),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColor().primariColor,
                                                  width: 2,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ),
                                      ),

                                  items: OrgProvider.organizations,

                                  onChanged: (OrganizationModel? Newvalue) {
                                    dialogSetState(() {
                                      _selectedOrganization = Newvalue;
                                      _selectServiceCenter = null;
                                      _selectedServiceType = null;
                                      context
                                          .read<ServiceCenterByTypeProvider>()
                                          .clearData();
                                    });
                                    if (Newvalue != null &&
                                        Newvalue.id != null) {
                                      print(
                                        "✅ Organization Selected. Fetching Service Centers for Company ID: ${Newvalue.id}",
                                      );

                                      Provider.of<
                                            serviceCenter_serialBookProvider
                                          >(context, listen: false)
                                          .fetchserviceCnter_serialbook(
                                            Newvalue.id!,
                                          );
                                    } else {
                                      Provider.of<
                                            serviceCenter_serialBookProvider
                                          >(context, listen: false)
                                          .clearData();
                                    }
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 10),
                          ],

                          CustomLabeltext("Service Center"),
                          SizedBox(height: 8),
                          Consumer<serviceCenter_serialBookProvider>(
                            builder: (context, orgServiceCenterProvider, child) {
                              return Consumer<ServiceCenterByTypeProvider>(
                                builder: (context, typeServiceCenterProvider, child) {
                                  final List<ServiceCenterModel>
                                  allServiceCenters = [
                                    ...orgServiceCenterProvider
                                        .serviceCenterList,

                                    ...typeServiceCenterProvider.serviceCenters,
                                  ];
                                  final bool isLoading =
                                      orgServiceCenterProvider.isLoading ||
                                      typeServiceCenterProvider.isLoading;

                                  if (isLoading) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor().primariColor,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    );
                                  }
                                  return DropdownSearch<ServiceCenterModel>(
                                    selectedItem: _selectServiceCenter,
                                    autoValidateMode: _autovalidateMode,
                                    validator: (value) {
                                      if (value == null) return "Required";
                                      return null;
                                    },
                                    popupProps: PopupProps.menu(
                                      menuProps: MenuProps(
                                        backgroundColor: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: BoxConstraints(
                                        maxHeight: 150,
                                      ),
                                      emptyBuilder: (context, searchEntry) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 24.0,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.inbox_outlined,
                                                  size: 60,
                                                  color: Colors.grey[300],
                                                ),
                                                SizedBox(height: 12),

                                                Text(
                                                  'No data',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    itemAsString: (ServiceCenterModel item) =>
                                        item.name ?? "",
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                hintText: "Service Center",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                                suffixIcon: Icon(Icons.search),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey
                                                            .shade400,
                                                      ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: AppColor()
                                                            .primariColor,
                                                        width: 2,
                                                      ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey
                                                            .shade300,
                                                      ),
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                              ),
                                        ),

                                    items: allServiceCenters,

                                    onChanged: (ServiceCenterModel? newValue) {
                                      dialogSetState(() {
                                        _selectServiceCenter = newValue;
                                        _selectedServiceType = null;
                                      });

                                      if (newValue != null &&
                                          newValue.companyId != null &&
                                          newValue.companyId!.isNotEmpty) {
                                        final String companyId =
                                            newValue.companyId!;
                                        print(
                                          "✅ Service Center Selected. Fetching Service Types for Company ID: $companyId",
                                        );
                                        Provider.of<
                                              serviceTypeSerialbook_Provider
                                            >(context, listen: false)
                                            .serviceType_serialbook(companyId);
                                      } else {
                                        print(
                                          "❌ Company ID not found in the selected Service Center. Clearing service types.",
                                        );
                                        Provider.of<
                                              serviceTypeSerialbook_Provider
                                            >(context, listen: false)
                                            .clearData();
                                      }

                                      // if (newValue != null &&
                                      //     newValue.companyId != null &&
                                      //     newValue.companyId!.isNotEmpty) {
                                      //   final String companyId = newValue
                                      //       .companyId!; // <-- সঠিক Company ID এখন এখান থেকে আসছে!
                                      //
                                      //   print(
                                      //       "✅ Service Center Selected. Fetching Service Types for Company ID: $companyId");
                                      //
                                      //   Provider.of<
                                      //       serviceTypeSerialbook_Provider>(
                                      //       context, listen: false)
                                      //       .serviceType_serialbook(companyId);
                                      // } else {
                                      //   // যদি কোনো কারণে companyId না পাওয়া যায়
                                      //   print(
                                      //       "❌ Company ID not found in the selected Service Center. Clearing service types.");
                                      //   Provider.of<
                                      //       serviceTypeSerialbook_Provider>(
                                      //       context, listen: false).clearData();
                                      // }

                                      ///
                                      ///
                                      // if (_selectedOrganization != null && _selectedOrganization!.id != null) {
                                      //   final String companyId = _selectedOrganization!.id!; // <-- সঠিক Company ID এখান থেকে নিন
                                      //
                                      //   print("✅ Service Center Selected. Fetching Service Types for Company ID: $companyId");
                                      //
                                      //
                                      //   Provider.of<serviceTypeSerialbook_Provider>(context, listen: false)
                                      //       .serviceType_serialbook(companyId);
                                      // } else {
                                      //
                                      //   print("❌ Company ID not found. Clearing service types.");
                                      //   Provider.of<serviceTypeSerialbook_Provider>(context, listen: false).clearData();
                                      // }

                                      print(newValue?.name);
                                    },
                                  );
                                },
                              );
                            },
                          ),

                          SizedBox(height: 10),
                          CustomLabeltext("Service Type"),
                          SizedBox(height: 8),
                          Consumer<serviceTypeSerialbook_Provider>(
                            builder: (context, serviceTypeProvider, child) {
                              if (serviceTypeProvider.isLoading) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor().primariColor,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                );
                              }

                              return DropdownSearch<serviceTypeModel>(
                                autoValidateMode: _autovalidateMode,
                                validator: (value) {
                                  if (value == null) return "Required";
                                  return null;
                                },
                                popupProps: PopupProps.menu(
                                  menuProps: MenuProps(
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(maxHeight: 150),

                                  emptyBuilder: (context, searchEntry) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 24.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.inbox_outlined,
                                              size: 60,
                                              color: Colors.grey.shade300,
                                            ),
                                            SizedBox(height: 12),

                                            Text(
                                              'No data',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                itemAsString: (serviceTypeModel item) =>
                                    item.name ?? "",
                                selectedItem: _selectedServiceType,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Service Type",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                    suffixIcon: Icon(Icons.search),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: AppColor().primariColor,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),

                                items: serviceTypeProvider.serviceTypeList,
                                onChanged: (newValue) {
                                  dialogSetState(() {
                                    _selectedServiceType =
                                        newValue; // <<<--- শুধু মান সেট করুন
                                  });
                                  print(newValue?.name);
                                },
                              );
                            },
                          ),

                          SizedBox(height: 10),
                          CustomLabeltext("Date"),
                          SizedBox(height: 8),
                          CustomTextField(
                            controller: DateController,
                            hintText: todayDate,
                            readOnly: true,
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
                                          onSurface:
                                              Colors.black, // Body text color
                                        ),
                                        dialogTheme: DialogThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
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
                                  initialDate: selectedDialogDate,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (newDate != null) {
                                  dialogSetState(() {
                                    selectedDialogDate = newDate;
                                    DateController.text = DateFormat(
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
                            groupValue: _SelectUserName,
                            items: [UserName.Self, UserName.Other],
                            onChanged: (UserName? newValue) {
                              dialogSetState(() {
                                _SelectUserName = newValue;
                              });
                            },
                            itemTitleBuilder: (UserName value) {
                              switch (value) {
                                case UserName.Self:
                                  return "Self";
                                case UserName.Other:
                                  return "Other";
                              }
                            },
                          ),

                          Visibility(
                            visible: _SelectUserName == UserName.Self,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomLabeltext("Contact No"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  enabled: false,
                                  filled: true,
                                  isPassword: false,
                                  controller: contactNoController,
                                ),
                                SizedBox(height: 15),
                                CustomLabeltext("Name"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  enabled: false,
                                  filled: true,
                                  isPassword: false,
                                  controller: NameController,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),

                          Visibility(
                            visible: _SelectUserName == UserName.Other,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomLabeltext("Contact No"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  isPassword: false,
                                  controller: contactNoController,
                                ),
                                SizedBox(height: 15),
                                CustomLabeltext("Name"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  isPassword: false,
                                  controller: NameController,
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
                                  print(
                                    'Selected Business Type: ${_dialogSelectedBusinessType?.name}',
                                  );
                                  print(
                                    'Selected Organization: ${_selectedOrganization?.name}',
                                  );
                                  print(
                                    'Selected Service Center: ${_selectServiceCenter?.name}',
                                  );
                                  print(
                                    'Selected Service Type: ${_selectedServiceType?.name}',
                                  );

                                  if (_dialogFormKey.currentState!.validate()) {
                                    final String? businessTypeId =
                                        _dialogSelectedBusinessType?.id
                                            ?.toString();
                                    final String? organizationId =
                                        _selectedOrganization?.id;
                                    final String? serviceCenterId =
                                        _selectServiceCenter?.id;
                                    final String? serviceTypeId =
                                        _selectedServiceType?.id;
                                    bool isIdMissing = false;

                                    if (businessTypeId == null ||
                                        serviceCenterId == null ||
                                        serviceTypeId == null) {
                                      isIdMissing = true;
                                    } else if (_dialogSelectedBusinessType
                                                ?.id ==
                                            1 &&
                                        organizationId == null) {
                                      isIdMissing = true;
                                    }
                                    if (isIdMissing) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "A required ID is missing. Please re-select the items.",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final bookProvider =
                                        Provider.of<bookSerialButton_provider>(
                                          context,
                                          listen: false,
                                        );
                                    final authProvider =
                                        Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final String serviceTakerId =
                                        authProvider.userModel!.user.id;
                                    final bool forSelfValue =
                                        _SelectUserName == UserName.Self;
                                    final String serviceDate =
                                        DateController.text.isNotEmpty
                                        ? DateController.text
                                        : DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(DateTime.now());

                                    try {
                                      final success =
                                          await Provider.of<
                                                bookSerialButton_provider
                                              >(context, listen: false)
                                              .fetchBookSerialButton(
                                                businessTypeId: businessTypeId!,
                                                serviceCenterId:
                                                    serviceCenterId!,
                                                serviceTypeId: serviceTypeId!,
                                                serviceDate: serviceDate,
                                                serviceTaker: serviceTakerId,
                                                contactNo:
                                                    contactNoController.text,
                                                name: NameController.text,
                                                organizationId: organizationId,
                                                forSelf: forSelfValue,
                                              );

                                      if (success) {
                                        await Provider.of<
                                              GetBookSerialProvider
                                            >(context, listen: false)
                                            .fetchgetBookSerial(serviceDate);

                                        if (!mounted) return;
                                        Navigator.pop(context);
                                        await CustomFlushbar.showSuccess(
                                          context: context,
                                          title: "Success",
                                          message:
                                              "Serial booked successfully!",
                                        );
                                      } else {
                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: CustomSnackBarWidget(
                                              title: "Error",
                                              message:
                                                  bookProvider.errorMessage ??
                                                  "Booking Failed",
                                              iconColor: Colors.red.shade400,
                                              icon: Icons.dangerous_outlined,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "An error occurred: $e",
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    dialogSetState(() {
                                      _autovalidateMode =
                                          AutovalidateMode.onUserInteraction;
                                    });
                                  }
                                },
                                child: Text(
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
                                  style: TextStyle(
                                    color: AppColor().primariColor,
                                  ),
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
          },
        );
      },
    );
  }

  // Edit Book Serial DialogBox
  void _showEdit_ialogBox(BuildContext context, MybookedModel mybook_Serial) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final serviceTypeProvider = Provider.of<serviceTypeSerialbook_Provider>(
      context,
      listen: false,
    );

    final String? companyId = mybook_Serial.serviceCenter?.companyId;
    if (companyId != null) {
      serviceTypeProvider.serviceType_serialbook(companyId);
    } else {
      print("Error: Could not find companyId in mybook_Serial.serviceCenter");
      print("CompanyId - ${companyId}");
    }

    TextEditingController contactNoController = TextEditingController(
      text: authProvider.userModel?.user.mobileNo ?? "",
    );
    TextEditingController NameController = TextEditingController(
      text: authProvider.userModel?.user.name ?? "",
    );
    TextEditingController DateController = TextEditingController();
    TextEditingController serviceCenterController = TextEditingController(
      text: mybook_Serial.serviceCenter?.name,
    );

    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime selectedDialogDate = DateTime.now();
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
    UserName? _SelectUserName = UserName.Self;

    ServiceCenterModel? _selectServiceCenter;
    serviceTypeModel? _selectedServiceType;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColor().primariColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
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
                            controller: serviceCenterController,
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
                              if (serviceTypeProvider.isLoading &&
                                  serviceTypeProvider.serviceTypeList.isEmpty) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor().primariColor,
                                    strokeWidth: 2.5,
                                  ),
                                );
                              }
                              // if (serviceTypeProvider.isLoading) {
                              //   return Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Center(
                              //         child: CircularProgressIndicator(
                              //           color: AppColor().primariColor,
                              //           strokeWidth: 2.5,
                              //         )),
                              //   );
                              // }

                              if (_selectedServiceType == null &&
                                  mybook_Serial.serviceType != null) {
                                try {
                                  // provider-এর লিস্ট থেকে সঠিক serviceType-টি খুঁজে বের করুন
                                  _selectedServiceType = serviceTypeProvider
                                      .serviceTypeList
                                      .firstWhere(
                                        (item) =>
                                            item.id ==
                                            mybook_Serial.serviceType!.id,
                                      );
                                } catch (e) {
                                  // যদি লিস্টে খুঁজে পাওয়া না যায় (যেমন: সার্ভার থেকে ডিলিট হয়ে গেলে)
                                  print(
                                    "Previously selected service type not found in the list.",
                                  );
                                }
                              }
                              return DropdownSearch<serviceTypeModel>(
                                autoValidateMode: _autovalidateMode,
                                validator: (value) {
                                  if (value == null) return "Required";
                                  return null;
                                },
                                popupProps: PopupProps.menu(
                                  menuProps: MenuProps(
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(maxHeight: 150),

                                  emptyBuilder: (context, searchEntry) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 24.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.inbox_outlined,
                                              size: 60,
                                              color: Colors.grey.shade300,
                                            ),
                                            SizedBox(height: 12),

                                            Text(
                                              'No data',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                itemAsString: (serviceTypeModel item) =>
                                    item.name ?? "no data",
                                selectedItem: _selectedServiceType,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Service Type",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                    suffixIcon: Icon(Icons.search),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: AppColor().primariColor,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),

                                items: serviceTypeProvider.serviceTypeList,

                                onChanged: (serviceTypeModel? newValue) {
                                  dialogSetState(() {
                                    _selectedServiceType =
                                        newValue; // <<<--- শুধু মান সেট করুন
                                  });
                                  print(newValue?.name);
                                },
                              );
                            },
                          ),
                          SizedBox(height: 10),

                          CustomLabeltext("Date"),
                          SizedBox(height: 8),
                          TextField(
                            controller: DateController,
                            decoration: InputDecoration(
                              enabled: false,
                              filled: true,
                              fillColor: Colors.red.shade50,
                              hintText: todayDate,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
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
                                            onSurface:
                                                Colors.black, // Body text color
                                          ),
                                          dialogTheme: DialogThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
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
                                    initialDate: selectedDialogDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  if (newDate != null) {
                                    dialogSetState(() {
                                      selectedDialogDate = newDate;
                                      DateController.text = DateFormat(
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
                            groupValue: _SelectUserName,
                            items: [UserName.Self, UserName.Other],
                            onChanged: (UserName? newValue) {
                              dialogSetState(() {
                                _SelectUserName = newValue;
                              });
                            },
                            itemTitleBuilder: (UserName value) {
                              switch (value) {
                                case UserName.Self:
                                  return "Self";
                                case UserName.Other:
                                  return "Other";
                              }
                            },
                          ),

                          Visibility(
                            visible: _SelectUserName == UserName.Self,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomLabeltext("Contact No"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  enabled: false,
                                  filled: true,
                                  isPassword: false,
                                  controller: contactNoController,
                                ),
                                SizedBox(height: 15),
                                CustomLabeltext("Name"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  enabled: false,
                                  filled: true,
                                  isPassword: false,
                                  controller: NameController,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          Visibility(
                            visible: _SelectUserName == UserName.Other,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomLabeltext("Contact No"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  isPassword: false,
                                  controller: contactNoController,
                                ),
                                SizedBox(height: 15),
                                CustomLabeltext("Name"),
                                SizedBox(height: 10),
                                CustomTextField(
                                  isPassword: false,
                                  controller: NameController,
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
                                  final String? serviceTypeId =
                                      _selectedServiceType?.id;
                                  final bool forSelfValue =
                                      _SelectUserName == UserName.Self;
                                  final String? bookingId = mybook_Serial.id;
                                  final String? serviceCenterId =
                                      mybook_Serial.serviceCenter?.id;

                                  if (bookingId == null ||
                                      serviceCenterId == null ||
                                      serviceTypeId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error: Missing required information to update.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (_dialogFormKey.currentState!.validate()) {
                                    final success =
                                        await Provider.of<
                                              UpdateBookSerialProvider
                                            >(context, listen: false)
                                            .update_bookSerial(
                                              id: bookingId,
                                              serviceCenterId: serviceCenterId,
                                              serviceTypeId: serviceTypeId,
                                              forSelf: forSelfValue,
                                              name: NameController.text,
                                              contactNo:
                                                  contactNoController.text,
                                            );

                                    if (success) {
                                      if (!mounted) return;

                                      final String serviceDate =
                                          DateController.text.isNotEmpty
                                          ? DateController.text
                                          : DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(DateTime.now());

                                      await Provider.of<GetBookSerialProvider>(
                                        context,
                                        listen: false,
                                      ).fetchgetBookSerial(serviceDate);

                                      Navigator.pop(context);

                                      await CustomFlushbar.showSuccess(
                                        context: context,
                                        title: "Success",
                                        message: "Serial booked successfully!",
                                      );
                                    } else {
                                      if (!mounted) return;
                                      final updateProvider =
                                          Provider.of<UpdateBookSerialProvider>(
                                            context,
                                            listen: false,
                                          );

                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: CustomSnackBarWidget(
                                            title: "Error",
                                            message:
                                                updateProvider.errorMessage ??
                                                "Booking Failed",
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
                                },
                                child: Text(
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
                                  style: TextStyle(
                                    color: AppColor().primariColor,
                                  ),
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
          },
        );
      },
    );
  }

  //
  void _showCommentDialogBox(
    BuildContext context,
    MybookedModel mybook_Serial,
  ) {
    ServiceCenterModel? _selectServiceCenter;
    serviceTypeModel? _selectedServiceType;

    TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColor().primariColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Cancel Serial",
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
                        SizedBox(height: 20),
                        Text(
                          "Please enter the reason or comment",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _commentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 3,
                          cursorColor: Colors.grey.shade300,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: AppColor().primariColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(12),

                            hintText: "Reason or comment",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                backgroundColor: AppColor().primariColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    5,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                final String comment = _commentController.text;
                                if (comment.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please enter a reason to cancel.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final String? serviceTypeId =
                                    mybook_Serial.serviceType?.id;
                                final String? bookingId = mybook_Serial.id;
                                final String? serviceCenterId =
                                    mybook_Serial.serviceCenter?.id;
                                final String? status = mybook_Serial.status;

                                if (bookingId == null ||
                                    serviceCenterId == null ||
                                    serviceTypeId == null ||
                                    status == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error: Missing required information to update.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final success =
                                    await Provider.of<
                                          CommentCancelButtonProvider
                                        >(context, listen: false)
                                        .commentCancelButton(
                                          id: bookingId,
                                          serviceCenterId: serviceCenterId,
                                          serviceTypeId: serviceTypeId,
                                          comment: comment,
                                          status: "Cancelled",
                                        );
                                if (success) {
                                  if (!mounted) return;
                                  final String serviceDate = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(DateTime.now());

                                  await Provider.of<GetBookSerialProvider>(
                                    context,
                                    listen: false,
                                  ).fetchgetBookSerial(serviceDate);

                                  // await Provider.of<GetCommentCancelButtonProvider>(context,listen: false).
                                  // get_commentCancelButton(serviceDate);

                                  Navigator.pop(context);
                                  await CustomFlushbar.showSuccess(
                                    context: context,
                                    title: "Success",
                                    message: "Serial cancelled  successfully!",
                                  );
                                } else {
                                  if (!mounted) return;

                                  final CommentProvider =
                                      Provider.of<CommentCancelButtonProvider>(
                                        context,
                                        listen: false,
                                      );

                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: CustomSnackBarWidget(
                                        title: "Error",
                                        message:
                                            CommentProvider.errorMessage ??
                                            "Booking Failed",
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
                              },
                              child: Text(
                                "Cancel Serial",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
          },
        );
      },
    );
  }
}
