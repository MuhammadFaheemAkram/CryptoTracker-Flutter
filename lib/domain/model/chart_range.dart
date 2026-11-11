/// What a coin's chart shows.
enum ChartRange {
  /// The prices seen since launch (the last 60 updates), moving with each
  /// tick.
  live('Live'),

  /// The last 7 days, from the seed (24 points). It doesn't tick.
  sevenDays('7 days');

  const ChartRange(this.label);

  final String label;
}
