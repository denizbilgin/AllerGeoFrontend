// ignore_for_file: constant_identifier_names

class Strings {
  static const String APP_NAME = 'AllerGeo';
  static const String APP_SLOGAN = 'Alerjinizi Kontrol Altına Alın, Seyahat Keyfini Çıkarın!';
  static const String APP_SHORT_DESCRIPTION = "Alerjik Bireyler için Günlük Yaşamı Kolaylaştıran Seyahat Yardımcısı";
  static const String CREATE_TRAVEL = 'Seyahat Oluştur';
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}