

import 'package:flutter/material.dart';
import 'package:serial_no_app/utils/color.dart';

class ManageSerialDialog extends StatefulWidget {
  final  String initialStatus;
  const ManageSerialDialog({Key? key, required this.initialStatus}) : super(key: key);

  @override
  _ManageSerialDialogState createState() => _ManageSerialDialogState();
}

class _ManageSerialDialogState extends State<ManageSerialDialog> {
  final List<String> _statuses = [
    'Booked', 'Present', 'Waiting', 'Serving', 'Served', 'Cancelled', 'Absent',
  ];

 late String _selectedStatus ;
  final _commentController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedStatus=widget.initialStatus;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Manage Serial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 20,
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Status', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 5.0,
                children: _statuses.map((status) {
                  bool isSelected = _selectedStatus == status;
                  return FilterChip(

                    label: Text(
                      status,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      }
                    },

                    backgroundColor: Colors.white,
                    selectedColor: AppColor().primariColor,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : Colors.grey.shade300,
                      ),
                    ),

                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              const Text('Comment', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Comment',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColor().primariColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: BorderSide(color: Colors.grey.shade400),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Update logic here
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor().primariColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Update'),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
    );
  }
}