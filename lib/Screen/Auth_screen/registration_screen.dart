import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/request_model/auth_request/serviceTaker_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/MyRadio Button.dart';
import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../model/user_model.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../request_model/auth_request/register_requset.dart';

import '../../utils/color.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

enum UserType { ServiceCenter, ServiceTaker }

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  Businesstype? _selectedBusinessType;
  bool _isLoadingBusinessTypes = false;

  UserType? _SelectUserType = UserType.ServiceCenter;
  bool obscureIndex = true;
  bool obscureIndex1 = true;

  final List<String> genderList = ["Male", "Female", "Other"];

  List<String> _saveItems = [];
  static const String _storageKey = "organization_names";

  // Controllers
  final TextEditingController name = TextEditingController();
  final TextEditingController addressLine1 = TextEditingController();
  final TextEditingController addressLine2 = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController organization = TextEditingController();
  final TextEditingController loginName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchBusinessTypes();
    });
    _loadSaveItems();
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
    loginName.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void _handleServiceCenterRegistration() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!_formkey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }

    final request = RegisterRequest(
      name: name.text.trim(),
      addressLine1: addressLine1.text.trim(),
      addressLine2: addressLine2.text.trim(),
      contactName: contactName.text.trim(),
      email: email.text.trim(),
      phone: phone.text.trim(),
      organizationName: organization.text.trim(),
      businessTypeId: _selectedBusinessType?.id,
      loginName: loginName.text.trim(),
      password: password.text,
    );

    final result = await authProvider.registerServiceCenter(request: request);

    if (!mounted) return;
    if (result["success"] == true) {
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Registration Successful",
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: result['message'] ?? 'Registration Failed',
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleServiceTakerRegistration() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!_formkey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }

    final request = ServiceTakerRequest(
      name: name.text.trim(),
      email: email.text.trim(),
      phone: phone.text.trim(),
      loginName: loginName.text.trim(),
      password: password.text,
      gender: _selectedGender,
    );
    final result = await authProvider.registerServiceTaker(request: request);

    if (!mounted) return;

    if (result["success"] == true) {
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Registration Successful",
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: result['message'] ?? 'Registration Failed',
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //load  organization data
  Future<void> _loadSaveItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _saveItems = prefs.getStringList(_storageKey) ?? [];
    });
  }

  //save organization data
  Future<void> _saveNewItem(String newData) async {
    if (newData.trim().isEmpty || _saveItems.contains(newData.trim())) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _saveItems.add(newData.trim());
    });
    await prefs.setStringList(_storageKey, _saveItems);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
      key: _formkey,
      autovalidateMode: _autovalidateMode,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColor().primariColor,
                      ),
                    ),
                    Text(
                      "Registration",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                //Custom Radio Button
                CustomRadioGroup<UserType>(
                  groupValue: _SelectUserType,
                  items: [UserType.ServiceCenter, UserType.ServiceTaker],
                  onChanged: (UserType? newValue) {
                    setState(() {
                      _SelectUserType = newValue;
                    });
                  },
                  itemTitleBuilder: (value) {
                    switch (value) {
                      case UserType.ServiceCenter:
                        return 'AS Service Center';
                      case UserType.ServiceTaker:
                        return 'AS Service Taker';
                    }
                  },
                ),

                //Service Center
                Visibility(
                  visible: _SelectUserType == UserType.ServiceCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomLabeltext("Name"),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Name",
                          isPassword: false,
                          controller: name,
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Address Line 1"),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Address Line 1",
                          isPassword: false,
                          controller: addressLine1,
                        ),

                        SizedBox(height: 10),
                        Text(
                          "Address Line 2",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: addressLine2,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor().primariColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),

                            hintText: "Address Line 2",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Contact Name"),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Contact Name",
                          isPassword: false,
                          controller: contactName,
                        ),

                        SizedBox(height: 10),
                        Text(
                          "Email Address",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor().primariColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),

                            hintText: "Email Address",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Mobile Number"),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Mobile Number",
                          isPassword: false,
                          controller: phone,
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Business Type"),
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

                          selectedItem: _selectedBusinessType,
                          items: authProvider.businessTypes,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedBusinessType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null)
                              return "Please select a business type";
                            return null;
                          },
                        ),

                        SizedBox(height: 10),
                        if (_selectedBusinessType?.id == 1) ...[
                          Text(
                            "Organization",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.50,
                            ),
                          ),
                          SizedBox(height: 12),
                          Autocomplete<String>(
                            initialValue: TextEditingValue(
                              text: organization.text,
                            ),
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return _saveItems;
                                  }
                                  return _saveItems.where((String option) {
                                    return option.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    );
                                  });
                                },
                            onSelected: (String selection) {
                              // _textEditingController.text = selection;
                              setState(() {
                                organization.text = selection;
                              });
                              //_saveNewItem(selection);
                              debugPrint('You just selected $selection');
                              FocusScope.of(context).unfocus();
                            },
                            fieldViewBuilder:
                                (
                                  BuildContext context,
                                  TextEditingController
                                  fieldTextEditingController,

                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted,
                                ) {
                                  if (organization.text.isNotEmpty &&
                                      fieldTextEditingController.text !=
                                          organization.text) {
                                    fieldTextEditingController.text =
                                        organization.text;
                                  }

                                  return TextField(
                                    controller: fieldTextEditingController,
                                    focusNode: focusNode,
                                    cursorColor: Colors.grey.shade500,

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                      isDense: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor().primariColor,
                                          width: 2,
                                        ),
                                      ),
                                      hintText: "Organization",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),

                                    onSubmitted: (String value) {
                                      final trimmerValue = value.trim();
                                      if (trimmerValue.isNotEmpty) {
                                        _saveNewItem(value);

                                        fieldTextEditingController.clear();

                                        setState(() {
                                          organization.clear();
                                          //Organization.text = value;
                                        });
                                      }
                                      onFieldSubmitted();
                                    },

                                    onChanged: (value) {
                                      // _textEditingController.text = value;
                                      organization.text = value;
                                    },
                                  );
                                },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  child: Container(
                                    height: 150,
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.86,
                                    constraints: BoxConstraints(maxWidth: 600),
                                    child: Scrollbar(
                                      thickness: 2,
                                      controller: ScrollController(),
                                      radius: Radius.circular(50),
                                      scrollbarOrientation:
                                          ScrollbarOrientation.left,
                                      thumbVisibility: true,
                                      trackVisibility: true,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        //shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          final option = options.elementAt(
                                            index,
                                          );
                                          return InkWell(
                                            onTap: () => onSelected(option),
                                            child: ListTile(
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                    ),
                                                child: Text(option),
                                              ),
                                              hoverColor: Colors.grey.shade200,
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                              return Divider(
                                                height: 1,
                                                thickness: 1,
                                                color: Colors.grey.shade200,
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],

                        SizedBox(height: 10),
                        CustomLabeltext("Login Name"),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Login name",
                          isPassword: false,
                          controller: loginName,
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Password"),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Password",
                          isPassword: true,
                          controller: password,
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Confirm Password"),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            setState(
                              () => _autovalidateMode = AutovalidateMode.always,
                            );
                            _formkey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            } else {
                              if (value != password.text) {
                                return "Passwords do not match";
                              }
                            }
                            return null;
                          },

                          controller: confirmPassword,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.grey.shade400,
                            ),
                            hintText: "Confirm password",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureIndex1 = !obscureIndex1;
                                  _formkey.currentState?.validate();
                                });
                              },
                              icon: Icon(
                                obscureIndex1
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          obscureText: obscureIndex1,
                          obscuringCharacter: "*",
                        ),

                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: authProvider.isLoading
                              ? null
                              : _handleServiceCenterRegistration,

                          child: Container(
                            height: 43,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor().primariColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                authProvider.isLoading
                                    ? "Please Wait..."
                                    : "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Service Taker Option
                Visibility(
                  visible: _SelectUserType == UserType.ServiceTaker,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomLabeltext("Name"),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Name",
                          isPassword: false,
                          controller: name,
                        ),

                        SizedBox(height: 10),
                        Text(
                          "Email Address",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.50,
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),

                            hintText: "Email Address",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Mobile Number"),
                        SizedBox(height: 12),
                        CustomTextField(
                          hintText: "Mobile Number",
                          isPassword: false,
                          controller: phone,
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Gender"),
                        SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          validator: (value) => value == null || value.isEmpty
                              ? "Required"
                              : null,
                          autovalidateMode: _autovalidateMode,
                          onChanged: (newValue) {
                            setState(() {
                              _autovalidateMode = AutovalidateMode.always;
                              _selectedGender = newValue ?? '';
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            isDense: true,
                            hintText: "Gender",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade50,
                              fontSize: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          value: _selectedGender,
                          items: genderList.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Login Name"),
                        SizedBox(height: 12),
                        CustomTextField(
                          hintText: "Login name",
                          isPassword: false,
                          controller: loginName,
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Password"),
                        SizedBox(height: 12),
                        CustomTextField(
                          hintText: "Passwrod",
                          isPassword: true,
                          controller: password,
                        ),

                        SizedBox(height: 10),
                        CustomLabeltext("Confirm Password"),
                        SizedBox(height: 12),
                        TextFormField(
                          onChanged: (value) {
                            setState(
                              () => _autovalidateMode = AutovalidateMode.always,
                            );
                            _formkey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            } else {
                              if (value != password.text) {
                                return "Passwords do not match";
                              }
                            }
                            return null;
                          },

                          controller: confirmPassword,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.grey.shade400,
                            ),
                            hintText: "Confirm password",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureIndex1 = !obscureIndex1;
                                });
                              },
                              icon: Icon(
                                obscureIndex1
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          obscureText: obscureIndex1,
                          obscuringCharacter: "*",
                        ),

                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: authProvider.isLoading
                              ? null
                              : _handleServiceTakerRegistration,

                          child: Container(
                            height: 43,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor().primariColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                authProvider.isLoading
                                    ? "Please Wait..."
                                    : "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
