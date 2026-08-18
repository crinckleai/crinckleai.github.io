import 'package:flop_fantasy/logic/price_manager.dart';
import 'package:flop_fantasy/models/player.dart';
import 'package:flutter_test/flutter_test.dart';

Player _p({
  String id = 'p',
  double price = 5.0,
  int inn = 0,
  int out = 0,
}) {
  return Player(
    id: id,
    name: id,
    club: 'C',
    country: 'X',
    position: PlayerPosition.midfielder,
    price: price,
    netTransfersIn: inn,
    netTransfersOut: out,
  );
}

void main() {
  const pm = PriceManager();

  test('no transfers => no price change', () {
    final updated = pm.applyRound([_p()], totalManagers: 1000);
    expect(updated.single.price, 5.0);
  });

  test('big positive net transfers raises price, capped at +0.3', () {
    final updated = pm.applyRound([_p(inn: 1000, out: 0)], totalManagers: 1000);
    expect(updated.single.price, 5.3);
  });

  test('big negative net transfers lowers price, capped at -0.3', () {
    final updated = pm.applyRound([_p(out: 1000, inn: 0)], totalManagers: 1000);
    expect(updated.single.price, 4.7);
  });

  test('mid-volume net transfers nudges by 0.1', () {
    // ~10% positive swing → 0.1
    final updated = pm.applyRound([_p(inn: 100, out: 0)], totalManagers: 1000);
    expect(updated.single.price, 5.1);
  });

  test('counters reset to zero after a round', () {
    final updated = pm.applyRound(
      [_p(inn: 500, out: 100)],
      totalManagers: 1000,
    );
    expect(updated.single.netTransfersIn, 0);
    expect(updated.single.netTransfersOut, 0);
  });

  test('respects min and max price clamps', () {
    final atFloor = pm.applyRound(
      [_p(price: 3.6, out: 1000, inn: 0)],
      totalManagers: 1000,
    );
    expect(atFloor.single.price, 3.5);

    final atCeiling = pm.applyRound(
      [_p(price: 14.3, inn: 1000, out: 0)],
      totalManagers: 1000,
    );
    expect(atCeiling.single.price, 14.5);
  });
}
