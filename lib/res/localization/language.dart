import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'language': 'Language',
      'english': 'English',
      'urdu': 'Urdu',
    },
    'ur_PK': {
      'hello': 'سلام',
      'language': 'زبان',
      'english': 'انگریزی',
      'urdu': 'اردو',
    },
  };
}