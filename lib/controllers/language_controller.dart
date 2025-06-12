import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final storage = GetStorage();
  final localeKey = 'language';

  @override
  void onInit() {
    String? langCode = storage.read(localeKey);
    if (langCode != null) {
      var locale = _getLocaleFromLanguage(langCode);
      Get.updateLocale(locale);
    }
    super.onInit();
  }

  void changeLanguage(String langCode) {
    var locale = _getLocaleFromLanguage(langCode);
    Get.updateLocale(locale);
    storage.write(localeKey, langCode);
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

  bool isLanguageSelected() {
    return storage.hasData(localeKey);
  }

}