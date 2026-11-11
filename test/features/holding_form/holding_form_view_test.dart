import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_cubit.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_state.dart';
import 'package:crypto_tracker/features/holding_form/holding_form_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockHoldingFormCubit extends MockCubit<HoldingFormState>
    implements HoldingFormCubit {}

void main() {
  late _MockHoldingFormCubit cubit;
  late StreamController<String> failures;
  late int closedWithoutBack;

  final coins = smallMarket().coins;

  setUp(() {
    cubit = _MockHoldingFormCubit();
    failures = StreamController<String>.broadcast();
    closedWithoutBack = 0;
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.save()).thenAnswer((_) async {});
    when(() => cubit.failures).thenAnswer((_) => failures.stream);
  });
  tearDown(() => failures.close());

  HoldingForm form({
    String? coinId,
    int? holdingId,
    String amount = '',
    String price = '',
    double? current,
    bool submitted = false,
    Currency currency = Currency.usd,
    String initialAmount = '',
  }) => HoldingForm(
    coins: coins,
    coin: coins.where((c) => c.id == coinId).firstOrNull,
    holdingId: holdingId,
    amountText: amount,
    priceText: price,
    currency: currency,
    rate: testRates.rateFor(currency),
    currentPriceUsd: current,
    initialCoinId: coinId,
    initialAmountText: initialAmount,
    initialPriceText: price,
    submitted: submitted,
  );

  /// The form pushed above a first screen, as the app shows it.
  Future<void> show(WidgetTester tester, HoldingFormState state) async {
    when(() => cubit.state).thenReturn(state);
    tester.usePhoneSurface();
    await tester.pumpWidget(
      MaterialApp(
        // A new app each time: a pushed route mustn't survive into the next.
        key: UniqueKey(),
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (_) => BlocProvider<HoldingFormCubit>.value(
                      value: cubit,
                      child: HoldingFormView(
                        isEditing: false,
                        onCloseWithoutBack: () => closedWithoutBack++,
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    // A spinner never settles: pump the route's transition instead.
    if (state is HoldingFormLoading) {
      await tester.pump(); // the route starts its transition…
      await tester.pump(const Duration(seconds: 1)); // …and ends it
    } else {
      await tester.pumpAndSettle();
    }
  }

  testWidgets('loading', (tester) async {
    await show(tester, const HoldingFormState.loading());

    expect(find.text('Add holding'), findsOneWidget);
    expect(find.text('Save'), findsNothing);
  });

  testWidgets('not found', (tester) async {
    await show(tester, const HoldingFormState.notFound());

    expect(find.text('Holding not found'), findsOneWidget);
  });

  testWidgets('a new holding: the coin to choose, the fields, Save', (
    tester,
  ) async {
    await show(tester, HoldingFormState.editing(form()));

    expect(find.text('Coin'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Buy price per coin'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    await tester.tap(find.text('Save'));
    verify(() => cubit.save()).called(1);
  });

  testWidgets('typing reaches the Cubit', (tester) async {
    await show(tester, HoldingFormState.editing(form(coinId: 'bitcoin')));

    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '0.5');
    await tester.enterText(
      find.widgetWithText(TextField, 'Buy price per coin'),
      '60000',
    );

    verify(() => cubit.amountChanged('0.5')).called(1);
    verify(() => cubit.priceChanged('60000')).called(1);
  });

  testWidgets('an Arabic keyboard\'s digits arrive as ASCII ones', (
    tester,
  ) async {
    await show(tester, HoldingFormState.editing(form(coinId: 'bitcoin')));

    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '٠٫٥');

    verify(() => cubit.amountChanged('0.5')).called(1);
  });

  testWidgets('the coin picker: search, pick, and the Cubit is told', (
    tester,
  ) async {
    await show(tester, HoldingFormState.editing(form()));

    await tester.tap(find.text('Coin'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a coin'), findsOneWidget);
    expect(find.text('Tether'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'sol');
    await tester.pump();
    expect(find.text('Tether'), findsNothing);

    await tester.tap(find.text('Solana'));
    await tester.pumpAndSettle();
    verify(() => cubit.coinChosen('solana')).called(1);
  });

  testWidgets('an existing holding\'s coin is shown, fixed', (tester) async {
    await show(
      tester,
      HoldingFormState.editing(form(coinId: 'ethereum', holdingId: 7)),
    );

    expect(find.text('Edit holding'), findsOneWidget);
    expect(find.text('Ethereum · ETH'), findsOneWidget);
    expect(find.text('A holding’s coin can’t change'), findsOneWidget);
    await tester.tap(find.text('Ethereum · ETH'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a coin'), findsNothing);
  });

  testWidgets('each problem in words; after Save, the empty fields too', (
    tester,
  ) async {
    await show(
      tester,
      HoldingFormState.editing(form(amount: '0', submitted: true)),
    );

    expect(find.text('Choose a coin'), findsOneWidget);
    expect(find.text('Must be more than 0'), findsOneWidget);
    expect(find.text('Enter a price'), findsOneWidget);
  });

  testWidgets('every error has its words', (tester) async {
    for (final (typed, message) in [
      ('1.2.3', 'Use digits and one decimal point'),
      ('0.000000001', 'At most 8 decimal places'),
      ('1000000000000', 'That’s too large'),
    ]) {
      await show(tester, HoldingFormState.editing(form(amount: typed)));
      expect(find.text(message), findsOneWidget, reason: typed);
    }
  });

  testWidgets('the preview: worth now, cost and P/L, in the currency', (
    tester,
  ) async {
    await show(
      tester,
      HoldingFormState.editing(
        form(
          coinId: 'bitcoin',
          amount: '0.5',
          price: '55200', // €, = $60,000
          current: 67240.5,
          currency: Currency.eur,
        ),
      ),
    );

    expect(find.text('Now €61,861.26'), findsOneWidget);
    expect(find.text('€30,930.63'), findsOneWidget); // worth now
    expect(find.text('€27,600.00'), findsOneWidget); // cost
    expect(find.text('+€3,330.63'), findsOneWidget);
  });

  testWidgets('Close with nothing changed just closes', (tester) async {
    await show(tester, HoldingFormState.editing(form(coinId: 'bitcoin')));

    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('Close with changes asks; "Keep editing" stays, "Discard" '
      'leaves', (tester) async {
    await show(tester, HoldingFormState.editing(form(amount: '2')));

    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsOneWidget);

    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.text('Amount'), findsOneWidget);

    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('opened by a link: Close asks too, then goes elsewhere', (
    tester,
  ) async {
    when(() => cubit.state)
        .thenReturn(HoldingFormState.editing(form(amount: '2')));
    tester.usePhoneSurface();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: BlocProvider<HoldingFormCubit>.value(
          value: cubit,
          child: HoldingFormView(
            isEditing: false,
            onCloseWithoutBack: () => closedWithoutBack++,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(closedWithoutBack, 1);
  });

  testWidgets('a save that fails is said', (tester) async {
    await show(tester, HoldingFormState.editing(form(coinId: 'bitcoin')));

    failures.add("Couldn't save that change. Please try again.");
    await tester.pumpAndSettle();

    expect(
      find.text("Couldn't save that change. Please try again."),
      findsOneWidget,
    );
  });
}
