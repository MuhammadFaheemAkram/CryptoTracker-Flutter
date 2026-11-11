import 'dart:async';

import 'package:crypto_tracker/core/prices/ticker_scheduler.dart';
import 'package:material_ui/material_ui.dart';

/// Keeps the market ticking while the app is on screen: it attaches the
/// [TickerScheduler] for the app's lifetime and tells it when the app goes
/// to the background and comes back.
///
/// A widget, because the app's lifecycle reaches Flutter through
/// [AppLifecycleListener]; the decisions themselves (which interval, paused
/// or not) live in the scheduler, where they're tested without widgets.
class LiveTicker extends StatefulWidget {
  const LiveTicker({super.key, required this.scheduler, required this.child});

  final TickerScheduler scheduler;
  final Widget child;

  @override
  State<LiveTicker> createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    widget.scheduler.attach();
    // `onHide`/`onShow`: the app left the screen (another app, the home
    // screen, the device locked) or came back. A brief `inactive` (the
    // control centre pulled down) keeps prices moving.
    _lifecycle = AppLifecycleListener(
      onHide: () => widget.scheduler.setForeground(foreground: false),
      onShow: () => widget.scheduler.setForeground(foreground: true),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(widget.scheduler.detach());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
