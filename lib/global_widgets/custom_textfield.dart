import 'package:flutter/material.dart';

import '../utils/color.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;
  final Color? color;
  final TextStyle? textStyle;
  final bool? enabled;
  final Color? fillColor;
  final bool? filled;
  final bool? readOnly;
  final VoidCallback? onTap;
  final bool showFocusBorder;
  final String? Function(String?)? validator;
  final bool enableValidation;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final TextInputType? keyboardType;

  const CustomTextField({
    this.showFocusBorder = true,
    super.key,
    this.hintText,
    required this.isPassword,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.color,
    this.textStyle,
    this.enabled,
    this.fillColor,
    this.filled,
    this.readOnly,
    this.onTap,
    this.validator,
    this.enableValidation = true,
    this.suffixIconConstraints,
    this.prefix,
    this.prefixIconConstraints,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureText;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if ((widget.enableValidation ?? true) &&
            (value == null || value.isEmpty)) {
          return 'Required';
        }

        if (widget.keyboardType == TextInputType.emailAddress &&
            value != null &&
            value.isNotEmpty) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Enter a valid email';
          }
        }

        if (widget.keyboardType == TextInputType.number &&
            value != null &&
            value.isNotEmpty) {
          final numberRegex = RegExp(r'^[0-9]+$');
          if (!numberRegex.hasMatch(value)) {
            return 'Enter a valid number';
          }
        }

        return null;
      },
      autovalidateMode: autovalidateMode,
      keyboardType: widget.keyboardType,
      onChanged: (value) {
        if (autovalidateMode != AutovalidateMode.always) {
          setState(() {
            autovalidateMode = AutovalidateMode.always;
          });
        }
      },
      obscureText: obscureText,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        constraints: BoxConstraints(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: widget.showFocusBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor().primariColor,
                  width: 2,
                ),
              )
            : borderStyle,
        enabled: widget.enabled ?? true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: widget.filled ?? false,
        fillColor: widget.color != null
            ? Colors.white
            : Colors.redAccent.withOpacity(0.1),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Colors.grey.shade400)
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.textStyle != null ? Colors.black : Colors.grey.shade400,
          fontSize: 16,
        ),
        prefix: widget.prefix,
        suffixIcon: widget.suffixIcon != null
            ? widget.suffixIcon
            : widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade400,
                ),
              )
            : null,
        suffixIconConstraints: widget.suffixIconConstraints,
        prefixIconConstraints: widget.prefixIconConstraints,
      ),
      cursorColor: Colors.grey.shade500,
    );
  }
}
