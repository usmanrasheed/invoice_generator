import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/res/colors/app_color.dart';
import 'package:invoice/res/utils/utils.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text( 'INVOICE', style: TextStyle(color: AppColor.whiteColor),),
        backgroundColor: AppColor.mainColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              //Logo and invoice no
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Utils.toastMessage('select logo tap');
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    splashColor: Colors.white.withOpacity(0.3),
                    child: Ink(
                      height: Get.height * 0.06,
                      width: Get.width * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // to center contents tightly
                          children: [
                            Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            SizedBox(width: 10), // spacing between icon and text
                            Text(
                              'Logo',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: Get.width * 0.1), // spacing between widgets

                  SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width * 0.5,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        hintText: '0000',
                        labelText: 'Invoice No',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Get.height * 0.01),
              //date and payment term
              Row(
                children: [
                  SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width * 0.40,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        hintText: 'Payment Terms',
                        labelText: 'Payment Terms',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),

                  SizedBox(width: Get.width * 0.05), // spacing between widgets

                  SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width * 0.45,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        hintText: 'Payment Terms',
                        labelText: 'Payment Terms',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
