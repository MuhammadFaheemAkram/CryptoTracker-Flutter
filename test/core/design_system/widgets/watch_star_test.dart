import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('says what a tap will do, for which coin; the shape changes '
      'too', (tester) async {
    var taps = 0;
    await tester.pumpThemed(
      WatchStar(coinName: 'Bitcoin', isWatched: false, onPressed: () => taps++),
    );
    expect(find.byTooltip('Add Bitcoin to watchlist'), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);

    await tester.tap(find.byType(WatchStar));
    expect(taps, 1);

    await tester.pumpThemed(
      WatchStar(coinName: 'Bitcoin', isWatched: true, onPressed: () {}),
    );
    expect(find.byTooltip('Remove Bitcoin from watchlist'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('a tap target of at least 48 × 48', (tester) async {
    await tester.pumpThemed(
      WatchStar(coinName: 'Bitcoin', isWatched: false, onPressed: () {}),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  });
}
