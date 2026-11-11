import 'package:drift/drift.dart';

/// The coins the user starred: one row each, in the order they were added.
///
/// The coin id isn't a foreign key: coins aren't stored (they come from the
/// seed at every launch), and a starred coin the market no longer lists is
/// simply not shown.
@DataClassName('WatchItemRow')
class WatchItems extends Table {
  TextColumn get coinId => text().check(coinId.length.isBiggerThanValue(0))();

  /// When it was starred (UTC): the watchlist's order, and what Undo puts
  /// back.
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {coinId};
}
