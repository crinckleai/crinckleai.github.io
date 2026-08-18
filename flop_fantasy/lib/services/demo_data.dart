import '../models/manager_squad.dart';
import '../models/match_stats.dart';
import '../models/player.dart';

/// In-memory seed data used when Firebase is not yet wired up.
///
/// This lets the UI render populated screens for demo / screenshot / local
/// testing without needing a real Firestore. Keep the data deterministic so
/// the live tracker order is reproducible.
class DemoData {
  DemoData._();

  static final List<Player> players = [
    // Goalkeepers (high card- / error- prone)
    _p('gk-flop1', 'Lars Müller', 'Wartburg FC', 'GER', PlayerPosition.goalkeeper, 5.5,
        injury: 0.10, cards: 0.05, og: 0.02),
    _p('gk-flop2', 'Toby Greene', 'Old Trent', 'ENG', PlayerPosition.goalkeeper, 5.0,
        injury: 0.12, cards: 0.04, og: 0.01),
    _p('gk-flop3', 'Pep Onyango', 'Lagos Stars', 'NGA', PlayerPosition.goalkeeper, 4.5,
        injury: 0.08, cards: 0.03, og: 0.00),

    // Defenders (red-card magnets, own-goal proneness)
    _p('df-flop1', 'Marco Rossi', 'Genoa Reserves', 'ITA', PlayerPosition.defender, 6.5,
        injury: 0.10, cards: 0.40, og: 0.06),
    _p('df-flop2', 'Kojo Mensah', 'Accra Heart', 'GHA', PlayerPosition.defender, 5.5,
        injury: 0.20, cards: 0.30, og: 0.05),
    _p('df-flop3', 'Bruno Lima', 'Santos B', 'BRA', PlayerPosition.defender, 6.0,
        injury: 0.15, cards: 0.35, og: 0.04),
    _p('df-flop4', 'Henrik Sørensen', 'FC Aalborg', 'DEN', PlayerPosition.defender, 5.5,
        injury: 0.18, cards: 0.25, og: 0.08),
    _p('df-flop5', 'Yusuf Demir', 'Ankara United', 'TUR', PlayerPosition.defender, 5.0,
        injury: 0.22, cards: 0.45, og: 0.03),

    // Midfielders (yellow cards, missed chances)
    _p('mf-flop1', 'Jean-Luc Mbappé', 'Lille', 'FRA', PlayerPosition.midfielder, 7.5,
        injury: 0.18, cards: 0.50, og: 0.02),
    _p('mf-flop2', 'Hiro Tanaka', 'Tokyo Verde', 'JPN', PlayerPosition.midfielder, 6.5,
        injury: 0.15, cards: 0.20, og: 0.01),
    _p('mf-flop3', 'Ali Hassan', 'Cairo East', 'EGY', PlayerPosition.midfielder, 6.0,
        injury: 0.12, cards: 0.30, og: 0.02),
    _p('mf-flop4', 'Petar Novak', 'Zagreb XI', 'CRO', PlayerPosition.midfielder, 5.5,
        injury: 0.20, cards: 0.40, og: 0.03),
    _p('mf-flop5', 'Diego Vargas', 'Lima FC', 'PER', PlayerPosition.midfielder, 5.0,
        injury: 0.16, cards: 0.35, og: 0.04),

    // Forwards (missed pens, big chances flopped)
    _p('fw-flop1', 'Olav Bjørn', 'Tromsø', 'NOR', PlayerPosition.forward, 9.5,
        injury: 0.25, cards: 0.20, og: 0.01),
    _p('fw-flop2', 'Salim Bouzid', 'Algiers Reserves', 'ALG', PlayerPosition.forward, 8.0,
        injury: 0.22, cards: 0.25, og: 0.02),
    _p('fw-flop3', 'Ronan O\'Sullivan', 'Cork Wanderers', 'IRL', PlayerPosition.forward, 7.5,
        injury: 0.30, cards: 0.30, og: 0.02),

    // Extra market options
    _p('mf-flop6', 'Carlos Mendes', 'Porto Reserves', 'POR', PlayerPosition.midfielder, 6.0,
        injury: 0.14, cards: 0.28, og: 0.02),
    _p('fw-flop4', 'Andrei Volkov', 'CSKA-2', 'RUS', PlayerPosition.forward, 8.5,
        injury: 0.20, cards: 0.18, og: 0.01),
    _p('df-flop6', 'Eduardo Fernández', 'Sevilla B', 'ESP', PlayerPosition.defender, 5.5,
        injury: 0.16, cards: 0.32, og: 0.07),
  ];

  static const String demoManagerId = 'demo-manager';

