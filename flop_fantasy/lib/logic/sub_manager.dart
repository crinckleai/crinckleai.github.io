import '../models/manager_squad.dart';
import '../models/player.dart';
import '../services/scoring_engine.dart';

/// Trigger that determines whether a bench player can replace a starter.
enum SubTrigger {
  /// Starter logged zero minutes / didNotAppear=true.
  didNotPlay,

  /// Manager flipped a manual sub before deadline.
  manual,
}

/// Why a manual sub got penalised.
enum ManualPenaltyReason {
  pastDeadline,
  duplicatePosition, // would break formation constraints
  benchPlayerDidNotPlay, // can't sub in someone who also flopped
}

class SubAction {
  const SubAction({
    required this.starterOutId,
    required this.benchInId,
    required this.trigger,
    this.penaltyReason,
    this.appliedAt,
  });

  final String starterOutId;
  final String benchInId;
  final SubTrigger trigger;
  final ManualPenaltyReason? penaltyReason;
  final DateTime? appliedAt;

  bool get isPenalised => penaltyReason != null;
}

class SubResolution {
  SubResolution({
    required this.finalStarters,
    required this.actions,
    required this.erasedPoints,
  });

  /// Effective set of starter IDs after all sub logic runs.
  final Set<String> finalStarters;
  final List<SubAction> actions;

  /// Total points wiped out by the point-erasure penalty.
  final int erasedPoints;
}

/// Pure-Dart sub manager.
///
/// State machine:
///
///   ┌──── deadline NOT passed ────────────────────────────┐
///   │                                                     │
///   ▼                                                     │
///  Manual sub (free)  ──── checks formation + bench valid ┤
///   │                                                     │
///   └──── deadline passed ─────────────────────────────┐  │
///                                                      ▼  ▼
///                                              Auto-sub kicks in for any
///                                              non-appearing starters,
///                                              respecting position rules.
///
/// Point-erasure penalty: if a manual sub is attempted *after* the deadline
/// (or a forbidden formation is forced), the bench player's flop points for
/// the gameweek are ZEROED — the manager doesn't get rewarded for cheating
/// the lineup. The original starter's points still count (they took the L).
class SubManager {
  const SubManager();

  /// Resolves the final starters and reports any penalty.
  ///
  /// [squad] is the gameweek's selected 15.
  /// [playersById] maps player ID -> Player (for position checks).
  /// [scores] is the engine output BEFORE captaincy multipliers — we need raw
  /// per-player points so we can subtract erased contributions cleanly.
  /// [manualSubs] are sub requests the manager submitted (in order).
  /// [deadline] is the GW deadline.
  /// [now] defaults to DateTime.now() — injected for tests.
  SubResolution resolve({
    required ManagerSquad squad,
    required Map<String, Player> playersById,
    required GameweekScore scores,
    List<SubAction> manualSubs = const [],
    required DateTime deadline,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final actions = <SubAction>[];
    var erasedPoints = 0;

    final starters = squad.starters.map((s) => s.playerId).toSet();
    final bench = squad.orderedBench.map((s) => s.playerId).toList();

    // === Phase 1: Manual subs ===
    for (final m in manualSubs) {
      final pastDeadline = (m.appliedAt ?? clock).isAfter(deadline);
      if (playersById[m.starterOutId] == null ||
          playersById[m.benchInId] == null) {
        continue;
      }

      // Validate formation if this sub is allowed in.
      final tentative = _swap(starters, m.starterOutId, m.benchInId);
      final formationOk = _formationValid(tentative, playersById);

      ManualPenaltyReason? reason;
      if (pastDeadline) {
        reason = ManualPenaltyReason.pastDeadline;
      } else if (!formationOk) {
        reason = ManualPenaltyReason.duplicatePosition;
      } else if (!(scores.perPlayer[m.benchInId]?.appeared ?? false)) {
        // You tried to bring on someone who also didn't play.
        reason = ManualPenaltyReason.benchPlayerDidNotPlay;
      }

      // Even penalised subs still execute (the manager wanted it).
      starters
        ..remove(m.starterOutId)
        ..add(m.benchInId);
      bench
        ..remove(m.benchInId)
        ..insert(0, m.starterOutId);

      if (reason != null) {
        // Wipe out the points that the bench player would have contributed.
        final pg = scores.perPlayer[m.benchInId];
        if (pg != null) {
          erasedPoints += pg.rawPoints;
          scores.perPlayer[m.benchInId] = _zeroOut(pg);
        }
      }

      actions.add(SubAction(
        starterOutId: m.starterOutId,
        benchInId: m.benchInId,
        trigger: SubTrigger.manual,
        penaltyReason: reason,
        appliedAt: m.appliedAt,
      ));
    }

    // === Phase 2: Auto-subs for non-appearing starters ===
    final remaining = List<String>.from(bench);
    final starterList = starters.toList();
    for (final sid in starterList) {
      final pg = scores.perPlayer[sid];
      final didShow = pg?.appeared ?? false;
      if (didShow) continue;

      // Find first available bench player that (a) appeared AND (b) keeps
      // formation valid.
      String? swapIn;
      for (final bid in remaining) {
        final benchAppeared = scores.perPlayer[bid]?.appeared ?? false;
        if (!benchAppeared) continue;
        final tentative = _swap(starters, sid, bid);
        if (_formationValid(tentative, playersById)) {
          swapIn = bid;
          break;
        }
      }
      if (swapIn == null) continue;

      starters
        ..remove(sid)
        ..add(swapIn);
      remaining.remove(swapIn);

      actions.add(SubAction(
        starterOutId: sid,
        benchInId: swapIn,
        trigger: SubTrigger.didNotPlay,
      ));
    }

    return SubResolution(
      finalStarters: starters,
      actions: actions,
      erasedPoints: erasedPoints,
    );
  }

  Set<String> _swap(Set<String> starters, String out, String inn) {
    final s = Set<String>.from(starters);
    s
      ..remove(out)
      ..add(inn);
    return s;
  }

  bool _formationValid(Set<String> starterIds, Map<String, Player> byId) {
    if (starterIds.length != 11) return false;
    var gk = 0, def = 0, mid = 0, fwd = 0;
    for (final id in starterIds) {
      final p = byId[id];
      if (p == null) return false;
      switch (p.position) {
        case PlayerPosition.goalkeeper:
          gk++;
        case PlayerPosition.defender:
          def++;
        case PlayerPosition.midfielder:
          mid++;
        case PlayerPosition.forward:
          fwd++;
      }
    }
    if (gk != 1) return false;
    if (def < 3 || def > 5) return false;
    if (mid < 2 || mid > 5) return false;
    if (fwd < 1 || fwd > 3) return false;
    return true;
  }

  PlayerGameweek _zeroOut(PlayerGameweek pg) {
    final neutered = PlayerGameweek(
      playerId: pg.playerId,
      rawPoints: 0,
      events: const [],
      appeared: pg.appeared,
    );
    return neutered;
  }
}
