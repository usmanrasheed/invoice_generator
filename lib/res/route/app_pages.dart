
import 'package:get/get.dart';
import 'package:invoice/res/route/app_routes.dart';
import 'package:invoice/views/invoice_screen.dart';
import 'package:invoice/views/language_screen.dart';

import '../../views/main_screen.dart';
import '../../views/quote_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.languageScreen, page: () => LanguageScreen(),
        transition: Transition.rightToLeft, transitionDuration: Duration(milliseconds: 200)),
    GetPage(name: AppRoutes.mainScreen,page: () => MainScreen(),
        transition: Transition.rightToLeft, transitionDuration: Duration(milliseconds: 200)),
    GetPage(name: AppRoutes.invoiceScreen, page: () => InvoiceScreen(),
        transition: Transition.rightToLeft, transitionDuration: Duration(milliseconds: 200)),
    GetPage(name: AppRoutes.quoteScreen, page: () => QuoteScreen(),
        transition: Transition.rightToLeft, transitionDuration: Duration(milliseconds: 200)),

  ];
}