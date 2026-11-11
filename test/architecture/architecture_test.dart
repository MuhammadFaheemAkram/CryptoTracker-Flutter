import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Rules the analyzer can't express, checked over the source tree. Each
// phase adds the rules for the layers it brings (drift's imports in
// Phase 4, for one).
void main() {
  final sources = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !file.path.endsWith('.g.dart'))
      .where((file) => !file.path.endsWith('.config.dart'))
      .toList();

  Iterable<File> under(String folder) =>
      sources.where((file) => file.path.startsWith('lib/$folder/'));

  List<String> filesContaining(Pattern pattern, {Iterable<File>? among}) => [
    for (final file in among ?? sources)
      if (file.readAsStringSync().contains(pattern)) file.path,
  ];

  test('finds the sources', () {
    expect(sources, isNotEmpty);
  });

  test('Material comes from material_ui, never the in-SDK library', () {
    expect(filesContaining("'package:flutter/material.dart'"), isEmpty);
  });

  test('the domain is plain Dart: no Flutter, no state management, no '
      'infrastructure', () {
    final domain = under('domain');
    expect(domain, isNotEmpty);
    for (final forbidden in [
      "'package:flutter/",
      "'package:material_ui/",
      "'package:flutter_bloc/",
      "'package:get_it/",
      "'package:json_annotation/",
      'crypto_tracker/data/',
      'crypto_tracker/di/',
      'crypto_tracker/features/',
    ]) {
      expect(
        filesContaining(forbidden, among: domain),
        isEmpty,
        reason: forbidden,
      );
    }
    // From core, only the shared vocabulary (`Result`, `AppException`).
    // `injectable` annotations are plain Dart, and allowed on use cases.
    final core = RegExp(r'crypto_tracker/core/(?!common/)');
    expect(filesContaining(core, among: domain), isEmpty);
  });

  test('the formatters are plain Dart too (tested without widgets)', () {
    final formatting = under('core/formatting');
    expect(formatting, isNotEmpty);
    for (final forbidden in ["'package:flutter/", "'package:material_ui/"]) {
      expect(filesContaining(forbidden, among: formatting), isEmpty);
    }
  });

  test('the design system knows no screens and no routes', () {
    final designSystem = under('core/design_system');
    expect(designSystem, isNotEmpty);
    for (final forbidden in [
      'crypto_tracker/features/',
      'crypto_tracker/core/navigation/',
      'crypto_tracker/data/',
      'crypto_tracker/di/',
    ]) {
      expect(
        filesContaining(forbidden, among: designSystem),
        isEmpty,
        reason: forbidden,
      );
    }
  });

  test('screens never reach the data layer', () {
    final features = under('features');
    expect(features, isNotEmpty);
    for (final forbidden in [
      'crypto_tracker/data/',
      'crypto_tracker/core/network/',
      'crypto_tracker/core/database/',
      'crypto_tracker/core/storage/',
    ]) {
      expect(
        filesContaining(forbidden, among: features),
        isEmpty,
        reason: forbidden,
      );
    }
  });

  test('only the data layer and the DI root know the network: DTOs never '
      'reach the domain or the screens', () {
    final outside = sources.where(
      (file) =>
          !file.path.startsWith('lib/core/network/') &&
          !file.path.startsWith('lib/data/') &&
          !file.path.startsWith('lib/di/'),
    );
    expect(
      filesContaining('crypto_tracker/core/network/', among: outside),
      isEmpty,
    );
  });

  test('state management stays in the screens (and the app)', () {
    bool allowed(File file) =>
        file.path.startsWith('lib/features/') ||
        file.path.startsWith('lib/app/');
    final elsewhere = sources.where((file) => !allowed(file));
    expect(
      filesContaining("'package:flutter_bloc/", among: elsewhere),
      isEmpty,
    );
  });

  test('the service locator is touched only by main, the app, the DI root '
      'and Page widgets (conventions §2)', () {
    bool allowed(File file) =>
        file.path == 'lib/main.dart' ||
        file.path.startsWith('lib/app/') ||
        file.path.startsWith('lib/di/') ||
        file.path.endsWith('_page.dart');
    final elsewhere = sources.where((file) => !allowed(file));
    expect(filesContaining(RegExp(r'\bgetIt\b'), among: elsewhere), isEmpty);
  });

  test('one ticker: only PriceTicker runs a periodic timer (every price '
      'comes from it)', () {
    expect(filesContaining('Timer.periodic'), [
      'lib/core/prices/price_ticker.dart',
    ]);
  });

  test('prices move in core/prices only: no screen or repository makes up '
      'its own (the walk is used by the ticker alone)', () {
    expect(
      filesContaining('RandomWalk'),
      unorderedEquals([
        'lib/core/prices/random_walk.dart',
        'lib/core/prices/price_ticker.dart',
      ]),
    );
  });

  test('no print(): the app has nothing to log to a console', () {
    expect(filesContaining(RegExp(r'(^|[^.\w])print\(')), isEmpty);
  });
}
