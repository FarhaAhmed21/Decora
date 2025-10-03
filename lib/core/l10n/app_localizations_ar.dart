// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحبا بالعالم';

  @override
  String get welcome => 'مرحبًا بك في ديكورا';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get location => 'الموقع';

  @override
  String get searchFurniture => 'ابحث عن الأثاث';

  @override
  String get cairoEgypt => 'مصر , القاهرة';

  @override
  String get product_added_to_favourite_successfully =>
      'تمت إضافة المنتج إلى المفضلة بنجاح';

  @override
  String get product_added_to_Cart_successfully =>
      'تمت إضافة المنتج إلى السلة بنجاح';

  @override
  String get our_Categories => 'فئاتنا';
}
