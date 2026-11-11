// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'watchlist_dao.dart';

// ignore_for_file: type=lint
mixin _$WatchlistDaoMixin on DatabaseAccessor<AppDatabase> {
  $WatchItemsTable get watchItems => attachedDatabase.watchItems;
  WatchlistDaoManager get managers => WatchlistDaoManager(this);
}

class WatchlistDaoManager {
  final _$WatchlistDaoMixin _db;
  WatchlistDaoManager(this._db);
  $$WatchItemsTableTableManager get watchItems =>
      $$WatchItemsTableTableManager(_db.attachedDatabase, _db.watchItems);
}
