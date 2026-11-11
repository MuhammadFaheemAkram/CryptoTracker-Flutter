import 'package:material_ui/material_ui.dart';

/// Shows [message] at the bottom of the screen, replacing whatever message
/// was there: two quick actions never queue two bars.
///
/// A bar with an [action] (Undo) stays twice as long (8 s): long enough
/// to read it and reach the button, a time found too short at 4 s on the
/// simulator. It still goes away by itself: Material would keep it until
/// dismissed, but an Undo covering the tab bar until someone notices it
/// would be worse. A screen reader user gets more time anyway: with
/// accessible navigation on, Flutter keeps it.
/// How long a plain message stays (Material's default).
const messageDuration = Duration(seconds: 4);

/// How long a message with an action (Undo) stays.
const actionDuration = Duration(seconds: 8);

void showAppSnackBar(
  ScaffoldMessengerState messenger,
  String message, {
  SnackBarAction? action,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        persist: false,
        duration: action == null ? messageDuration : actionDuration,
      ),
    );
}
