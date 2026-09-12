// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeCodeMeta = const VerificationMeta(
    'localeCode',
  );
  @override
  late final GeneratedColumn<String> localeCode = GeneratedColumn<String>(
    'locale_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    localeCode,
    countryCode,
    currencyCode,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('locale_code')) {
      context.handle(
        _localeCodeMeta,
        localeCode.isAcceptableOrUnknown(data['locale_code']!, _localeCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeCodeMeta);
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      localeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_code'],
      )!,
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String displayName;
  final String localeCode;
  final String countryCode;
  final String currencyCode;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.displayName,
    required this.localeCode,
    required this.countryCode,
    required this.currencyCode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['locale_code'] = Variable<String>(localeCode);
    map['country_code'] = Variable<String>(countryCode);
    map['currency_code'] = Variable<String>(currencyCode);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      localeCode: Value(localeCode),
      countryCode: Value(countryCode),
      currencyCode: Value(currencyCode),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      localeCode: serializer.fromJson<String>(json['localeCode']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'localeCode': serializer.toJson<String>(localeCode),
      'countryCode': serializer.toJson<String>(countryCode),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    int? id,
    String? displayName,
    String? localeCode,
    String? countryCode,
    String? currencyCode,
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    localeCode: localeCode ?? this.localeCode,
    countryCode: countryCode ?? this.countryCode,
    currencyCode: currencyCode ?? this.currencyCode,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      localeCode: data.localeCode.present
          ? data.localeCode.value
          : this.localeCode,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('localeCode: $localeCode, ')
          ..write('countryCode: $countryCode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    localeCode,
    countryCode,
    currencyCode,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.localeCode == this.localeCode &&
          other.countryCode == this.countryCode &&
          other.currencyCode == this.currencyCode &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String> localeCode;
  final Value<String> countryCode;
  final Value<String> currencyCode;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.localeCode = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String displayName,
    required String localeCode,
    required String countryCode,
    required String currencyCode,
    required DateTime createdAt,
  }) : displayName = Value(displayName),
       localeCode = Value(localeCode),
       countryCode = Value(countryCode),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? localeCode,
    Expression<String>? countryCode,
    Expression<String>? currencyCode,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (localeCode != null) 'locale_code': localeCode,
      if (countryCode != null) 'country_code': countryCode,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? displayName,
    Value<String>? localeCode,
    Value<String>? countryCode,
    Value<String>? currencyCode,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      localeCode: localeCode ?? this.localeCode,
      countryCode: countryCode ?? this.countryCode,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (localeCode.present) {
      map['locale_code'] = Variable<String>(localeCode.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('localeCode: $localeCode, ')
          ..write('countryCode: $countryCode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarsTable extends Calendars
    with TableInfo<$CalendarsTable, Calendar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorArgbMeta = const VerificationMeta(
    'colorArgb',
  );
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
    'color_argb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorArgb,
    isSystem,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendars';
  @override
  VerificationContext validateIntegrity(
    Insertable<Calendar> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_argb')) {
      context.handle(
        _colorArgbMeta,
        colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta),
      );
    } else if (isInserting) {
      context.missing(_colorArgbMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Calendar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Calendar(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_argb'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CalendarsTable createAlias(String alias) {
    return $CalendarsTable(attachedDatabase, alias);
  }
}

class Calendar extends DataClass implements Insertable<Calendar> {
  final int id;
  final String name;
  final int colorArgb;
  final bool isSystem;
  final int sortOrder;
  const Calendar({
    required this.id,
    required this.name,
    required this.colorArgb,
    required this.isSystem,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_argb'] = Variable<int>(colorArgb);
    map['is_system'] = Variable<bool>(isSystem);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CalendarsCompanion toCompanion(bool nullToAbsent) {
    return CalendarsCompanion(
      id: Value(id),
      name: Value(name),
      colorArgb: Value(colorArgb),
      isSystem: Value(isSystem),
      sortOrder: Value(sortOrder),
    );
  }

  factory Calendar.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Calendar(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorArgb: serializer.fromJson<int>(json['colorArgb']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorArgb': serializer.toJson<int>(colorArgb),
      'isSystem': serializer.toJson<bool>(isSystem),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Calendar copyWith({
    int? id,
    String? name,
    int? colorArgb,
    bool? isSystem,
    int? sortOrder,
  }) => Calendar(
    id: id ?? this.id,
    name: name ?? this.name,
    colorArgb: colorArgb ?? this.colorArgb,
    isSystem: isSystem ?? this.isSystem,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Calendar copyWithCompanion(CalendarsCompanion data) {
    return Calendar(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Calendar(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorArgb, isSystem, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Calendar &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorArgb == this.colorArgb &&
          other.isSystem == this.isSystem &&
          other.sortOrder == this.sortOrder);
}

class CalendarsCompanion extends UpdateCompanion<Calendar> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> colorArgb;
  final Value<bool> isSystem;
  final Value<int> sortOrder;
  const CalendarsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CalendarsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int colorArgb,
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       colorArgb = Value(colorArgb);
  static Insertable<Calendar> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? colorArgb,
    Expression<bool>? isSystem,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (isSystem != null) 'is_system': isSystem,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CalendarsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? colorArgb,
    Value<bool>? isSystem,
    Value<int>? sortOrder,
  }) {
    return CalendarsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorArgb: colorArgb ?? this.colorArgb,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $FinanceCategoriesTable extends FinanceCategories
    with TableInfo<$FinanceCategoriesTable, FinanceCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 48,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorArgbMeta = const VerificationMeta(
    'colorArgb',
  );
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
    'color_argb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameKey,
    displayName,
    kind,
    colorArgb,
    sortOrder,
    isSystem,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinanceCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('color_argb')) {
      context.handle(
        _colorArgbMeta,
        colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta),
      );
    } else if (isInserting) {
      context.missing(_colorArgbMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      colorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_argb'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $FinanceCategoriesTable createAlias(String alias) {
    return $FinanceCategoriesTable(attachedDatabase, alias);
  }
}

class FinanceCategory extends DataClass implements Insertable<FinanceCategory> {
  final int id;

  /// Stable i18n key (e.g. food, salary) or `custom` for user-named.
  final String nameKey;

  /// Custom display name; when set, UI prefers this over i18n of [nameKey].
  final String? displayName;

  /// `expense` | `income`
  final String kind;
  final int colorArgb;
  final int sortOrder;
  final bool isSystem;
  final bool isArchived;
  const FinanceCategory({
    required this.id,
    required this.nameKey,
    this.displayName,
    required this.kind,
    required this.colorArgb,
    required this.sortOrder,
    required this.isSystem,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_key'] = Variable<String>(nameKey);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['kind'] = Variable<String>(kind);
    map['color_argb'] = Variable<int>(colorArgb);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_system'] = Variable<bool>(isSystem);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  FinanceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return FinanceCategoriesCompanion(
      id: Value(id),
      nameKey: Value(nameKey),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      kind: Value(kind),
      colorArgb: Value(colorArgb),
      sortOrder: Value(sortOrder),
      isSystem: Value(isSystem),
      isArchived: Value(isArchived),
    );
  }

  factory FinanceCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceCategory(
      id: serializer.fromJson<int>(json['id']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      kind: serializer.fromJson<String>(json['kind']),
      colorArgb: serializer.fromJson<int>(json['colorArgb']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameKey': serializer.toJson<String>(nameKey),
      'displayName': serializer.toJson<String?>(displayName),
      'kind': serializer.toJson<String>(kind),
      'colorArgb': serializer.toJson<int>(colorArgb),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  FinanceCategory copyWith({
    int? id,
    String? nameKey,
    Value<String?> displayName = const Value.absent(),
    String? kind,
    int? colorArgb,
    int? sortOrder,
    bool? isSystem,
    bool? isArchived,
  }) => FinanceCategory(
    id: id ?? this.id,
    nameKey: nameKey ?? this.nameKey,
    displayName: displayName.present ? displayName.value : this.displayName,
    kind: kind ?? this.kind,
    colorArgb: colorArgb ?? this.colorArgb,
    sortOrder: sortOrder ?? this.sortOrder,
    isSystem: isSystem ?? this.isSystem,
    isArchived: isArchived ?? this.isArchived,
  );
  FinanceCategory copyWithCompanion(FinanceCategoriesCompanion data) {
    return FinanceCategory(
      id: data.id.present ? data.id.value : this.id,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      kind: data.kind.present ? data.kind.value : this.kind,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceCategory(')
          ..write('id: $id, ')
          ..write('nameKey: $nameKey, ')
          ..write('displayName: $displayName, ')
          ..write('kind: $kind, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameKey,
    displayName,
    kind,
    colorArgb,
    sortOrder,
    isSystem,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceCategory &&
          other.id == this.id &&
          other.nameKey == this.nameKey &&
          other.displayName == this.displayName &&
          other.kind == this.kind &&
          other.colorArgb == this.colorArgb &&
          other.sortOrder == this.sortOrder &&
          other.isSystem == this.isSystem &&
          other.isArchived == this.isArchived);
}

class FinanceCategoriesCompanion extends UpdateCompanion<FinanceCategory> {
  final Value<int> id;
  final Value<String> nameKey;
  final Value<String?> displayName;
  final Value<String> kind;
  final Value<int> colorArgb;
  final Value<int> sortOrder;
  final Value<bool> isSystem;
  final Value<bool> isArchived;
  const FinanceCategoriesCompanion({
    this.id = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.kind = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  FinanceCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nameKey,
    this.displayName = const Value.absent(),
    required String kind,
    required int colorArgb,
    this.sortOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isArchived = const Value.absent(),
  }) : nameKey = Value(nameKey),
       kind = Value(kind),
       colorArgb = Value(colorArgb);
  static Insertable<FinanceCategory> custom({
    Expression<int>? id,
    Expression<String>? nameKey,
    Expression<String>? displayName,
    Expression<String>? kind,
    Expression<int>? colorArgb,
    Expression<int>? sortOrder,
    Expression<bool>? isSystem,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameKey != null) 'name_key': nameKey,
      if (displayName != null) 'display_name': displayName,
      if (kind != null) 'kind': kind,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isSystem != null) 'is_system': isSystem,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  FinanceCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? nameKey,
    Value<String?>? displayName,
    Value<String>? kind,
    Value<int>? colorArgb,
    Value<int>? sortOrder,
    Value<bool>? isSystem,
    Value<bool>? isArchived,
  }) {
    return FinanceCategoriesCompanion(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      displayName: displayName ?? this.displayName,
      kind: kind ?? this.kind,
      colorArgb: colorArgb ?? this.colorArgb,
      sortOrder: sortOrder ?? this.sortOrder,
      isSystem: isSystem ?? this.isSystem,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameKey: $nameKey, ')
          ..write('displayName: $displayName, ')
          ..write('kind: $kind, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
    'ends_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calendarIdMeta = const VerificationMeta(
    'calendarId',
  );
  @override
  late final GeneratedColumn<int> calendarId = GeneratedColumn<int>(
    'calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calendars (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    startsAt,
    endsAt,
    calendarId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(
        _endsAtMeta,
        endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endsAtMeta);
    }
    if (data.containsKey('calendar_id')) {
      context.handle(
        _calendarIdMeta,
        calendarId.isAcceptableOrUnknown(data['calendar_id']!, _calendarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_calendarIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      endsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ends_at'],
      )!,
      calendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calendar_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String title;
  final DateTime startsAt;
  final DateTime endsAt;
  final int calendarId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Event({
    required this.id,
    required this.title,
    required this.startsAt,
    required this.endsAt,
    required this.calendarId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['ends_at'] = Variable<DateTime>(endsAt);
    map['calendar_id'] = Variable<int>(calendarId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title: Value(title),
      startsAt: Value(startsAt),
      endsAt: Value(endsAt),
      calendarId: Value(calendarId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime>(json['endsAt']),
      calendarId: serializer.fromJson<int>(json['calendarId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'endsAt': serializer.toJson<DateTime>(endsAt),
      'calendarId': serializer.toJson<int>(calendarId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Event copyWith({
    int? id,
    String? title,
    DateTime? startsAt,
    DateTime? endsAt,
    int? calendarId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Event(
    id: id ?? this.id,
    title: title ?? this.title,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt ?? this.endsAt,
    calendarId: calendarId ?? this.calendarId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      calendarId: data.calendarId.present
          ? data.calendarId.value
          : this.calendarId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('calendarId: $calendarId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    startsAt,
    endsAt,
    calendarId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.title == this.title &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.calendarId == this.calendarId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> startsAt;
  final Value<DateTime> endsAt;
  final Value<int> calendarId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required int calendarId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : title = Value(title),
       startsAt = Value(startsAt),
       endsAt = Value(endsAt),
       calendarId = Value(calendarId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<int>? calendarId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (calendarId != null) 'calendar_id': calendarId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EventsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? startsAt,
    Value<DateTime>? endsAt,
    Value<int>? calendarId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      calendarId: calendarId ?? this.calendarId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (calendarId.present) {
      map['calendar_id'] = Variable<int>(calendarId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('calendarId: $calendarId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FinanceAccountsTable extends FinanceAccounts
    with TableInfo<$FinanceAccountsTable, FinanceAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMinorMeta = const VerificationMeta(
    'balanceMinor',
  );
  @override
  late final GeneratedColumn<int> balanceMinor = GeneratedColumn<int>(
    'balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    balanceMinor,
    currencyCode,
    sortOrder,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinanceAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance_minor')) {
      context.handle(
        _balanceMinorMeta,
        balanceMinor.isAcceptableOrUnknown(
          data['balance_minor']!,
          _balanceMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      balanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FinanceAccountsTable createAlias(String alias) {
    return $FinanceAccountsTable(attachedDatabase, alias);
  }
}

class FinanceAccount extends DataClass implements Insertable<FinanceAccount> {
  final int id;
  final String name;
  final int balanceMinor;
  final String currencyCode;
  final int sortOrder;
  final bool isArchived;
  final DateTime createdAt;
  const FinanceAccount({
    required this.id,
    required this.name,
    required this.balanceMinor,
    required this.currencyCode,
    required this.sortOrder,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['balance_minor'] = Variable<int>(balanceMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FinanceAccountsCompanion toCompanion(bool nullToAbsent) {
    return FinanceAccountsCompanion(
      id: Value(id),
      name: Value(name),
      balanceMinor: Value(balanceMinor),
      currencyCode: Value(currencyCode),
      sortOrder: Value(sortOrder),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory FinanceAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceAccount(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      balanceMinor: serializer.fromJson<int>(json['balanceMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'balanceMinor': serializer.toJson<int>(balanceMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FinanceAccount copyWith({
    int? id,
    String? name,
    int? balanceMinor,
    String? currencyCode,
    int? sortOrder,
    bool? isArchived,
    DateTime? createdAt,
  }) => FinanceAccount(
    id: id ?? this.id,
    name: name ?? this.name,
    balanceMinor: balanceMinor ?? this.balanceMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    sortOrder: sortOrder ?? this.sortOrder,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  FinanceAccount copyWithCompanion(FinanceAccountsCompanion data) {
    return FinanceAccount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      balanceMinor: data.balanceMinor.present
          ? data.balanceMinor.value
          : this.balanceMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceAccount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balanceMinor: $balanceMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    balanceMinor,
    currencyCode,
    sortOrder,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceAccount &&
          other.id == this.id &&
          other.name == this.name &&
          other.balanceMinor == this.balanceMinor &&
          other.currencyCode == this.currencyCode &&
          other.sortOrder == this.sortOrder &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class FinanceAccountsCompanion extends UpdateCompanion<FinanceAccount> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> balanceMinor;
  final Value<String> currencyCode;
  final Value<int> sortOrder;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const FinanceAccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.balanceMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FinanceAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.balanceMinor = const Value.absent(),
    required String currencyCode,
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt);
  static Insertable<FinanceAccount> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? balanceMinor,
    Expression<String>? currencyCode,
    Expression<int>? sortOrder,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (balanceMinor != null) 'balance_minor': balanceMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FinanceAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? balanceMinor,
    Value<String>? currencyCode,
    Value<int>? sortOrder,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return FinanceAccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      balanceMinor: balanceMinor ?? this.balanceMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balanceMinor.present) {
      map['balance_minor'] = Variable<int>(balanceMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceAccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balanceMinor: $balanceMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MonthlyBudgetsTable extends MonthlyBudgets
    with TableInfo<$MonthlyBudgetsTable, MonthlyBudget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyBudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalLimitMinorMeta = const VerificationMeta(
    'totalLimitMinor',
  );
  @override
  late final GeneratedColumn<int> totalLimitMinor = GeneratedColumn<int>(
    'total_limit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    totalLimitMinor,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyBudget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('total_limit_minor')) {
      context.handle(
        _totalLimitMinorMeta,
        totalLimitMinor.isAcceptableOrUnknown(
          data['total_limit_minor']!,
          _totalLimitMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalLimitMinorMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyBudget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyBudget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      totalLimitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_limit_minor'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MonthlyBudgetsTable createAlias(String alias) {
    return $MonthlyBudgetsTable(attachedDatabase, alias);
  }
}

class MonthlyBudget extends DataClass implements Insertable<MonthlyBudget> {
  final int id;
  final int year;
  final int month;
  final int totalLimitMinor;
  final DateTime updatedAt;
  const MonthlyBudget({
    required this.id,
    required this.year,
    required this.month,
    required this.totalLimitMinor,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['total_limit_minor'] = Variable<int>(totalLimitMinor);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MonthlyBudgetsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyBudgetsCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      totalLimitMinor: Value(totalLimitMinor),
      updatedAt: Value(updatedAt),
    );
  }

  factory MonthlyBudget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyBudget(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      totalLimitMinor: serializer.fromJson<int>(json['totalLimitMinor']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'totalLimitMinor': serializer.toJson<int>(totalLimitMinor),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MonthlyBudget copyWith({
    int? id,
    int? year,
    int? month,
    int? totalLimitMinor,
    DateTime? updatedAt,
  }) => MonthlyBudget(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    totalLimitMinor: totalLimitMinor ?? this.totalLimitMinor,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MonthlyBudget copyWithCompanion(MonthlyBudgetsCompanion data) {
    return MonthlyBudget(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      totalLimitMinor: data.totalLimitMinor.present
          ? data.totalLimitMinor.value
          : this.totalLimitMinor,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyBudget(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('totalLimitMinor: $totalLimitMinor, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, year, month, totalLimitMinor, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyBudget &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.totalLimitMinor == this.totalLimitMinor &&
          other.updatedAt == this.updatedAt);
}

class MonthlyBudgetsCompanion extends UpdateCompanion<MonthlyBudget> {
  final Value<int> id;
  final Value<int> year;
  final Value<int> month;
  final Value<int> totalLimitMinor;
  final Value<DateTime> updatedAt;
  const MonthlyBudgetsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.totalLimitMinor = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MonthlyBudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int year,
    required int month,
    required int totalLimitMinor,
    required DateTime updatedAt,
  }) : year = Value(year),
       month = Value(month),
       totalLimitMinor = Value(totalLimitMinor),
       updatedAt = Value(updatedAt);
  static Insertable<MonthlyBudget> custom({
    Expression<int>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? totalLimitMinor,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (totalLimitMinor != null) 'total_limit_minor': totalLimitMinor,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MonthlyBudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? year,
    Value<int>? month,
    Value<int>? totalLimitMinor,
    Value<DateTime>? updatedAt,
  }) {
    return MonthlyBudgetsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      totalLimitMinor: totalLimitMinor ?? this.totalLimitMinor,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (totalLimitMinor.present) {
      map['total_limit_minor'] = Variable<int>(totalLimitMinor.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyBudgetsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('totalLimitMinor: $totalLimitMinor, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CategoryAllocationsTable extends CategoryAllocations
    with TableInfo<$CategoryAllocationsTable, CategoryAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES finance_categories (id)',
    ),
  );
  static const VerificationMeta _allocatedMinorMeta = const VerificationMeta(
    'allocatedMinor',
  );
  @override
  late final GeneratedColumn<int> allocatedMinor = GeneratedColumn<int>(
    'allocated_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    categoryId,
    allocatedMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('allocated_minor')) {
      context.handle(
        _allocatedMinorMeta,
        allocatedMinor.isAcceptableOrUnknown(
          data['allocated_minor']!,
          _allocatedMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allocatedMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      allocatedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocated_minor'],
      )!,
    );
  }

  @override
  $CategoryAllocationsTable createAlias(String alias) {
    return $CategoryAllocationsTable(attachedDatabase, alias);
  }
}

class CategoryAllocation extends DataClass
    implements Insertable<CategoryAllocation> {
  final int id;
  final int year;
  final int month;
  final int categoryId;
  final int allocatedMinor;
  const CategoryAllocation({
    required this.id,
    required this.year,
    required this.month,
    required this.categoryId,
    required this.allocatedMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['category_id'] = Variable<int>(categoryId);
    map['allocated_minor'] = Variable<int>(allocatedMinor);
    return map;
  }

  CategoryAllocationsCompanion toCompanion(bool nullToAbsent) {
    return CategoryAllocationsCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      categoryId: Value(categoryId),
      allocatedMinor: Value(allocatedMinor),
    );
  }

  factory CategoryAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryAllocation(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      allocatedMinor: serializer.fromJson<int>(json['allocatedMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'categoryId': serializer.toJson<int>(categoryId),
      'allocatedMinor': serializer.toJson<int>(allocatedMinor),
    };
  }

  CategoryAllocation copyWith({
    int? id,
    int? year,
    int? month,
    int? categoryId,
    int? allocatedMinor,
  }) => CategoryAllocation(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    categoryId: categoryId ?? this.categoryId,
    allocatedMinor: allocatedMinor ?? this.allocatedMinor,
  );
  CategoryAllocation copyWithCompanion(CategoryAllocationsCompanion data) {
    return CategoryAllocation(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      allocatedMinor: data.allocatedMinor.present
          ? data.allocatedMinor.value
          : this.allocatedMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryAllocation(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('categoryId: $categoryId, ')
          ..write('allocatedMinor: $allocatedMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, year, month, categoryId, allocatedMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryAllocation &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.categoryId == this.categoryId &&
          other.allocatedMinor == this.allocatedMinor);
}

class CategoryAllocationsCompanion extends UpdateCompanion<CategoryAllocation> {
  final Value<int> id;
  final Value<int> year;
  final Value<int> month;
  final Value<int> categoryId;
  final Value<int> allocatedMinor;
  const CategoryAllocationsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.allocatedMinor = const Value.absent(),
  });
  CategoryAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int year,
    required int month,
    required int categoryId,
    required int allocatedMinor,
  }) : year = Value(year),
       month = Value(month),
       categoryId = Value(categoryId),
       allocatedMinor = Value(allocatedMinor);
  static Insertable<CategoryAllocation> custom({
    Expression<int>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? categoryId,
    Expression<int>? allocatedMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (categoryId != null) 'category_id': categoryId,
      if (allocatedMinor != null) 'allocated_minor': allocatedMinor,
    });
  }

  CategoryAllocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? year,
    Value<int>? month,
    Value<int>? categoryId,
    Value<int>? allocatedMinor,
  }) {
    return CategoryAllocationsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      categoryId: categoryId ?? this.categoryId,
      allocatedMinor: allocatedMinor ?? this.allocatedMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (allocatedMinor.present) {
      map['allocated_minor'] = Variable<int>(allocatedMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('categoryId: $categoryId, ')
          ..write('allocatedMinor: $allocatedMinor')
          ..write(')'))
        .toString();
  }
}

class $FinanceTransactionsTable extends FinanceTransactions
    with TableInfo<$FinanceTransactionsTable, FinanceTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES finance_categories (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES finance_accounts (id)',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountMinor,
    kind,
    categoryId,
    accountId,
    occurredAt,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinanceTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FinanceTransactionsTable createAlias(String alias) {
    return $FinanceTransactionsTable(attachedDatabase, alias);
  }
}

class FinanceTransaction extends DataClass
    implements Insertable<FinanceTransaction> {
  final int id;

  /// Always positive; sign comes from [kind].
  final int amountMinor;

  /// `expense` | `income`
  final String kind;
  final int categoryId;
  final int accountId;
  final DateTime occurredAt;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FinanceTransaction({
    required this.id,
    required this.amountMinor,
    required this.kind,
    required this.categoryId,
    required this.accountId,
    required this.occurredAt,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['kind'] = Variable<String>(kind);
    map['category_id'] = Variable<int>(categoryId);
    map['account_id'] = Variable<int>(accountId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FinanceTransactionsCompanion toCompanion(bool nullToAbsent) {
    return FinanceTransactionsCompanion(
      id: Value(id),
      amountMinor: Value(amountMinor),
      kind: Value(kind),
      categoryId: Value(categoryId),
      accountId: Value(accountId),
      occurredAt: Value(occurredAt),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FinanceTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceTransaction(
      id: serializer.fromJson<int>(json['id']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      kind: serializer.fromJson<String>(json['kind']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'kind': serializer.toJson<String>(kind),
      'categoryId': serializer.toJson<int>(categoryId),
      'accountId': serializer.toJson<int>(accountId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FinanceTransaction copyWith({
    int? id,
    int? amountMinor,
    String? kind,
    int? categoryId,
    int? accountId,
    DateTime? occurredAt,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FinanceTransaction(
    id: id ?? this.id,
    amountMinor: amountMinor ?? this.amountMinor,
    kind: kind ?? this.kind,
    categoryId: categoryId ?? this.categoryId,
    accountId: accountId ?? this.accountId,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FinanceTransaction copyWithCompanion(FinanceTransactionsCompanion data) {
    return FinanceTransaction(
      id: data.id.present ? data.id.value : this.id,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      kind: data.kind.present ? data.kind.value : this.kind,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransaction(')
          ..write('id: $id, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('kind: $kind, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountMinor,
    kind,
    categoryId,
    accountId,
    occurredAt,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceTransaction &&
          other.id == this.id &&
          other.amountMinor == this.amountMinor &&
          other.kind == this.kind &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FinanceTransactionsCompanion extends UpdateCompanion<FinanceTransaction> {
  final Value<int> id;
  final Value<int> amountMinor;
  final Value<String> kind;
  final Value<int> categoryId;
  final Value<int> accountId;
  final Value<DateTime> occurredAt;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FinanceTransactionsCompanion({
    this.id = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.kind = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FinanceTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int amountMinor,
    required String kind,
    required int categoryId,
    required int accountId,
    required DateTime occurredAt,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : amountMinor = Value(amountMinor),
       kind = Value(kind),
       categoryId = Value(categoryId),
       accountId = Value(accountId),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FinanceTransaction> custom({
    Expression<int>? id,
    Expression<int>? amountMinor,
    Expression<String>? kind,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (kind != null) 'kind': kind,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FinanceTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? amountMinor,
    Value<String>? kind,
    Value<int>? categoryId,
    Value<int>? accountId,
    Value<DateTime>? occurredAt,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FinanceTransactionsCompanion(
      id: id ?? this.id,
      amountMinor: amountMinor ?? this.amountMinor,
      kind: kind ?? this.kind,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('kind: $kind, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TodayPreferencesTable extends TodayPreferences
    with TableInfo<$TodayPreferencesTable, TodayPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodayPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _showFinanceSummaryMeta =
      const VerificationMeta('showFinanceSummary');
  @override
  late final GeneratedColumn<bool> showFinanceSummary = GeneratedColumn<bool>(
    'show_finance_summary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_finance_summary" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showBudgetStatusMeta = const VerificationMeta(
    'showBudgetStatus',
  );
  @override
  late final GeneratedColumn<bool> showBudgetStatus = GeneratedColumn<bool>(
    'show_budget_status',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_budget_status" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showTodaySpendMeta = const VerificationMeta(
    'showTodaySpend',
  );
  @override
  late final GeneratedColumn<bool> showTodaySpend = GeneratedColumn<bool>(
    'show_today_spend',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_today_spend" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showTodayEventsMeta = const VerificationMeta(
    'showTodayEvents',
  );
  @override
  late final GeneratedColumn<bool> showTodayEvents = GeneratedColumn<bool>(
    'show_today_events',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_today_events" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _widgetOrderMeta = const VerificationMeta(
    'widgetOrder',
  );
  @override
  late final GeneratedColumn<String> widgetOrder = GeneratedColumn<String>(
    'widget_order',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('finance,budget,spend,events'),
  );
  static const VerificationMeta _layoutJsonMeta = const VerificationMeta(
    'layoutJson',
  );
  @override
  late final GeneratedColumn<String> layoutJson = GeneratedColumn<String>(
    'layout_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    showFinanceSummary,
    showBudgetStatus,
    showTodaySpend,
    showTodayEvents,
    widgetOrder,
    layoutJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'today_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodayPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('show_finance_summary')) {
      context.handle(
        _showFinanceSummaryMeta,
        showFinanceSummary.isAcceptableOrUnknown(
          data['show_finance_summary']!,
          _showFinanceSummaryMeta,
        ),
      );
    }
    if (data.containsKey('show_budget_status')) {
      context.handle(
        _showBudgetStatusMeta,
        showBudgetStatus.isAcceptableOrUnknown(
          data['show_budget_status']!,
          _showBudgetStatusMeta,
        ),
      );
    }
    if (data.containsKey('show_today_spend')) {
      context.handle(
        _showTodaySpendMeta,
        showTodaySpend.isAcceptableOrUnknown(
          data['show_today_spend']!,
          _showTodaySpendMeta,
        ),
      );
    }
    if (data.containsKey('show_today_events')) {
      context.handle(
        _showTodayEventsMeta,
        showTodayEvents.isAcceptableOrUnknown(
          data['show_today_events']!,
          _showTodayEventsMeta,
        ),
      );
    }
    if (data.containsKey('widget_order')) {
      context.handle(
        _widgetOrderMeta,
        widgetOrder.isAcceptableOrUnknown(
          data['widget_order']!,
          _widgetOrderMeta,
        ),
      );
    }
    if (data.containsKey('layout_json')) {
      context.handle(
        _layoutJsonMeta,
        layoutJson.isAcceptableOrUnknown(data['layout_json']!, _layoutJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodayPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodayPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      showFinanceSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_finance_summary'],
      )!,
      showBudgetStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_budget_status'],
      )!,
      showTodaySpend: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_today_spend'],
      )!,
      showTodayEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_today_events'],
      )!,
      widgetOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}widget_order'],
      )!,
      layoutJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_json'],
      )!,
    );
  }

  @override
  $TodayPreferencesTable createAlias(String alias) {
    return $TodayPreferencesTable(attachedDatabase, alias);
  }
}

class TodayPreference extends DataClass implements Insertable<TodayPreference> {
  final int id;
  final bool showFinanceSummary;
  final bool showBudgetStatus;
  final bool showTodaySpend;
  final bool showTodayEvents;

  /// Comma-separated ids: finance,budget,spend,events (legacy)
  final String widgetOrder;

  /// JSON map of slotCount → {identifier → DashboardItem.toMap()} for drag/resize grid.
  final String layoutJson;
  const TodayPreference({
    required this.id,
    required this.showFinanceSummary,
    required this.showBudgetStatus,
    required this.showTodaySpend,
    required this.showTodayEvents,
    required this.widgetOrder,
    required this.layoutJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['show_finance_summary'] = Variable<bool>(showFinanceSummary);
    map['show_budget_status'] = Variable<bool>(showBudgetStatus);
    map['show_today_spend'] = Variable<bool>(showTodaySpend);
    map['show_today_events'] = Variable<bool>(showTodayEvents);
    map['widget_order'] = Variable<String>(widgetOrder);
    map['layout_json'] = Variable<String>(layoutJson);
    return map;
  }

  TodayPreferencesCompanion toCompanion(bool nullToAbsent) {
    return TodayPreferencesCompanion(
      id: Value(id),
      showFinanceSummary: Value(showFinanceSummary),
      showBudgetStatus: Value(showBudgetStatus),
      showTodaySpend: Value(showTodaySpend),
      showTodayEvents: Value(showTodayEvents),
      widgetOrder: Value(widgetOrder),
      layoutJson: Value(layoutJson),
    );
  }

  factory TodayPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodayPreference(
      id: serializer.fromJson<int>(json['id']),
      showFinanceSummary: serializer.fromJson<bool>(json['showFinanceSummary']),
      showBudgetStatus: serializer.fromJson<bool>(json['showBudgetStatus']),
      showTodaySpend: serializer.fromJson<bool>(json['showTodaySpend']),
      showTodayEvents: serializer.fromJson<bool>(json['showTodayEvents']),
      widgetOrder: serializer.fromJson<String>(json['widgetOrder']),
      layoutJson: serializer.fromJson<String>(json['layoutJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'showFinanceSummary': serializer.toJson<bool>(showFinanceSummary),
      'showBudgetStatus': serializer.toJson<bool>(showBudgetStatus),
      'showTodaySpend': serializer.toJson<bool>(showTodaySpend),
      'showTodayEvents': serializer.toJson<bool>(showTodayEvents),
      'widgetOrder': serializer.toJson<String>(widgetOrder),
      'layoutJson': serializer.toJson<String>(layoutJson),
    };
  }

  TodayPreference copyWith({
    int? id,
    bool? showFinanceSummary,
    bool? showBudgetStatus,
    bool? showTodaySpend,
    bool? showTodayEvents,
    String? widgetOrder,
    String? layoutJson,
  }) => TodayPreference(
    id: id ?? this.id,
    showFinanceSummary: showFinanceSummary ?? this.showFinanceSummary,
    showBudgetStatus: showBudgetStatus ?? this.showBudgetStatus,
    showTodaySpend: showTodaySpend ?? this.showTodaySpend,
    showTodayEvents: showTodayEvents ?? this.showTodayEvents,
    widgetOrder: widgetOrder ?? this.widgetOrder,
    layoutJson: layoutJson ?? this.layoutJson,
  );
  TodayPreference copyWithCompanion(TodayPreferencesCompanion data) {
    return TodayPreference(
      id: data.id.present ? data.id.value : this.id,
      showFinanceSummary: data.showFinanceSummary.present
          ? data.showFinanceSummary.value
          : this.showFinanceSummary,
      showBudgetStatus: data.showBudgetStatus.present
          ? data.showBudgetStatus.value
          : this.showBudgetStatus,
      showTodaySpend: data.showTodaySpend.present
          ? data.showTodaySpend.value
          : this.showTodaySpend,
      showTodayEvents: data.showTodayEvents.present
          ? data.showTodayEvents.value
          : this.showTodayEvents,
      widgetOrder: data.widgetOrder.present
          ? data.widgetOrder.value
          : this.widgetOrder,
      layoutJson: data.layoutJson.present
          ? data.layoutJson.value
          : this.layoutJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodayPreference(')
          ..write('id: $id, ')
          ..write('showFinanceSummary: $showFinanceSummary, ')
          ..write('showBudgetStatus: $showBudgetStatus, ')
          ..write('showTodaySpend: $showTodaySpend, ')
          ..write('showTodayEvents: $showTodayEvents, ')
          ..write('widgetOrder: $widgetOrder, ')
          ..write('layoutJson: $layoutJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    showFinanceSummary,
    showBudgetStatus,
    showTodaySpend,
    showTodayEvents,
    widgetOrder,
    layoutJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodayPreference &&
          other.id == this.id &&
          other.showFinanceSummary == this.showFinanceSummary &&
          other.showBudgetStatus == this.showBudgetStatus &&
          other.showTodaySpend == this.showTodaySpend &&
          other.showTodayEvents == this.showTodayEvents &&
          other.widgetOrder == this.widgetOrder &&
          other.layoutJson == this.layoutJson);
}

class TodayPreferencesCompanion extends UpdateCompanion<TodayPreference> {
  final Value<int> id;
  final Value<bool> showFinanceSummary;
  final Value<bool> showBudgetStatus;
  final Value<bool> showTodaySpend;
  final Value<bool> showTodayEvents;
  final Value<String> widgetOrder;
  final Value<String> layoutJson;
  const TodayPreferencesCompanion({
    this.id = const Value.absent(),
    this.showFinanceSummary = const Value.absent(),
    this.showBudgetStatus = const Value.absent(),
    this.showTodaySpend = const Value.absent(),
    this.showTodayEvents = const Value.absent(),
    this.widgetOrder = const Value.absent(),
    this.layoutJson = const Value.absent(),
  });
  TodayPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.showFinanceSummary = const Value.absent(),
    this.showBudgetStatus = const Value.absent(),
    this.showTodaySpend = const Value.absent(),
    this.showTodayEvents = const Value.absent(),
    this.widgetOrder = const Value.absent(),
    this.layoutJson = const Value.absent(),
  });
  static Insertable<TodayPreference> custom({
    Expression<int>? id,
    Expression<bool>? showFinanceSummary,
    Expression<bool>? showBudgetStatus,
    Expression<bool>? showTodaySpend,
    Expression<bool>? showTodayEvents,
    Expression<String>? widgetOrder,
    Expression<String>? layoutJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (showFinanceSummary != null)
        'show_finance_summary': showFinanceSummary,
      if (showBudgetStatus != null) 'show_budget_status': showBudgetStatus,
      if (showTodaySpend != null) 'show_today_spend': showTodaySpend,
      if (showTodayEvents != null) 'show_today_events': showTodayEvents,
      if (widgetOrder != null) 'widget_order': widgetOrder,
      if (layoutJson != null) 'layout_json': layoutJson,
    });
  }

  TodayPreferencesCompanion copyWith({
    Value<int>? id,
    Value<bool>? showFinanceSummary,
    Value<bool>? showBudgetStatus,
    Value<bool>? showTodaySpend,
    Value<bool>? showTodayEvents,
    Value<String>? widgetOrder,
    Value<String>? layoutJson,
  }) {
    return TodayPreferencesCompanion(
      id: id ?? this.id,
      showFinanceSummary: showFinanceSummary ?? this.showFinanceSummary,
      showBudgetStatus: showBudgetStatus ?? this.showBudgetStatus,
      showTodaySpend: showTodaySpend ?? this.showTodaySpend,
      showTodayEvents: showTodayEvents ?? this.showTodayEvents,
      widgetOrder: widgetOrder ?? this.widgetOrder,
      layoutJson: layoutJson ?? this.layoutJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (showFinanceSummary.present) {
      map['show_finance_summary'] = Variable<bool>(showFinanceSummary.value);
    }
    if (showBudgetStatus.present) {
      map['show_budget_status'] = Variable<bool>(showBudgetStatus.value);
    }
    if (showTodaySpend.present) {
      map['show_today_spend'] = Variable<bool>(showTodaySpend.value);
    }
    if (showTodayEvents.present) {
      map['show_today_events'] = Variable<bool>(showTodayEvents.value);
    }
    if (widgetOrder.present) {
      map['widget_order'] = Variable<String>(widgetOrder.value);
    }
    if (layoutJson.present) {
      map['layout_json'] = Variable<String>(layoutJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodayPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('showFinanceSummary: $showFinanceSummary, ')
          ..write('showBudgetStatus: $showBudgetStatus, ')
          ..write('showTodaySpend: $showTodaySpend, ')
          ..write('showTodayEvents: $showTodayEvents, ')
          ..write('widgetOrder: $widgetOrder, ')
          ..write('layoutJson: $layoutJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $CalendarsTable calendars = $CalendarsTable(this);
  late final $FinanceCategoriesTable financeCategories =
      $FinanceCategoriesTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $FinanceAccountsTable financeAccounts = $FinanceAccountsTable(
    this,
  );
  late final $MonthlyBudgetsTable monthlyBudgets = $MonthlyBudgetsTable(this);
  late final $CategoryAllocationsTable categoryAllocations =
      $CategoryAllocationsTable(this);
  late final $FinanceTransactionsTable financeTransactions =
      $FinanceTransactionsTable(this);
  late final $TodayPreferencesTable todayPreferences = $TodayPreferencesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    calendars,
    financeCategories,
    events,
    financeAccounts,
    monthlyBudgets,
    categoryAllocations,
    financeTransactions,
    todayPreferences,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String displayName,
  required String localeCode,
  required String countryCode,
  required String currencyCode,
  required DateTime createdAt,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> displayName,
  Value<String> localeCode,
  Value<String> countryCode,
  Value<String> currencyCode,
  Value<DateTime> createdAt,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> localeCode = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                displayName: displayName,
                localeCode: localeCode,
                countryCode: countryCode,
                currencyCode: currencyCode,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String displayName,
                required String localeCode,
                required String countryCode,
                required String currencyCode,
                required DateTime createdAt,
              }) => ProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                localeCode: localeCode,
                countryCode: countryCode,
                currencyCode: currencyCode,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$CalendarsTableCreateCompanionBuilder = CalendarsCompanion Function({
  Value<int> id,
  required String name,
  required int colorArgb,
  Value<bool> isSystem,
  Value<int> sortOrder,
});
typedef $$CalendarsTableUpdateCompanionBuilder = CalendarsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> colorArgb,
  Value<bool> isSystem,
  Value<int> sortOrder,
});

final class $$CalendarsTableReferences
    extends BaseReferences<_$AppDatabase, $CalendarsTable, Calendar> {
  $$CalendarsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'calendars__id__events__calendar_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.calendarId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalendarsTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarsTable> {
  $$CalendarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.calendarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalendarsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarsTable> {
  $$CalendarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarsTable> {
  $$CalendarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.calendarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalendarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarsTable,
          Calendar,
          $$CalendarsTableFilterComposer,
          $$CalendarsTableOrderingComposer,
          $$CalendarsTableAnnotationComposer,
          $$CalendarsTableCreateCompanionBuilder,
          $$CalendarsTableUpdateCompanionBuilder,
          (Calendar, $$CalendarsTableReferences),
          Calendar,
          PrefetchHooks Function({bool eventsRefs})
        > {
  $$CalendarsTableTableManager(_$AppDatabase db, $CalendarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorArgb = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CalendarsCompanion(
                id: id,
                name: name,
                colorArgb: colorArgb,
                isSystem: isSystem,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int colorArgb,
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CalendarsCompanion.insert(
                id: id,
                name: name,
                colorArgb: colorArgb,
                isSystem: isSystem,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CalendarsTable, Calendar>(table),
                  $$CalendarsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (eventsRefs) db.events],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventsRefs)
                    await $_getPrefetchedData<Calendar, $CalendarsTable, Event>(
                      currentTable: table,
                      referencedTable: $$CalendarsTableReferences
                          ._eventsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CalendarsTableReferences(db, table, p0).eventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.calendarId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CalendarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarsTable,
      Calendar,
      $$CalendarsTableFilterComposer,
      $$CalendarsTableOrderingComposer,
      $$CalendarsTableAnnotationComposer,
      $$CalendarsTableCreateCompanionBuilder,
      $$CalendarsTableUpdateCompanionBuilder,
      (Calendar, $$CalendarsTableReferences),
      Calendar,
      PrefetchHooks Function({bool eventsRefs})
    >;
typedef $$FinanceCategoriesTableCreateCompanionBuilder =
    FinanceCategoriesCompanion Function({
      Value<int> id,
      required String nameKey,
      Value<String?> displayName,
      required String kind,
      required int colorArgb,
      Value<int> sortOrder,
      Value<bool> isSystem,
      Value<bool> isArchived,
    });
typedef $$FinanceCategoriesTableUpdateCompanionBuilder =
    FinanceCategoriesCompanion Function({
      Value<int> id,
      Value<String> nameKey,
      Value<String?> displayName,
      Value<String> kind,
      Value<int> colorArgb,
      Value<int> sortOrder,
      Value<bool> isSystem,
      Value<bool> isArchived,
    });

final class $$FinanceCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FinanceCategoriesTable,
          FinanceCategory
        > {
  $$FinanceCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $CategoryAllocationsTable,
    List<CategoryAllocation>
  >
  _categoryAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryAllocations,
        aliasName: 'finance_categories__id__category_allocations__category_id',
      );

  $$CategoryAllocationsTableProcessedTableManager get categoryAllocationsRefs {
    final manager = $$CategoryAllocationsTableTableManager(
      $_db,
      $_db.categoryAllocations,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _categoryAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FinanceTransactionsTable,
    List<FinanceTransaction>
  >
  _financeTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.financeTransactions,
        aliasName: 'finance_categories__id__finance_transactions__category_id',
      );

  $$FinanceTransactionsTableProcessedTableManager get financeTransactionsRefs {
    final manager = $$FinanceTransactionsTableTableManager(
      $_db,
      $_db.financeTransactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _financeTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FinanceCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceCategoriesTable> {
  $$FinanceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryAllocationsRefs(
    Expression<bool> Function($$CategoryAllocationsTableFilterComposer f) f,
  ) {
    final $$CategoryAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryAllocations,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.categoryAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> financeTransactionsRefs(
    Expression<bool> Function($$FinanceTransactionsTableFilterComposer f) f,
  ) {
    final $$FinanceTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.financeTransactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.financeTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FinanceCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceCategoriesTable> {
  $$FinanceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinanceCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceCategoriesTable> {
  $$FinanceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  Expression<T> categoryAllocationsRefs<T extends Object>(
    Expression<T> Function($$CategoryAllocationsTableAnnotationComposer a) f,
  ) {
    final $$CategoryAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.categoryAllocations,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.categoryAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> financeTransactionsRefs<T extends Object>(
    Expression<T> Function($$FinanceTransactionsTableAnnotationComposer a) f,
  ) {
    final $$FinanceTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.financeTransactions,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinanceTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.financeTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FinanceCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinanceCategoriesTable,
          FinanceCategory,
          $$FinanceCategoriesTableFilterComposer,
          $$FinanceCategoriesTableOrderingComposer,
          $$FinanceCategoriesTableAnnotationComposer,
          $$FinanceCategoriesTableCreateCompanionBuilder,
          $$FinanceCategoriesTableUpdateCompanionBuilder,
          (FinanceCategory, $$FinanceCategoriesTableReferences),
          FinanceCategory,
          PrefetchHooks Function({
            bool categoryAllocationsRefs,
            bool financeTransactionsRefs,
          })
        > {
  $$FinanceCategoriesTableTableManager(
    _$AppDatabase db,
    $FinanceCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinanceCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> colorArgb = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => FinanceCategoriesCompanion(
                id: id,
                nameKey: nameKey,
                displayName: displayName,
                kind: kind,
                colorArgb: colorArgb,
                sortOrder: sortOrder,
                isSystem: isSystem,
                isArchived: isArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameKey,
                Value<String?> displayName = const Value.absent(),
                required String kind,
                required int colorArgb,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => FinanceCategoriesCompanion.insert(
                id: id,
                nameKey: nameKey,
                displayName: displayName,
                kind: kind,
                colorArgb: colorArgb,
                sortOrder: sortOrder,
                isSystem: isSystem,
                isArchived: isArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinanceCategoriesTable, FinanceCategory>(table),
                  $$FinanceCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryAllocationsRefs = false,
                financeTransactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryAllocationsRefs) db.categoryAllocations,
                    if (financeTransactionsRefs) db.financeTransactions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryAllocationsRefs)
                        await $_getPrefetchedData<
                          FinanceCategory,
                          $FinanceCategoriesTable,
                          CategoryAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$FinanceCategoriesTableReferences
                              ._categoryAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinanceCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (financeTransactionsRefs)
                        await $_getPrefetchedData<
                          FinanceCategory,
                          $FinanceCategoriesTable,
                          FinanceTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$FinanceCategoriesTableReferences
                              ._financeTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinanceCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).financeTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FinanceCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinanceCategoriesTable,
      FinanceCategory,
      $$FinanceCategoriesTableFilterComposer,
      $$FinanceCategoriesTableOrderingComposer,
      $$FinanceCategoriesTableAnnotationComposer,
      $$FinanceCategoriesTableCreateCompanionBuilder,
      $$FinanceCategoriesTableUpdateCompanionBuilder,
      (FinanceCategory, $$FinanceCategoriesTableReferences),
      FinanceCategory,
      PrefetchHooks Function({
        bool categoryAllocationsRefs,
        bool financeTransactionsRefs,
      })
    >;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required String title,
  required DateTime startsAt,
  required DateTime endsAt,
  required int calendarId,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<DateTime> startsAt,
  Value<DateTime> endsAt,
  Value<int> calendarId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CalendarsTable _calendarIdTable(_$AppDatabase db) =>
      db.calendars.createAlias('events__calendar_id__calendars__id');

  $$CalendarsTableProcessedTableManager get calendarId {
    final $_column = $_itemColumn<int>('calendar_id')!;

    final manager = $$CalendarsTableTableManager(
      $_db,
      $_db.calendars,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calendarIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CalendarsTableFilterComposer get calendarId {
    final $$CalendarsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calendarId,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableFilterComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalendarsTableOrderingComposer get calendarId {
    final $$CalendarsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calendarId,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableOrderingComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CalendarsTableAnnotationComposer get calendarId {
    final $$CalendarsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calendarId,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, $$EventsTableReferences),
          Event,
          PrefetchHooks Function({bool calendarId})
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<DateTime> endsAt = const Value.absent(),
                Value<int> calendarId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                title: title,
                startsAt: startsAt,
                endsAt: endsAt,
                calendarId: calendarId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime startsAt,
                required DateTime endsAt,
                required int calendarId,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => EventsCompanion.insert(
                id: id,
                title: title,
                startsAt: startsAt,
                endsAt: endsAt,
                calendarId: calendarId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventsTable, Event>(table),
                  $$EventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({calendarId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (calendarId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.calendarId,
                        referencedTable: $$EventsTableReferences
                            ._calendarIdTable(db),
                        referencedColumn: $$EventsTableReferences
                            ._calendarIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, $$EventsTableReferences),
      Event,
      PrefetchHooks Function({bool calendarId})
    >;
typedef $$FinanceAccountsTableCreateCompanionBuilder =
    FinanceAccountsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> balanceMinor,
      required String currencyCode,
      Value<int> sortOrder,
      Value<bool> isArchived,
      required DateTime createdAt,
    });
typedef $$FinanceAccountsTableUpdateCompanionBuilder =
    FinanceAccountsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> balanceMinor,
      Value<String> currencyCode,
      Value<int> sortOrder,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });

final class $$FinanceAccountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FinanceAccountsTable, FinanceAccount> {
  $$FinanceAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $FinanceTransactionsTable,
    List<FinanceTransaction>
  >
  _financeTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.financeTransactions,
        aliasName: 'finance_accounts__id__finance_transactions__account_id',
      );

  $$FinanceTransactionsTableProcessedTableManager get financeTransactionsRefs {
    final manager = $$FinanceTransactionsTableTableManager(
      $_db,
      $_db.financeTransactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _financeTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FinanceAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceAccountsTable> {
  $$FinanceAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceMinor => $composableBuilder(
    column: $table.balanceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> financeTransactionsRefs(
    Expression<bool> Function($$FinanceTransactionsTableFilterComposer f) f,
  ) {
    final $$FinanceTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.financeTransactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.financeTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FinanceAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceAccountsTable> {
  $$FinanceAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceMinor => $composableBuilder(
    column: $table.balanceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinanceAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceAccountsTable> {
  $$FinanceAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get balanceMinor => $composableBuilder(
    column: $table.balanceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> financeTransactionsRefs<T extends Object>(
    Expression<T> Function($$FinanceTransactionsTableAnnotationComposer a) f,
  ) {
    final $$FinanceTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.financeTransactions,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinanceTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.financeTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FinanceAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinanceAccountsTable,
          FinanceAccount,
          $$FinanceAccountsTableFilterComposer,
          $$FinanceAccountsTableOrderingComposer,
          $$FinanceAccountsTableAnnotationComposer,
          $$FinanceAccountsTableCreateCompanionBuilder,
          $$FinanceAccountsTableUpdateCompanionBuilder,
          (FinanceAccount, $$FinanceAccountsTableReferences),
          FinanceAccount,
          PrefetchHooks Function({bool financeTransactionsRefs})
        > {
  $$FinanceAccountsTableTableManager(
    _$AppDatabase db,
    $FinanceAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinanceAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> balanceMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FinanceAccountsCompanion(
                id: id,
                name: name,
                balanceMinor: balanceMinor,
                currencyCode: currencyCode,
                sortOrder: sortOrder,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> balanceMinor = const Value.absent(),
                required String currencyCode,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
              }) => FinanceAccountsCompanion.insert(
                id: id,
                name: name,
                balanceMinor: balanceMinor,
                currencyCode: currencyCode,
                sortOrder: sortOrder,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinanceAccountsTable, FinanceAccount>(table),
                  $$FinanceAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({financeTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (financeTransactionsRefs) db.financeTransactions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (financeTransactionsRefs)
                    await $_getPrefetchedData<
                      FinanceAccount,
                      $FinanceAccountsTable,
                      FinanceTransaction
                    >(
                      currentTable: table,
                      referencedTable: $$FinanceAccountsTableReferences
                          ._financeTransactionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FinanceAccountsTableReferences(
                            db,
                            table,
                            p0,
                          ).financeTransactionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.accountId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FinanceAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinanceAccountsTable,
      FinanceAccount,
      $$FinanceAccountsTableFilterComposer,
      $$FinanceAccountsTableOrderingComposer,
      $$FinanceAccountsTableAnnotationComposer,
      $$FinanceAccountsTableCreateCompanionBuilder,
      $$FinanceAccountsTableUpdateCompanionBuilder,
      (FinanceAccount, $$FinanceAccountsTableReferences),
      FinanceAccount,
      PrefetchHooks Function({bool financeTransactionsRefs})
    >;
typedef $$MonthlyBudgetsTableCreateCompanionBuilder =
    MonthlyBudgetsCompanion Function({
      Value<int> id,
      required int year,
      required int month,
      required int totalLimitMinor,
      required DateTime updatedAt,
    });
typedef $$MonthlyBudgetsTableUpdateCompanionBuilder =
    MonthlyBudgetsCompanion Function({
      Value<int> id,
      Value<int> year,
      Value<int> month,
      Value<int> totalLimitMinor,
      Value<DateTime> updatedAt,
    });

class $$MonthlyBudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLimitMinor => $composableBuilder(
    column: $table.totalLimitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthlyBudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLimitMinor => $composableBuilder(
    column: $table.totalLimitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyBudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get totalLimitMinor => $composableBuilder(
    column: $table.totalLimitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MonthlyBudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyBudgetsTable,
          MonthlyBudget,
          $$MonthlyBudgetsTableFilterComposer,
          $$MonthlyBudgetsTableOrderingComposer,
          $$MonthlyBudgetsTableAnnotationComposer,
          $$MonthlyBudgetsTableCreateCompanionBuilder,
          $$MonthlyBudgetsTableUpdateCompanionBuilder,
          (
            MonthlyBudget,
            BaseReferences<_$AppDatabase, $MonthlyBudgetsTable, MonthlyBudget>,
          ),
          MonthlyBudget,
          PrefetchHooks Function()
        > {
  $$MonthlyBudgetsTableTableManager(
    _$AppDatabase db,
    $MonthlyBudgetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> totalLimitMinor = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MonthlyBudgetsCompanion(
                id: id,
                year: year,
                month: month,
                totalLimitMinor: totalLimitMinor,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int year,
                required int month,
                required int totalLimitMinor,
                required DateTime updatedAt,
              }) => MonthlyBudgetsCompanion.insert(
                id: id,
                year: year,
                month: month,
                totalLimitMinor: totalLimitMinor,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MonthlyBudgetsTable, MonthlyBudget>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MonthlyBudgetsTable,
                    MonthlyBudget
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthlyBudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyBudgetsTable,
      MonthlyBudget,
      $$MonthlyBudgetsTableFilterComposer,
      $$MonthlyBudgetsTableOrderingComposer,
      $$MonthlyBudgetsTableAnnotationComposer,
      $$MonthlyBudgetsTableCreateCompanionBuilder,
      $$MonthlyBudgetsTableUpdateCompanionBuilder,
      (
        MonthlyBudget,
        BaseReferences<_$AppDatabase, $MonthlyBudgetsTable, MonthlyBudget>,
      ),
      MonthlyBudget,
      PrefetchHooks Function()
    >;
typedef $$CategoryAllocationsTableCreateCompanionBuilder =
    CategoryAllocationsCompanion Function({
      Value<int> id,
      required int year,
      required int month,
      required int categoryId,
      required int allocatedMinor,
    });
typedef $$CategoryAllocationsTableUpdateCompanionBuilder =
    CategoryAllocationsCompanion Function({
      Value<int> id,
      Value<int> year,
      Value<int> month,
      Value<int> categoryId,
      Value<int> allocatedMinor,
    });

final class $$CategoryAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoryAllocationsTable,
          CategoryAllocation
        > {
  $$CategoryAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FinanceCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .financeCategories
      .createAlias('category_allocations__category_id__finance_categories__id');

  $$FinanceCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$FinanceCategoriesTableTableManager(
      $_db,
      $_db.financeCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CategoryAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryAllocationsTable> {
  $$CategoryAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allocatedMinor => $composableBuilder(
    column: $table.allocatedMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$FinanceCategoriesTableFilterComposer get categoryId {
    final $$FinanceCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.financeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.financeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryAllocationsTable> {
  $$CategoryAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allocatedMinor => $composableBuilder(
    column: $table.allocatedMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$FinanceCategoriesTableOrderingComposer get categoryId {
    final $$FinanceCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.financeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.financeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryAllocationsTable> {
  $$CategoryAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get allocatedMinor => $composableBuilder(
    column: $table.allocatedMinor,
    builder: (column) => column,
  );

  $$FinanceCategoriesTableAnnotationComposer get categoryId {
    final $$FinanceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.financeCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinanceCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.financeCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CategoryAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryAllocationsTable,
          CategoryAllocation,
          $$CategoryAllocationsTableFilterComposer,
          $$CategoryAllocationsTableOrderingComposer,
          $$CategoryAllocationsTableAnnotationComposer,
          $$CategoryAllocationsTableCreateCompanionBuilder,
          $$CategoryAllocationsTableUpdateCompanionBuilder,
          (CategoryAllocation, $$CategoryAllocationsTableReferences),
          CategoryAllocation,
          PrefetchHooks Function({bool categoryId})
        > {
  $$CategoryAllocationsTableTableManager(
    _$AppDatabase db,
    $CategoryAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryAllocationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CategoryAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> allocatedMinor = const Value.absent(),
              }) => CategoryAllocationsCompanion(
                id: id,
                year: year,
                month: month,
                categoryId: categoryId,
                allocatedMinor: allocatedMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int year,
                required int month,
                required int categoryId,
                required int allocatedMinor,
              }) => CategoryAllocationsCompanion.insert(
                id: id,
                year: year,
                month: month,
                categoryId: categoryId,
                allocatedMinor: allocatedMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoryAllocationsTable, CategoryAllocation>(
                    table,
                  ),
                  $$CategoryAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$CategoryAllocationsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$CategoryAllocationsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CategoryAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryAllocationsTable,
      CategoryAllocation,
      $$CategoryAllocationsTableFilterComposer,
      $$CategoryAllocationsTableOrderingComposer,
      $$CategoryAllocationsTableAnnotationComposer,
      $$CategoryAllocationsTableCreateCompanionBuilder,
      $$CategoryAllocationsTableUpdateCompanionBuilder,
      (CategoryAllocation, $$CategoryAllocationsTableReferences),
      CategoryAllocation,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$FinanceTransactionsTableCreateCompanionBuilder =
    FinanceTransactionsCompanion Function({
      Value<int> id,
      required int amountMinor,
      required String kind,
      required int categoryId,
      required int accountId,
      required DateTime occurredAt,
      Value<String> note,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$FinanceTransactionsTableUpdateCompanionBuilder =
    FinanceTransactionsCompanion Function({
      Value<int> id,
      Value<int> amountMinor,
      Value<String> kind,
      Value<int> categoryId,
      Value<int> accountId,
      Value<DateTime> occurredAt,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$FinanceTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FinanceTransactionsTable,
          FinanceTransaction
        > {
  $$FinanceTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FinanceCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .financeCategories
      .createAlias('finance_transactions__category_id__finance_categories__id');

  $$FinanceCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$FinanceCategoriesTableTableManager(
      $_db,
      $_db.financeCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FinanceAccountsTable _accountIdTable(_$AppDatabase db) => db
      .financeAccounts
      .createAlias('finance_transactions__account_id__finance_accounts__id');

  $$FinanceAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$FinanceAccountsTableTableManager(
      $_db,
      $_db.financeAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FinanceTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceTransactionsTable> {
  $$FinanceTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FinanceCategoriesTableFilterComposer get categoryId {
    final $$FinanceCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.financeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.financeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FinanceAccountsTableFilterComposer get accountId {
    final $$FinanceAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.financeAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceAccountsTableFilterComposer(
            $db: $db,
            $table: $db.financeAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinanceTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceTransactionsTable> {
  $$FinanceTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FinanceCategoriesTableOrderingComposer get categoryId {
    final $$FinanceCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.financeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.financeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FinanceAccountsTableOrderingComposer get accountId {
    final $$FinanceAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.financeAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.financeAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinanceTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceTransactionsTable> {
  $$FinanceTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$FinanceCategoriesTableAnnotationComposer get categoryId {
    final $$FinanceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.financeCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinanceCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.financeCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$FinanceAccountsTableAnnotationComposer get accountId {
    final $$FinanceAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.financeAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinanceAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.financeAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinanceTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinanceTransactionsTable,
          FinanceTransaction,
          $$FinanceTransactionsTableFilterComposer,
          $$FinanceTransactionsTableOrderingComposer,
          $$FinanceTransactionsTableAnnotationComposer,
          $$FinanceTransactionsTableCreateCompanionBuilder,
          $$FinanceTransactionsTableUpdateCompanionBuilder,
          (FinanceTransaction, $$FinanceTransactionsTableReferences),
          FinanceTransaction,
          PrefetchHooks Function({bool categoryId, bool accountId})
        > {
  $$FinanceTransactionsTableTableManager(
    _$AppDatabase db,
    $FinanceTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FinanceTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FinanceTransactionsCompanion(
                id: id,
                amountMinor: amountMinor,
                kind: kind,
                categoryId: categoryId,
                accountId: accountId,
                occurredAt: occurredAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountMinor,
                required String kind,
                required int categoryId,
                required int accountId,
                required DateTime occurredAt,
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => FinanceTransactionsCompanion.insert(
                id: id,
                amountMinor: amountMinor,
                kind: kind,
                categoryId: categoryId,
                accountId: accountId,
                occurredAt: occurredAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinanceTransactionsTable, FinanceTransaction>(
                    table,
                  ),
                  $$FinanceTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$FinanceTransactionsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$FinanceTransactionsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$FinanceTransactionsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$FinanceTransactionsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FinanceTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinanceTransactionsTable,
      FinanceTransaction,
      $$FinanceTransactionsTableFilterComposer,
      $$FinanceTransactionsTableOrderingComposer,
      $$FinanceTransactionsTableAnnotationComposer,
      $$FinanceTransactionsTableCreateCompanionBuilder,
      $$FinanceTransactionsTableUpdateCompanionBuilder,
      (FinanceTransaction, $$FinanceTransactionsTableReferences),
      FinanceTransaction,
      PrefetchHooks Function({bool categoryId, bool accountId})
    >;
typedef $$TodayPreferencesTableCreateCompanionBuilder =
    TodayPreferencesCompanion Function({
      Value<int> id,
      Value<bool> showFinanceSummary,
      Value<bool> showBudgetStatus,
      Value<bool> showTodaySpend,
      Value<bool> showTodayEvents,
      Value<String> widgetOrder,
      Value<String> layoutJson,
    });
typedef $$TodayPreferencesTableUpdateCompanionBuilder =
    TodayPreferencesCompanion Function({
      Value<int> id,
      Value<bool> showFinanceSummary,
      Value<bool> showBudgetStatus,
      Value<bool> showTodaySpend,
      Value<bool> showTodayEvents,
      Value<String> widgetOrder,
      Value<String> layoutJson,
    });

class $$TodayPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $TodayPreferencesTable> {
  $$TodayPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showFinanceSummary => $composableBuilder(
    column: $table.showFinanceSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showBudgetStatus => $composableBuilder(
    column: $table.showBudgetStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showTodaySpend => $composableBuilder(
    column: $table.showTodaySpend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showTodayEvents => $composableBuilder(
    column: $table.showTodayEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get widgetOrder => $composableBuilder(
    column: $table.widgetOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodayPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $TodayPreferencesTable> {
  $$TodayPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showFinanceSummary => $composableBuilder(
    column: $table.showFinanceSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showBudgetStatus => $composableBuilder(
    column: $table.showBudgetStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showTodaySpend => $composableBuilder(
    column: $table.showTodaySpend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showTodayEvents => $composableBuilder(
    column: $table.showTodayEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get widgetOrder => $composableBuilder(
    column: $table.widgetOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodayPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodayPreferencesTable> {
  $$TodayPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get showFinanceSummary => $composableBuilder(
    column: $table.showFinanceSummary,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showBudgetStatus => $composableBuilder(
    column: $table.showBudgetStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showTodaySpend => $composableBuilder(
    column: $table.showTodaySpend,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showTodayEvents => $composableBuilder(
    column: $table.showTodayEvents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get widgetOrder => $composableBuilder(
    column: $table.widgetOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => column,
  );
}

class $$TodayPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodayPreferencesTable,
          TodayPreference,
          $$TodayPreferencesTableFilterComposer,
          $$TodayPreferencesTableOrderingComposer,
          $$TodayPreferencesTableAnnotationComposer,
          $$TodayPreferencesTableCreateCompanionBuilder,
          $$TodayPreferencesTableUpdateCompanionBuilder,
          (
            TodayPreference,
            BaseReferences<
              _$AppDatabase,
              $TodayPreferencesTable,
              TodayPreference
            >,
          ),
          TodayPreference,
          PrefetchHooks Function()
        > {
  $$TodayPreferencesTableTableManager(
    _$AppDatabase db,
    $TodayPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodayPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodayPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodayPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> showFinanceSummary = const Value.absent(),
                Value<bool> showBudgetStatus = const Value.absent(),
                Value<bool> showTodaySpend = const Value.absent(),
                Value<bool> showTodayEvents = const Value.absent(),
                Value<String> widgetOrder = const Value.absent(),
                Value<String> layoutJson = const Value.absent(),
              }) => TodayPreferencesCompanion(
                id: id,
                showFinanceSummary: showFinanceSummary,
                showBudgetStatus: showBudgetStatus,
                showTodaySpend: showTodaySpend,
                showTodayEvents: showTodayEvents,
                widgetOrder: widgetOrder,
                layoutJson: layoutJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> showFinanceSummary = const Value.absent(),
                Value<bool> showBudgetStatus = const Value.absent(),
                Value<bool> showTodaySpend = const Value.absent(),
                Value<bool> showTodayEvents = const Value.absent(),
                Value<String> widgetOrder = const Value.absent(),
                Value<String> layoutJson = const Value.absent(),
              }) => TodayPreferencesCompanion.insert(
                id: id,
                showFinanceSummary: showFinanceSummary,
                showBudgetStatus: showBudgetStatus,
                showTodaySpend: showTodaySpend,
                showTodayEvents: showTodayEvents,
                widgetOrder: widgetOrder,
                layoutJson: layoutJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TodayPreferencesTable, TodayPreference>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TodayPreferencesTable,
                    TodayPreference
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodayPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodayPreferencesTable,
      TodayPreference,
      $$TodayPreferencesTableFilterComposer,
      $$TodayPreferencesTableOrderingComposer,
      $$TodayPreferencesTableAnnotationComposer,
      $$TodayPreferencesTableCreateCompanionBuilder,
      $$TodayPreferencesTableUpdateCompanionBuilder,
      (
        TodayPreference,
        BaseReferences<_$AppDatabase, $TodayPreferencesTable, TodayPreference>,
      ),
      TodayPreference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$CalendarsTableTableManager get calendars =>
      $$CalendarsTableTableManager(_db, _db.calendars);
  $$FinanceCategoriesTableTableManager get financeCategories =>
      $$FinanceCategoriesTableTableManager(_db, _db.financeCategories);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$FinanceAccountsTableTableManager get financeAccounts =>
      $$FinanceAccountsTableTableManager(_db, _db.financeAccounts);
  $$MonthlyBudgetsTableTableManager get monthlyBudgets =>
      $$MonthlyBudgetsTableTableManager(_db, _db.monthlyBudgets);
  $$CategoryAllocationsTableTableManager get categoryAllocations =>
      $$CategoryAllocationsTableTableManager(_db, _db.categoryAllocations);
  $$FinanceTransactionsTableTableManager get financeTransactions =>
      $$FinanceTransactionsTableTableManager(_db, _db.financeTransactions);
  $$TodayPreferencesTableTableManager get todayPreferences =>
      $$TodayPreferencesTableTableManager(_db, _db.todayPreferences);
}
