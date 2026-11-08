import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/sound_service.dart';
import '../../../widgets/tomato/cozy_scene.dart';
import '../../user/application/user_providers.dart';
import '../../user/application/user_state.dart';
import '../application/shop_providers.dart';
import '../data/datasources/default_shop_items.dart';
import '../domain/entities/shop_category.dart';
import '../domain/entities/shop_item.dart';

const _wardrobeInk = Color(0xff58242e);
const _outline = Color(0xff828971);
const _muted = Color(0xff6b6658);
const _surface = Color(0xfffcf6ec);

TextStyle _serif(double size) => TextStyle(
  fontFamily: 'serif',
  fontWeight: FontWeight.w700,
  fontSize: size,
  color: _wardrobeInk,
  height: 1.15,
);

extension on ShopCategory {
  String get label => switch (this) {
    ShopCategory.backgrounds => 'Temalar',
    ShopCategory.accessories => 'Aksesuarlar',
    ShopCategory.sounds => 'Sesler',
  };

  String get singular => switch (this) {
    ShopCategory.backgrounds => 'tema',
    ShopCategory.accessories => 'aksesuar',
    ShopCategory.sounds => 'ses',
  };

  String get collectionLabel => switch (this) {
    ShopCategory.backgrounds => 'Temalarım',
    ShopCategory.accessories => 'Aksesuarlarım',
    ShopCategory.sounds => 'Seslerim',
  };

  String get discoverLabel => switch (this) {
    ShopCategory.backgrounds => 'Mağazada temaları keşfet',
    ShopCategory.accessories => 'Mağazada aksesuarları keşfet',
    ShopCategory.sounds => 'Mağazada sesleri keşfet',
  };
}

class WardrobeScreen extends ConsumerStatefulWidget {
  const WardrobeScreen({super.key});

