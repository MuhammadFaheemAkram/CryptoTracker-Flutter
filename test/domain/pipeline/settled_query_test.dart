import 'dart:async';

import 'package:crypto_tracker/domain/pipeline/settled_query.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const wait = Duration(milliseconds: 300);

  group('in fake time', () {
    test('a query goes through after the wait, not before', () {
      fakeAsync((async) {
        final typed = StreamController<String>();
        final settled = <String>[];
        typed.stream.settled(wait).listen(settled.add);

        typed.add('sol');
        async.elapse(const Duration(milliseconds: 299));
        expect(settled, isEmpty);

        async.elapse(const Duration(milliseconds: 1));
        expect(settled, ['sol']);
        unawaited(typed.close());
      });
    });

    test('an empty query goes through at once, and spaces are trimmed', () {
      fakeAsync((async) {
        final typed = StreamController<String>();
        final settled = <String>[];
        typed.stream.settled(wait).listen(settled.add);

        typed.add('   ');
        async.flushMicrotasks();

        expect(settled, ['']);
        unawaited(typed.close());
      });
    });

    test('the same query again (after trimming) is dropped', () {
      fakeAsync((async) {
        final typed = StreamController<String>();
        final settled = <String>[];
        typed.stream.settled(wait).listen(settled.add);

        typed.add('sol');
        async.elapse(wait);
        typed.add(' sol ');
        async.elapse(wait);

        expect(settled, ['sol']);
        unawaited(typed.close());
      });
    });
  });

  // Replacing a pending query makes switchMap wait for the old timer's
  // cancel future, which completes in the root zone: real time
  // (conventions §11.122).
  group('in real time', () {
    const short = Duration(milliseconds: 40);

    test('fast typing settles once, on the last query', () async {
      final typed = StreamController<String>();
      final settled = <String>[];
      typed.stream.settled(short).listen(settled.add);

      for (final query in ['s', 'so', 'sol']) {
        typed.add(query);
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      await Future<void>.delayed(short * 3);

      expect(settled, ['sol']);
      await typed.close();
    });

    test('clearing the field cancels a query still waiting', () async {
      final typed = StreamController<String>();
      final settled = <String>[];
      typed.stream.settled(short).listen(settled.add);

      typed.add('sol');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      typed.add('');
      await Future<void>.delayed(short * 3);

      expect(settled, ['']);
      await typed.close();
    });
  });
}
