import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final storage = GetStorage();
  final localeKey = 'language';

  @override
  void onInit() {
    super.onInit();
    String? langCode = storage.read(localeKey);
    if (langCode != null) {
      Locale locale = _getLocaleFromLanguage(langCode);
      Get.updateLocale(locale);
      if (kDebugMode) {
        print('Applied saved language: $langCode');
      }
    }
  }

  void changeLanguage(String langCode) {
    Locale locale = _getLocaleFromLanguage(langCode);
    Get.updateLocale(locale);
    storage.write(localeKey, langCode);
  }

  bool isLanguageSelected() {
    return storage.hasData(localeKey);
  }

  Locale _getLocaleFromLanguage(String code) {
    switch (code) {
      case 'en':
        return const Locale('en', 'US');
      case 'ur':
        return const Locale('ur', 'PK');
      default:
        return const Locale('en', 'US');
    }
  }
}
