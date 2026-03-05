import '../../features/library/domain/entities/line_type.dart';

class AppStrings {
  static const String appName = 'Коран';
  static const String surahs = 'Суры';
  static const String juzs = 'Джузы';
  static const String hizbs = 'Хизбы';
  static const String settings = 'Настройки';
  static const String errorLoadSurahsList = 'Ошибка загрузки списка сур: ';
  static const String errorLoadJuzsList = 'Ошибка загрузки списка джузов: ';
  static const String errorLoadHizbsList = 'Ошибка загрузки списка хизбов: ';
  static const String goTo = 'Перейти к ...';
  static const String searchByAyahs = 'Поиск аятов';

  static const String fontGilroy = 'Gilroy';
  static const String fontUthmanicHafs = 'Uthmanic Hafs';
  static const String fontSFPro = 'SF Pro';

  static const int totalPages = 604;

  static String ayahWord(int count) {
    if (count % 100 >= 11 && count % 100 <= 14) {
      return 'аятов';
    }

    switch (count % 10) {
      case 1:
        return 'аят';
      case 2:
      case 3:
      case 4:
        return 'аята';
      default:
        return 'аятов';
    }
  }

  static LineType lineTypeFromDb(String value) {
    switch (value) {
      case 'ayah':
        return LineType.ayah;
      case 'surah_name':
        return LineType.surahName;
      case 'basmallah':
        return LineType.basmallah;
      default:
        return LineType.ayah;
    }
  }
}