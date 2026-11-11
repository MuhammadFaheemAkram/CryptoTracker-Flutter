import 'dart:async';

import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/core/navigation/fallback_close_button.dart';
import 'package:crypto_tracker/domain/validation/decimal_input.dart';
import 'package:crypto_tracker/features/holding_form/coin_picker.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_cubit.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Renders [HoldingFormState], and keeps unsaved changes from being lost:
/// leaving with changes asks first.
class HoldingFormView extends StatefulWidget {
  const HoldingFormView({
    super.key,
    required this.isEditing,
    required this.onCloseWithoutBack,
  });

  /// The title, before the form has loaded.
  final bool isEditing;

  /// Close when there's nothing to go back to (a link opened the form).
  final VoidCallback onCloseWithoutBack;

  @override
  State<HoldingFormView> createState() => _HoldingFormViewState();
}

class _HoldingFormViewState extends State<HoldingFormView> {
  StreamSubscription<String>? _failures;

  @override
  void initState() {
    super.initState();
    // `read` is allowed here; the messenger is looked up when a failure
    // comes (an inherited lookup isn't allowed in initState).
    _failures = context.read<HoldingFormCubit>().failures.listen((message) {
      if (mounted) showAppSnackBar(ScaffoldMessenger.of(context), message);
    });
  }

  @override
  void dispose() {
    unawaited(_failures?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HoldingFormCubit>();
    final state = context.watch<HoldingFormCubit>().state;
    final form = switch (state) {
      HoldingFormEditing(:final form) => form,
      _ => null,
    };
    final dirty = form?.isDirty ?? false;
    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmDiscard(context) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            (form?.isEditing ?? widget.isEditing)
                ? 'Edit holding'
                : 'Add holding',
          ),
          leading: fallbackCloseButton(context, () async {
            if (!dirty || await confirmDiscard(context)) {
              widget.onCloseWithoutBack();
            }
          }),
          actions: [
            if (form != null)
              TextButton(
                onPressed: form.isSaving ? null : cubit.save,
                child: const Text('Save'),
              ),
          ],
        ),
        body: switch (state) {
          HoldingFormLoading() || HoldingFormSaved() => const LoadingView(),
          HoldingFormError(:final message) => ErrorView(
            message: message,
            onRetry: cubit.load,
          ),
          HoldingFormNotFound() => const EmptyStateView(
            icon: Icons.search_off,
            title: 'Holding not found',
            message: 'It may have been removed.',
          ),
          HoldingFormEditing(:final form) => _Form(form: form),
        },
      ),
    );
  }
}

/// Asks before throwing changes away; whether to discard them.
Future<bool> confirmDiscard(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('What you entered won’t be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    ) ??
    false;

/// What a field's problem says.
String? inputErrorText(DecimalInputError? error, {required String what}) =>
    switch (error) {
      null => null,
      DecimalInputError.empty => 'Enter $what',
      DecimalInputError.notANumber => 'Use digits and one decimal point',
      DecimalInputError.notPositive => 'Must be more than 0',
      DecimalInputError.tooManyDecimals =>
        'At most $maxDecimals decimal places',
      DecimalInputError.tooLarge => 'That’s too large',
    };

class _Form extends StatefulWidget {
  const _Form({required this.form});

  final HoldingForm form;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  // Owned here, so the text and the cursor survive every new state (each
  // keystroke and each tick is one).
  late final _amount = TextEditingController(text: widget.form.amountText);
  late final _price = TextEditingController(text: widget.form.priceText);

  @override
  void didUpdateWidget(_Form old) {
    super.didUpdateWidget(old);
    // The Cubit can fill the price itself (a coin's price, suggested); a
    // keystroke comes back equal to the field, and changes nothing here.
    if (widget.form.priceText != _price.text) {
      _price.text = widget.form.priceText;
    }
    if (widget.form.amountText != _amount.text) {
      _amount.text = widget.form.amountText;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HoldingFormCubit>();
    final form = widget.form;
    final money = MoneyFormatter(form.currency, rate: form.rate);
    final symbol = form.coin?.symbol.toUpperCase();
    final current = form.currentPriceUsd;
    // Digits (an Arabic or Persian keyboard's too, as ASCII), and points or
    // commas; the rules themselves are checked by parseDecimalInput, with a
    // message.
    final numbersOnly = [
      TextInputFormatter.withFunction(
        (_, value) => value.copyWith(text: normalizeDigits(value.text)),
      ),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
    ];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      children: [
        _CoinField(form: form),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          controller: _amount,
          onChanged: cubit.amountChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: numbersOnly,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Amount',
            suffixText: symbol,
            errorText: inputErrorText(form.amountError, what: 'an amount'),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          controller: _price,
          onChanged: cubit.priceChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: numbersOnly,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => cubit.save(),
          decoration: InputDecoration(
            labelText: 'Buy price per coin',
            suffixText: form.currency.code,
            helperText: current == null ? null : 'Now ${money.price(current)}',
            errorText: inputErrorText(form.priceError, what: 'a price'),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        _Preview(form: form, money: money),
      ],
    );
  }
}

/// The coin: a button that opens the picker, or, for a holding being
/// edited, the coin it holds (fixed).
class _CoinField extends StatelessWidget {
  const _CoinField({required this.form});

  final HoldingForm form;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coin = form.coin;
    final editable = !form.isEditing;
    final decorator = InputDecorator(
      isEmpty: coin == null,
      decoration: InputDecoration(
        labelText: 'Coin',
        helperText: editable ? null : 'A holding’s coin can’t change',
        errorText: form.coinMissing ? 'Choose a coin' : null,
        border: const OutlineInputBorder(),
        suffixIcon: editable ? const Icon(Icons.expand_more) : null,
      ),
      // Empty, it still holds a line: as tall as the text fields below.
      child: coin == null
          ? Text('', style: theme.textTheme.bodyLarge)
          : Row(
              children: [
                CoinBadge(symbol: coin.symbol, size: 24),
                const SizedBox(width: AppSpacing.xSmall),
                Flexible(
                  child: Text(
                    '${coin.name} · ${coin.symbol.toUpperCase()}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
    );
    if (!editable) return decorator;
    return Semantics(
      button: true,
      label: coin == null ? 'Coin, none chosen' : 'Coin, ${coin.name}',
      hint: 'Choose a coin',
      excludeSemantics: !form.coinMissing,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.small),
        onTap: () async {
          final cubit = context.read<HoldingFormCubit>();
          final id = await showCoinPicker(
            context,
            coins: form.coins,
            selectedId: coin?.id,
          );
          if (id != null) cubit.coinChosen(id);
        },
        child: decorator,
      ),
    );
  }
}

/// What the holding would be worth now, what it cost, and the difference,
/// as the user types (and as the price ticks).
class _Preview extends StatelessWidget {
  const _Preview({required this.form, required this.money});

  final HoldingForm form;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context) {
    final worth = form.worthNowUsd;
    final cost = form.costUsd;
    if (worth == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    Widget figure(String label, String value) => MergeSemantics(
      child: Wrap(
        spacing: AppSpacing.xSmall,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            figure('Worth now', money.price(worth)),
            if (cost != null) ...[
              const SizedBox(height: AppSpacing.xxSmall),
              figure('Cost', money.price(cost)),
              const SizedBox(height: AppSpacing.xxSmall),
              ValueChange(
                label: 'P/L',
                semanticLabel: 'Profit and loss',
                money: money.signedPrice(worth - cost),
                moneyInWords: money.describeSignedPrice(worth - cost),
                percent: cost == 0 ? 0 : (worth - cost) / cost * 100,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
