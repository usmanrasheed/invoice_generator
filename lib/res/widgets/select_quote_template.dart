import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/res/colors/app_color.dart';
import 'package:invoice/res/route/app_routes.dart';
import 'package:invoice/res/utils/utils.dart';

class SelectQuoteTemplate extends StatelessWidget {
  const SelectQuoteTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Quote Template'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryDarkColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _templateOption(
                context,
                imagePath: 'assets/images/template1.jpg',
                onTap: () {
                  Get.toNamed(AppRoutes.quoteScreen);
                },
              ),
              const SizedBox(width: 16),
              _templateOption(
                context,
                imagePath: 'assets/images/template1.jpg',
                onTap: () {
                  Utils.toastMessage('Quote template 2');
                  //Navigator.pop(context); // Close popup
                  // TODO: Use Template 2
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _templateOption(
                context,
                imagePath: 'assets/images/template1.jpg',
                onTap: () {
                  Utils.toastMessage('Quote template 3');
                  //Navigator.pop(context); // Close popup
                  // TODO: Use Template 1
                },
              ),
              const SizedBox(width: 16),
              _templateOption(
                context,
                imagePath: 'assets/images/template1.jpg',
                onTap: () {
                  Utils.toastMessage('Quote template 4');
                  //Navigator.pop(context); // Close popup
                  // TODO: Use Template 2
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _templateOption(BuildContext context,
      {required String imagePath, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
