import '../models/match_stats.dart';
import '../models/player.dart';

/// Result of scoring a single player's match.
class PlayerScore {
  PlayerScore({required this.playerId, required this.matchId});

  final String playerId;
  final String matchId;
  final List<ScoredEvent> events = [];

  int get total => events.fold(0, (s, e) => s + e.points);
}

class ScoredEvent {
  const ScoredEvent({
    required this.event,
    required this.points,
    this.minute,
  });
  final DisasterEvent event;
  final int points;
  final int? minute;
}

/// The disaster matrix. Reverse-logic: disasters earn points.
///
/// Values are per-occurrence unless noted. Modify here to retune balance —
/// the engine reads exclusively from this map so behaviour stays predictable.
class DisasterMatrix {
  static const Map<DisasterEvent, int> baseValues = {
    DisasterEvent.ownGoal: 10,
    DisasterEvent.redCard: 7,
    DisasterEvent.secondYellow: 5,
    DisasterEvent.yellowCard: 2,
    DisasterEvent.missedPenalty: 8,
    DisasterEvent.penaltySaved: 5,
    DisasterEvent.giveawayPenalty: 6,
    DisasterEvent.goalConceded: 1, // per goal (GK/DEF only — see engine)
    DisasterEvent.cleanSheetFailureGk: 3, // bonus when GK ships 2+
    DisasterEvent.cleanSheetFailureDef: 2, // bonus when DEF ships 2+
    DisasterEvent.subbedOffEarly: 3,
    DisasterEvent.didNotPlay: 5,
    DisasterEvent.injuryOff: 4,
    DisasterEvent.bigChanceMissed: 2,
    DisasterEvent.errorLeadingToGoal: 4,
    DisasterEvent.hitWoodwork: 1, // "so close" irony bonus
    DisasterEvent.matchLost: 3,
    DisasterEvent.heavyDefeat: 4, // additive on top of matchLost
  };

  static int valueOf(DisasterEvent e) => baseValues[e] ?? 0;
}

/// Pure-Dart scoring engine. No Firebase, no Flutter, no I/O — so the math
/// can be tested in isolation.
class ScoringEngine {
  const ScoringEngine();

  /// Compute a [PlayerScore] for a single player given their match stats and
  /// position. Captaincy is applied separately by [scoreSquadGameweek].
  PlayerScore scorePlayerMatch({
    required Player player,
    required MatchStats stats,
  }) {
    final score = PlayerScore(playerId: player.id, matchId: stats.matchId);

    // Did Not Play: short-circuit. No other disasters can occur if they didn't appear.
    if (stats.didNotAppear || stats.minutesPlayed == 0) {
      score.events.add(ScoredEvent(
        event: DisasterEvent.didNotPlay,
        points: DisasterMatrix.valueOf(DisasterEvent.didNotPlay),
      ));
      return score;
    }

    // Cards
    _addRepeated(score, DisasterEvent.yellowCard, stats.yellowCards);
    _addRepeated(score, DisasterEvent.secondYellow, stats.secondYellows);
    _addRepeated(score, DisasterEvent.redCard, stats.redCards);

    // Goal-related disasters
    _addRepeated(score, DisasterEvent.ownGoal, stats.ownGoals);
    _addRepeated(score, DisasterEvent.missedPenalty, stats.missedPenalties);
    _addRepeated(score, DisasterEvent.penaltySaved, stats.penaltiesHadSaved);
    _addRepeated(score, DisasterEvent.giveawayPenalty, stats.penaltiesGivenAway);

    // Goals conceded — only GK and DEF earn for these (you can't hide a leaky back line).
    if (player.position == PlayerPosition.goalkeeper ||
        player.position == PlayerPosition.defender) {
      _addRepeated(score, DisasterEvent.goalConceded, stats.goalsConceded);

      if (stats.goalsConceded >= 2) {
        final event = player.position == PlayerPosition.goalkeeper
            ? DisasterEvent.cleanSheetFailureGk
            : DisasterEvent.cleanSheetFailureDef;
        score.events.add(ScoredEvent(event: event, points: DisasterMatrix.valueOf(event)));
      }
    }

    // Performance disasters
    _addRepeated(score, DisasterEvent.bigChanceMissed, stats.bigChancesMissed);
    _addRepeated(score, DisasterEvent.errorLeadingToGoal, stats.errorsLeadingToGoal);
    _addRepeated(score, DisasterEvent.hitWoodwork, stats.hitWoodwork);

    // State-based disasters (boolean)
    if (stats.subbedOffBefore60) {
      score.events.add(ScoredEvent(
        event: DisasterEvent.subbedOffEarly,
        points: DisasterMatrix.valueOf(DisasterEvent.subbedOffEarly),
      ));
    }
    if (stats.injuredOff) {
      score.events.add(ScoredEvent(
        event: DisasterEvent.injuryOff,
        points: DisasterMatrix.valueOf(DisasterEvent.injuryOff),
      ));
    }
    if (stats.teamLost) {
      score.events.add(ScoredEvent(
        event: DisasterEvent.matchLost,
        points: DisasterMatrix.valueOf(DisasterEvent.matchLost),
      ));
    }
    if (stats.teamLostHeavily) {
      score.events.add(ScoredEvent(
        event: DisasterEvent.heavyDefeat,
        points: DisasterMatrix.valueOf(DisasterEvent.heavyDefeat),
      ));
    }

    return score;
  }

