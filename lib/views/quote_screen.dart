import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colors/app_color.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text( 'Quote'.tr, style: TextStyle(color: AppColor.whiteColor),),
          backgroundColor: AppColor.primaryColor,
        ),

    );
  }
}
