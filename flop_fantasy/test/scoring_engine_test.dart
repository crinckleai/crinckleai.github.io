import 'package:flop_fantasy/models/match_stats.dart';
import 'package:flop_fantasy/models/player.dart';
import 'package:flop_fantasy/services/scoring_engine.dart';
import 'package:flutter_test/flutter_test.dart';

Player _player({
  String id = 'p1',
  PlayerPosition pos = PlayerPosition.midfielder,
}) {
  return Player(
    id: id,
    name: 'Test $id',
    club: 'Club',
    country: 'XX',
    position: pos,
    price: 5.0,
  );
}

MatchStats _stats({
  String playerId = 'p1',
  String matchId = 'm1',
  int minutes = 90,
  int ownGoals = 0,
  int redCards = 0,
  int yellowCards = 0,
  int secondYellows = 0,
  int missedPenalties = 0,
  int penaltiesSaved = 0,
  int penaltiesGivenAway = 0,
  int goalsConceded = 0,
  bool subbedOffEarly = false,
  bool injuredOff = false,
  int bigChancesMissed = 0,
  int errorsLeadingToGoal = 0,
  int hitWoodwork = 0,
  bool teamLost = false,
  bool teamLostHeavily = false,
  bool didNotAppear = false,
}) {
  return MatchStats(
    playerId: playerId,
    matchId: matchId,
    minutesPlayed: minutes,
    ownGoals: ownGoals,
    redCards: redCards,
    yellowCards: yellowCards,
    secondYellows: secondYellows,
    missedPenalties: missedPenalties,
    penaltiesHadSaved: penaltiesSaved,
    penaltiesGivenAway: penaltiesGivenAway,
    goalsConceded: goalsConceded,
    subbedOffBefore60: subbedOffEarly,
    injuredOff: injuredOff,
    bigChancesMissed: bigChancesMissed,
    errorsLeadingToGoal: errorsLeadingToGoal,
    hitWoodwork: hitWoodwork,
    teamLost: teamLost,
    teamLostHeavily: teamLostHeavily,
    didNotAppear: didNotAppear,
  );
}

void main() {
  const engine = ScoringEngine();

  group('ScoringEngine — single events', () {
    test('own goal awards +10', () {
      final score = engine.scorePlayerMatch(
        player: _player(),
        stats: _stats(ownGoals: 1),
      );
      expect(score.total, 10);
    });

    test('red card awards +7', () {
      final score = engine.scorePlayerMatch(
        player: _player(),
        stats: _stats(redCards: 1),
      );
      expect(score.total, 7);
    });

    test('yellow card awards +2', () {
      final score = engine.scorePlayerMatch(
        player: _player(),
        stats: _stats(yellowCards: 1),
      );
      expect(score.total, 2);
    });

    test('missed penalty awards +8', () {
      final score = engine.scorePlayerMatch(
        player: _player(),
        stats: _stats(missedPenalties: 1),
      );
      expect(score.total, 8);
    });

    test('did not play short-circuits with +5', () {
      final score = engine.scorePlayerMatch(
        player: _player(),
        stats: _stats(
          minutes: 0,
          didNotAppear: true,
          // Should be ignored because did-not-play short-circuits.
          yellowCards: 1,
          ownGoals: 1,
        ),
      );
      expect(score.total, 5);
      expect(score.events.length, 1);
      expect(score.events.single.event, DisasterEvent.didNotPlay);
    });
  });

  group('ScoringEngine — position-aware', () {
    test('goals conceded only score for GK/DEF', () {
      final mid = engine.scorePlayerMatch(
        player: _player(pos: PlayerPosition.midfielder),
        stats: _stats(goalsConceded: 3),
      );
      expect(mid.total, 0);

      final def = engine.scorePlayerMatch(
        player: _player(pos: PlayerPosition.defender),
        stats: _stats(goalsConceded: 3),
      );
      // 3 goals * 1 + clean-sheet-failure-def 2 = 5
      expect(def.total, 5);

      final gk = engine.scorePlayerMatch(
        player: _player(pos: PlayerPosition.goalkeeper),
        stats: _stats(goalsConceded: 2),
      );
      // 2 goals * 1 + clean-sheet-failure-gk 3 = 5
      expect(gk.total, 5);
    });
  });

  group('ScoringEngine — combined disasters', () {
    test('compound flop game stacks all events', () {
      final score = engine.scorePlayerMatch(
        player: _player(pos: PlayerPosition.defender),
        stats: _stats(
          yellowCards: 1,
          secondYellows: 1,
          redCards: 1,
          ownGoals: 1,
          goalsConceded: 3,
          subbedOffEarly: true,
          teamLost: true,
          teamLostHeavily: true,
        ),
      );
      // 2 + 5 + 7 + 10 + (3*1) + 2 (CS fail def) + 3 (subbed off) + 3 (lost) + 4 (heavy) = 39
      expect(score.total, 39);
    });
  });

  group('ScoringEngine — gameweek aggregation', () {
    test('captain doubles raw points; vice falls back when captain didn\'t play', () {
      final squad = [
        _player(id: 'c'),
        _player(id: 'v'),
        _player(id: 'x'),
      ];
      final stats = {
        'c': [_stats(playerId: 'c', didNotAppear: true, minutes: 0)],
        'v': [_stats(playerId: 'v', yellowCards: 1)], // +2
        'x': [_stats(playerId: 'x', missedPenalties: 1)], // +8
      };
      final result = engine.scoreSquadGameweek(
        squad: squad,
        captainId: 'c',
        viceCaptainId: 'v',
        statsByPlayer: stats,
        startingIds: {'c', 'v', 'x'},
      );
      // captain 'c' didn't play (5 pts, no double) since fallback to 'v' as captain.
      // c: 5 raw * 1 = 5
      // v (effective captain): 2 raw * 2 = 4
      // x: 8 raw * 1 = 8
      // total = 17
      expect(result.effectiveCaptainId, 'v');
      expect(result.gameweekTotal, 17);
    });

    test('triple captain triples points', () {
      final squad = [_player(id: 'a')];
      final stats = {'a': [_stats(playerId: 'a', ownGoals: 1)]};
      final result = engine.scoreSquadGameweek(
        squad: squad,
        captainId: 'a',
        statsByPlayer: stats,
        startingIds: {'a'},
        tripleCaptain: true,
      );
      expect(result.gameweekTotal, 30);
    });

    test('bench boost adds bench contributions', () {
      final squad = [_player(id: 'a'), _player(id: 'b')];
      final stats = {
        'a': [_stats(playerId: 'a', yellowCards: 1)], // +2
        'b': [_stats(playerId: 'b', redCards: 1)], // +7
      };
      final result = engine.scoreSquadGameweek(
        squad: squad,
        captainId: 'a',
        statsByPlayer: stats,
        startingIds: {'a'}, // 'b' is on the bench
        benchBoost: true,
      );
      // a as captain: 2 * 2 = 4
      // b bench: 7
      // total = 11
      expect(result.gameweekTotal, 11);
    });
  });
}