  static ManagerSquad demoSquad() {
    return ManagerSquad(
      managerId: demoManagerId,
      gameweek: 1,
      budgetRemaining: 2.5,
      freeTransfers: 1,
      slots: const [
        // Starters: 1-4-4-2
        SquadSlot(playerId: 'gk-flop1', position: PlayerPosition.goalkeeper, isStarter: true),
        SquadSlot(playerId: 'df-flop1', position: PlayerPosition.defender, isStarter: true),
        SquadSlot(playerId: 'df-flop2', position: PlayerPosition.defender, isStarter: true),
        SquadSlot(playerId: 'df-flop3', position: PlayerPosition.defender, isStarter: true),
        SquadSlot(playerId: 'df-flop4', position: PlayerPosition.defender, isStarter: true),
        SquadSlot(playerId: 'mf-flop1', position: PlayerPosition.midfielder, isStarter: true, isCaptain: true),
        SquadSlot(playerId: 'mf-flop2', position: PlayerPosition.midfielder, isStarter: true),
        SquadSlot(playerId: 'mf-flop3', position: PlayerPosition.midfielder, isStarter: true),
        SquadSlot(playerId: 'mf-flop4', position: PlayerPosition.midfielder, isStarter: true, isViceCaptain: true),
        SquadSlot(playerId: 'fw-flop1', position: PlayerPosition.forward, isStarter: true),
        SquadSlot(playerId: 'fw-flop2', position: PlayerPosition.forward, isStarter: true),
        // Bench
        SquadSlot(playerId: 'gk-flop2', position: PlayerPosition.goalkeeper, isStarter: false, benchOrder: 0),
        SquadSlot(playerId: 'df-flop5', position: PlayerPosition.defender, isStarter: false, benchOrder: 1),
        SquadSlot(playerId: 'mf-flop5', position: PlayerPosition.midfielder, isStarter: false, benchOrder: 2),
        SquadSlot(playerId: 'fw-flop3', position: PlayerPosition.forward, isStarter: false, benchOrder: 3),
      ],
    );
  }

  /// A canned live disaster feed — chronologically ordered, most recent first.
  static List<DisasterFeedItem> demoFeed() {
    final base = DateTime.now();
    DisasterFeedItem mk(int min, String pid, String name, DisasterEvent e, int pts, int agoMin) =>
        DisasterFeedItem(
          matchId: 'gw1-m1',
          playerId: pid,
          playerName: name,
          event: e,
          points: pts,
          minute: min,
          timestamp: base.subtract(Duration(minutes: agoMin)),
        );
    return [
      mk(87, 'df-flop1', 'Marco Rossi', DisasterEvent.ownGoal, 10, 1),
      mk(83, 'mf-flop1', 'Jean-Luc Mbappé', DisasterEvent.missedPenalty, 8, 5),
      mk(72, 'fw-flop1', 'Olav Bjørn', DisasterEvent.bigChanceMissed, 2, 16),
      mk(64, 'df-flop2', 'Kojo Mensah', DisasterEvent.redCard, 7, 24),
      mk(58, 'mf-flop4', 'Petar Novak', DisasterEvent.subbedOffEarly, 3, 30),
      mk(41, 'df-flop3', 'Bruno Lima', DisasterEvent.yellowCard, 2, 47),
      mk(33, 'gk-flop1', 'Lars Müller', DisasterEvent.errorLeadingToGoal, 4, 55),
      mk(28, 'mf-flop2', 'Hiro Tanaka', DisasterEvent.hitWoodwork, 1, 60),
      mk(16, 'mf-flop1', 'Jean-Luc Mbappé', DisasterEvent.yellowCard, 2, 72),
      mk(9, 'df-flop4', 'Henrik Sørensen', DisasterEvent.giveawayPenalty, 6, 79),
    ];
  }

  /// Live point totals to overlay on the pitch chips.
  static Map<String, int> demoPointsById() => const {
        'gk-flop1': 4,
        'df-flop1': 10,
        'df-flop2': 7,
        'df-flop3': 2,
        'df-flop4': 6,
        'mf-flop1': 10, // captain — would be doubled to 20 in totals
        'mf-flop2': 1,
        'mf-flop3': 0,
        'mf-flop4': 3,
        'fw-flop1': 2,
        'fw-flop2': 0,
      };

  static Player _p(
    String id,
    String name,
    String club,
    String country,
    PlayerPosition pos,
    double price, {
    double injury = 0.0,
    double cards = 0.0,
    double og = 0.0,
  }) {
    return Player(
      id: id,
      name: name,
      club: club,
      country: country,
      position: pos,
      price: price,
      injuryRisk: injury,
      cardProneness: cards,
      ownGoalIndex: og,
      totalOwnership: 0.10,
    );
  }
}
