import '../../features/library/domain/entities/line_type.dart';

class AppStrings {
  static const String appName = 'Коран';
  static const String surahs = 'Суры';
  static const String bookmarks = 'Избранное';
  static const String juzs = 'Джузы';
  static const String juz = 'Джуз';
  static const String hizbs = 'Хизбы';
  static const String hizb = 'Хизб';
  static const String page = 'Страница';
  static const String pageShort = 'Стр.';
  static const String surah = 'Сура';
  static const String settings = 'Настройки';

  static const String start = 'Начало: ';
  static const String end = 'Конец: ';
  static const String loadingData = 'Загрузка данных...';
  static const String errorLoadSurahsList = 'Ошибка загрузки списка сур: ';
  static const String errorLoadJuzsList = 'Ошибка загрузки списка джузов: ';
  static const String errorLoadHizbsList = 'Ошибка загрузки списка хизбов: ';
  static const String errorMushafFavoritesList = 'Ошибка загрузки избранного: ';
  static const String errorMushafLastFavoritesList = 'Ошибка загрузки недавних страниц: ';
  static const String errorLoad = 'Ошибка загрузки: ';
  static const String addedToFavorite = 'Добавлено в избранное';
  static const String addToFavorite = 'Добавить в избранное';
  static const String removedFromFavorite = 'Удалено из избранного';
  static const String removeFromFavorite = 'Удалить из избранного';

  static const String lastMushafPages = 'Недавние страницы: ';
  static const String lastMushafPagesEmpty = 'Недавних страниц нет';
  static const String favoriteMushafPages = 'Избранные страницы';
  static const String favoriteMushafPagesEmpty = 'Избранных страниц нет';
  static const String goTo = 'Перейти к...';
  static const String searchByAyahs = 'Поиск аятов';
  static const String translate = 'Перевод';

  static const String fontGilroy = 'Gilroy';
  static const String fontGilroyMedium = 'Gilroy Medium';
  static const String fontUthmanicHafs = 'Uthmanic Hafs';
  static const String fontSFPro = 'SF Pro';
  static const String fontSurahName = 'Surah name';

  static const int totalPages = 604;

  static const List<String> appThemeModeNames = [
    'Системная',
    'Светлая',
    'Тёмная',
  ];

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
        throw StateError("Unknown line_type value: $value");
    }
  }

  static String surahNameByNumber(int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw StateError('Invalid surah number: $surahNumber');
    }
    return 'surah${surahNumber.toString().padLeft(3, '0')}';
  }
}