  @override
  ConsumerState<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends ConsumerState<WardrobeScreen>
    with SingleTickerProviderStateMixin {
  static const _categories = [
    ShopCategory.backgrounds,
    ShopCategory.accessories,
    ShopCategory.sounds,
  ];
  static const _sunny = DefaultShopItems.sunnyGreenhouse;

  late final _tabs = TabController(length: 2, vsync: this);
  final _scroll = ScrollController();
  ShopCategory _category = ShopCategory.backgrounds;
  ShopItem? _preview;
  bool _inStore = false;
  bool _busy = false;

  @override
  void dispose() {
    _tabs.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _showTab(int index) {
    _tabs.animateTo(index);
    if (_inStore == (index == 1)) return;
    setState(() {
      _inStore = index == 1;
      _preview = null;
    });
    _scroll.jumpTo(0);
  }

  void _selectCategory(ShopCategory category) {
    if (category == _category) return;
    setState(() {
      _category = category;
      _preview = null;
    });
    _scroll.jumpTo(0);
  }

  void _previewItem(ShopItem item) {
    setState(() => _preview = item);
    unawaited(
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ),
    );
  }

  Future<void> _purchase(ShopItem item) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final purchased = await ref
          .read(userNotifierProvider.notifier)
          .purchaseItem(item.id, item.price);
      if (!mounted) return;
      _message(
        purchased
            ? '${item.name} koleksiyonuna eklendi.'
            : 'Satın alma tamamlanamadı.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _equip(ShopCategory category, String? id) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final notifier = ref.read(userNotifierProvider.notifier);
      await switch (category) {
        ShopCategory.backgrounds => notifier.equipBackground(
          id == _sunny.id ? null : id,
        ),
        ShopCategory.accessories => notifier.equipAccessory(id),
        ShopCategory.sounds => notifier.equipSound(id),
      };
      if (mounted && ref.read(userErrorProvider) != null) {
        _message('Seçim kaydedilemedi.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _listen(ShopItem item) {
    final source = SoundService.sourceFor(item.id);
    if (source == null) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _SoundSample(name: item.name, source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider);
    final shop = ref.watch(shopNotifierProvider);
    final equippedTheme = DefaultShopItems.backgroundFor(
      user.equippedBackground,
    );
    final preview = _preview;
    final scene = preview?.isBackground == true ? preview! : equippedTheme;
    final accessory = preview?.isAccessory == true
        ? preview!.id
        : user.equippedAccessory;
    final equippedId = switch (_category) {
      ShopCategory.backgrounds => equippedTheme.id,
      ShopCategory.accessories => user.equippedAccessory,
      ShopCategory.sounds => user.equippedSound,
    };
    final categoryItems = shop.allItems
        .where((item) => item.category == _category)
        .toList();
    final items = _inStore
        ? categoryItems
        : [
            if (_category == ShopCategory.backgrounds) _sunny,
            ...categoryItems.where((item) => user.isItemPurchased(item.id)),
          ];
    final activeIndex = items.indexWhere((item) => item.id == equippedId);
    final equipped = activeIndex < 0 ? null : items[activeIndex];
    if (!_inStore && activeIndex > 0) {
      items.insert(0, items.removeAt(activeIndex));
    }
    final disabled = _busy || user.isLoading;

    return Scaffold(
      backgroundColor: parchment,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(user.tomatoBalance),
                Expanded(
                  child: ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
                    children: [
                      AspectRatio(
                        aspectRatio: 2.5,
                        child: CozyScene(
                          pose: GardenPose.ready,
                          accessory: accessory,
                          backgroundAsset: scene == _sunny
                              ? 'assets/images/windowsill.webp'
                              : scene.assetPath!,
                          backgroundAlignment: scene == _sunny
                              ? const Alignment(0, .55)
                              : const Alignment(0, -.06),
                        ),
                      ),
                      if (!_inStore && equipped != null) ...[
                        const SizedBox(height: 10),
                        _EquippedRow(
                          item: equipped,
                          onRemove:
                              _category == ShopCategory.backgrounds || disabled
                              ? null
                              : () => _equip(_category, null),
                        ),
                      ],
                      if (_inStore && preview != null) ...[
                        const SizedBox(height: 10),
                        _previewActions(preview, user, disabled),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          for (final category in _categories)
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: category == _categories.last ? 0 : 8,
                                ),
                                child: _categoryButton(category),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _inStore
                                  ? _category == ShopCategory.backgrounds
                                        ? 'Arka plan temaları'
                                        : _category.label
                                  : _category.collectionLabel,
                              style: _serif(23),
                            ),
                          ),
                          if (!_inStore && !shop.isLoading && !user.isLoading)
                            Text(
                              '${items.length} ${_category.singular}',
                              style: const TextStyle(color: _muted),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (shop.isLoading || user.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (shop.errorMessage != null)
                        TextButton(
                          onPressed: () =>
                              ref.read(shopNotifierProvider.notifier).refresh(),
                          child: const Text('Öğeler yüklenemedi. Tekrar dene'),
                        )
                      else if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Bu kategoride henüz bir öğen yok.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _muted),
                          ),
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const gap = 12.0;
                            final minimumWidth = MediaQuery.textScalerOf(
                              context,
                            ).scale(145);
                            final columns =
                                constraints.maxWidth >= minimumWidth * 2 + gap
                                ? 2
                                : 1;
                            final width =
                                (constraints.maxWidth - gap * (columns - 1)) /
                                columns;
                            return Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              children: [
                                for (final item in items)
                                  SizedBox(
                                    width: width,
                                    child: _WardrobeCard(
                                      item: item,
                                      owned: user.isItemPurchased(item.id),
                                      active: item.id == equippedId,
                                      selected: item.id == preview?.id,
                                      inStore: _inStore,
                                      onPreview: () => _previewItem(item),
                                      onApply: disabled || item.id == equippedId
                                          ? null
                                          : () =>
                                                _equip(item.category, item.id),
                                      onListen: () => _listen(item),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      if (!_inStore) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(foregroundColor: sage),
                            onPressed: () => _showTab(1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    _category.discoverLabel,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(int balance) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Text('Gardırop', style: _serif(36))),
            _TomatoBadge(
              amount: balance,
              label: 'Domates bakiyesi',
              borderColor: const Color(0xffc7a5a8),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TabBar(
          controller: _tabs,
          onTap: _showTab,
          labelColor: berry,
          unselectedLabelColor: _muted,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          indicatorColor: berry,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: _outline,
          tabs: const [
            Tab(text: 'Koleksiyon'),
            Tab(text: 'Mağaza'),
          ],
        ),
      ],
    ),
  );

  Widget _categoryButton(ShopCategory category) {
    final selected = _category == category;
    return Semantics(
      selected: selected,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          foregroundColor: selected ? Colors.white : sage,
          backgroundColor: selected ? sage : Colors.transparent,
          side: BorderSide(color: selected ? sage : _outline),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        onPressed: () => _selectCategory(category),
        child: Text(category.label, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _previewActions(ShopItem item, UserState user, bool disabled) {
    final owned = user.isItemPurchased(item.id);
    final active = user.isItemEquipped(item.id);
    final missing = item.price - user.tomatoBalance;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: _serif(19)),
          Text(
            !owned && missing > 0 ? '$missing domates eksik' : 'Önizleme',
            style: const TextStyle(color: _muted),
          ),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (item.isSound)
                TextButton.icon(
                  onPressed: () => _listen(item),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Dinle'),
                ),
              if (active)
                const _ActiveBadge()
              else if (owned)
                FilledButton(
                  onPressed: disabled
                      ? null
                      : () => _equip(item.category, item.id),
                  child: const Text('Uygula'),
                )
              else
                FilledButton(
                  onPressed: disabled || missing > 0
                      ? null
                      : () => _purchase(item),
                  child: Text('Satın al · 🍅 ${item.price}'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EquippedRow extends StatelessWidget {
  const _EquippedRow({required this.item, this.onRemove});

  final ShopItem item;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: _surface,
      border: Border.all(color: const Color(0xffd5d4c2)),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: [
        const Icon(Icons.check_circle, size: 22, color: sage),
        const SizedBox(width: 8),
        Expanded(child: Text(item.name, style: _serif(16))),
        const _ActiveBadge(showIcon: false),
        if (onRemove != null)
          IconButton(
            tooltip: item.isSound ? 'Sustur' : 'Çıkar',
            onPressed: onRemove,
            icon: Icon(item.isSound ? Icons.volume_off_outlined : Icons.close),
          ),
      ],
    ),
  );
}

class _WardrobeCard extends StatelessWidget {
  const _WardrobeCard({
    required this.item,
    required this.owned,
    required this.active,
    required this.selected,
    required this.inStore,
    required this.onPreview,
    required this.onApply,
    required this.onListen,
  });

  final ShopItem item;
  final bool owned, active, selected, inStore;
  final VoidCallback onPreview, onListen;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final outlined = selected || (!inStore && active);
    return Material(
      color: _surface,
      elevation: outlined ? 0 : 1,
      shadowColor: const Color(0x554c4034),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(
          color: outlined ? sage : const Color(0xffe8dfd2),
          width: outlined ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: inStore ? onPreview : null,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: item.isBackground ? 1.6 : 2,
              child: _art(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 9),
              child: Column(
                children: [
                  Text(
                    item.name,
                    style: _serif(16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  if (inStore)
                    owned
                        ? const _ActiveBadge(label: 'Sahip olundu')
                        : _TomatoBadge(amount: item.price, label: 'Fiyat')
                  else ...[
                    if (active)
                      const SizedBox(
                        height: 48,
                        child: Center(child: _ActiveBadge()),
                      )
                    else
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(92, 42),
                          foregroundColor: sage,
                          side: const BorderSide(color: _outline),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: onApply,
                        child: const Text('Uygula'),
                      ),
                    if (item.isSound)
                      TextButton.icon(
                        onPressed: onListen,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Dinle'),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _art() {
    if (item.isBackground) {
      final sunny = item == DefaultShopItems.sunnyGreenhouse;
      return Image.asset(
        sunny ? 'assets/images/windowsill.webp' : item.assetPath!,
        fit: BoxFit.cover,
        alignment: Alignment(0, switch (item.id) {
          'bg_sunny' => .35,
          'bg_night' => -.8,
          'bg_ocean' => -.42,
          _ => -.28,
        }),
        excludeFromSemantics: true,
      );
    }
    if (item.isAccessory) {
      return CozyScene(pose: GardenPose.ready, accessory: item.id);
    }
    return const ColoredBox(
      color: Color(0xffe6e9d9),
      child: Icon(Icons.graphic_eq_rounded, color: sage, size: 35),
    );
  }
}

class _TomatoBadge extends StatelessWidget {
  const _TomatoBadge({
    required this.amount,
    required this.label,
    this.borderColor = _outline,
  });

  final int amount;
  final String label;
  final Color borderColor;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label, $amount domates',
    excludeSemantics: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍅', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 5),
          Text(
            '$amount',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: _wardrobeInk,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({this.label = 'Kullanımda', this.showIcon = true});

  final String label;
  final bool showIcon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: sage,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          const Icon(Icons.check, size: 14, color: Colors.white),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _SoundSample extends StatefulWidget {
  const _SoundSample({required this.name, required this.source});

  final String name;
  final Source source;

  @override
  State<_SoundSample> createState() => _SoundSampleState();
}

class _SoundSampleState extends State<_SoundSample> {
  final _player = AudioPlayer();
  late final StreamSubscription<void> _completion;
  Timer? _stop;
  String _status = 'Ses yükleniyor…';

  @override
  void initState() {
    super.initState();
    _completion = _player.onPlayerComplete.listen((_) => _finish());
    unawaited(_play());
  }

  Future<void> _play() async {
    try {
      await _player.play(
        widget.source,
        volume: .45,
        ctx: AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      if (!mounted) return;
      setState(() => _status = 'Ses önizlemesi çalıyor');
      _stop = Timer(const Duration(seconds: 8), () {
        unawaited(_player.stop());
        _finish();
      });
    } catch (_) {
      if (mounted) setState(() => _status = 'Ses önizlemesi yüklenemedi');
    }
  }

  void _finish() {
    _stop?.cancel();
    if (mounted) setState(() => _status = 'Ses önizlemesi bitti');
  }

  @override
  void dispose() {
    _stop?.cancel();
    unawaited(_completion.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.name, style: _serif(24)),
          const SizedBox(height: 8),
          Semantics(liveRegion: true, child: Text(_status)),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    ),
  );
}
