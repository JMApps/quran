import '../../features/library/domain/entities/line_type.dart';
import 'app_constants.dart';

class AppStrings {
  static const String basmaLlah = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيم';
  static const String appName = 'Мусхаф';
  static const String surahs = 'Суры';
  static const String bookmarks = 'Избранное';
  static const String juzs = 'Джузы';
  static const String juz = 'Джуз';
  static const String hizbs = 'Хизбы';
  static const String hizb = 'Хизб';
  static const String page = 'Страница';
  static const String pages = 'Страницы';
  static const String pageShort = 'Стр.';
  static const String surah = 'Сура';
  static const String ayah = 'аят';
  static const String ayahs = 'Аяты';
  static const String settings = 'Настройки';

  static const String loadingData = 'Загрузка данных...';
  static const String errorLoadSurahsList = 'Ошибка загрузки списка сур: ';
  static const String errorLoadJuzsList = 'Ошибка загрузки списка джузов: ';
  static const String errorLoadHizbsList = 'Ошибка загрузки списка хизбов: ';
  static const String errorAyahFavoritesList = 'Ошибка загрузки избранных аятов: ';
  static const String errorPageFavoritesList = 'Ошибка загрузки избранных страниц: ';
  static const String errorMushafLastFavoritesList = 'Ошибка загрузки недавних страниц: ';
  static const String errorLoad = 'Ошибка загрузки: ';
  static const String errorSearch = 'Ошибка поиска: ';
  static const String searchNoResults = 'Ничего не найдено';
  static const String enterSearchQueryMessage = 'Введите слово для поиска';
  static const String addedToFavorite = 'Добавлено в избранное';
  static const String addToFavorite = 'Добавить в избранное';
  static const String removedFromFavorite = 'Удалено из избранного';
  static const String removeFromFavorite = 'Удалить из избранного';

  static const String lastMushafPagesEmpty = 'Недавних страниц нет';
  static const String favoriteMushafPages = 'Избранные страницы';
  static const String favoritePagesEmpty = 'Избранных страниц нет';
  static const String favoriteAyahsEmpty = 'Избранных аятов нет';
  static const String goTo = 'Перейти к...';
  static const String searchByAyahs = 'Поиск аятов';
  static const String translate = 'Перевод';
  static const String semanticTranslation = 'Смысловой перевод';
  static const String recent = 'Недавнее';
  static const String strDefault = 'По умолчанию';

  static const String deleteAllFavorites = 'Удалить все избарнные';
  static const String delete = 'Удалить';
  static const String cancel = 'Отмена';

  static const String themeColor = 'Цвет темы';
  static const String selectThemeColor = 'Выберите цвет темы';
  static const String arabicSurahName = 'Название сур на арабском';
  static const String alwaysDisplayOn = 'Дисплей всегда включен';
  static const String translationSurahName = 'Перевод названия сур';
  static const String appTheme = 'Тема приложения';
  static const String ayahsTextSize = 'Размер текста аятов';
  static const String arabic = 'Арабский';
  static const String translation = 'Перевод';

  static const String copy = 'Скопировать';
  static const String copied = 'Скопировано';
  static const String share = 'Поделиться';


  static const String fontGilroy = 'Gilroy';
  static const String fontGilroyMedium = 'Gilroy Medium';
  static const String fontUthmanicHafs = 'Uthmanic Hafs';
  static const String fontSFPro = 'SF Pro';
  static const String fontSurahName = 'SurahName';

  static const String foundOne = 'найден';
  static const String foundFew = 'найдено';
  static const String foundMany = 'найдено';

  static const String resultOne = 'результат';
  static const String resultFew = 'результата';
  static const String resultMany = 'результатов';


  static const String ayahOne = 'аят';
  static const String ayahFew = 'аята';
  static const String ayahMany = 'аятов';

  static const String searchByQuery = 'По запросу';

  static const String noDataFor = 'Нет данных для:';
  static const String retry = 'Повторить попытку';

  static const String mecca = 'Мекка';
  static const String medina = 'Медина';

  static const String jumpToPage = 'Переход к странице';

  static const List<({String name, String column})> ayahTranslations = [
    (name: 'Кулиев', column: 'kuliev'),
    (name: 'Абу Адель', column: 'adel'),
    // (name: 'Eng intl', column: 'intl'),
  ];

  static const Map<String, int> defaultTranslationIndex = {
    'ru': 0,
    // 'en': 2,
  };

  static bool containsArabic(String value) {
    return RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]',
    ).hasMatch(value);
  }

  static const List<String> appThemeModeNames = [
    'Системная',
    'Светлая',
    'Тёмная',
  ];

  static String plural(int count, String one, String few, String many) {
    if (count % 100 >= 11 && count % 100 <= 14) return many;

    switch (count % 10) {
      case 1:
        return one;
      case 2:
      case 3:
      case 4:
        return few;
      default:
        return many;
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
    if (surahNumber < 1 || surahNumber > AppConstants.totalSurahsCount) {
      throw StateError('Invalid surah number: $surahNumber');
    }
    return String.fromCharCode(0xE000 + surahNumber);
  }
}