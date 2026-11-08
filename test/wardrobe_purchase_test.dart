import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:tomadoro/features/shop/data/datasources/default_shop_items.dart';
import 'package:tomadoro/features/user/data/datasources/user_local_datasource.dart';

void main() {
  test(
    'Theme purchase debits once and preserves ownership after reopening',
    () async {
      final directory = await Directory.systemTemp.createTemp('tomadoro_shop_');
      Hive.init(directory.path);
      final autumn = DefaultShopItems.backgroundFor('bg_sunset');
      final winter = DefaultShopItems.backgroundFor('bg_ocean');

      try {
        final box = await Hive.openBox('user');
        final user = UserLocalDataSource(box);
        await user.setTomatoBalance(autumn.price + 1);

        final results = await Future.wait([
          user.purchaseItem(autumn.id, autumn.price),
          user.purchaseItem(autumn.id, autumn.price),
        ]);
        expect(results, [1, null]);
        expect(await user.purchaseItem(winter.id, winter.price), isNull);
        expect(user.getTotalTomatoesEarned(), 0);
        await user.setEquippedBackground(autumn.id);
        await box.close();

        final reopened = UserLocalDataSource(await Hive.openBox('user'));
        expect(reopened.getTomatoBalance(), 1);
        expect(reopened.getPurchasedItemIds(), [autumn.id]);
        expect(reopened.getEquippedBackground(), autumn.id);
      } finally {
        await Hive.close();
        await directory.delete(recursive: true);
      }
    },
  );
}
