import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Widgets/custom_dropdown/custom_dropdown.dart';

import '../../../../Widgets/custom_labeltext.dart';
import '../../../../Widgets/custom_textfield.dart';
import '../../../../model/user_model.dart';
import '../../../../providers/auth_provider/auth_providers.dart';
import '../../../../utils/color.dart';

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

  bool _isLoadingBusinessTypes = false;
  Businesstype? _selectedBusinessType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                  style: TextStyle(color: Colors.black, fontSize: 17),
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
                  style: TextStyle(color: Colors.black, fontSize: 17),
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
                      hintText: "Select",
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
                //
                // CustomDropdown(
                //     child: child,
                //     items: items,
                //     onChanged: onChanged,
                //     itemAsString: itemAsString
                // ),
                SizedBox(height: 10),
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
