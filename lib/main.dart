import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:invoice/res/localization/language.dart';
import 'package:invoice/views/invoice_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:invoice/views/language_screen.dart';

import 'controllers/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Wait for splash screen to load
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await GetStorage.init();
  await Future.delayed(Duration(seconds: 2)); // simulate some async loading
  FlutterNativeSplash.remove(); // remove splash screen

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LanguageController langController = Get.put(LanguageController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget initialScreen = langController.isLanguageSelected()
        ? InvoiceScreen()
        : LanguageScreen();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quinvo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      translations: AppTranslations(),
      locale: Get.deviceLocale, // temporary until GetStorage loads
      fallbackLocale: const Locale('en', 'US'),
      home: initialScreen,
    );
  }
}