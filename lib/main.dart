import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:invoice/res/localization/app_translations.dart';
import 'package:invoice/res/route/app_pages.dart';
import 'package:invoice/res/route/app_routes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'controllers/language_controller.dart';

void main() async {
  final bindings = WidgetsFlutterBinding.ensureInitialized();
FlutterNativeSplash.preserve(widgetsBinding: bindings);

  await GetStorage.init();

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LanguageController langController = Get.put(LanguageController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String initialRoute = langController.isLanguageSelected()
        ? AppRoutes.invoiceScreen
        : AppRoutes.languageScreen;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quinvo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      translations: AppTranslations(),
      // locale: Get.locale ?? Locale('en', 'US'),
      // fallbackLocale: Locale('en', 'US'),
      // home: initialScreen,
      locale: Get.locale ?? Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      initialRoute: initialRoute,
      getPages: AppPages.routes,

    );
  }
}