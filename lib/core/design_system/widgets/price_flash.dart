import 'package:crypto_tracker/core/design_system/theme/app_colors.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:material_ui/material_ui.dart';

/// A background that flashes: a tint of the up or down color for a moment
/// after a tick ([tick] changes), fading back to nothing over [duration].
/// A coin's row and the header of its page both flash.
///
/// `Ink`, not a `ColoredBox`: the ripple of a tap paints on the same
/// `Material`, so it stays visible over the tint. Off when the platform
/// asks for reduced motion: then nothing flashes, and the arrow and the
/// changing number still say what happened.
class PriceFlash extends StatefulWidget {
  const PriceFlash({
    super.key,
    required this.direction,
    required this.tick,
    required this.child,
  });

  final PriceDirection direction;
  final Object? tick;
  final Widget child;

  static const duration = Duration(milliseconds: 600);

  @override
  State<PriceFlash> createState() => _PriceFlashState();
}

class _PriceFlashState extends State<PriceFlash>
    with SingleTickerProviderStateMixin {
  late final _fade = AnimationController(
    vsync: this,
    duration: PriceFlash.duration,
    value: 1, // faded out: the first build doesn't flash
  );

  @override
  void didUpdateWidget(PriceFlash old) {
    super.didUpdateWidget(old);
    if (widget.tick != old.tick &&
        widget.direction != PriceDirection.flat &&
        !MediaQuery.disableAnimationsOf(context)) {
      _fade.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tint = switch (widget.direction) {
      PriceDirection.up => colors.upFlash,
      PriceDirection.down => colors.downFlash,
      PriceDirection.flat => null,
    };
    return AnimatedBuilder(
      animation: _fade,
      builder: (context, child) => Ink(
        color: tint == null || _fade.isCompleted
            ? null
            : Color.lerp(tint, tint.withValues(alpha: 0), _fade.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// The price, cross-fading to each new value (instantly with reduced
/// motion), both values aligned on [alignment] while they overlap.
class AnimatedPrice extends StatelessWidget {
  const AnimatedPrice(
    this.price, {
    super.key,
    required this.style,
    this.alignment = AlignmentDirectional.centerEnd,
  });

  final String price;
  final TextStyle? style;
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 250),
      layoutBuilder: (current, previous) =>
          Stack(alignment: alignment, children: [...previous, ?current]),
      child: Text(
        price,
        key: ValueKey(price),
        style: (style ?? const TextStyle()).copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
