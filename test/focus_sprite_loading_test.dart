import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomadoro/widgets/tomato/tomato_clip.dart';

class _CountingBundle extends CachingAssetBundle {
  final reads = <String, int>{};

  @override
  Future<ByteData> load(String key) {
    reads.update(key, (count) => count + 1, ifAbsent: () => 1);
    return rootBundle.load(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Nine clips decode a bounded set of shared sprite pages once', () async {
    final bundle = _CountingBundle();
    final clips = await FocusClips.load(bundle);
    try {
      final pngReads = bundle.reads.entries
          .where((e) => e.key.endsWith('.png'))
          .toList();
      expect(pngReads, isNotEmpty);
      expect(
        pngReads.length,
        lessThanOrEqualTo(8),
        reason:
            'Full transparent canvases must not allocate one GPU texture per exported frame.',
      );
      expect(pngReads.every((e) => e.value == 1), isTrue);
    } finally {
      clips.dispose();
    }
  });
}
