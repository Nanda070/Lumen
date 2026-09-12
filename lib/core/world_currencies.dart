/// ISO 4217 active currencies for base-currency pickers.
class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.nameEn,
    required this.nameRu,
  });

  final String code;
  final String nameEn;
  final String nameRu;

  String label(String localeCode) =>
      localeCode == 'ru' ? nameRu : nameEn;

  bool matches(String query, String localeCode) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return code.toLowerCase().contains(q) ||
        nameEn.toLowerCase().contains(q) ||
        nameRu.toLowerCase().contains(q);
  }
}

abstract final class WorldCurrencies {
  /// 154 active ISO 4217 codes (excl. precious metals / testing).
  static const List<CurrencyOption> all = [
    CurrencyOption(code: 'AED', nameEn: 'UAE Dirham', nameRu: 'Дирхам ОАЭ'),
    CurrencyOption(code: 'AFN', nameEn: 'Afghan Afghani', nameRu: 'Афгани'),
    CurrencyOption(code: 'ALL', nameEn: 'Albanian Lek', nameRu: 'Албанский лек'),
    CurrencyOption(code: 'AMD', nameEn: 'Armenian Dram', nameRu: 'Армянский драм'),
    CurrencyOption(code: 'ANG', nameEn: 'Netherlands Antillean Guilder', nameRu: 'Нидерландский антильский гульден'),
    CurrencyOption(code: 'AOA', nameEn: 'Angolan Kwanza', nameRu: 'Ангольская кванза'),
    CurrencyOption(code: 'ARS', nameEn: 'Argentine Peso', nameRu: 'Аргентинский песо'),
    CurrencyOption(code: 'AUD', nameEn: 'Australian Dollar', nameRu: 'Австралийский доллар'),
    CurrencyOption(code: 'AWG', nameEn: 'Aruban Florin', nameRu: 'Арубанский флорин'),
    CurrencyOption(code: 'AZN', nameEn: 'Azerbaijani Manat', nameRu: 'Азербайджанский манат'),
    CurrencyOption(code: 'BAM', nameEn: 'Bosnia-Herzegovina Convertible Mark', nameRu: 'Конвертируемая марка БиГ'),
    CurrencyOption(code: 'BBD', nameEn: 'Barbadian Dollar', nameRu: 'Барбадосский доллар'),
    CurrencyOption(code: 'BDT', nameEn: 'Bangladeshi Taka', nameRu: 'Бангладешская така'),
    CurrencyOption(code: 'BGN', nameEn: 'Bulgarian Lev', nameRu: 'Болгарский лев'),
    CurrencyOption(code: 'BHD', nameEn: 'Bahraini Dinar', nameRu: 'Бахрейнский динар'),
    CurrencyOption(code: 'BIF', nameEn: 'Burundian Franc', nameRu: 'Бурундийский франк'),
    CurrencyOption(code: 'BMD', nameEn: 'Bermudan Dollar', nameRu: 'Бермудский доллар'),
    CurrencyOption(code: 'BND', nameEn: 'Brunei Dollar', nameRu: 'Брунейский доллар'),
    CurrencyOption(code: 'BOB', nameEn: 'Bolivian Boliviano', nameRu: 'Боливийский боливиано'),
    CurrencyOption(code: 'BRL', nameEn: 'Brazilian Real', nameRu: 'Бразильский реал'),
    CurrencyOption(code: 'BSD', nameEn: 'Bahamian Dollar', nameRu: 'Багамский доллар'),
    CurrencyOption(code: 'BTN', nameEn: 'Bhutanese Ngultrum', nameRu: 'Бутанский нгултрум'),
    CurrencyOption(code: 'BWP', nameEn: 'Botswanan Pula', nameRu: 'Ботсванская пула'),
    CurrencyOption(code: 'BYN', nameEn: 'Belarusian Ruble', nameRu: 'Белорусский рубль'),
    CurrencyOption(code: 'BZD', nameEn: 'Belize Dollar', nameRu: 'Белизский доллар'),
    CurrencyOption(code: 'CAD', nameEn: 'Canadian Dollar', nameRu: 'Канадский доллар'),
    CurrencyOption(code: 'CDF', nameEn: 'Congolese Franc', nameRu: 'Конголезский франк'),
    CurrencyOption(code: 'CHF', nameEn: 'Swiss Franc', nameRu: 'Швейцарский франк'),
    CurrencyOption(code: 'CLP', nameEn: 'Chilean Peso', nameRu: 'Чилийский песо'),
    CurrencyOption(code: 'CNY', nameEn: 'Chinese Yuan', nameRu: 'Китайский юань'),
    CurrencyOption(code: 'COP', nameEn: 'Colombian Peso', nameRu: 'Колумбийский песо'),
    CurrencyOption(code: 'CRC', nameEn: 'Costa Rican Colón', nameRu: 'Костариканский колон'),
    CurrencyOption(code: 'CUP', nameEn: 'Cuban Peso', nameRu: 'Кубинский песо'),
    CurrencyOption(code: 'CVE', nameEn: 'Cape Verdean Escudo', nameRu: 'Эскудо Кабо-Верде'),
    CurrencyOption(code: 'CZK', nameEn: 'Czech Koruna', nameRu: 'Чешская крона'),
    CurrencyOption(code: 'DJF', nameEn: 'Djiboutian Franc', nameRu: 'Джибутийский франк'),
    CurrencyOption(code: 'DKK', nameEn: 'Danish Krone', nameRu: 'Датская крона'),
    CurrencyOption(code: 'DOP', nameEn: 'Dominican Peso', nameRu: 'Доминиканский песо'),
    CurrencyOption(code: 'DZD', nameEn: 'Algerian Dinar', nameRu: 'Алжирский динар'),
    CurrencyOption(code: 'EGP', nameEn: 'Egyptian Pound', nameRu: 'Египетский фунт'),
    CurrencyOption(code: 'ERN', nameEn: 'Eritrean Nakfa', nameRu: 'Эритрейская накфа'),
    CurrencyOption(code: 'ETB', nameEn: 'Ethiopian Birr', nameRu: 'Эфиопский быр'),
    CurrencyOption(code: 'EUR', nameEn: 'Euro', nameRu: 'Евро'),
    CurrencyOption(code: 'FJD', nameEn: 'Fijian Dollar', nameRu: 'Доллар Фиджи'),
    CurrencyOption(code: 'FKP', nameEn: 'Falkland Islands Pound', nameRu: 'Фунт Фолклендских островов'),
    CurrencyOption(code: 'GBP', nameEn: 'British Pound', nameRu: 'Фунт стерлингов'),
    CurrencyOption(code: 'GEL', nameEn: 'Georgian Lari', nameRu: 'Грузинский лари'),
    CurrencyOption(code: 'GHS', nameEn: 'Ghanaian Cedi', nameRu: 'Ганский седи'),
    CurrencyOption(code: 'GIP', nameEn: 'Gibraltar Pound', nameRu: 'Гибралтарский фунт'),
    CurrencyOption(code: 'GMD', nameEn: 'Gambian Dalasi', nameRu: 'Гамбийский даласи'),
    CurrencyOption(code: 'GNF', nameEn: 'Guinean Franc', nameRu: 'Гвинейский франк'),
    CurrencyOption(code: 'GTQ', nameEn: 'Guatemalan Quetzal', nameRu: 'Гватемальский кетсаль'),
    CurrencyOption(code: 'GYD', nameEn: 'Guyanaese Dollar', nameRu: 'Гайанский доллар'),
    CurrencyOption(code: 'HKD', nameEn: 'Hong Kong Dollar', nameRu: 'Гонконгский доллар'),
    CurrencyOption(code: 'HNL', nameEn: 'Honduran Lempira', nameRu: 'Гондурасская лемпира'),
    CurrencyOption(code: 'HTG', nameEn: 'Haitian Gourde', nameRu: 'Гаитянский гурд'),
    CurrencyOption(code: 'HUF', nameEn: 'Hungarian Forint', nameRu: 'Венгерский форинт'),
    CurrencyOption(code: 'IDR', nameEn: 'Indonesian Rupiah', nameRu: 'Индонезийская рупия'),
    CurrencyOption(code: 'ILS', nameEn: 'Israeli New Shekel', nameRu: 'Израильский шекель'),
    CurrencyOption(code: 'INR', nameEn: 'Indian Rupee', nameRu: 'Индийская рупия'),
    CurrencyOption(code: 'IQD', nameEn: 'Iraqi Dinar', nameRu: 'Иракский динар'),
    CurrencyOption(code: 'IRR', nameEn: 'Iranian Rial', nameRu: 'Иранский риал'),
    CurrencyOption(code: 'ISK', nameEn: 'Icelandic Króna', nameRu: 'Исландская крона'),
    CurrencyOption(code: 'JMD', nameEn: 'Jamaican Dollar', nameRu: 'Ямайский доллар'),
    CurrencyOption(code: 'JOD', nameEn: 'Jordanian Dinar', nameRu: 'Иорданский динар'),
    CurrencyOption(code: 'JPY', nameEn: 'Japanese Yen', nameRu: 'Японская иена'),
    CurrencyOption(code: 'KES', nameEn: 'Kenyan Shilling', nameRu: 'Кенийский шиллинг'),
    CurrencyOption(code: 'KGS', nameEn: 'Kyrgystani Som', nameRu: 'Киргизский сом'),
    CurrencyOption(code: 'KHR', nameEn: 'Cambodian Riel', nameRu: 'Камбоджийский риель'),
    CurrencyOption(code: 'KMF', nameEn: 'Comorian Franc', nameRu: 'Коморский франк'),
    CurrencyOption(code: 'KPW', nameEn: 'North Korean Won', nameRu: 'Северокорейская вона'),
    CurrencyOption(code: 'KRW', nameEn: 'South Korean Won', nameRu: 'Южнокорейская вона'),
    CurrencyOption(code: 'KWD', nameEn: 'Kuwaiti Dinar', nameRu: 'Кувейтский динар'),
    CurrencyOption(code: 'KYD', nameEn: 'Cayman Islands Dollar', nameRu: 'Доллар Каймановых островов'),
    CurrencyOption(code: 'KZT', nameEn: 'Kazakhstani Tenge', nameRu: 'Казахстанский тенге'),
    CurrencyOption(code: 'LAK', nameEn: 'Laotian Kip', nameRu: 'Лаосский кип'),
    CurrencyOption(code: 'LBP', nameEn: 'Lebanese Pound', nameRu: 'Ливанский фунт'),
    CurrencyOption(code: 'LKR', nameEn: 'Sri Lankan Rupee', nameRu: 'Шри-ланкийская рупия'),
    CurrencyOption(code: 'LRD', nameEn: 'Liberian Dollar', nameRu: 'Либерийский доллар'),
    CurrencyOption(code: 'LSL', nameEn: 'Lesotho Loti', nameRu: 'Лоти Лесото'),
    CurrencyOption(code: 'LYD', nameEn: 'Libyan Dinar', nameRu: 'Ливийский динар'),
    CurrencyOption(code: 'MAD', nameEn: 'Moroccan Dirham', nameRu: 'Марокканский дирхам'),
    CurrencyOption(code: 'MDL', nameEn: 'Moldovan Leu', nameRu: 'Молдавский лей'),
    CurrencyOption(code: 'MGA', nameEn: 'Malagasy Ariary', nameRu: 'Малагасийский ариари'),
    CurrencyOption(code: 'MKD', nameEn: 'Macedonian Denar', nameRu: 'Македонский денар'),
    CurrencyOption(code: 'MMK', nameEn: 'Myanmar Kyat', nameRu: 'Мьянманский кьят'),
    CurrencyOption(code: 'MNT', nameEn: 'Mongolian Tugrik', nameRu: 'Монгольский тугрик'),
    CurrencyOption(code: 'MOP', nameEn: 'Macanese Pataca', nameRu: 'Патака Макао'),
    CurrencyOption(code: 'MRU', nameEn: 'Mauritanian Ouguiya', nameRu: 'Мавританская угия'),
    CurrencyOption(code: 'MUR', nameEn: 'Mauritian Rupee', nameRu: 'Маврикийская рупия'),
    CurrencyOption(code: 'MVR', nameEn: 'Maldivian Rufiyaa', nameRu: 'Мальдивская руфия'),
    CurrencyOption(code: 'MWK', nameEn: 'Malawian Kwacha', nameRu: 'Малавийская квача'),
    CurrencyOption(code: 'MXN', nameEn: 'Mexican Peso', nameRu: 'Мексиканский песо'),
    CurrencyOption(code: 'MYR', nameEn: 'Malaysian Ringgit', nameRu: 'Малайзийский ринггит'),
    CurrencyOption(code: 'MZN', nameEn: 'Mozambican Metical', nameRu: 'Мозамбикский метикал'),
    CurrencyOption(code: 'NAD', nameEn: 'Namibian Dollar', nameRu: 'Намибийский доллар'),
    CurrencyOption(code: 'NGN', nameEn: 'Nigerian Naira', nameRu: 'Нигерийская найра'),
    CurrencyOption(code: 'NIO', nameEn: 'Nicaraguan Córdoba', nameRu: 'Никарагуанская кордоба'),
    CurrencyOption(code: 'NOK', nameEn: 'Norwegian Krone', nameRu: 'Норвежская крона'),
    CurrencyOption(code: 'NPR', nameEn: 'Nepalese Rupee', nameRu: 'Непальская рупия'),
    CurrencyOption(code: 'NZD', nameEn: 'New Zealand Dollar', nameRu: 'Новозеландский доллар'),
    CurrencyOption(code: 'OMR', nameEn: 'Omani Rial', nameRu: 'Оманский риал'),
    CurrencyOption(code: 'PAB', nameEn: 'Panamanian Balboa', nameRu: 'Панамский бальбоа'),
    CurrencyOption(code: 'PEN', nameEn: 'Peruvian Sol', nameRu: 'Перуанский соль'),
    CurrencyOption(code: 'PGK', nameEn: 'Papua New Guinean Kina', nameRu: 'Кина Папуа — Новой Гвинеи'),
    CurrencyOption(code: 'PHP', nameEn: 'Philippine Peso', nameRu: 'Филиппинский песо'),
    CurrencyOption(code: 'PKR', nameEn: 'Pakistani Rupee', nameRu: 'Пакистанская рупия'),
    CurrencyOption(code: 'PLN', nameEn: 'Polish Złoty', nameRu: 'Польский злотый'),
    CurrencyOption(code: 'PYG', nameEn: 'Paraguayan Guarani', nameRu: 'Парагвайский гуарани'),
    CurrencyOption(code: 'QAR', nameEn: 'Qatari Riyal', nameRu: 'Катарский риал'),
    CurrencyOption(code: 'RON', nameEn: 'Romanian Leu', nameRu: 'Румынский лей'),
    CurrencyOption(code: 'RSD', nameEn: 'Serbian Dinar', nameRu: 'Сербский динар'),
    CurrencyOption(code: 'RUB', nameEn: 'Russian Ruble', nameRu: 'Российский рубль'),
    CurrencyOption(code: 'RWF', nameEn: 'Rwandan Franc', nameRu: 'Руандийский франк'),
    CurrencyOption(code: 'SAR', nameEn: 'Saudi Riyal', nameRu: 'Саудовский риал'),
    CurrencyOption(code: 'SBD', nameEn: 'Solomon Islands Dollar', nameRu: 'Доллар Соломоновых островов'),
    CurrencyOption(code: 'SCR', nameEn: 'Seychellois Rupee', nameRu: 'Сейшельская рупия'),
    CurrencyOption(code: 'SDG', nameEn: 'Sudanese Pound', nameRu: 'Суданский фунт'),
    CurrencyOption(code: 'SEK', nameEn: 'Swedish Krona', nameRu: 'Шведская крона'),
    CurrencyOption(code: 'SGD', nameEn: 'Singapore Dollar', nameRu: 'Сингапурский доллар'),
    CurrencyOption(code: 'SHP', nameEn: 'Saint Helena Pound', nameRu: 'Фунт Святой Елены'),
    CurrencyOption(code: 'SLE', nameEn: 'Sierra Leonean Leone', nameRu: 'Леоне Сьерра-Леоне'),
    CurrencyOption(code: 'SOS', nameEn: 'Somali Shilling', nameRu: 'Сомалийский шиллинг'),
    CurrencyOption(code: 'SRD', nameEn: 'Surinamese Dollar', nameRu: 'Суринамский доллар'),
    CurrencyOption(code: 'SSP', nameEn: 'South Sudanese Pound', nameRu: 'Южносуданский фунт'),
    CurrencyOption(code: 'STN', nameEn: 'São Tomé and Príncipe Dobra', nameRu: 'Добра Сан-Томе и Принсипи'),
    CurrencyOption(code: 'SYP', nameEn: 'Syrian Pound', nameRu: 'Сирийский фунт'),
    CurrencyOption(code: 'SZL', nameEn: 'Swazi Lilangeni', nameRu: 'Свазилендский лилангени'),
    CurrencyOption(code: 'THB', nameEn: 'Thai Baht', nameRu: 'Тайский бат'),
    CurrencyOption(code: 'TJS', nameEn: 'Tajikistani Somoni', nameRu: 'Таджикский сомони'),
    CurrencyOption(code: 'TMT', nameEn: 'Turkmenistani Manat', nameRu: 'Туркменский манат'),
    CurrencyOption(code: 'TND', nameEn: 'Tunisian Dinar', nameRu: 'Тунисский динар'),
    CurrencyOption(code: 'TOP', nameEn: 'Tongan Paʻanga', nameRu: 'Тонганская паанга'),
    CurrencyOption(code: 'TRY', nameEn: 'Turkish Lira', nameRu: 'Турецкая лира'),
    CurrencyOption(code: 'TTD', nameEn: 'Trinidad and Tobago Dollar', nameRu: 'Доллар Тринидада и Тобаго'),
    CurrencyOption(code: 'TWD', nameEn: 'New Taiwan Dollar', nameRu: 'Новый тайваньский доллар'),
    CurrencyOption(code: 'TZS', nameEn: 'Tanzanian Shilling', nameRu: 'Танзанийский шиллинг'),
    CurrencyOption(code: 'UAH', nameEn: 'Ukrainian Hryvnia', nameRu: 'Украинская гривна'),
    CurrencyOption(code: 'UGX', nameEn: 'Ugandan Shilling', nameRu: 'Угандийский шиллинг'),
    CurrencyOption(code: 'USD', nameEn: 'US Dollar', nameRu: 'Доллар США'),
    CurrencyOption(code: 'UYU', nameEn: 'Uruguayan Peso', nameRu: 'Уругвайский песо'),
    CurrencyOption(code: 'UZS', nameEn: 'Uzbekistani Som', nameRu: 'Узбекский сум'),
    CurrencyOption(code: 'VES', nameEn: 'Venezuelan Bolívar', nameRu: 'Венесуэльский боливар'),
    CurrencyOption(code: 'VND', nameEn: 'Vietnamese Dong', nameRu: 'Вьетнамский донг'),
    CurrencyOption(code: 'VUV', nameEn: 'Vanuatu Vatu', nameRu: 'Вануатский вату'),
    CurrencyOption(code: 'WST', nameEn: 'Samoan Tala', nameRu: 'Самоанская тала'),
    CurrencyOption(code: 'XAF', nameEn: 'Central African CFA Franc', nameRu: 'Франк КФА BEAC'),
    CurrencyOption(code: 'XCD', nameEn: 'East Caribbean Dollar', nameRu: 'Восточно-карибский доллар'),
    CurrencyOption(code: 'XOF', nameEn: 'West African CFA Franc', nameRu: 'Франк КФА BCEAO'),
    CurrencyOption(code: 'XPF', nameEn: 'CFP Franc', nameRu: 'Франк КФП'),
    CurrencyOption(code: 'YER', nameEn: 'Yemeni Rial', nameRu: 'Йеменский риал'),
    CurrencyOption(code: 'ZAR', nameEn: 'South African Rand', nameRu: 'Южноафриканский рэнд'),
    CurrencyOption(code: 'ZMW', nameEn: 'Zambian Kwacha', nameRu: 'Замбийская квача'),
    CurrencyOption(code: 'ZWL', nameEn: 'Zimbabwean Dollar', nameRu: 'Зимбабвийский доллар'),
  ];

  static CurrencyOption? byCode(String code) {
    final upper = code.toUpperCase();
    for (final c in all) {
      if (c.code == upper) return c;
    }
    return null;
  }

  static List<CurrencyOption> search(String query, String localeCode) {
    return [
      for (final c in all)
        if (c.matches(query, localeCode)) c,
    ];
  }
}
