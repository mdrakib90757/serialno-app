import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import '../../global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import '../../global_widgets/Custom_NavigationBar/my_bottom_navigationBar/my_bottom_navigationBar.dart';
import '../../global_widgets/My_Appbar.dart';
import '../../global_widgets/custom_flushbar.dart';
import '../../global_widgets/custom_labeltext.dart';
import '../../global_widgets/custom_sanckbar.dart';
import '../../global_widgets/custom_textfield.dart';
import '../../providers/auth_provider/password_upadate_provider.dart';
import '../../request_model/auth_request/update_password_request.dart';
import '../../utils/color.dart';

class PasswordScreen extends StatefulWidget {
  final bool showAppBar;
  final bool showBottomNavBar;
  final bool isServiceTaker;

  const PasswordScreen({
    super.key,
    this.showAppBar = true,
    this.showBottomNavBar = false,
    this.isServiceTaker = false,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController password_controller = TextEditingController();
  final TextEditingController Newpassword_controller = TextEditingController();
  final TextEditingController Confirmpassword_controller =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    password_controller.dispose();
    Newpassword_controller.dispose();
    Confirmpassword_controller.dispose();
  }

  Future<void> _handleChangePassword() async {
    final changePasswordProvider = Provider.of<PasswordUpdateProvider>(
      context,
      listen: false,
    );

    if (!_formkey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    UpdatePasswordRequest passwordRequest = UpdatePasswordRequest(
      currentPassword: password_controller.text,
      newPassword: Newpassword_controller.text,
    );

    final success = await changePasswordProvider.fetchUpdatePassword(
      passwordRequest,
    );

    if (!mounted) return;

    if (success) {
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Password updated successfully",
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",

            message:
                changePasswordProvider.errorMessage ??
                "Password update failed.",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final changePassword = Provider.of<PasswordUpdateProvider>(context);
    return Form(
      key: _formkey,
      child: Scaffold(
        appBar: widget.showAppBar ? MyAppbar() : null,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Account Password",
                    style: TextStyle(
                      color: AppColor().primariColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomLabeltext("Current Password"),
              SizedBox(height: 12),
              CustomTextField(
                controller: password_controller,
                hintText: "Current Password",
                isPassword: true,
                //prefixIcon: Icons.lock_outline,
              ),
              SizedBox(height: 20),
              CustomLabeltext("New Password"),
              SizedBox(height: 12),
              CustomTextField(
                controller: Newpassword_controller,
                hintText: "New Password",
                isPassword: true,
                //prefixIcon: Icons.lock_outline,
              ),
              SizedBox(height: 20),
              CustomLabeltext("Confirm Password"),
              SizedBox(height: 12),
              CustomTextField(
                controller: Confirmpassword_controller,
                hintText: "Confirm Password",
                isPassword: true,
                //prefixIcon: Icons.lock_outline,
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: changePassword.isLoading ? null : _handleChangePassword,
                child: Container(
                  height: 43,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor().primariColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      changePassword.isLoading
                          ? "Please Wait..."
                          : "Change Password",
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
        bottomNavigationBar: widget.showBottomNavBar
            ? MyBottomNavigationBar(
                currentIndex: 0,
                onTap: (index) {
                  if (widget.isServiceTaker) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => CustomServicetakerNavigationbar(),
                      ),
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomServicecenterNavigationbar(),
                      ),
                      (route) => false,
                    );
                  }
                },
                isServicetaker: widget.isServiceTaker,
              )
            : null,
      ),
    );
  }
}
