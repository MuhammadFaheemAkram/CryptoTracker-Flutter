/// How the market list is ordered. Each option has one direction, the one
/// people expect (Correctness Rule 6): rank and name ascending, price and
/// 24 h change descending (the biggest first). Ties fall back to rank.
enum SortOption { rank, price, change24h, name }
