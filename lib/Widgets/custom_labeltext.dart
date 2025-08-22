import 'package:flutter/material.dart';

class CustomLabeltext extends StatefulWidget {
  final String label;
  final Color? color;
  final double? fonsize;
  final FontWeight? fontWeight;
  const CustomLabeltext(
    this.label, {
    super.key,
    this.color,
    this.fonsize,
    this.fontWeight,
  });

  @override
  State<CustomLabeltext> createState() => _CustomLabeltextState();
}

class _CustomLabeltextState extends State<CustomLabeltext> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: TextStyle(color: Colors.black, fontSize: 14.50),
        children: [
          TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
