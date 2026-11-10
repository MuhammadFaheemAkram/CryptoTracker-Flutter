/// Which way a price moved: what a row flashes (Phase 3: from one tick to
/// the next), and which arrow a 24 h change shows.
enum PriceDirection {
  up,
  down,
  flat;

  /// The direction of a percentage change *as it will be shown*: rounded to
  /// two decimals, like the label next to it. A change that rounds to
  /// 0.00 % is flat, so an arrow never points at "0.00 %". Anything that
  /// isn't a number is flat too.
  static PriceDirection ofChange(double percent) {
    if (!percent.isFinite) return flat;
    return switch ((percent * 100).round()) {
      > 0 => up,
      < 0 => down,
      _ => flat,
    };
  }
}
