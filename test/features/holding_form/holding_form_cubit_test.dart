import 'dart:async';

import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_coin_price_use_case.dart';
import 'package:crypto_tracker/domain/usecase/portfolio_use_cases.dart';
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart';
import 'package:crypto_tracker/domain/validation/decimal_input.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_cubit.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_portfolio_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fixtures.dart';

void main() {
  late FakeMarketRepository market;
  late FakeSettingsRepository settings;
  late FakePortfolioRepository portfolio;
  late HoldingFormCubit cubit;

  final existing = Holding(
    id: 7,
    coinId: 'ethereum',
    amount: 2,
    buyPriceUsd: 3000,
    createdAt: testNow,
  );

  HoldingFormCubit newCubit({String? coinId, int? holdingId}) =>
      HoldingFormCubit(
        coinId,
        holdingId,
        LoadMarketUseCase(market),
        FindHoldingUseCase(portfolio),
        AddHoldingUseCase(portfolio),
        UpdateHoldingUseCase(portfolio),
        ObserveCoinPriceUseCase(market),
        CurrentSettingsUseCase(settings),
      );

  Future<void> start({
    String? coinId,
    int? holdingId,
    Currency currency = Currency.usd,
    Result<MarketSeed>? result,
  }) async {
    market = FakeMarketRepository(result: result);
    await market.loadMarket(); // the ticker has the seed's prices
    settings = FakeSettingsRepository(AppSettings(currency: currency));
    portfolio = FakePortfolioRepository([existing]);
    cubit = newCubit(coinId: coinId, holdingId: holdingId);
    await cubit.load();
    await pumpEventQueue();
  }

  tearDown(() async {
    await cubit.close();
    await (market.dispose(), settings.dispose(), portfolio.dispose()).wait;
  });

  HoldingForm form() => switch (cubit.state) {
    HoldingFormEditing(:final form) => form,
    final state => fail('not editing: $state'),
  };

  void tick(String coinId, double price) => market.emitQuotes({
    ...market.currentQuotes,
    coinId: market.currentQuotes[coinId]!.copyWith(
      priceUsd: price,
      updatedAt: market.currentQuotes[coinId]!.updatedAt.add(
        const Duration(seconds: 1),
      ),
    ),
  });

  group('a new holding', () {
    test('starts empty, with nothing to lose', () async {
      await start();

      expect(form().coin, isNull);
      expect(form().isEditing, isFalse);
      expect(form().priceText, '');
      expect(form().isDirty, isFalse);
      expect(form().coins, hasLength(4));
    });

    test('from a coin\'s page: that coin, its price now suggested (not a '
        'change)', () async {
      await start(coinId: 'bitcoin');

      expect(form().coin?.id, 'bitcoin');
      expect(form().priceText, '67240.5');
      expect(form().currentPriceUsd, 67240.5);
      expect(form().isDirty, isFalse);
    });

    test('the suggestion is as precise as a shown price, not the walk\'s '
        'full precision', () async {
      await start(coinId: 'bitcoin');
      tick('solana', 150.123456789); // Solana's price now, at full precision

      cubit.coinChosen('solana');
      await pumpEventQueue();

      expect(form().priceText, '150.12');
    });

    test('the suggestion is in the chosen currency', () async {
      await start(coinId: 'bitcoin', currency: Currency.eur);

      expect(form().priceText, '61861.26');
    });

    test('the suggestion is filled once: ticks don\'t change the field, '
        '"worth now" follows them', () async {
      await start(coinId: 'bitcoin');
      cubit.amountChanged('2');

      tick('bitcoin', 70000);
      await pumpEventQueue();

      expect(form().priceText, '67240.5');
      expect(form().worthNowUsd, 140000);
    });

    test(
      'another coin replaces a suggested price, keeps a typed one',
      () async {
        await start(coinId: 'bitcoin');

        cubit.coinChosen('solana');
        await pumpEventQueue();
        expect(form().coin?.id, 'solana');
        expect(form().priceText, '148.92');

        cubit
          ..priceChanged('150')
          ..coinChosen('ethereum');
        await pumpEventQueue();
        expect(form().priceText, '150');
        expect(form().isDirty, isTrue);
      },
    );

    test('choosing another coin stops following the old one\'s price '
        '(switchMap)', () async {
      await start(coinId: 'bitcoin');
      cubit.coinChosen('solana');
      await pumpEventQueue();

      tick('bitcoin', 1);
      await pumpEventQueue();
      expect(form().currentPriceUsd, 148.92);

      tick('solana', 200);
      await pumpEventQueue();
      expect(form().currentPriceUsd, 200);
    });

    test('Save with problems shows every one, the empty fields too', () async {
      await start();
      cubit.amountChanged('0.000000001');
      expect(form().amountError, DecimalInputError.tooManyDecimals);
      expect(form().priceError, isNull); // empty isn't an error yet

      await cubit.save();

      expect(form().coinMissing, isTrue);
      expect(form().priceError, DecimalInputError.empty);
      expect(portfolio.holdings, [existing]);
    });

    test(
      'Save: typed in euros, stored in dollars (Correctness Rule 2)',
      () async {
        await start(coinId: 'bitcoin', currency: Currency.eur);
        cubit
          ..amountChanged('0.5')
          ..priceChanged('46000');

        await cubit.save();

        expect(
          cubit.state,
          const HoldingFormState.saved('Added 0.5 BTC to your portfolio'),
        );
        final added = portfolio.holdings.last;
        expect(added.coinId, 'bitcoin');
        expect(added.amount, 0.5);
        expect(added.buyPriceUsd, closeTo(50000, 1e-9));
      },
    );

    test('a save that fails stays on the form and says why', () async {
      await start(coinId: 'bitcoin');
      portfolio.failWrites = true;
      cubit.amountChanged('1');
      final failures = <String>[];
      cubit.failures.listen(failures.add);

      await cubit.save();
      await pumpEventQueue();

      expect(form().isSaving, isFalse);
      expect(failures, ["Couldn't save that change. Please try again."]);
    });
  });

  group('an existing holding', () {
    test('opens with its amount, and its price in the chosen currency; '
        'nothing to lose yet', () async {
      await start(holdingId: 7, currency: Currency.eur);

      expect(form().isEditing, isTrue);
      expect(form().coin?.id, 'ethereum');
      expect(form().amountText, '2');
      expect(form().priceText, '2760'); // $3,000 × 0.92
      expect(form().isDirty, isFalse);
    });

    test('its coin is fixed', () async {
      await start(holdingId: 7);

      cubit.coinChosen('bitcoin');

      expect(form().coin?.id, 'ethereum');
    });

    test('Save updates it, in dollars', () async {
      await start(holdingId: 7, currency: Currency.eur);
      cubit.amountChanged('3');
      expect(form().isDirty, isTrue);

      await cubit.save();

      expect(cubit.state, const HoldingFormState.saved('Updated your 3 ETH'));
      expect(portfolio.holdings.single.amount, 3);
      expect(portfolio.holdings.single.buyPriceUsd, closeTo(3000, 1e-9));
    });

    test('an id that doesn\'t exist: not found', () async {
      await start(holdingId: 99);

      expect(cubit.state, const HoldingFormState.notFound());
    });

    test('removed elsewhere while being edited: not found on save', () async {
      await start(holdingId: 7);
      await portfolio.remove(7);
      cubit.amountChanged('3');

      await cubit.save();

      expect(cubit.state, const HoldingFormState.notFound());
    });
  });

  test('the market fails: the error; "Try again" fills the form', () async {
    await start(result: const Err(NetworkException()));
    expect(cubit.state, isA<HoldingFormError>());

    market.result = Ok(smallMarket());
    await cubit.load();
    await pumpEventQueue();

    expect(form().coins, hasLength(4));
  });

  test('closed while loading: the seed landing during close\'s own awaits '
      'fills nothing', () async {
    market = FakeMarketRepository()..gate = Completer<void>();
    settings = FakeSettingsRepository();
    portfolio = FakePortfolioRepository();
    cubit = newCubit(coinId: 'bitcoin');
    final loading = cubit.load();
    await pumpEventQueue();

    final closing = cubit.close();
    market.gate!.complete(); // the seed arrives while close() awaits
    await closing;

    await expectLater(loading, completes);
    expect(cubit.state, const HoldingFormState.loading());
  });

  test('closed while loading: a failure landing during close\'s awaits '
      'emits nothing either', () async {
    market = FakeMarketRepository(result: const Err(NetworkException()))
      ..gate = Completer<void>();
    settings = FakeSettingsRepository();
    portfolio = FakePortfolioRepository();
    cubit = newCubit(coinId: 'bitcoin');
    final loading = cubit.load();
    await pumpEventQueue();

    final closing = cubit.close();
    market.gate!.complete();
    await closing;

    await expectLater(loading, completes);
    expect(cubit.state, const HoldingFormState.loading());
  });
}
