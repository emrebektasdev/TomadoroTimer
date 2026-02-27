/// Main shop screen with categories.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../auth/application/auth_service.dart';
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
          _buildProfileButton(ref),
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

  Widget _buildProfileButton(WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return PopupMenuButton<int>(
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      tooltip: 'Profile',
      child: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.tomatoRed.withOpacity(0.1),
        backgroundImage: authState?.photoURL != null
            ? NetworkImage(authState!.photoURL!)
            : null,
        child: authState?.photoURL == null
            ? const Icon(Icons.person, size: 20, color: AppColors.tomatoRed)
            : null,
      ),
      itemBuilder: (context) => [
        if (authState == null)
          PopupMenuItem<int>(
            value: 0,
            onTap: () {
              ref.read(authStateProvider.notifier).signInWithGoogle();
            },
            child: const Row(
              children: [
                Icon(Icons.login, color: AppColors.textPrimary),
                SizedBox(width: 12),
                Text(
                  'Sign in with Google',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        else ...[
          PopupMenuItem<int>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  authState.displayName ?? 'Tomadoro User',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  authState.email ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            onTap: () {
              ref.read(authStateProvider.notifier).signOut();
            },
            child: const Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 12),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
