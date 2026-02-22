/// Tab displaying a grid of shop items for a specific category.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/shop_providers.dart';
import '../../domain/entities/shop_category.dart';
import 'shop_item_card.dart';

class ShopCategoryTab extends ConsumerWidget {
  final ShopCategory category;
  final IconData emptyIcon;
  final String emptyMessage;

  const ShopCategoryTab({
    super.key,
    required this.category,
    required this.emptyIcon,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch shop items
    final shopState = ref.watch(shopNotifierProvider);

    // Filter items for this category
    final items = shopState.allItems
        .where((item) => item.category == category)
        .toList();

    if (shopState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (shopState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              shopState.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () {
                ref.read(shopNotifierProvider.notifier).refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ShopItemCard(item: items[index]);
      },
    );
  }
}
