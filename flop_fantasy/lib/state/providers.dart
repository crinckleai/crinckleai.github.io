import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/price_manager.dart';
import '../logic/sub_manager.dart';
import '../models/manager_squad.dart';
import '../models/match_stats.dart';
import '../models/player.dart';
import '../services/demo_data.dart';
import '../services/firestore_service.dart';
import '../services/scoring_engine.dart';

// === Service singletons ===
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final scoringEngineProvider = Provider<ScoringEngine>((_) => const ScoringEngine());
final subManagerProvider = Provider<SubManager>((_) => const SubManager());
final priceManagerProvider = Provider<PriceManager>((_) => const PriceManager());

// === Demo mode: when true (e.g. Firebase not initialised), data comes from
// the in-memory DemoData seed. Toggled by main.dart at startup.
final demoModeProvider = StateProvider<bool>((_) => false);

// === Current manager session ===
final currentManagerIdProvider = StateProvider<String?>((ref) {
  return ref.watch(demoModeProvider) ? DemoData.demoManagerId : null;
});
final currentGameweekProvider = StateProvider<int>((_) => 1);

// === Player catalogue stream ===
final playersStreamProvider = StreamProvider<List<Player>>((ref) {
  if (ref.watch(demoModeProvider)) {
    return Stream<List<Player>>.value(DemoData.players);
  }
  return ref.watch(firestoreServiceProvider).watchPlayers();
});

// === Manager's squad for current GW ===
final squadStreamProvider = StreamProvider<ManagerSquad?>((ref) {
  if (ref.watch(demoModeProvider)) {
    return Stream<ManagerSquad?>.value(DemoData.demoSquad());
  }
  final managerId = ref.watch(currentManagerIdProvider);
  final gw = ref.watch(currentGameweekProvider);
  if (managerId == null) return Stream<ManagerSquad?>.empty();
  return ref.watch(firestoreServiceProvider).watchSquad(managerId, gw);
});

// === Disaster feed (live) ===
final disasterFeedProvider = StreamProvider<List<DisasterFeedItem>>((ref) {
  if (ref.watch(demoModeProvider)) {
    return Stream<List<DisasterFeedItem>>.value(DemoData.demoFeed());
  }
  final gw = ref.watch(currentGameweekProvider);
  return ref.watch(firestoreServiceProvider).watchDisasterFeed(gw);
});

// === Live points overlay (only populated in demo mode for now) ===
final livePointsProvider = Provider<Map<String, int>>((ref) {
  return ref.watch(demoModeProvider) ? DemoData.demoPointsById() : const {};
});

// === Transfer market filters ===
class MarketFilter {
  const MarketFilter({this.position, this.maxPrice, this.search = ''});
  final PlayerPosition? position;
  final double? maxPrice;
  final String search;

  MarketFilter copyWith({PlayerPosition? position, double? maxPrice, String? search}) =>
      MarketFilter(
        position: position ?? this.position,
        maxPrice: maxPrice ?? this.maxPrice,
        search: search ?? this.search,
      );
}

final marketFilterProvider =
    StateProvider<MarketFilter>((_) => const MarketFilter());

final filteredMarketProvider = Provider<List<Player>>((ref) {
  final players = ref.watch(playersStreamProvider).maybeWhen(
        data: (p) => p,
        orElse: () => const <Player>[],
      );
  final f = ref.watch(marketFilterProvider);
  return players.where((p) {
    if (f.position != null && p.position != f.position) return false;
    if (f.maxPrice != null && p.price > f.maxPrice!) return false;
    if (f.search.isNotEmpty &&
        !p.name.toLowerCase().contains(f.search.toLowerCase()) &&
        !p.club.toLowerCase().contains(f.search.toLowerCase())) {
      return false;
    }
    return true;
  }).toList()
    ..sort((a, b) => b.price.compareTo(a.price));
});
