// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WatchItemsTable extends WatchItems
    with TableInfo<$WatchItemsTable, WatchItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _coinIdMeta = const VerificationMeta('coinId');
  @override
  late final GeneratedColumn<String> coinId = GeneratedColumn<String>(
    'coin_id',
    aliasedName,
    false,
    check: () => ComparableExpr(coinId.length).isBiggerThanValue(0),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [coinId, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watch_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('coin_id')) {
      context.handle(
        _coinIdMeta,
        coinId.isAcceptableOrUnknown(data['coin_id']!, _coinIdMeta),
      );
    } else if (isInserting) {
      context.missing(_coinIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {coinId};
  @override
  WatchItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchItemRow(
      coinId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coin_id'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $WatchItemsTable createAlias(String alias) {
    return $WatchItemsTable(attachedDatabase, alias);
  }
}

class WatchItemRow extends DataClass implements Insertable<WatchItemRow> {
  final String coinId;

  /// When it was starred (UTC): the watchlist's order, and what Undo puts
  /// back.
  final DateTime addedAt;
  const WatchItemRow({required this.coinId, required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['coin_id'] = Variable<String>(coinId);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  WatchItemsCompanion toCompanion(bool nullToAbsent) {
    return WatchItemsCompanion(coinId: Value(coinId), addedAt: Value(addedAt));
  }

  factory WatchItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchItemRow(
      coinId: serializer.fromJson<String>(json['coinId']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'coinId': serializer.toJson<String>(coinId),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  WatchItemRow copyWith({String? coinId, DateTime? addedAt}) => WatchItemRow(
    coinId: coinId ?? this.coinId,
    addedAt: addedAt ?? this.addedAt,
  );
  WatchItemRow copyWithCompanion(WatchItemsCompanion data) {
    return WatchItemRow(
      coinId: data.coinId.present ? data.coinId.value : this.coinId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchItemRow(')
          ..write('coinId: $coinId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(coinId, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchItemRow &&
          other.coinId == this.coinId &&
          other.addedAt == this.addedAt);
}

class WatchItemsCompanion extends UpdateCompanion<WatchItemRow> {
  final Value<String> coinId;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const WatchItemsCompanion({
    this.coinId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WatchItemsCompanion.insert({
    required String coinId,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : coinId = Value(coinId),
       addedAt = Value(addedAt);
  static Insertable<WatchItemRow> custom({
    Expression<String>? coinId,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (coinId != null) 'coin_id': coinId,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WatchItemsCompanion copyWith({
    Value<String>? coinId,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return WatchItemsCompanion(
      coinId: coinId ?? this.coinId,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (coinId.present) {
      map['coin_id'] = Variable<String>(coinId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchItemsCompanion(')
          ..write('coinId: $coinId, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HoldingsTable extends Holdings
    with TableInfo<$HoldingsTable, HoldingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoldingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _coinIdMeta = const VerificationMeta('coinId');
  @override
  late final GeneratedColumn<String> coinId = GeneratedColumn<String>(
    'coin_id',
    aliasedName,
    false,
    check: () => ComparableExpr(coinId.length).isBiggerThanValue(0),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    check: () => ComparableExpr(amount).isBiggerThanValue(0),
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buyPriceUsdMeta = const VerificationMeta(
    'buyPriceUsd',
  );
  @override
  late final GeneratedColumn<double> buyPriceUsd = GeneratedColumn<double>(
    'buy_price_usd',
    aliasedName,
    false,
    check: () => ComparableExpr(buyPriceUsd).isBiggerThanValue(0),
    type: DriftSqlType.double,
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
    coinId,
    amount,
    buyPriceUsd,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holdings';
  @override
  VerificationContext validateIntegrity(
    Insertable<HoldingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('coin_id')) {
      context.handle(
        _coinIdMeta,
        coinId.isAcceptableOrUnknown(data['coin_id']!, _coinIdMeta),
      );
    } else if (isInserting) {
      context.missing(_coinIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('buy_price_usd')) {
      context.handle(
        _buyPriceUsdMeta,
        buyPriceUsd.isAcceptableOrUnknown(
          data['buy_price_usd']!,
          _buyPriceUsdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_buyPriceUsdMeta);
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
  HoldingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HoldingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      coinId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coin_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      buyPriceUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}buy_price_usd'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HoldingsTable createAlias(String alias) {
    return $HoldingsTable(attachedDatabase, alias);
  }
}

class HoldingRow extends DataClass implements Insertable<HoldingRow> {
  /// `INTEGER PRIMARY KEY AUTOINCREMENT`: an id is never reused, so Undo
  /// can put a removed holding back under the same id.
  final int id;
  final String coinId;
  final double amount;
  final double buyPriceUsd;
  final DateTime createdAt;
  const HoldingRow({
    required this.id,
    required this.coinId,
    required this.amount,
    required this.buyPriceUsd,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['coin_id'] = Variable<String>(coinId);
    map['amount'] = Variable<double>(amount);
    map['buy_price_usd'] = Variable<double>(buyPriceUsd);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HoldingsCompanion toCompanion(bool nullToAbsent) {
    return HoldingsCompanion(
      id: Value(id),
      coinId: Value(coinId),
      amount: Value(amount),
      buyPriceUsd: Value(buyPriceUsd),
      createdAt: Value(createdAt),
    );
  }

  factory HoldingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HoldingRow(
      id: serializer.fromJson<int>(json['id']),
      coinId: serializer.fromJson<String>(json['coinId']),
      amount: serializer.fromJson<double>(json['amount']),
      buyPriceUsd: serializer.fromJson<double>(json['buyPriceUsd']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'coinId': serializer.toJson<String>(coinId),
      'amount': serializer.toJson<double>(amount),
      'buyPriceUsd': serializer.toJson<double>(buyPriceUsd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HoldingRow copyWith({
    int? id,
    String? coinId,
    double? amount,
    double? buyPriceUsd,
    DateTime? createdAt,
  }) => HoldingRow(
    id: id ?? this.id,
    coinId: coinId ?? this.coinId,
    amount: amount ?? this.amount,
    buyPriceUsd: buyPriceUsd ?? this.buyPriceUsd,
    createdAt: createdAt ?? this.createdAt,
  );
  HoldingRow copyWithCompanion(HoldingsCompanion data) {
    return HoldingRow(
      id: data.id.present ? data.id.value : this.id,
      coinId: data.coinId.present ? data.coinId.value : this.coinId,
      amount: data.amount.present ? data.amount.value : this.amount,
      buyPriceUsd: data.buyPriceUsd.present
          ? data.buyPriceUsd.value
          : this.buyPriceUsd,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HoldingRow(')
          ..write('id: $id, ')
          ..write('coinId: $coinId, ')
          ..write('amount: $amount, ')
          ..write('buyPriceUsd: $buyPriceUsd, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, coinId, amount, buyPriceUsd, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HoldingRow &&
          other.id == this.id &&
          other.coinId == this.coinId &&
          other.amount == this.amount &&
          other.buyPriceUsd == this.buyPriceUsd &&
          other.createdAt == this.createdAt);
}

class HoldingsCompanion extends UpdateCompanion<HoldingRow> {
  final Value<int> id;
  final Value<String> coinId;
  final Value<double> amount;
  final Value<double> buyPriceUsd;
  final Value<DateTime> createdAt;
  const HoldingsCompanion({
    this.id = const Value.absent(),
    this.coinId = const Value.absent(),
    this.amount = const Value.absent(),
    this.buyPriceUsd = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HoldingsCompanion.insert({
    this.id = const Value.absent(),
    required String coinId,
    required double amount,
    required double buyPriceUsd,
    required DateTime createdAt,
  }) : coinId = Value(coinId),
       amount = Value(amount),
       buyPriceUsd = Value(buyPriceUsd),
       createdAt = Value(createdAt);
  static Insertable<HoldingRow> custom({
    Expression<int>? id,
    Expression<String>? coinId,
    Expression<double>? amount,
    Expression<double>? buyPriceUsd,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (coinId != null) 'coin_id': coinId,
      if (amount != null) 'amount': amount,
      if (buyPriceUsd != null) 'buy_price_usd': buyPriceUsd,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HoldingsCompanion copyWith({
    Value<int>? id,
    Value<String>? coinId,
    Value<double>? amount,
    Value<double>? buyPriceUsd,
    Value<DateTime>? createdAt,
  }) {
    return HoldingsCompanion(
      id: id ?? this.id,
      coinId: coinId ?? this.coinId,
      amount: amount ?? this.amount,
      buyPriceUsd: buyPriceUsd ?? this.buyPriceUsd,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (coinId.present) {
      map['coin_id'] = Variable<String>(coinId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (buyPriceUsd.present) {
      map['buy_price_usd'] = Variable<double>(buyPriceUsd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoldingsCompanion(')
          ..write('id: $id, ')
          ..write('coinId: $coinId, ')
          ..write('amount: $amount, ')
          ..write('buyPriceUsd: $buyPriceUsd, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WatchItemsTable watchItems = $WatchItemsTable(this);
  late final $HoldingsTable holdings = $HoldingsTable(this);
  late final WatchlistDao watchlistDao = WatchlistDao(this as AppDatabase);
  late final PortfolioDao portfolioDao = PortfolioDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [watchItems, holdings];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$WatchItemsTableCreateCompanionBuilder = WatchItemsCompanion Function({
  required String coinId,
  required DateTime addedAt,
  Value<int> rowid,
});
typedef $$WatchItemsTableUpdateCompanionBuilder = WatchItemsCompanion Function({
  Value<String> coinId,
  Value<DateTime> addedAt,
  Value<int> rowid,
});

class $$WatchItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WatchItemsTable> {
  $$WatchItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get coinId => $composableBuilder(
    column: $table.coinId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchItemsTable> {
  $$WatchItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get coinId => $composableBuilder(
    column: $table.coinId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchItemsTable> {
  $$WatchItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get coinId =>
      $composableBuilder(column: $table.coinId, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$WatchItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchItemsTable,
          WatchItemRow,
          $$WatchItemsTableFilterComposer,
          $$WatchItemsTableOrderingComposer,
          $$WatchItemsTableAnnotationComposer,
          $$WatchItemsTableCreateCompanionBuilder,
          $$WatchItemsTableUpdateCompanionBuilder,
          (
            WatchItemRow,
            BaseReferences<_$AppDatabase, $WatchItemsTable, WatchItemRow>,
          ),
          WatchItemRow,
          PrefetchHooks Function()
        > {
  $$WatchItemsTableTableManager(_$AppDatabase db, $WatchItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> coinId = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WatchItemsCompanion(
                coinId: coinId,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String coinId,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => WatchItemsCompanion.insert(
                coinId: coinId,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WatchItemsTable, WatchItemRow>(table),
                  BaseReferences<_$AppDatabase, $WatchItemsTable, WatchItemRow>(
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

typedef $$WatchItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchItemsTable,
      WatchItemRow,
      $$WatchItemsTableFilterComposer,
      $$WatchItemsTableOrderingComposer,
      $$WatchItemsTableAnnotationComposer,
      $$WatchItemsTableCreateCompanionBuilder,
      $$WatchItemsTableUpdateCompanionBuilder,
      (
        WatchItemRow,
        BaseReferences<_$AppDatabase, $WatchItemsTable, WatchItemRow>,
      ),
      WatchItemRow,
      PrefetchHooks Function()
    >;
typedef $$HoldingsTableCreateCompanionBuilder = HoldingsCompanion Function({
  Value<int> id,
  required String coinId,
  required double amount,
  required double buyPriceUsd,
  required DateTime createdAt,
});
typedef $$HoldingsTableUpdateCompanionBuilder = HoldingsCompanion Function({
  Value<int> id,
  Value<String> coinId,
  Value<double> amount,
  Value<double> buyPriceUsd,
  Value<DateTime> createdAt,
});

class $$HoldingsTableFilterComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableFilterComposer({
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

  ColumnFilters<String> get coinId => $composableBuilder(
    column: $table.coinId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get buyPriceUsd => $composableBuilder(
    column: $table.buyPriceUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HoldingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableOrderingComposer({
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

  ColumnOrderings<String> get coinId => $composableBuilder(
    column: $table.coinId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get buyPriceUsd => $composableBuilder(
    column: $table.buyPriceUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HoldingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get coinId =>
      $composableBuilder(column: $table.coinId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get buyPriceUsd => $composableBuilder(
    column: $table.buyPriceUsd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HoldingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HoldingsTable,
          HoldingRow,
          $$HoldingsTableFilterComposer,
          $$HoldingsTableOrderingComposer,
          $$HoldingsTableAnnotationComposer,
          $$HoldingsTableCreateCompanionBuilder,
          $$HoldingsTableUpdateCompanionBuilder,
          (
            HoldingRow,
            BaseReferences<_$AppDatabase, $HoldingsTable, HoldingRow>,
          ),
          HoldingRow,
          PrefetchHooks Function()
        > {
  $$HoldingsTableTableManager(_$AppDatabase db, $HoldingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoldingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoldingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoldingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> coinId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> buyPriceUsd = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HoldingsCompanion(
                id: id,
                coinId: coinId,
                amount: amount,
                buyPriceUsd: buyPriceUsd,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String coinId,
                required double amount,
                required double buyPriceUsd,
                required DateTime createdAt,
              }) => HoldingsCompanion.insert(
                id: id,
                coinId: coinId,
                amount: amount,
                buyPriceUsd: buyPriceUsd,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HoldingsTable, HoldingRow>(table),
                  BaseReferences<_$AppDatabase, $HoldingsTable, HoldingRow>(
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

typedef $$HoldingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HoldingsTable,
      HoldingRow,
      $$HoldingsTableFilterComposer,
      $$HoldingsTableOrderingComposer,
      $$HoldingsTableAnnotationComposer,
      $$HoldingsTableCreateCompanionBuilder,
      $$HoldingsTableUpdateCompanionBuilder,
      (HoldingRow, BaseReferences<_$AppDatabase, $HoldingsTable, HoldingRow>),
      HoldingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WatchItemsTableTableManager get watchItems =>
      $$WatchItemsTableTableManager(_db, _db.watchItems);
  $$HoldingsTableTableManager get holdings =>
      $$HoldingsTableTableManager(_db, _db.holdings);
}
