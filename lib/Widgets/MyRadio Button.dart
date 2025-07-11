
import 'package:flutter/material.dart';

import '../Screen/Auth_screen/registration_screen.dart';
import '../utils/color.dart';

class MyRadioButton extends StatefulWidget {
  final void Function(UserType?) onChanged;
  final UserType? initialSelection;
  const MyRadioButton({super.key, required this.onChanged, this.initialSelection});

  @override
  State<MyRadioButton> createState() => _MyRadioButtonState();
}




class _MyRadioButtonState extends State<MyRadioButton> {
  UserType? _SelectUserType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _SelectUserType=widget.initialSelection?? UserType.ServiceCenter;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(

            onTap: () {
              setState(() {
                _SelectUserType = UserType.ServiceCenter;
              });
              widget.onChanged(_SelectUserType);
            },

            child: Row(
              children: [
                Icon(
                  _SelectUserType == UserType.ServiceCenter
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _SelectUserType == UserType.ServiceCenter
                      ? AppColor().primariColor
                      : Colors.grey,
                  size: 19,
                ),
                SizedBox(width: 5),
                Text(
                  "AS Service Center",
                  style: TextStyle(
                      color: _SelectUserType == UserType.ServiceCenter
                          ? Colors.black.withOpacity(0.8)
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _SelectUserType = UserType.ServiceTaker;
              });
              widget.onChanged(_SelectUserType);
            },
            child: Row(
              children: [
                Icon(
                  _SelectUserType == UserType.ServiceTaker
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _SelectUserType == UserType.ServiceTaker
                      ? AppColor().primariColor
                      : Colors.grey,
                  size: 19,
                ),
                SizedBox(width: 5),
                Text(
                  "AS Service Taker",
                  style: TextStyle(
                      color: _SelectUserType == UserType.ServiceTaker
                          ? Colors.black.withOpacity(0.8)
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
