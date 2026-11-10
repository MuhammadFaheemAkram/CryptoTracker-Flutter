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
      "'package:injectable/",
      'crypto_tracker/core/',
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

  test('no print(): the app has nothing to log to a console', () {
    expect(filesContaining(RegExp(r'(^|[^.\w])print\(')), isEmpty);
  });
}
