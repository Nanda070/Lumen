import 'world_currencies.dart';

export 'world_currencies.dart';

/// Curated country → default currency map for onboarding.
class RegionOption {
  const RegionOption({
    required this.countryCode,
    required this.nameEn,
    required this.nameRu,
    required this.currencyCode,
  });

  final String countryCode;
  final String nameEn;
  final String nameRu;
  final String currencyCode;

  String label(String localeCode) => localeCode == 'ru' ? nameRu : nameEn;
}

abstract final class RegionOptions {
  static const List<RegionOption> countries = [
    RegionOption(
      countryCode: 'US',
      nameEn: 'United States',
      nameRu: 'США',
      currencyCode: 'USD',
    ),
    RegionOption(
      countryCode: 'GB',
      nameEn: 'United Kingdom',
      nameRu: 'Великобритания',
      currencyCode: 'GBP',
    ),
    RegionOption(
      countryCode: 'EU',
      nameEn: 'Eurozone',
      nameRu: 'Еврозона',
      currencyCode: 'EUR',
    ),
    RegionOption(
      countryCode: 'RU',
      nameEn: 'Russia',
      nameRu: 'Россия',
      currencyCode: 'RUB',
    ),
    RegionOption(
      countryCode: 'DE',
      nameEn: 'Germany',
      nameRu: 'Германия',
      currencyCode: 'EUR',
    ),
    RegionOption(
      countryCode: 'FR',
      nameEn: 'France',
      nameRu: 'Франция',
      currencyCode: 'EUR',
    ),
    RegionOption(
      countryCode: 'PL',
      nameEn: 'Poland',
      nameRu: 'Польша',
      currencyCode: 'PLN',
    ),
    RegionOption(
      countryCode: 'UA',
      nameEn: 'Ukraine',
      nameRu: 'Украина',
      currencyCode: 'UAH',
    ),
  ];

  /// Full world list — see [WorldCurrencies].
  static List<CurrencyOption> get currencies => WorldCurrencies.all;

  static RegionOption byCountry(String code) {
    return countries.firstWhere(
      (c) => c.countryCode == code,
      orElse: () => countries.first,
    );
  }

  static String defaultCurrencyFor(String countryCode) {
    return byCountry(countryCode).currencyCode;
  }
}
