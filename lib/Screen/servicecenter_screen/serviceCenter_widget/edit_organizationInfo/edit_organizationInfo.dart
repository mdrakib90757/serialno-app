import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/locationDialog/locationPickerDialogContant/locationPickerDialog.dart';
import 'package:serialno_app/Widgets/custom_dropdown/custom_dropdown.dart';
import 'package:serialno_app/model/division_model.dart';
import 'package:serialno_app/providers/serviceCenter_provider/divisionProvider/divisionProvider.dart';

import '../../../../Widgets/custom_labeltext.dart';
import '../../../../Widgets/custom_textfield.dart';
import '../../../../model/user_model.dart';
import '../../../../providers/auth_provider/auth_providers.dart';
import '../../../../utils/color.dart';
import '../locationDialog/locationDialog.dart';

class EditOrganizationInfo extends StatefulWidget {
  const EditOrganizationInfo({super.key});

  @override
  State<EditOrganizationInfo> createState() => _EditOrganizationInfoState();
}

class _EditOrganizationInfoState extends State<EditOrganizationInfo> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController name = TextEditingController();
  final TextEditingController addressLine1 = TextEditingController();
  final TextEditingController addressLine2 = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController organization = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoadingBusinessTypes = false;
  Businesstype? _selectedBusinessType;

  bool _isLoadingDivision = false;
  DivisionModel? _selectDivision;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Made async
      final divisionProvider = Provider.of<DivisionProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await divisionProvider.fetchDivisions();
      await authProvider.fetchBusinessTypes();

      setState(() {
        _isLoadingBusinessTypes = true; // Start loading for business types
        _isLoadingDivision =
            true; // Assuming you want to show loading for divisions too
      });

      if (authProvider.userModel != null &&
          authProvider.businessTypes.isNotEmpty) {
        setState(() {
          _selectedBusinessType = authProvider.businessTypes.firstWhere(
            (type) => type.id == authProvider.userModel!.businessTypeId,
            // Assuming businessTypeId is the correct field
            orElse: () => authProvider.businessTypes.first, // Fallback
          );
        });
      }
    });
  }

  // Future<void> _fetchInitialData() async {
  //   final divisionProvider = Provider.of<DivisionProvider>(context, listen: false);
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //
  //   setState(() {
  //     _isLoadingBusinessTypes = true; // Start loading for business types
  //     _isLoadingDivision = true; // Assuming you want to show loading for divisions too
  //   });
  //
  //   try {
  //     await Future.wait([
  //       divisionProvider.fetchDivisions(),
  //       authProvider.fetchBusinessTypes(),
  //     ]);
  //
  //     if (authProvider.userModel != null && authProvider.businessTypes.isNotEmpty) {
  //       // Ensure this logic runs only after business types are fetched
  //       _selectedBusinessType = authProvider.businessTypes.firstWhere(
  //             (type) => type.id == authProvider.userModel!.businessTypeId,
  //         orElse: () => authProvider.businessTypes.first, // Fallback
  //       );
  //     }
  //
  //     // If you want to pre-select division based on userModel, add similar logic here
  //     if (authProvider.userModel != null && divisionProvider.divisions.isNotEmpty) {
  //       _selectDivision = divisionProvider.divisions.firstWhere(
  //             (division) => division.id == authProvider.userModel!.divisionId, // Assuming a divisionId field
  //         orElse: () => divisionProvider.divisions.first, // Fallback
  //       );
  //     }
  //
  //   } catch (e) {
  //     print("Error fetching initial data: $e");
  //     // Handle error, e.g., show a snackbar
  //   } finally {
  //     setState(() {
  //       _isLoadingBusinessTypes = false; // Stop loading for business types
  //       _isLoadingDivision = false; // Stop loading for divisions
  //     });
  //   }
  // }

  @override
  void dispose() {
    name.dispose();
    addressLine1.dispose();
    addressLine2.dispose();
    contactName.dispose();
    email.dispose();
    phone.dispose();
    organization.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final divisionProvider = Provider.of<DivisionProvider>(context);
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
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

                SizedBox(height: 20),
                Text(
                  "Address Line 1",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: addressLine2,
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

                    hintText: "Address Line 1",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  "Address Line 2",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: addressLine2,
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

                    hintText: "Address Line 2",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                CustomLabeltext("Email"),
                SizedBox(height: 12),
                CustomTextField(
                  hintText: "Email",
                  isPassword: false,
                  controller: phone,
                ),

                SizedBox(height: 20),
                CustomLabeltext("Mobile Number"),
                SizedBox(height: 12),
                CustomTextField(
                  hintText: "Mobile Number",
                  isPassword: false,
                  controller: phone,
                ),

                SizedBox(height: 20),
                CustomLabeltext("Business Type"),
                SizedBox(height: 12),
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
                      hintText: authProvider.userModel?.businessTypeName ?? "",
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
                        borderSide: BorderSide(color: Colors.grey.shade400),
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
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),

                  selectedItem: _selectedBusinessType,
                  items: authProvider.businessTypes,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBusinessType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) return "Please select a business type";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text(
                  "Division",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(height: 12),
                DropdownSearch<DivisionModel>(
                  popupProps: PopupProps.menu(
                    menuProps: MenuProps(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(maxHeight: 170),
                  ),

                  itemAsString: (DivisionModel type) => type.name,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Division",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: divisionProvider.isLoading
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

                      enabled: !divisionProvider.isLoading,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
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
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),

                  selectedItem: _selectDivision,
                  items: divisionProvider.divisions,
                  onChanged: (newValue) {
                    setState(() {
                      _selectDivision = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) return "Please select a division";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text(
                  "District",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(height: 12),
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    menuProps: MenuProps(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(maxHeight: 170),
                  ),

                  //itemAsString: ( type) => type.name,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "District",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: divisionProvider.isLoading
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

                      enabled: !divisionProvider.isLoading,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
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
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),

                  //selectedItem: _selectDivision,
                  // items: divisionProvider.divisions,
                  //  onChanged: (newValue) {
                  //    setState(() {
                  //      _selectDivision = newValue;
                  //    });
                  //  },
                  validator: (value) {
                    if (value == null) return "Please select a division";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text(
                  "Thana",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(height: 12),
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    menuProps: MenuProps(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(maxHeight: 170),
                  ),

                  //itemAsString: ( type) => type.name,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Thana Or Upazila",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: divisionProvider.isLoading
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

                      enabled: !divisionProvider.isLoading,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
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
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),

                  //selectedItem: _selectDivision,
                  // items: divisionProvider.divisions,
                  //  onChanged: (newValue) {
                  //    setState(() {
                  //      _selectDivision = newValue;
                  //    });
                  //  },
                  validator: (value) {
                    if (value == null) return "Please select a division";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text(
                  "Area",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(height: 12),
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    menuProps: MenuProps(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(maxHeight: 170),
                  ),

                  //itemAsString: ( type) => type.name,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Area or village",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: divisionProvider.isLoading
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

                      enabled: !divisionProvider.isLoading,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
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
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),

                  //selectedItem: _selectDivision,
                  // items: divisionProvider.divisions,
                  //  onChanged: (newValue) {
                  //    setState(() {
                  //      _selectDivision = newValue;
                  //    });
                  //  },
                  validator: (value) {
                    if (value == null) return "Please select a division";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text(
                  "Location",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(height: 12),
                TextFormField(
                  cursorColor: Colors.grey.shade400,
                  controller: _locationController,
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
                            print("Selected Location: $result");
                          }
                        },
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: AppColor().primariColor,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
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
                      onPressed: () {},
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