  /// Score a manager's gameweek across multiple matches. Applies the captain
  /// double-multiplier (vice-captain fallback if captain did not appear).
  ///
  /// [statsByPlayer] maps playerId -> list of MatchStats for the gameweek
  /// (most players will have a single entry; group games could have more).
  GameweekScore scoreSquadGameweek({
    required List<Player> squad,
    required String captainId,
    String? viceCaptainId,
    required Map<String, List<MatchStats>> statsByPlayer,
    required Set<String> startingIds,
    bool tripleCaptain = false,
    bool benchBoost = false,
  }) {
    final byId = {for (final p in squad) p.id: p};
    final result = GameweekScore();

    for (final player in squad) {
      final matches = statsByPlayer[player.id] ?? const [];
      var playerTotal = 0;
      final allEvents = <ScoredEvent>[];
      var appeared = false;
      for (final m in matches) {
        final ps = scorePlayerMatch(player: player, stats: m);
        playerTotal += ps.total;
        allEvents.addAll(ps.events);
        if (m.appeared) appeared = true;
      }

      result.perPlayer[player.id] = PlayerGameweek(
        playerId: player.id,
        rawPoints: playerTotal,
        events: allEvents,
        appeared: appeared,
      );
    }

    // Determine effective captain. If captain didn't appear, fall back to vice.
    var effectiveCaptain = captainId;
    final captainAppeared = result.perPlayer[captainId]?.appeared ?? false;
    if (!captainAppeared && viceCaptainId != null) {
      final viceAppeared = result.perPlayer[viceCaptainId]?.appeared ?? false;
      if (viceAppeared) effectiveCaptain = viceCaptainId;
    }
    result.effectiveCaptainId = effectiveCaptain;

    // Sum starters with captaincy multiplier.
    final captainMult = tripleCaptain ? 3 : 2;
    for (final pid in startingIds) {
      final pg = result.perPlayer[pid];
      if (pg == null) continue;
      final mult = (pid == effectiveCaptain) ? captainMult : 1;
      pg.contribution = pg.rawPoints * mult;
      result.startingTotal += pg.contribution;
    }

    // Bench boost: bench players also contribute (1x, no captain mult on bench).
    if (benchBoost) {
      for (final entry in result.perPlayer.entries) {
        if (startingIds.contains(entry.key)) continue;
        entry.value.contribution = entry.value.rawPoints;
        result.benchTotal += entry.value.contribution;
      }
    }

    result.gameweekTotal = result.startingTotal + result.benchTotal;

    // Sanity touch — keep [byId] referenced for future extension hooks.
    assert(byId.length == squad.length);
    return result;
  }

  void _addRepeated(PlayerScore score, DisasterEvent event, int count) {
    if (count <= 0) return;
    final unit = DisasterMatrix.valueOf(event);
    for (var i = 0; i < count; i++) {
      score.events.add(ScoredEvent(event: event, points: unit));
    }
  }
}

class PlayerGameweek {
  PlayerGameweek({
    required this.playerId,
    required this.rawPoints,
    required this.events,
    required this.appeared,
  });
  final String playerId;
  final int rawPoints;
  final List<ScoredEvent> events;
  final bool appeared;

  /// Filled in after captaincy / starter resolution.
  int contribution = 0;
}

class GameweekScore {
  final Map<String, PlayerGameweek> perPlayer = {};
  int startingTotal = 0;
  int benchTotal = 0;
  int gameweekTotal = 0;
  String? effectiveCaptainId;
}
