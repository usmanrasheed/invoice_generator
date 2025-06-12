import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/views/invoice_screen.dart';

import '../controllers/language_controller.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController langController = Get.find();

  void _selectLanguage(String langCode) {
    langController.changeLanguage(langCode);
    Get.offAll(() => InvoiceScreen()); // Navigate to main screen and remove back stack
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('language'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('hello'.tr, style: TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _selectLanguage('en'),
              child: Text('english'.tr),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectLanguage('ur'),
              child: Text('urdu'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
