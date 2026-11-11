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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WatchItemsTable watchItems = $WatchItemsTable(this);
  late final WatchlistDao watchlistDao = WatchlistDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [watchItems];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WatchItemsTableTableManager get watchItems =>
      $$WatchItemsTableTableManager(_db, _db.watchItems);
}
