/// Dialog for confirming item purchase.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/shop_item.dart';
import '../../../user/application/user_providers.dart';

class PurchaseDialog extends ConsumerWidget {
  final ShopItem item;

  const PurchaseDialog({super.key, required this.item});

  static Future<void> show(BuildContext context, ShopItem item) {
    return showDialog(
      context: context,
      builder: (context) => PurchaseDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.read(tomatoBalanceProvider);
    final canAfford = balance >= item.price;
    final userNotifier = ref.read(userNotifierProvider.notifier);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(item.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🍅', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                '${item.price}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (!canAfford) ...[
            const SizedBox(height: 8),
            Text(
              'You need ${item.price - balance} more tomatoes',
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: canAfford
              ? () async {
                  // Perform purchase
                  final success = await userNotifier.purchaseItem(
                    item.id,
                    item.price,
                  );

                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} purchased! 🎉'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Purchase failed. Please try again.',
                          ),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  }
                }
              : null,
          child: const Text('Buy'),
        ),
      ],
    );
  }
}
