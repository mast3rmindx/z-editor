import 'package:flutter/services.dart';

/// Utility class for handling text input operations
class TextInputHandler {
  /// Convert a raw character to its input representation
  static String processRawCharacter(String char, int tabSize) {
    switch (char) {
      case '\t':
        return ' ' * tabSize;
      default:
        return char;
    }
  }

  /// Get the line and column for a given offset in text
  static (int, int) getLineAndColumn(String text, int offset) {
    if (offset <= 0) return (0, 0);
    if (offset >= text.length) {
      final lastNewline = text.lastIndexOf('\n');
      if (lastNewline == -1) return (0, offset);
      return (text.substring(0, lastNewline).split('\n').length,
          offset - lastNewline - 1);
    }

    final beforeCursor = text.substring(0, offset);
    final lines = beforeCursor.split('\n');
    return (lines.length - 1, lines.last.length);
  }

  /// Get the offset for a given line and column
  static int getOffsetForLineAndColumn(String text, int line, int column) {
    final lines = text.split('\n');
    if (line >= lines.length) return text.length;

    var offset = 0;
    for (var i = 0; i < line; i++) {
      offset += lines[i].length + 1; // +1 for newline
    }
    return offset + column.clamp(0, lines[line].length);
  }

  /// Get the indentation level for a new line based on the previous line
  static String getIndentation(String previousLine, int tabSize) {
    final match = RegExp(r'^\s*').firstMatch(previousLine);
    if (match == null) return '';
    return match.group(0) ?? '';
  }

  /// Handle special key combinations
  static bool isSpecialKeyCombination(KeyEvent event) {
    final isControlPressed = event.isControlPressed || event.isMetaPressed;
    if (!isControlPressed) return false;

    return event.logicalKey == LogicalKeyboardKey.keyC || // Copy
           event.logicalKey == LogicalKeyboardKey.keyV || // Paste
           event.logicalKey == LogicalKeyboardKey.keyX || // Cut
           event.logicalKey == LogicalKeyboardKey.keyA || // Select all
           event.logicalKey == LogicalKeyboardKey.keyZ || // Undo
           event.logicalKey == LogicalKeyboardKey.keyY;  // Redo
  }

  /// Get the word boundaries at a given offset
  static (int, int) getWordBoundaries(String text, int offset) {
    if (text.isEmpty || offset < 0 || offset >= text.length) {
      return (0, 0);
    }

    var start = offset;
    var end = offset;

    // Move start to the beginning of the word
    while (start > 0 && _isWordChar(text[start - 1])) {
      start--;
    }

    // Move end to the end of the word
    while (end < text.length && _isWordChar(text[end])) {
      end++;
    }

    return (start, end);
  }

  /// Check if a character is part of a word
  static bool _isWordChar(String char) {
    return RegExp(r'[a-zA-Z0-9_]').hasMatch(char);
  }

  /// Get the current line text at a given offset
  static String getCurrentLine(String text, int offset) {
    if (text.isEmpty) return '';

    final lines = text.split('\n');
    final (line, _) = getLineAndColumn(text, offset);
    return lines[line];
  }
} 