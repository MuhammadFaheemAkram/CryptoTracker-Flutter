// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'portfolio_dao.dart';

// ignore_for_file: type=lint
mixin _$PortfolioDaoMixin on DatabaseAccessor<AppDatabase> {
  $HoldingsTable get holdings => attachedDatabase.holdings;
  PortfolioDaoManager get managers => PortfolioDaoManager(this);
}

class PortfolioDaoManager {
  final _$PortfolioDaoMixin _db;
  PortfolioDaoManager(this._db);
  $$HoldingsTableTableManager get holdings =>
      $$HoldingsTableTableManager(_db.attachedDatabase, _db.holdings);
}
