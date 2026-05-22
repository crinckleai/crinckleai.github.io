import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/manager_squad.dart';
import '../models/match_stats.dart';
import '../models/player.dart';

/// Thin Firestore wrapper. All read/write happens here so UI/logic stay clean.
///
/// Collections:
///   /players/{playerId}
///   /matches/{matchId}/stats/{playerId}
///   /managers/{managerId}/squads/{gameweek}
///   /gameweeks/{gw}/feed/{eventId}
class FirestoreService {
  FirestoreService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // ------- Players -------
  Stream<List<Player>> watchPlayers() {
    return _db.collection('players').snapshots().map((snap) =>
        snap.docs.map((d) => Player.fromMap({...d.data(), 'id': d.id})).toList());
  }

  Future<void> upsertPlayer(Player player) async {
    await _db.collection('players').doc(player.id).set(player.toMap(), SetOptions(merge: true));
  }

  Future<void> bulkUpdatePlayers(List<Player> players) async {
    final batch = _db.batch();
    for (final p in players) {
      batch.set(_db.collection('players').doc(p.id), p.toMap(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  // ------- Match stats -------
  Stream<List<MatchStats>> watchMatchStats(String matchId) {
    return _db
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .snapshots()
        .map((snap) => snap.docs.map((d) => MatchStats.fromMap(d.data())).toList());
  }

  Future<void> writeMatchStats(MatchStats stats) async {
    await _db
        .collection('matches')
        .doc(stats.matchId)
        .collection('stats')
        .doc(stats.playerId)
        .set(stats.toMap());
  }

  // ------- Squads -------
  Future<ManagerSquad?> getSquad(String managerId, int gameweek) async {
    final doc = await _db
        .collection('managers')
        .doc(managerId)
        .collection('squads')
        .doc('$gameweek')
        .get();
    if (!doc.exists) return null;
    return ManagerSquad.fromMap(doc.data()!);
  }

  Stream<ManagerSquad?> watchSquad(String managerId, int gameweek) {
    return _db
        .collection('managers')
        .doc(managerId)
        .collection('squads')
        .doc('$gameweek')
        .snapshots()
        .map((d) => d.exists ? ManagerSquad.fromMap(d.data()!) : null);
  }

  Future<void> saveSquad(ManagerSquad squad) async {
    await _db
        .collection('managers')
        .doc(squad.managerId)
        .collection('squads')
        .doc('${squad.gameweek}')
        .set(squad.toMap());
  }

  // ------- Disaster feed -------
  Stream<List<DisasterFeedItem>> watchDisasterFeed(int gameweek) {
    return _db
        .collection('gameweeks')
        .doc('$gameweek')
        .collection('feed')
        .orderBy('timestamp', descending: true)
        .limit(200)
        .snapshots()
        .map((snap) => snap.docs.map(_disasterFromDoc).toList());
  }

  DisasterFeedItem _disasterFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data();
    return DisasterFeedItem(
      matchId: m['matchId'] as String,
      playerId: m['playerId'] as String,
      playerName: m['playerName'] as String? ?? 'Unknown',
      event: DisasterEvent.values.firstWhere(
        (e) => e.name == (m['event'] as String? ?? ''),
        orElse: () => DisasterEvent.didNotPlay,
      ),
      points: (m['points'] as num?)?.toInt() ?? 0,
      minute: (m['minute'] as num?)?.toInt() ?? 0,
      timestamp: (m['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
