import 'package:flutter/material.dart';

import '../../utils/color.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Row(
                children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.arrow_back,color: AppColor().primariColor,)),
                  Text("Forgot Password",style: TextStyle(
                      color: AppColor().primariColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              
              SizedBox(height: 20,),
              Text("Please select your email for receiving password recovery code",style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400
              ),),
              SizedBox(height: 15,),
              Text("Your login email",style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),),
              SizedBox(height: 15,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  prefixIcon: Icon(Icons.email_outlined,color: Colors.grey.shade600,),
                  hintText: "Email address",hintStyle:TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400
                )
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor().primariColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text("Send OTP",style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
