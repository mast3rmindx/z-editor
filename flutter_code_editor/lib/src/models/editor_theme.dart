import 'package:flutter/material.dart';

/// Theme configuration for the code editor
class EditorTheme {
  /// Background color of the editor
  final Color backgroundColor;

  /// Text color for the editor content
  final Color textColor;

  /// Color for the current line highlight
  final Color currentLineColor;

  /// Color for line numbers
  final Color lineNumberColor;

  /// Color for the selection highlight
  final Color selectionColor;

  /// Color for matching brackets
  final Color bracketMatchColor;

  /// Color for the gutter background
  final Color gutterBackgroundColor;

  /// Theme colors for syntax highlighting
  final Map<String, TextStyle> syntaxTheme;

  const EditorTheme({
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.textColor = const Color(0xFFD4D4D4),
    this.currentLineColor = const Color(0xFF282828),
    this.lineNumberColor = const Color(0xFF858585),
    this.selectionColor = const Color(0xFF264F78),
    this.bracketMatchColor = const Color(0xFF327D7D),
    this.gutterBackgroundColor = const Color(0xFF1E1E1E),
    this.syntaxTheme = const {
      'keyword': TextStyle(color: Color(0xFF569CD6)),
      'string': TextStyle(color: Color(0xFFCE9178)),
      'number': TextStyle(color: Color(0xFFB5CEA8)),
      'comment': TextStyle(color: Color(0xFF6A9955)),
      'class': TextStyle(color: Color(0xFF4EC9B0)),
      'function': TextStyle(color: Color(0xFFDCDCAA)),
    },
  });

  /// Creates a copy of this theme with the given fields replaced with new values
  EditorTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? currentLineColor,
    Color? lineNumberColor,
    Color? selectionColor,
    Color? bracketMatchColor,
    Color? gutterBackgroundColor,
    Map<String, TextStyle>? syntaxTheme,
  }) {
    return EditorTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      currentLineColor: currentLineColor ?? this.currentLineColor,
      lineNumberColor: lineNumberColor ?? this.lineNumberColor,
      selectionColor: selectionColor ?? this.selectionColor,
      bracketMatchColor: bracketMatchColor ?? this.bracketMatchColor,
      gutterBackgroundColor: gutterBackgroundColor ?? this.gutterBackgroundColor,
      syntaxTheme: syntaxTheme ?? this.syntaxTheme,
    );
  }
} 