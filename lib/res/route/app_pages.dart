
import 'package:get/get.dart';
import 'package:invoice/res/route/app_routes.dart';
import 'package:invoice/views/invoice_screen.dart';
import 'package:invoice/views/language_screen.dart';

import '../../views/main_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.languageScreen, page: () => LanguageScreen()),//transition: Transition.rightToLeft, transitionDuration: Duration(milliseconds: 600)
    GetPage(name: AppRoutes.mainScreen,page: () => MainScreen()),
    GetPage(name: AppRoutes.invoiceScreen, page: () => InvoiceScreen()),

  ];
}