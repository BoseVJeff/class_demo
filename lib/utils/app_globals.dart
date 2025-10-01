import 'package:flutter/widgets.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class AppGlobals extends InheritedWidget {
  final Highlighter highlighter;
  final Highlighter darkHighlighter;

  AppGlobals({
    super.key,
    required HighlighterTheme theme,
    required HighlighterTheme lightTheme,
    required HighlighterTheme darkTheme,
    required super.child,
  }) : highlighter = Highlighter(language: "dart", theme: theme),
       darkHighlighter = Highlighter(language: "dart", theme: darkTheme);

  @override
  bool updateShouldNotify(AppGlobals oldWidget) {
    return oldWidget.highlighter != highlighter;
  }

  static AppGlobals? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppGlobals>();

  static AppGlobals of(BuildContext context) {
    AppGlobals? appGlobals = maybeOf(context);
    assert(
      appGlobals != null,
      "No ancestor `AppGlobals` widget found in tree!",
    );
    return appGlobals!;
  }
}
