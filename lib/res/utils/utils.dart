
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:invoice/res/colors/app_color.dart';

class Utils {
  static DateTime? _lastPressedAt;

  static toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: AppColor.primaryColor,
        textColor: AppColor.whiteColor,
        gravity: ToastGravity.BOTTOM
    );
  }
  static toastMessageCancel(){
    Fluttertoast.cancel();
  }

  static snackBar(String title, String message){
    Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.blackColor);
  }

  // Handle back press with double back press to exit
  static Future<dynamic> handleBackPress() async {
    DateTime now = DateTime.now();
    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;
      toastMessage('Press again to exit');
      return null;  // Returning null as dynamic
    }
    // Exit the app on second press within 2 seconds
    SystemNavigator.pop();
    return null;  // Returning null as dynamic
  }
}