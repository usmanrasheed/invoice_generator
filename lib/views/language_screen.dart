import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';
import '../res/colors/app_color.dart';
import '../res/route/app_routes.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController langController = Get.find();

  final List<Map<String, String>> languages = const [
    {'code': 'en', 'label': 'English'},
    {'code': 'ur', 'label': 'اردو'},
    {'code': 'es', 'label': 'Español'},
    {'code': 'fr', 'label': 'Français'},
    {'code': 'de', 'label': 'Deutsch'},
    {'code': 'it', 'label': 'Italiano'},
    {'code': 'pt', 'label': 'Português'},
    {'code': 'zh', 'label': '中文'},
    {'code': 'ar', 'label': 'العربية'},
    {'code': 'hi', 'label': 'हिंदी'},
    // Add more as needed
  ];

  void _selectLanguage(String langCode) {
    langController.changeLanguage(langCode);

    Get.offAllNamed(AppRoutes.mainScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Languages'.tr,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 15),

            // Welcome Text
            Text(
              'Please select your language'.tr,
              style: TextStyle(
                fontSize: 20,
                color: AppColor.primaryDarkColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Language List
            Expanded(
              child: ListView.separated(
                itemCount: languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return _buildLanguageButton(
                    label: lang['label']!,
                    onTap: () => _selectLanguage(lang['code']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColor.primaryDarkColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*  final LanguageController langController = Get.find();

  void _selectLanguage(String langCode) {
    langController.changeLanguage(langCode);

    Get.offAllNamed(AppRoutes.invoiceScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: Text('language'.tr,style: TextStyle(color: AppColor.whiteColor)),
        backgroundColor: AppColor.primaryColor,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('hello'.tr, style: TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _selectLanguage('en'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryDarkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ), // optional: control shadow
              ),
              child: Text('english'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectLanguage('ur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryDarkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ), // optional: control shadow
              ),
              child: Text('urdu'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

            ),
          ],
        ),
      ),
    );
  }*/
