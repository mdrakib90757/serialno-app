import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/model/division_model.dart';
import 'package:serialno_app/providers/serviceCenter_provider/divisionProvider/divisionProvider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/update_organization_settingScreen/update_organization_Provider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/update_orginization_request/update_orginization_request.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/company_details_model.dart';
import '../../../../model/user_model.dart';
import '../../../../providers/auth_provider/auth_providers.dart';
import '../../../../providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import '../../../../providers/serviceCenter_provider/business_type_provider/business_type_provider.dart';
import '../../../../providers/serviceCenter_provider/company_details_provider/company_details_provider.dart';
import '../../../../providers/serviceCenter_provider/location_provider/location_provider.dart';
import '../../../../providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import '../../../../providers/serviceCenter_provider/update_organization_settingScreen/get_update_organization/get_update_organization_provider.dart';
import '../../../../utils/color.dart';
import '../google_locationDialog/locationPickerDialogContant/locationPickerDialog.dart';

class EditOrganizationInfo extends StatefulWidget {
  final CompanyDetailsModel companyDetails;

  const EditOrganizationInfo({super.key, required this.companyDetails});

  @override
  State<EditOrganizationInfo> createState() => _EditOrganizationInfoState();
}

class _EditOrganizationInfoState extends State<EditOrganizationInfo> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController name;
  late TextEditingController addressLine1;
  late TextEditingController addressLine2;
  late TextEditingController contactName;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController organization;
  late TextEditingController _locationController;
  bool _isLoadingBusinessTypes = false;
  Businesstype? _selectedBusinessType;
  bool _isLoadingDivision = false;
  DivisionModel? _selectDivision;
  LocationPart? _selectedDivision;
  LocationPart? _selectedDistrict;
  LocationPart? _selectedThana;
  LocationPart? _selectedArea;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final company = widget.companyDetails;
    name = TextEditingController();
    addressLine1 = TextEditingController();
    addressLine2 = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    _locationController = TextEditingController(
      text: company.location?.toString() ?? '',
    );
    _selectedDivision = company.division;
    _selectedDistrict = company.district;
    _selectedThana = company.thana;
    _selectedArea = company.area;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
      _loadInitialDropdownLists();
    });
  }

  Future<void> _fetchInitialData() async {
    final divisionProvider = Provider.of<DivisionProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final companyDetailsProvider = Provider.of<CompanyDetailsProvider>(
      context,
      listen: false,
    );
    final businessTypeProvider = Provider.of<BusinessTypeProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoadingBusinessTypes = true;
      _isLoadingDivision = true;
    });

    try {
      await Future.wait([
        divisionProvider.fetchDivisions(),
        authProvider.fetchBusinessTypes(),
      ]);
      if (companyDetailsProvider.companyDetails != null) {
        final company = companyDetailsProvider.companyDetails!;

        name.text = company.name ?? '';
        addressLine1.text = company.addressLine1 ?? '';
        addressLine2.text = company.addressLine2 ?? '';
        email.text = company.email ?? "";
        phone.text = company.phone ?? '';

        if (authProvider.userModel != null &&
            authProvider.businessTypes.isNotEmpty) {
          _selectedBusinessType = authProvider.businessTypes.firstWhere(
            (type) => type.id == authProvider.userModel!.businessTypeId,
            orElse: () => authProvider.businessTypes.first,
          );
        }
      }
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      setState(() {
        _isLoadingBusinessTypes = false;
        _isLoadingDivision = false;
      });
    }
  }

  Future<void> _loadInitialDropdownLists() async {
    final locationProvider = context.read<LocationProvider>();
    final authProvider = context.read<AuthProvider>();

    setState(() => _isLoading = true);
    try {
      await Future.wait([
        authProvider.fetchBusinessTypes(),
        locationProvider.getDivisions(),
      ]);

      if (authProvider.userModel != null &&
          authProvider.businessTypes.isNotEmpty) {
        _selectedBusinessType = authProvider.businessTypes.firstWhere(
          (type) => type.id == authProvider.userModel!.businessTypeId,
          orElse: () => authProvider.businessTypes.first,
        );
      }

      if (_selectedDivision != null) {
        await locationProvider.getDistricts(_selectedDivision!.id!);
      }

      if (_selectedDistrict != null) {
        await locationProvider.getThanas(_selectedDistrict!.id!);
      }

      if (_selectedThana != null) {
        await locationProvider.getAreas(_selectedThana!.id!);
      }
    } catch (e) {
      print("Error loading initial dropdown lists: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    name.dispose();
    addressLine1.dispose();
    addressLine2.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> _updateOrganizationInfo() async {
    if (_dialogFormKey.currentState!.validate()) {
      _dialogFormKey.currentState!.save();
      final navigator = Navigator.of(context);
      final UpdateOrgProvider = context.read<UpdateOrganizationInfoProvider>();
      final getUpdateOrgProvider = context.read<getUpdateOrganization>();
      final companyDetails = widget.companyDetails;
      final companyId = companyDetails.id;
      if (companyId != null) {
        UpdateOrginizationRequest request = UpdateOrginizationRequest(
          name: name.text,
          addressLine1: addressLine1.text,
          addressLine2: addressLine2.text,
          email: email.text,
          phone: phone.text,
          businessTypeId: _selectedBusinessType?.id,
          divisionId: _selectedDivision?.id,
          districtId: _selectedDistrict?.id,
          thanaId: _selectedThana?.id,
          areaId: _selectedArea?.id,
          location: _locationController.text,
        );
        final success = await UpdateOrgProvider.updateOrignazation(
          request,
          companyId,
        );

        if (success) {
          // await getUpdateOrgProvider.fetchDetails(companyId);

          navigator.pop(true);
          await CustomFlushbar.showSuccess(
            context: context,
            title: "Success",
            message: "  Organization Update Successfully",
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomSnackBarWidget(
                title: "Error",
                message: UpdateOrgProvider.errorMessage ?? "Failed to Add User",
                iconColor: Colors.red.shade400,
                icon: Icons.dangerous_outlined,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final UpdateOrgProvider = Provider.of<UpdateOrganizationInfoProvider>(
      context,
    );
    final companyDetailsProvider = context.watch<CompanyDetailsProvider>();
    if (companyDetailsProvider.isLoading ||
        locationProvider.isLoading ||
        authProvider.isLoading) {
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
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: AppColor().primariColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                      "Edit Information",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomLabeltext("Name"),
                SizedBox(height: 10),
                CustomTextField(
                  hintText: "Name",
                  isPassword: false,
                  controller: name,
                ),

                SizedBox(height: 10),
                CustomLabeltext("Address Line 1", showStar: false),
                SizedBox(height: 8),
                CustomTextField(
                  hintText: "Address Line 1",
                  isPassword: false,
                  controller: addressLine1,
                  enableValidation: false,
                ),

                SizedBox(height: 10),
                CustomLabeltext("Address Line 2", showStar: false),
                SizedBox(height: 10),
                CustomTextField(
                  controller: addressLine2,
                  enableValidation: false,
                  hintText: "Address Line 2",
                  isPassword: false,
                ),

                SizedBox(height: 10),
                CustomLabeltext("Email"),
                SizedBox(height: 8),
                CustomTextField(
                  hintText: "Email",
                  isPassword: false,
                  controller: email,
                ),

                SizedBox(height: 10),
                CustomLabeltext("Mobile Number"),
                SizedBox(height: 8),
                CustomTextField(
                  hintText: "Mobile Number",
                  isPassword: false,
                  controller: phone,
                ),

                SizedBox(height: 10),
                CustomLabeltext("Business Type"),
                SizedBox(height: 10),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomDropdown<Businesstype>(
                      items: authProvider.businessTypes,
                      value: _selectedBusinessType,
                      //   selectedItem: _,
                      onChanged: (Businesstype? newvalue) {
                        debugPrint(
                          "DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                        );
                        setState(() {
                          _selectedBusinessType = newvalue;
                        });
                      },
                      itemAsString: (Businesstype type) => type.name,
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
                            authProvider.isBusinessTypesLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColor().primariColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _selectedBusinessType?.name ??
                                        "Select Business Type",
                                    style: TextStyle(
                                      color: _selectedBusinessType != null
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

                // CustomDropdownFormField<BusinessType>(
                //   hintText: 'Select a service type',
                //   items: authProvider.businessTypes,
                //   initialValue: _selectedBusinessType,
                //   itemAsString: (BusinessType item) =>
                //   item.name ?? "No Name",
                //   onChanged: (newValue) {
                //     setState(() {
                //       _selectedBusinessType = newValue;
                //     });
                //     print('Selected: $newValue');
                //   },
                //   validator: (value) {
                //     if (value == null)
                //       return "Requried";
                //     return null;
                //   },
                // ),
                SizedBox(height: 10),

                CustomLabeltext("Division", showStar: false),
                SizedBox(height: 8),
                Container(
                  height: 47,
                  child: CustomDropdown<LocationPart>(
                    itemAsString: (item) => item.name ?? '',
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDivision = newValue;
                        _selectedDistrict = null;
                        _selectedThana = null;
                        _selectedArea = null;
                      });
                      locationProvider.clearDistricts();
                      locationProvider.clearThanas();
                      locationProvider.clearAreas();

                      if (newValue != null) {
                        locationProvider.getDistricts(newValue.id!);
                      }
                    },
                    // validator: (value) {
                    //       if (value == null)
                    //         return "Please select a business type";
                    //       return null;
                    //     },
                    selectedItem: _selectedDivision,
                    items: locationProvider.divisions,
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
                          Text(_selectedDivision?.name ?? "Select Division"),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                CustomLabeltext("District", showStar: false),
                SizedBox(height: 8),
                Container(
                  height: 47,
                  child: CustomDropdown<LocationPart>(
                    itemAsString: (item) => item.name ?? '',
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDistrict = newValue;
                        _selectedThana = null;
                        _selectedArea = null;
                      });
                      locationProvider.clearThanas();
                      locationProvider.clearAreas();
                      if (newValue != null) {
                        locationProvider.getThanas(newValue.id!);
                      }
                    },

                    // validator: (value) {
                    //       if (value == null)
                    //         return "Please select a business type";
                    //       return null;
                    //     },
                    items: locationProvider.districts,
                    selectedItem: _selectedDistrict,
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
                          Text(_selectedDistrict?.name ?? "Select District"),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                CustomLabeltext("Thana", showStar: false),
                SizedBox(height: 8),
                Container(
                  height: 47,
                  child: CustomDropdown<LocationPart>(
                    itemAsString: (item) => item.name ?? '',
                    onChanged: (newValue) {
                      setState(() {
                        _selectedThana = newValue;
                        _selectedArea = null;
                      });
                      locationProvider.clearThanas();
                      locationProvider.clearAreas();

                      if (newValue != null) {
                        locationProvider.getAreas(newValue.id!);
                      }
                    },

                    // validator: (value) {
                    //       if (value == null)
                    //         return "Please select a business type";
                    //       return null;
                    //     },
                    items: locationProvider.districts,
                    selectedItem: _selectedDistrict,
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
                          Text(_selectedThana?.name ?? "Select District"),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                CustomLabeltext("Area", showStar: false),
                SizedBox(height: 8),
                Container(
                  height: 47,
                  child: CustomDropdown<LocationPart>(
                    itemAsString: (item) => item.name ?? '',

                    onChanged: (newValue) {
                      setState(() {
                        _selectedArea = newValue;
                      });
                      locationProvider.clearAreas();
                      if (newValue != null) {
                        locationProvider.getAreas(newValue.id!);
                      }
                    },

                    items: locationProvider.districts,
                    selectedItem: _selectedDistrict,
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
                          Text(_selectedArea?.name ?? "Select District"),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                CustomLabeltext("Location", showStar: false),
                SizedBox(height: 8),
                CustomTextField(
                  hintText: "Location",
                  isPassword: false,
                  controller: _locationController,
                  suffixIcon: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      // borderRadius: BorderRadiusGeometry.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) => LocationPickerDialog(),
                        );

                        if (result != null) {
                          setState(() {
                            _locationController.text =
                                '${result.latitude.toStringAsFixed(6)}, ${result.longitude.toStringAsFixed(6)}';
                          });
                        }
                      },
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: AppColor().primariColor,
                      ),
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(5),
                        ),
                        backgroundColor: AppColor().primariColor,
                      ),
                      onPressed: _updateOrganizationInfo,
                      child: UpdateOrgProvider.isLoading
                          ? Text(
                              "please wait...",
                              style: TextStyle(color: Colors.white),
                            )
                          : Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(5),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "cancel",
                        style: TextStyle(color: AppColor().primariColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
