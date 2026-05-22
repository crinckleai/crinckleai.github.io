import 'package:flop_fantasy/logic/sub_manager.dart';
import 'package:flop_fantasy/models/manager_squad.dart';
import 'package:flop_fantasy/models/match_stats.dart';
import 'package:flop_fantasy/models/player.dart';
import 'package:flop_fantasy/services/scoring_engine.dart';
import 'package:flutter_test/flutter_test.dart';

Player _p(String id, PlayerPosition pos) => Player(
      id: id,
      name: id,
      club: 'C',
      country: 'X',
      position: pos,
      price: 5,
    );

ManagerSquad _squad() {
  // 1 GK + 4 DEF + 4 MID + 2 FWD = 11 starters; bench: 1 GK + 3 outfield
  final slots = <SquadSlot>[
    const SquadSlot(playerId: 'gk1', position: PlayerPosition.goalkeeper, isStarter: true, isCaptain: false),
    const SquadSlot(playerId: 'd1', position: PlayerPosition.defender, isStarter: true),
    const SquadSlot(playerId: 'd2', position: PlayerPosition.defender, isStarter: true),
    const SquadSlot(playerId: 'd3', position: PlayerPosition.defender, isStarter: true),
    const SquadSlot(playerId: 'd4', position: PlayerPosition.defender, isStarter: true),
    const SquadSlot(playerId: 'm1', position: PlayerPosition.midfielder, isStarter: true),
    const SquadSlot(playerId: 'm2', position: PlayerPosition.midfielder, isStarter: true),
    const SquadSlot(playerId: 'm3', position: PlayerPosition.midfielder, isStarter: true),
    const SquadSlot(playerId: 'm4', position: PlayerPosition.midfielder, isStarter: true, isCaptain: true),
    const SquadSlot(playerId: 'f1', position: PlayerPosition.forward, isStarter: true),
    const SquadSlot(playerId: 'f2', position: PlayerPosition.forward, isStarter: true),
    // bench
    const SquadSlot(playerId: 'gk2', position: PlayerPosition.goalkeeper, isStarter: false, benchOrder: 0),
    const SquadSlot(playerId: 'bd1', position: PlayerPosition.defender, isStarter: false, benchOrder: 1),
    const SquadSlot(playerId: 'bm1', position: PlayerPosition.midfielder, isStarter: false, benchOrder: 2),
    const SquadSlot(playerId: 'bf1', position: PlayerPosition.forward, isStarter: false, benchOrder: 3),
  ];
  return ManagerSquad(managerId: 'mgr', gameweek: 1, slots: slots);
}

Map<String, Player> _byId() => {
      'gk1': _p('gk1', PlayerPosition.goalkeeper),
      'd1': _p('d1', PlayerPosition.defender),
      'd2': _p('d2', PlayerPosition.defender),
      'd3': _p('d3', PlayerPosition.defender),
      'd4': _p('d4', PlayerPosition.defender),
      'm1': _p('m1', PlayerPosition.midfielder),
      'm2': _p('m2', PlayerPosition.midfielder),
      'm3': _p('m3', PlayerPosition.midfielder),
      'm4': _p('m4', PlayerPosition.midfielder),
      'f1': _p('f1', PlayerPosition.forward),
      'f2': _p('f2', PlayerPosition.forward),
      'gk2': _p('gk2', PlayerPosition.goalkeeper),
      'bd1': _p('bd1', PlayerPosition.defender),
      'bm1': _p('bm1', PlayerPosition.midfielder),
      'bf1': _p('bf1', PlayerPosition.forward),
    };

/// Build a fake GameweekScore where named players' appearance / points
/// are explicit.
GameweekScore _scores(Map<String, (int, bool)> data) {
  final gw = GameweekScore();
  for (final entry in data.entries) {
    final (raw, appeared) = entry.value;
    gw.perPlayer[entry.key] = PlayerGameweek(
      playerId: entry.key,
      rawPoints: raw,
      events: const [],
      appeared: appeared,
    );
  }
  return gw;
}

