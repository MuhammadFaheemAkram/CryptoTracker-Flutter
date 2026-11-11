/// How often the simulated market moves.
///
/// Pausing isn't an interval here (the native specs list "paused" as a
/// fourth option): it's a switch of its own, so resuming returns to the
/// interval the user chose (see `AppSettings.livePricesPaused`).
enum TickInterval {
  oneSecond(Duration(seconds: 1)),
  twoSeconds(Duration(seconds: 2)),
  fiveSeconds(Duration(seconds: 5));

  const TickInterval(this.period);

  final Duration period;
}
