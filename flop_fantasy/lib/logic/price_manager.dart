import '../models/player.dart';

/// Post-gameweek price updates driven by net transfer volume.
///
/// Cap: +/- 0.3 per round (i.e. a single GW can shift a player at most 0.3).
/// Granularity: prices move in steps of 0.1.
///
/// Mechanism:
///   - Each player has a netTransfers value = transfersIn - transfersOut.
///   - We normalise by total ownership (proxy for population). The bigger the
///     net swing relative to ownership, the faster the price moves.
///   - The result is clamped to +/- 0.3 and rounded to one decimal.
class PriceManager {
  const PriceManager({
    this.maxStepPerRound = 0.3,
    this.granularity = 0.1,
    this.thresholdLow = 0.05, // <5% ownership swing → no move
    this.thresholdMid = 0.15, // 5-15% → +/-0.1
    this.thresholdHigh = 0.30, // 15-30% → +/-0.2
    // anything above → +/-0.3
    this.minPrice = 3.5,
    this.maxPrice = 14.5,
  });

  final double maxStepPerRound;
  final double granularity;
  final double thresholdLow;
  final double thresholdMid;
  final double thresholdHigh;
  final double minPrice;
  final double maxPrice;

  /// Returns updated players with new [Player.price] values applied.
  /// Original counters (`netTransfersIn/Out`) are reset to 0 for the next round.
  List<Player> applyRound(
    List<Player> players, {
    int? totalManagers,
  }) {
    final updated = <Player>[];
    for (final p in players) {
      final delta = _delta(p, totalManagers: totalManagers);
      var newPrice = p.price + delta;
      newPrice = newPrice.clamp(minPrice, maxPrice);
      newPrice = _round(newPrice);
      updated.add(p.copyWith(
        price: newPrice,
        netTransfersIn: 0,
        netTransfersOut: 0,
      ));
    }
    return updated;
  }

  /// Exposed for tests / preview UIs: what would this player's price move be?
  double previewDelta(Player p, {int? totalManagers}) =>
      _delta(p, totalManagers: totalManagers);

  double _delta(Player p, {int? totalManagers}) {
    // Compute the swing fraction. If totalManagers is supplied, use that as
    // the denominator; otherwise fall back to ownership * 1_000_000 heuristic.
    final denom = (totalManagers != null && totalManagers > 0)
        ? totalManagers.toDouble()
        : (p.totalOwnership > 0 ? p.totalOwnership * 1000000 : 1000000);
    final swing = p.netTransfers / denom;
    final mag = swing.abs();

    double step;
    if (mag < thresholdLow) {
      step = 0.0;
    } else if (mag < thresholdMid) {
      step = 0.1;
    } else if (mag < thresholdHigh) {
      step = 0.2;
    } else {
      step = maxStepPerRound;
    }
    final signed = swing >= 0 ? step : -step;
    // Clamp to ±maxStepPerRound just in case.
    return signed.clamp(-maxStepPerRound, maxStepPerRound);
  }

  double _round(double value) {
    final stepsFromZero = (value / granularity).round();
    return double.parse((stepsFromZero * granularity).toStringAsFixed(1));
  }
}
