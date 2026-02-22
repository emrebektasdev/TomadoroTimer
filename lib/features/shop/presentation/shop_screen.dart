/// Main shop screen with categories.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../user/application/user_providers.dart';
import '../domain/entities/shop_category.dart';
import 'widgets/shop_category_tab.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(ref),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ShopCategoryTab(
                    category: ShopCategory.sounds,
                    emptyIcon: Icons.music_note_rounded,
                    emptyMessage: 'Ambient sounds coming soon!',
                  ),
                  ShopCategoryTab(
                    category: ShopCategory.backgrounds,
                    emptyIcon: Icons.image_rounded,
                    emptyMessage: 'Beautiful backgrounds coming soon!',
                  ),
                  ShopCategoryTab(
                    category: ShopCategory.accessories,
                    emptyIcon: Icons.auto_awesome,
                    emptyMessage: 'Fun accessories coming soon!',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Space for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    final tomatoBalance = ref.watch(tomatoBalanceProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Tomato Balance (LEFT)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🍅', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  '$tomatoBalance',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Spacer to push title to center and button to right
          const Expanded(child: SizedBox()),

          // Shop Title (CENTER)
          const Text(
            'Store',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          // Spacer
          const Expanded(child: SizedBox()),

          // Sign In / Settings Button (RIGHT)
          // For now, mirroring legacy "Sign In" button functionality roughly,
          // but maybe just a simple icon or placeholder if auth isn't in scope yet.
          // Legacy had a Google Sign In button.
          // I'll add a placeholder icon button for now to maintain layout balance.
          IconButton(
            onPressed: () {
              // Placeholder for auth dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Multi-device sync coming soon!')),
              );
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.tomatoRed,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('🎧'), SizedBox(width: 4), Text('Sounds')],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('🌄'), SizedBox(width: 4), Text('Themes')],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('🧢'), SizedBox(width: 4), Text('Accessories')],
            ),
          ),
        ],
      ),
    );
  }
}