void main() {
  const sub = SubManager();
  final deadline = DateTime(2026, 6, 1, 12);

  group('SubManager — auto-subs', () {
    test('auto-subs follow bench order — first valid replacement is taken', () {
      // m4 (MID) didn't play. Bench order is [gk2 (GK), bd1 (DEF), bm1 (MID), bf1 (FWD)].
      // gk2 can't replace a MID (formation would have 2 GKs). bd1 IS a valid
      // replacement (yields 1-5-3-2), so bench-order rules pick bd1, not bm1.
      final scores = _scores({
        'gk1': (0, true),
        'd1': (0, true), 'd2': (0, true), 'd3': (0, true), 'd4': (0, true),
        'm1': (0, true), 'm2': (0, true), 'm3': (0, true),
        'm4': (5, false),
        'f1': (0, true), 'f2': (0, true),
        'gk2': (0, true),
        'bd1': (0, true), 'bm1': (3, true), 'bf1': (0, true),
      });
      final res = sub.resolve(
        squad: _squad(),
        playersById: _byId(),
        scores: scores,
        deadline: deadline,
        now: deadline.subtract(const Duration(hours: 1)),
      );
      expect(res.finalStarters.contains('m4'), isFalse);
      expect(res.finalStarters.contains('bd1'), isTrue);
      expect(res.finalStarters.contains('bm1'), isFalse);
      expect(res.erasedPoints, 0);
    });

    test('skips bench players who did not appear when picking auto-sub', () {
      // Same scenario, but bd1 didn't play — so the auto-sub falls through
      // to bm1 (next valid bench player who appeared).
      final scores = _scores({
        'gk1': (0, true),
        'd1': (0, true), 'd2': (0, true), 'd3': (0, true), 'd4': (0, true),
        'm1': (0, true), 'm2': (0, true), 'm3': (0, true),
        'm4': (5, false),
        'f1': (0, true), 'f2': (0, true),
        'gk2': (0, true),
        'bd1': (5, false), 'bm1': (3, true), 'bf1': (0, true),
      });
      final res = sub.resolve(
        squad: _squad(),
        playersById: _byId(),
        scores: scores,
        deadline: deadline,
        now: deadline.subtract(const Duration(hours: 1)),
      );
      expect(res.finalStarters.contains('bd1'), isFalse);
      expect(res.finalStarters.contains('bm1'), isTrue);
    });

    test('keeps the flopped starter when no bench player who appeared can sub in', () {
      // Only the goalkeeper bench appeared — but a GK can't replace a midfielder
      // (would break formation). All other bench players also did not appear,
      // so the auto-sub system has nothing to play with and m4 stays in.
      final scores = _scores({
        'gk1': (0, true),
        'd1': (0, true), 'd2': (0, true), 'd3': (0, true), 'd4': (0, true),
        'm1': (0, true), 'm2': (0, true), 'm3': (0, true),
        'm4': (5, false),
        'f1': (0, true), 'f2': (0, true),
        'gk2': (0, true),
        'bd1': (5, false), 'bm1': (5, false), 'bf1': (5, false),
      });
      final res = sub.resolve(
        squad: _squad(),
        playersById: _byId(),
        scores: scores,
        deadline: deadline,
        now: deadline.subtract(const Duration(hours: 1)),
      );
      expect(res.finalStarters.contains('m4'), isTrue);
      expect(res.finalStarters.contains('bm1'), isFalse);
      expect(res.actions, isEmpty);
    });
  });

  group('SubManager — manual subs + penalty', () {
    test('manual sub before deadline applies cleanly, no penalty', () {
      final scores = _scores({
        for (final id in _byId().keys) id: (0, true),
      });
      // Add some flop points to the incoming bench mid so we can check it isn't erased.
      scores.perPlayer['bm1'] = PlayerGameweek(
        playerId: 'bm1',
        rawPoints: 6,
        events: const [],
        appeared: true,
      );
      final res = sub.resolve(
        squad: _squad(),
        playersById: _byId(),
        scores: scores,
        deadline: deadline,
        now: deadline.subtract(const Duration(hours: 1)),
        manualSubs: [
          SubAction(
            starterOutId: 'm4',
            benchInId: 'bm1',
            trigger: SubTrigger.manual,
            appliedAt: deadline.subtract(const Duration(hours: 2)),
          ),
        ],
      );
      expect(res.erasedPoints, 0);
      expect(res.finalStarters.contains('bm1'), isTrue);
      expect(scores.perPlayer['bm1']!.rawPoints, 6);
    });

    test('manual sub past deadline erases bench player\'s points', () {
      final scores = _scores({
        for (final id in _byId().keys) id: (0, true),
      });
      scores.perPlayer['bm1'] = PlayerGameweek(
        playerId: 'bm1',
        rawPoints: 6,
        events: const [],
        appeared: true,
      );
      final res = sub.resolve(
        squad: _squad(),
        playersById: _byId(),
        scores: scores,
        deadline: deadline,
        now: deadline.add(const Duration(hours: 1)),
        manualSubs: [
          SubAction(
            starterOutId: 'm4',
            benchInId: 'bm1',
            trigger: SubTrigger.manual,
            appliedAt: deadline.add(const Duration(minutes: 30)),
          ),
        ],
      );
      expect(res.erasedPoints, 6);
      expect(res.actions.single.penaltyReason, ManualPenaltyReason.pastDeadline);
      expect(scores.perPlayer['bm1']!.rawPoints, 0);
    });

    test('manual sub bringing on someone who did not play is penalised', () {
      final scores = _scores({
        for (final id in _byId().keys) id: (0, true),
      });
      // bm1 didn't play; the other appearing bench players also didn't play
      // so Phase 2 can't add a second auto-sub.
      scores.perPlayer['bm1'] = PlayerGameweek(
        playerId: 'bm1', rawPoints: 5, events: const [], appeared: false,
      );
      scores.perPlayer['bd1'] = PlayerGameweek(
        playerId: 'bd1', rawPoints: 5, events: const [], appeared: false,
      );
      scores.perPlayer['bf1'] = PlayerGameweek(
        playerId: 'bf1', rawPoints: 5, events: const [], appeared: false,
      );
      final res = sub.resolve(
        squad: _squad(),
        playersById: _byId(),
        scores: scores,
        deadline: deadline,
        now: deadline.subtract(const Duration(hours: 1)),
        manualSubs: [
          SubAction(
            starterOutId: 'm4',
            benchInId: 'bm1',
            trigger: SubTrigger.manual,
            appliedAt: deadline.subtract(const Duration(hours: 2)),
          ),
        ],
      );
      final manual = res.actions.firstWhere(
        (a) => a.trigger == SubTrigger.manual,
      );
      expect(manual.penaltyReason, ManualPenaltyReason.benchPlayerDidNotPlay);
      expect(res.erasedPoints, 5);
    });
  });
}
