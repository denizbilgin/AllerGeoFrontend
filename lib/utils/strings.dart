// ignore_for_file: constant_identifier_names

class Strings {
  static const String APP_NAME = 'AllerGeo';
  static const String APP_SLOGAN = 'Alerjinizi Kontrol Altına Alın, Seyahat Keyfini Çıkarın!';
  static const String APP_SHORT_DESCRIPTION = "Alerjik Bireyler için Günlük Yaşamı Kolaylaştıran Seyahat Yardımcısı";
  static const String CREATE_TRAVEL = 'Seyahat Oluştur';
  static const String USER_TRAVELS = 'Seyahatlerim';
  static const String CREATE_TRAVEL_INFO = 'Haritaya tıklayarak sırayla durak noktalarının konumlarını seçin ve her bir durakta ne zaman bulunacağınızı belirleyin.';
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}