// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _limitMinorUnitsMeta = const VerificationMeta(
    'limitMinorUnits',
  );
  @override
  late final GeneratedColumn<int> limitMinorUnits = GeneratedColumn<int>(
    'limit_minor_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Currency, String> currency =
      GeneratedColumn<String>(
        'currency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Currency>($BudgetsTable.$convertercurrency);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    limitMinorUnits,
    currency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetDto> instance, {
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
    if (data.containsKey('limit_minor_units')) {
      context.handle(
        _limitMinorUnitsMeta,
        limitMinorUnits.isAcceptableOrUnknown(
          data['limit_minor_units']!,
          _limitMinorUnitsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_limitMinorUnitsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {year, month},
  ];
  @override
  BudgetDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetDto(
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
      limitMinorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_minor_units'],
      )!,
      currency: $BudgetsTable.$convertercurrency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}currency'],
        )!,
      ),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Currency, String, String> $convertercurrency =
      const EnumNameConverter<Currency>(Currency.values);
}

class BudgetDto extends DataClass implements Insertable<BudgetDto> {
  final int id;
  final int year;

  /// Month of the year, `1..12`.
  final int month;
  final int limitMinorUnits;
  final Currency currency;
  const BudgetDto({
    required this.id,
    required this.year,
    required this.month,
    required this.limitMinorUnits,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['limit_minor_units'] = Variable<int>(limitMinorUnits);
    {
      map['currency'] = Variable<String>(
        $BudgetsTable.$convertercurrency.toSql(currency),
      );
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      limitMinorUnits: Value(limitMinorUnits),
      currency: Value(currency),
    );
  }

  factory BudgetDto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetDto(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      limitMinorUnits: serializer.fromJson<int>(json['limitMinorUnits']),
      currency: $BudgetsTable.$convertercurrency.fromJson(
        serializer.fromJson<String>(json['currency']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'limitMinorUnits': serializer.toJson<int>(limitMinorUnits),
      'currency': serializer.toJson<String>(
        $BudgetsTable.$convertercurrency.toJson(currency),
      ),
    };
  }

  BudgetDto copyWith({
    int? id,
    int? year,
    int? month,
    int? limitMinorUnits,
    Currency? currency,
  }) => BudgetDto(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    limitMinorUnits: limitMinorUnits ?? this.limitMinorUnits,
    currency: currency ?? this.currency,
  );
  BudgetDto copyWithCompanion(BudgetsCompanion data) {
    return BudgetDto(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      limitMinorUnits: data.limitMinorUnits.present
          ? data.limitMinorUnits.value
          : this.limitMinorUnits,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetDto(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('limitMinorUnits: $limitMinorUnits, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, year, month, limitMinorUnits, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetDto &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.limitMinorUnits == this.limitMinorUnits &&
          other.currency == this.currency);
}

class BudgetsCompanion extends UpdateCompanion<BudgetDto> {
  final Value<int> id;
  final Value<int> year;
  final Value<int> month;
  final Value<int> limitMinorUnits;
  final Value<Currency> currency;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.limitMinorUnits = const Value.absent(),
    this.currency = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int year,
    required int month,
    required int limitMinorUnits,
    required Currency currency,
  }) : year = Value(year),
       month = Value(month),
       limitMinorUnits = Value(limitMinorUnits),
       currency = Value(currency);
  static Insertable<BudgetDto> custom({
    Expression<int>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? limitMinorUnits,
    Expression<String>? currency,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (limitMinorUnits != null) 'limit_minor_units': limitMinorUnits,
      if (currency != null) 'currency': currency,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? year,
    Value<int>? month,
    Value<int>? limitMinorUnits,
    Value<Currency>? currency,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      limitMinorUnits: limitMinorUnits ?? this.limitMinorUnits,
      currency: currency ?? this.currency,
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
    if (limitMinorUnits.present) {
      map['limit_minor_units'] = Variable<int>(limitMinorUnits.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(
        $BudgetsTable.$convertercurrency.toSql(currency.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('limitMinorUnits: $limitMinorUnits, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryIcon, String> icon =
      GeneratedColumn<String>(
        'icon',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategoryIcon>($CategoriesTable.$convertericon);
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, colorValue, isDefault];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryDto> instance, {
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
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryDto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: $CategoriesTable.$convertericon.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}icon'],
        )!,
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryIcon, String, String> $convertericon =
      const EnumNameConverter<CategoryIcon>(CategoryIcon.values);
}

class CategoryDto extends DataClass implements Insertable<CategoryDto> {
  final int id;
  final String name;

  /// Semantic icon ([CategoryIcon]); the UI resolves it to a `const IconData`.
  final CategoryIcon icon;

  /// ARGB colour of the category as an int, so no Flutter type is persisted.
  final int colorValue;

  /// Whether the category was created by [DatabaseSeeder] rather than the user.
  final bool isDefault;
  const CategoryDto({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['icon'] = Variable<String>(
        $CategoriesTable.$convertericon.toSql(icon),
      );
    }
    map['color_value'] = Variable<int>(colorValue);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      colorValue: Value(colorValue),
      isDefault: Value(isDefault),
    );
  }

  factory CategoryDto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryDto(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: $CategoriesTable.$convertericon.fromJson(
        serializer.fromJson<String>(json['icon']),
      ),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(
        $CategoriesTable.$convertericon.toJson(icon),
      ),
      'colorValue': serializer.toJson<int>(colorValue),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  CategoryDto copyWith({
    int? id,
    String? name,
    CategoryIcon? icon,
    int? colorValue,
    bool? isDefault,
  }) => CategoryDto(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorValue: colorValue ?? this.colorValue,
    isDefault: isDefault ?? this.isDefault,
  );
  CategoryDto copyWithCompanion(CategoriesCompanion data) {
    return CategoryDto(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDto(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, colorValue, isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryDto &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorValue == this.colorValue &&
          other.isDefault == this.isDefault);
}

class CategoriesCompanion extends UpdateCompanion<CategoryDto> {
  final Value<int> id;
  final Value<String> name;
  final Value<CategoryIcon> icon;
  final Value<int> colorValue;
  final Value<bool> isDefault;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isDefault = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required CategoryIcon icon,
    required int colorValue,
    this.isDefault = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       colorValue = Value(colorValue);
  static Insertable<CategoryDto> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? colorValue,
    Expression<bool>? isDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorValue != null) 'color_value': colorValue,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<CategoryIcon>? icon,
    Value<int>? colorValue,
    Value<bool>? isDefault,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
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
    if (icon.present) {
      map['icon'] = Variable<String>(
        $CategoriesTable.$convertericon.toSql(icon.value),
      );
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountMinorUnitsMeta = const VerificationMeta(
    'amountMinorUnits',
  );
  @override
  late final GeneratedColumn<int> amountMinorUnits = GeneratedColumn<int>(
    'amount_minor_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Currency, String> currency =
      GeneratedColumn<String>(
        'currency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Currency>($TransactionsTable.$convertercurrency);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionKind>($TransactionsTable.$converterkind);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 160,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
      'REFERENCES categories (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionSource, String>
  source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TransactionSource>($TransactionsTable.$convertersource);
  static const VerificationMeta _receiptMerchantMeta = const VerificationMeta(
    'receiptMerchant',
  );
  @override
  late final GeneratedColumn<String> receiptMerchant = GeneratedColumn<String>(
    'receipt_merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptImagePathMeta = const VerificationMeta(
    'receiptImagePath',
  );
  @override
  late final GeneratedColumn<String> receiptImagePath = GeneratedColumn<String>(
    'receipt_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountMinorUnits,
    currency,
    kind,
    description,
    occurredAt,
    categoryId,
    source,
    receiptMerchant,
    receiptImagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionDto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_minor_units')) {
      context.handle(
        _amountMinorUnitsMeta,
        amountMinorUnits.isAcceptableOrUnknown(
          data['amount_minor_units']!,
          _amountMinorUnitsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorUnitsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('receipt_merchant')) {
      context.handle(
        _receiptMerchantMeta,
        receiptMerchant.isAcceptableOrUnknown(
          data['receipt_merchant']!,
          _receiptMerchantMeta,
        ),
      );
    }
    if (data.containsKey('receipt_image_path')) {
      context.handle(
        _receiptImagePathMeta,
        receiptImagePath.isAcceptableOrUnknown(
          data['receipt_image_path']!,
          _receiptImagePathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionDto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amountMinorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor_units'],
      )!,
      currency: $TransactionsTable.$convertercurrency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}currency'],
        )!,
      ),
      kind: $TransactionsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      source: $TransactionsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      receiptMerchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_merchant'],
      ),
      receiptImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_image_path'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Currency, String, String> $convertercurrency =
      const EnumNameConverter<Currency>(Currency.values);
  static JsonTypeConverter2<TransactionKind, String, String> $converterkind =
      const EnumNameConverter<TransactionKind>(TransactionKind.values);
  static JsonTypeConverter2<TransactionSource, String, String>
  $convertersource = const EnumNameConverter<TransactionSource>(
    TransactionSource.values,
  );
}

class TransactionDto extends DataClass implements Insertable<TransactionDto> {
  final int id;

  /// Amount in minor units (kuruş/cents), matching the `Money` value object.
  final int amountMinorUnits;
  final Currency currency;
  final TransactionKind kind;
  final String description;
  final DateTime occurredAt;
  final int categoryId;
  final TransactionSource source;

  /// Merchant name extracted from a scanned receipt, when applicable.
  final String? receiptMerchant;

  /// Path of the captured receipt image, kept for later review/audit.
  final String? receiptImagePath;
  const TransactionDto({
    required this.id,
    required this.amountMinorUnits,
    required this.currency,
    required this.kind,
    required this.description,
    required this.occurredAt,
    required this.categoryId,
    required this.source,
    this.receiptMerchant,
    this.receiptImagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_minor_units'] = Variable<int>(amountMinorUnits);
    {
      map['currency'] = Variable<String>(
        $TransactionsTable.$convertercurrency.toSql(currency),
      );
    }
    {
      map['kind'] = Variable<String>(
        $TransactionsTable.$converterkind.toSql(kind),
      );
    }
    map['description'] = Variable<String>(description);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['category_id'] = Variable<int>(categoryId);
    {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || receiptMerchant != null) {
      map['receipt_merchant'] = Variable<String>(receiptMerchant);
    }
    if (!nullToAbsent || receiptImagePath != null) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amountMinorUnits: Value(amountMinorUnits),
      currency: Value(currency),
      kind: Value(kind),
      description: Value(description),
      occurredAt: Value(occurredAt),
      categoryId: Value(categoryId),
      source: Value(source),
      receiptMerchant: receiptMerchant == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptMerchant),
      receiptImagePath: receiptImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptImagePath),
    );
  }

  factory TransactionDto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionDto(
      id: serializer.fromJson<int>(json['id']),
      amountMinorUnits: serializer.fromJson<int>(json['amountMinorUnits']),
      currency: $TransactionsTable.$convertercurrency.fromJson(
        serializer.fromJson<String>(json['currency']),
      ),
      kind: $TransactionsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      description: serializer.fromJson<String>(json['description']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      source: $TransactionsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      receiptMerchant: serializer.fromJson<String?>(json['receiptMerchant']),
      receiptImagePath: serializer.fromJson<String?>(json['receiptImagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountMinorUnits': serializer.toJson<int>(amountMinorUnits),
      'currency': serializer.toJson<String>(
        $TransactionsTable.$convertercurrency.toJson(currency),
      ),
      'kind': serializer.toJson<String>(
        $TransactionsTable.$converterkind.toJson(kind),
      ),
      'description': serializer.toJson<String>(description),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'categoryId': serializer.toJson<int>(categoryId),
      'source': serializer.toJson<String>(
        $TransactionsTable.$convertersource.toJson(source),
      ),
      'receiptMerchant': serializer.toJson<String?>(receiptMerchant),
      'receiptImagePath': serializer.toJson<String?>(receiptImagePath),
    };
  }

  TransactionDto copyWith({
    int? id,
    int? amountMinorUnits,
    Currency? currency,
    TransactionKind? kind,
    String? description,
    DateTime? occurredAt,
    int? categoryId,
    TransactionSource? source,
    Value<String?> receiptMerchant = const Value.absent(),
    Value<String?> receiptImagePath = const Value.absent(),
  }) => TransactionDto(
    id: id ?? this.id,
    amountMinorUnits: amountMinorUnits ?? this.amountMinorUnits,
    currency: currency ?? this.currency,
    kind: kind ?? this.kind,
    description: description ?? this.description,
    occurredAt: occurredAt ?? this.occurredAt,
    categoryId: categoryId ?? this.categoryId,
    source: source ?? this.source,
    receiptMerchant: receiptMerchant.present
        ? receiptMerchant.value
        : this.receiptMerchant,
    receiptImagePath: receiptImagePath.present
        ? receiptImagePath.value
        : this.receiptImagePath,
  );
  TransactionDto copyWithCompanion(TransactionsCompanion data) {
    return TransactionDto(
      id: data.id.present ? data.id.value : this.id,
      amountMinorUnits: data.amountMinorUnits.present
          ? data.amountMinorUnits.value
          : this.amountMinorUnits,
      currency: data.currency.present ? data.currency.value : this.currency,
      kind: data.kind.present ? data.kind.value : this.kind,
      description: data.description.present
          ? data.description.value
          : this.description,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      source: data.source.present ? data.source.value : this.source,
      receiptMerchant: data.receiptMerchant.present
          ? data.receiptMerchant.value
          : this.receiptMerchant,
      receiptImagePath: data.receiptImagePath.present
          ? data.receiptImagePath.value
          : this.receiptImagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionDto(')
          ..write('id: $id, ')
          ..write('amountMinorUnits: $amountMinorUnits, ')
          ..write('currency: $currency, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('source: $source, ')
          ..write('receiptMerchant: $receiptMerchant, ')
          ..write('receiptImagePath: $receiptImagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountMinorUnits,
    currency,
    kind,
    description,
    occurredAt,
    categoryId,
    source,
    receiptMerchant,
    receiptImagePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionDto &&
          other.id == this.id &&
          other.amountMinorUnits == this.amountMinorUnits &&
          other.currency == this.currency &&
          other.kind == this.kind &&
          other.description == this.description &&
          other.occurredAt == this.occurredAt &&
          other.categoryId == this.categoryId &&
          other.source == this.source &&
          other.receiptMerchant == this.receiptMerchant &&
          other.receiptImagePath == this.receiptImagePath);
}

class TransactionsCompanion extends UpdateCompanion<TransactionDto> {
  final Value<int> id;
  final Value<int> amountMinorUnits;
  final Value<Currency> currency;
  final Value<TransactionKind> kind;
  final Value<String> description;
  final Value<DateTime> occurredAt;
  final Value<int> categoryId;
  final Value<TransactionSource> source;
  final Value<String?> receiptMerchant;
  final Value<String?> receiptImagePath;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amountMinorUnits = const Value.absent(),
    this.currency = const Value.absent(),
    this.kind = const Value.absent(),
    this.description = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.source = const Value.absent(),
    this.receiptMerchant = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int amountMinorUnits,
    required Currency currency,
    required TransactionKind kind,
    this.description = const Value.absent(),
    required DateTime occurredAt,
    required int categoryId,
    required TransactionSource source,
    this.receiptMerchant = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
  }) : amountMinorUnits = Value(amountMinorUnits),
       currency = Value(currency),
       kind = Value(kind),
       occurredAt = Value(occurredAt),
       categoryId = Value(categoryId),
       source = Value(source);
  static Insertable<TransactionDto> custom({
    Expression<int>? id,
    Expression<int>? amountMinorUnits,
    Expression<String>? currency,
    Expression<String>? kind,
    Expression<String>? description,
    Expression<DateTime>? occurredAt,
    Expression<int>? categoryId,
    Expression<String>? source,
    Expression<String>? receiptMerchant,
    Expression<String>? receiptImagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountMinorUnits != null) 'amount_minor_units': amountMinorUnits,
      if (currency != null) 'currency': currency,
      if (kind != null) 'kind': kind,
      if (description != null) 'description': description,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (categoryId != null) 'category_id': categoryId,
      if (source != null) 'source': source,
      if (receiptMerchant != null) 'receipt_merchant': receiptMerchant,
      if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? amountMinorUnits,
    Value<Currency>? currency,
    Value<TransactionKind>? kind,
    Value<String>? description,
    Value<DateTime>? occurredAt,
    Value<int>? categoryId,
    Value<TransactionSource>? source,
    Value<String?>? receiptMerchant,
    Value<String?>? receiptImagePath,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amountMinorUnits: amountMinorUnits ?? this.amountMinorUnits,
      currency: currency ?? this.currency,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      occurredAt: occurredAt ?? this.occurredAt,
      categoryId: categoryId ?? this.categoryId,
      source: source ?? this.source,
      receiptMerchant: receiptMerchant ?? this.receiptMerchant,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountMinorUnits.present) {
      map['amount_minor_units'] = Variable<int>(amountMinorUnits.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(
        $TransactionsTable.$convertercurrency.toSql(currency.value),
      );
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TransactionsTable.$converterkind.toSql(kind.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source.value),
      );
    }
    if (receiptMerchant.present) {
      map['receipt_merchant'] = Variable<String>(receiptMerchant.value);
    }
    if (receiptImagePath.present) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountMinorUnits: $amountMinorUnits, ')
          ..write('currency: $currency, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('source: $source, ')
          ..write('receiptMerchant: $receiptMerchant, ')
          ..write('receiptImagePath: $receiptImagePath')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    budgets,
    categories,
    transactions,
  ];
}

typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      required int year,
      required int month,
      required int limitMinorUnits,
      required Currency currency,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<int> year,
      Value<int> month,
      Value<int> limitMinorUnits,
      Value<Currency> currency,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
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

  ColumnFilters<int> get limitMinorUnits => $composableBuilder(
    column: $table.limitMinorUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Currency, Currency, String> get currency =>
      $composableBuilder(
        column: $table.currency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
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

  ColumnOrderings<int> get limitMinorUnits => $composableBuilder(
    column: $table.limitMinorUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
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

  GeneratedColumn<int> get limitMinorUnits => $composableBuilder(
    column: $table.limitMinorUnits,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Currency, String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetDto,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetDto, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetDto>),
          BudgetDto,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> limitMinorUnits = const Value.absent(),
                Value<Currency> currency = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                year: year,
                month: month,
                limitMinorUnits: limitMinorUnits,
                currency: currency,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int year,
                required int month,
                required int limitMinorUnits,
                required Currency currency,
              }) => BudgetsCompanion.insert(
                id: id,
                year: year,
                month: month,
                limitMinorUnits: limitMinorUnits,
                currency: currency,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetDto>(table),
                  BaseReferences<_$AppDatabase, $BudgetsTable, BudgetDto>(
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

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetDto,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetDto, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetDto>),
      BudgetDto,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required CategoryIcon icon,
      required int colorValue,
      Value<bool> isDefault,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<CategoryIcon> icon,
      Value<int> colorValue,
      Value<bool> isDefault,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryDto> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TransactionDto>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<CategoryIcon, CategoryIcon, String> get icon =>
      $composableBuilder(
        column: $table.icon,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<CategoryIcon, String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryDto,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryDto, $$CategoriesTableReferences),
          CategoryDto,
          PrefetchHooks Function({bool transactionsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CategoryIcon> icon = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                colorValue: colorValue,
                isDefault: isDefault,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required CategoryIcon icon,
                required int colorValue,
                Value<bool> isDefault = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                colorValue: colorValue,
                isDefault: isDefault,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryDto>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<
                      CategoryDto,
                      $CategoriesTable,
                      TransactionDto
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryDto,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryDto, $$CategoriesTableReferences),
      CategoryDto,
      PrefetchHooks Function({bool transactionsRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int amountMinorUnits,
      required Currency currency,
      required TransactionKind kind,
      Value<String> description,
      required DateTime occurredAt,
      required int categoryId,
      required TransactionSource source,
      Value<String?> receiptMerchant,
      Value<String?> receiptImagePath,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> amountMinorUnits,
      Value<Currency> currency,
      Value<TransactionKind> kind,
      Value<String> description,
      Value<DateTime> occurredAt,
      Value<int> categoryId,
      Value<TransactionSource> source,
      Value<String?> receiptMerchant,
      Value<String?> receiptImagePath,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, TransactionDto> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<int> get amountMinorUnits => $composableBuilder(
    column: $table.amountMinorUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Currency, Currency, String> get currency =>
      $composableBuilder(
        column: $table.currency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TransactionKind, TransactionKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionSource, TransactionSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get receiptMerchant => $composableBuilder(
    column: $table.receiptMerchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<int> get amountMinorUnits => $composableBuilder(
    column: $table.amountMinorUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptMerchant => $composableBuilder(
    column: $table.receiptMerchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinorUnits => $composableBuilder(
    column: $table.amountMinorUnits,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Currency, String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TransactionSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get receiptMerchant => $composableBuilder(
    column: $table.receiptMerchant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionDto,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TransactionDto, $$TransactionsTableReferences),
          TransactionDto,
          PrefetchHooks Function({bool categoryId})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountMinorUnits = const Value.absent(),
                Value<Currency> currency = const Value.absent(),
                Value<TransactionKind> kind = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<TransactionSource> source = const Value.absent(),
                Value<String?> receiptMerchant = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amountMinorUnits: amountMinorUnits,
                currency: currency,
                kind: kind,
                description: description,
                occurredAt: occurredAt,
                categoryId: categoryId,
                source: source,
                receiptMerchant: receiptMerchant,
                receiptImagePath: receiptImagePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountMinorUnits,
                required Currency currency,
                required TransactionKind kind,
                Value<String> description = const Value.absent(),
                required DateTime occurredAt,
                required int categoryId,
                required TransactionSource source,
                Value<String?> receiptMerchant = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amountMinorUnits: amountMinorUnits,
                currency: currency,
                kind: kind,
                description: description,
                occurredAt: occurredAt,
                categoryId: categoryId,
                source: source,
                receiptMerchant: receiptMerchant,
                receiptImagePath: receiptImagePath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionDto>(table),
                  $$TransactionsTableReferences(db, table, e),
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
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$TransactionsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$TransactionsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionDto,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TransactionDto, $$TransactionsTableReferences),
      TransactionDto,
      PrefetchHooks Function({bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}
