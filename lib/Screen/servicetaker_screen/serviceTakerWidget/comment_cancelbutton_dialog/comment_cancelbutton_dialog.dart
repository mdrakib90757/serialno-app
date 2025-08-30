import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/request_model/seviceTaker_request/commentCancel_request/commentCancel_request.dart';

import '../../../../Widgets/custom_flushbar.dart';
import '../../../../Widgets/custom_sanckbar.dart';
import '../../../../model/mybooked_model.dart';
import '../../../../providers/serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
import '../../../../providers/serviceTaker_provider/commentCancelProvider/commentCancelButton_provider.dart';
import '../../../../utils/color.dart';

class CommentCancelButtonDialog extends StatefulWidget {
  final MybookedModel bookingDetails;
  const CommentCancelButtonDialog({super.key, required this.bookingDetails});

  @override
  State<CommentCancelButtonDialog> createState() =>
      _CommentCancelButtonDialogState();
}

class _CommentCancelButtonDialogState extends State<CommentCancelButtonDialog> {
  final TextEditingController _commentController = TextEditingController();
  MybookedModel? mybook_Serial;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mybook_Serial = widget.bookingDetails;
  }

  Future<void> _CancelComment() async {
    final commentProvider = Provider.of<CommentCancelButtonProvider>(
      context,
      listen: false,
    );
    final String comment = _commentController.text;
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: "Please enter a reason to cancel.",
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (mybook_Serial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: " Booking details not found.",
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String? serviceTypeId = mybook_Serial?.serviceType?.id;
    final String? bookingId = mybook_Serial?.id;
    final String? serviceCenterId = mybook_Serial?.serviceCenter?.id;

    CommentCancelRequest commentCancelRequest = CommentCancelRequest(
      id: bookingId,
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      comment: comment,
      status: "Cancelled",
    );

    final success = await commentProvider.commentCancelButton(
      commentCancelRequest,
      bookingId!,
      serviceCenterId!,
    );

    if (success) {
      if (!mounted) return;
      final String serviceDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());
      await Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(serviceDate);

      Navigator.pop(context);

      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Serial cancelled  successfully!",
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: commentProvider.errorMessage ?? "Booking Failed",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentCancelButtonProvider>(context);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor().primariColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cancel Serial",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_sharp),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Please enter the reason or comment",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 3,
                  cursorColor: Colors.grey.shade300,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColor().primariColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: EdgeInsets.all(12),

                    hintText: "Reason or comment",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        backgroundColor: AppColor().primariColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        await _CancelComment();
                      },
                      child: commentProvider.isLoading
                          ? Text(
                              "Please wait...",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "Cancel Serial",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
