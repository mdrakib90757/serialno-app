

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serial_no_app/Widgets/custom_tabbar.dart';
import 'package:serial_no_app/model/service_type_model.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/get_serialServiceCenter_provider.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/post_serialServiceCenter_provider.dart';
import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../model/serviceCenter_model.dart';
import '../../providers/auth_providers.dart';
import '../../providers/serviceCenter_provider/getAddButton_provider.dart';
import '../../providers/serviceCenter_provider/getAddButton_serviceType_privider.dart';
import '../../providers/getprofile_provider.dart';
import '../../utils/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with
    SingleTickerProviderStateMixin {


  String _FormatedDateTime = "";
  Timer?_timer;
  ServiceCenterModel? _selectedServiceCenter;
  DateTime _selectedDate = DateTime.now();


  //TabBar List
  final List<String>tabList = ["Queue", "Served "];
  int indexNo = 0;
  late TabController tabController;


  void _fetchDataForUI() {
    if (_selectedServiceCenter != null) {
      debugPrint("🚀 FETCHING SERIALS for Service Center ID: ${_selectedServiceCenter!.id!}");
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      Provider.of<SerialListProvider>(context, listen: false)
          .fetchSerials(_selectedServiceCenter!.id!, formattedDate);
    }else{
      debugPrint("⚠️ _fetchDataForUI called but _selectedServiceCenter is null.");
    }
  }



  String formatApiTime(String? dateString) {
    if (dateString == null) return "No Time";

    try {

      final parts = dateString.split('T');
      if (parts.length != 2) throw FormatException("Invalid format");

      final datePart = parts[0];
      final timePart = parts[1];


      final ymd = datePart.split('-');
      if (ymd.length != 3) throw FormatException("Invalid date part");
      final year = int.parse(ymd[0]);
      final month = int.parse(ymd[1]);
      final day = int.parse(ymd[2]);

      final hms = timePart.split(':');
      if (hms.length != 3) throw FormatException("Invalid time part");

      final hour = int.parse(hms[0]);
      final minute = int.parse(hms[1]);


      final secondParts = hms[2].split('.');
      final second = int.parse(secondParts[0]);
      final millisecond = secondParts.length > 1 ? int.parse(secondParts[1].padRight(3, '0').substring(0,3)) : 0;



      final utcTime = DateTime.utc(year, month, day, hour, minute, second, millisecond);


      final localTime = utcTime.toLocal();


      return DateFormat('hh:mm a').format(localTime);

    } catch (e) {
      print("FATAL: Could not manually parse date: '$dateString' - $e");
      return "Time Error";
    }
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
  }


  Future<void> _initialDataLoad() async {

    final profileProvider = context.read<Getprofileprovider>();
    final addButtonProvider = context.read<GetAddButtonProvider>();
    final serviceTypeProvider = context.read<GetAddButton_serviceType_Provider>();


    await profileProvider.fetchUserProfile();


    final companyId = profileProvider.profileData?.currentCompany.id;


    if (mounted && companyId != null) {
      debugPrint("✅ Using Company ID for fetching data: $companyId");


      await Future.wait([
        addButtonProvider.fetchGetAddButton(),
        serviceTypeProvider.fetchGetAddButton_ServiceType(),
      ]);


      final serviceCenters = addButtonProvider.serviceCenterList;
      if (mounted && serviceCenters.isNotEmpty) {
        setState(() {
          _selectedServiceCenter = serviceCenters.first;
        });
        debugPrint("✅ INITIAL LOAD: Automatically selected Service Center ID: ${_selectedServiceCenter?.id}");
        _fetchDataForUI();
      }
    } else {
      if (mounted) {
        debugPrint("❌ Error in HomeScreen: Could not find Company ID.");
      }
    }
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formatted = DateFormat('EEEE, dd MMMM, yyyy ').format(now);
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
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final getprofile = Provider.of<Getprofileprovider>(context, listen: false);
    final profile = getprofile.profileData;
    final serialService = Provider.of<SerialListProvider>(context,);


    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
        context, listen: false);
    ServiceCenterModel? defaultSelectItem;
    if (getAddButtonProvider.serviceCenterList.isNotEmpty) {
      defaultSelectItem = getAddButtonProvider.serviceCenterList.first;
    }


    if (profile == null || profile.currentCompany.name.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColor().primariColor),
        ),
      );
    }

    final company = profile.currentCompany;
    final Timedate = _FormatedDateTime;


    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company.name, style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500
              ),),
              SizedBox(height: 10,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Timedate, style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700
                  ),),
                  GestureDetector(
                    onTap: () async {
                      if (_selectedServiceCenter != null) {
                        final bool? wasSuccessful = await _showDialogBox(context, _selectedServiceCenter!);

                        if (wasSuccessful == true) {

                          await CustomFlushbar.showSuccess(
                              context: context,
                              title: "Success",
                              message: "New serial has been booked successfully."
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
                                message: "Failed to create new serial. Please try again."
                            ),
                          ),
                        );
                      }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(
                                "Please select a service center first.")),
                          );
                        }
                      }
                      },
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                          color: AppColor().primariColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add, color: Colors.white, weight: 5,),
                            SizedBox(width: 5),
                            Text("New Serial", style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),

              SizedBox(height: 15,),

              Container(
                height: 55,
                child: DropdownSearch<ServiceCenterModel>(
                    popupProps: PopupProps.menu(
                      menuProps: MenuProps(

                          backgroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      constraints: BoxConstraints(
                          maxHeight: 150
                      ),

                      emptyBuilder: (context, searchEntry) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24.0),
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
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(

                        hintText: "Select Data",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400
                        ),
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: AppColor().primariColor,
                                width: 2
                            )
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Colors.red
                            )
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400),
                        ),

                      ),
                    ),

                    itemAsString: (ServiceCenterModel item) =>
                    item.name ?? "No Name",
                    items: Provider
                        .of<GetAddButtonProvider>(context)
                        .serviceCenterList,
                    selectedItem: _selectedServiceCenter,

                    onChanged: (ServiceCenterModel? newvalue) {
                      debugPrint("🔄 DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}");
                      setState(() {
                        _selectedServiceCenter = newvalue;
                      });
                      _fetchDataForUI();
                    }
                ),
              ),


          TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.grey.shade600,
            labelColor: AppColor().primariColor,
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            indicatorColor: AppColor().primariColor,
            tabs: [
              Tab(text: "Queue"),
              Tab(text: "Served"),
            ],
          ),
          Expanded(
              child: TabBarView(
                  controller: tabController,
                  children: [

                    serialService.isLoading ?
                    Center(child: CircularProgressIndicator(
                      color: AppColor().primariColor,
                      strokeWidth: 2.5,
                    ),) :
                    Consumer<SerialListProvider>(
                        builder: (context, serialProvider, child) {
                          final serviceTypesProvider = Provider.of<
                              GetAddButton_serviceType_Provider>(
                              context, listen: false);

                          if (serialProvider.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (serialProvider.serials.isEmpty) {
                            return Center(child: Text("No serials found."));
                          }


                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: serialProvider.serials.length,
                            itemBuilder: (context, index) {
                              final serial = serialProvider.serials[index];
                              final String displayTime = formatApiTime(
                                  serial.date);
                              return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Text("${serial.serialNo}.",
                                                  style: TextStyle(
                                                      color: AppColor()
                                                          .primariColor,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.bold
                                                  ),),
                                          ),
                                          SizedBox(width: 5,),
                                          CircleAvatar(
                                            backgroundColor: Colors.grey
                                                .shade500,
                                            radius: 22,
                                            child: Icon(Icons.person,
                                              color: Colors.white,),
                                          ),
                                          SizedBox(width: 8,),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(serial.name ?? "N/A",
                                                style: TextStyle(
                                                    color: AppColor()
                                                        .primariColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight
                                                        .bold
                                                ),),
                                              Text(displayTime),

                                              Text(serial.serviceType!.name
                                                  .toString())
                                            ],
                                          ),

                                          Spacer(),
                                          GestureDetector(
                                            onTap: () async {

                                              _showDialogBoxManage(
                                                  BuildContext, context,
                                                  serial.status??"Booked"
                                              );
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Center(child: Text(serial.status.toString()))
                                            ),
                                          ),
                                        ],
                                      ),


                                    ],
                                  )
                              );
                            },
                          );
                        }),


                    Center(
                      child: Text(
                        "Saved tab content will be here.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ]),
          )
            ]
          ),


        ));
  }




  Future<bool?> _showDialogBox(BuildContext context,
      ServiceCenterModel? serviceCenterModel) async{
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();


    final getAddButton_serviceType_Provider =
    Provider.of<GetAddButton_serviceType_Provider>(context, listen: false);


    if (getAddButton_serviceType_Provider.serviceTypeList.isNotEmpty) {
      final serviceTypeList = getAddButton_serviceType_Provider.serviceTypeList;
      ServiceTypeModel? _selectedDialogServiceType;

      DateTime date = DateTime.now();

      TextEditingController servicecenterController = TextEditingController(
          text: serviceCenterModel?.name ?? "N/A");
      TextEditingController nameController = TextEditingController();
      TextEditingController contactController = TextEditingController();

      TextEditingController serviceDateDisplayController =
      TextEditingController(text: DateFormat("yyyy-MM-dd").format(date));
      TextEditingController serviceTypeController = TextEditingController();


      AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;


     return await showDialog<bool>(context: context, builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogSetState) {
              final authProvider = Provider.of<AuthProvider>(context);

              return Dialog(
                backgroundColor: Colors.white,
                insetPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColor().primariColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

                  child: Container(
                    //height: 415,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Form(
                      key: _dialogFormKey,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text("New Serial", style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  IconButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.close_sharp))
                                ],
                              ),

                              CustomLabeltext("Service Center"),
                              SizedBox(height: 8,),
                              CustomTextField(
                                enabled: false,
                                fillColor: Colors.red.shade50,
                                filled: true,
                                controller: servicecenterController,
                                isPassword: false,
                              ),
                              SizedBox(height: 10,),
                              CustomLabeltext("Service Type"),
                              SizedBox(height: 8,),
                              DropdownSearch<ServiceTypeModel>(
                                autoValidateMode: _autovalidateMode,
                                validator: (value) {
                                  if (value == null)
                                    return "Required";
                                  return null;
                                },
                                popupProps: PopupProps.menu(
                                  menuProps: MenuProps(
                                      backgroundColor: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  constraints: BoxConstraints(
                                      maxHeight: 150
                                  ),
                                  emptyBuilder: (context, searchEntry) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [

                                            Icon(
                                              Icons.inbox_outlined,
                                              size: 60,
                                              color: Colors.grey.shade300,
                                            ),
                                            SizedBox(height: 12),

                                            Text(
                                              "No data",
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

                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Service Type",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade400
                                    ),
                                    suffixIcon: Icon(Icons.search),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: AppColor().primariColor,
                                            width: 2
                                        )
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Colors.red
                                        )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),

                                  ),
                                ),

                                itemAsString: (ServiceTypeModel item) =>
                                item.name ?? "No Name",
                                items: getAddButton_serviceType_Provider
                                    .serviceTypeList,

                                onChanged: (ServiceTypeModel? newValue) {
                                  dialogSetState(() {
                                    // **ইউজার সিলেক্ট করলে, মানটি এখানে সেভ হচ্ছে**
                                    _selectedDialogServiceType = newValue;
                                  });
                                  print(newValue?.name);
                                },
                              ),
                              SizedBox(height: 10,),

                              CustomLabeltext("Date"),
                              SizedBox(height: 8,),
                              CustomTextField(
                                enabled: false,
                                filled: true,
                                fillColor: Colors.red.shade50,
                                // hintText: "${today}",
                                textStyle: TextStyle(
                                    color: Colors.grey.shade400
                                ),
                                isPassword: false,
                                controller: serviceDateDisplayController,
                                // readOnly: true,
                                suffixIcon: IconButton(onPressed: () async
                                {
                                  DateTime? newDate = await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: AppColor()
                                                    .primariColor,
                                                // Header color
                                                onPrimary: Colors.white,
                                                // Header text color
                                                onSurface: Colors
                                                    .black, // Body text color
                                              ),
                                              dialogTheme: DialogThemeData(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(
                                                        16.0),
                                                  )),
                                              textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: AppColor()
                                                      .primariColor, // Button text color
                                                ),
                                              ),
                                            ), child: child!);
                                      },
                                      context: context,
                                      initialDate: date,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100)
                                  );
                                  if (newDate != null) {
                                    dialogSetState(() {
                                      date = newDate;
                                      serviceDateDisplayController.text =
                                          DateFormat("yyyy-MM-dd").format(date);
                                    });
                                  }
                                },
                                    icon: Icon(Icons.date_range_outlined,
                                      color: Colors.grey.shade400,)),
                              ),
                              SizedBox(height: 10,),
                              CustomLabeltext("Name"),
                              SizedBox(height: 8,),
                              CustomTextField(
                                controller: nameController,
                                hintText: "Name",
                                isPassword: false,
                              ),
                              SizedBox(height: 10,),
                              CustomLabeltext("Contact No"),
                              SizedBox(height: 8,),
                              CustomTextField(
                                controller: contactController,
                                hintText: "Contact",
                                isPassword: false,
                              ),
                              SizedBox(height: 10,),

                              //Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor()
                                              .primariColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  5)
                                          )
                                      ),
                                      onPressed: () async {

                                        //Validator Logic
                                        if (_dialogFormKey.currentState?.validate() ?? false) {
                                          if (_selectedDialogServiceType == null) {
                                            ScaffoldMessenger
                                                .of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please select a service type.")));
                                            return;
                                          }
                                        }

                                          String dateForApiCreate = date.toIso8601String();

                                          String serviceTypeId = _selectedDialogServiceType!.id!;

                                        String serviceCenterId = serviceCenterModel!.id!;

                                          final success = await SerialProvider().createSerial(


                                              serviceTypeId: serviceTypeId,
                                              serviceDate: dateForApiCreate,
                                              name: nameController.text,
                                              contactNo: contactController.text,
                                              serviceCenterName: servicecenterController.text,
                                              serviceCenterId: serviceCenterId
                                          );

                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context, success);

                                        }else{
                                              dialogSetState(() {
                                                _autovalidateMode = AutovalidateMode.onUserInteraction;
                                              });
                                            }

                                      }, child: Text("Ok", style: TextStyle(
                                      color: Colors.white
                                  ),)),


                                  SizedBox(width: 10,),


                                  //cancel Button
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(

                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  5)
                                          )
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }, child: Text("Cancel", style: TextStyle(
                                      color: AppColor().primariColor
                                  ),))
                                ],
                              )

                            ],
                          )
                      ),
                    ),
                  ),
                ),
              );
            }
        );
      }
      );
    }
  }


  void _showDialogBoxManage(BuildContext, context, currentSatus) {
    showDialog(context: context, builder: (context) {
      return ManageSerialDialog(initialStatus: currentSatus,);
    },);
  }
}

