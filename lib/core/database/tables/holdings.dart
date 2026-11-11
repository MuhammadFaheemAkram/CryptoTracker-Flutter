import 'package:drift/drift.dart';

/// What the user owns: an amount of a coin, bought at a price.
///
/// Money is stored in US dollars (`buy_price_usd`): a price typed in euros
/// is converted on save, so changing the currency later never changes what
/// a holding cost. The `CHECK`s back up the form's validation: a zero or
/// negative amount can't reach the table, whatever the caller.
@DataClassName('HoldingRow')
class Holdings extends Table {
  /// `INTEGER PRIMARY KEY AUTOINCREMENT`: an id is never reused, so Undo
  /// can put a removed holding back under the same id.
  IntColumn get id => integer().autoIncrement()();
  TextColumn get coinId => text().check(coinId.length.isBiggerThanValue(0))();
  // A check names its own column, which reads as a getter returning
  // itself: drift's documented form, not a recursion (the builder only
  // reads the column's name).
  // ignore: recursive_getters
  RealColumn get amount => real().check(amount.isBiggerThanValue(0))();
  RealColumn get buyPriceUsd =>
      // ignore: recursive_getters
      real().check(buyPriceUsd.isBiggerThanValue(0))();
  DateTimeColumn get createdAt => dateTime()();
}
