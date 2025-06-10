import 'package:flutter/material.dart';

/// Utility class for handling code folding operations
class CodeFoldingHandler {
  /// Find foldable regions in the text
  static List<FoldRegion> findFoldableRegions(String text) {
    final regions = <FoldRegion>[];
    final lines = text.split('\n');
    final bracketStack = <_BracketInfo>[];
    var lineNumber = 0;

    for (final line in lines) {
      final trimmedLine = line.trim();
      
      // Check for block comments
      if (trimmedLine.startsWith('/*')) {
        var endLine = _findBlockCommentEnd(lines, lineNumber);
        if (endLine != -1) {
          regions.add(FoldRegion(
            startLine: lineNumber,
            endLine: endLine,
            type: FoldType.comment,
          ));
        }
      }

      // Check for curly braces
      if (trimmedLine.contains('{')) {
        bracketStack.add(_BracketInfo(lineNumber, FoldType.block));
      }

      if (trimmedLine.contains('}') && bracketStack.isNotEmpty) {
        final openBracket = bracketStack.removeLast();
        regions.add(FoldRegion(
          startLine: openBracket.line,
          endLine: lineNumber,
          type: openBracket.type,
        ));
      }

      lineNumber++;
    }

    return regions;
  }

  /// Find the end line of a block comment
  static int _findBlockCommentEnd(List<String> lines, int startLine) {
    for (var i = startLine; i < lines.length; i++) {
      if (lines[i].contains('*/')) {
        return i;
      }
    }
    return -1;
  }

  /// Get the placeholder text for a folded region
  static String getFoldPlaceholder(String text, FoldRegion region) {
    final lines = text.split('\n');
    final firstLine = lines[region.startLine].trim();
    
    switch (region.type) {
      case FoldType.block:
        return '$firstLine ... }';
      case FoldType.comment:
        return '/* ... */';
      default:
        return '...';
    }
  }

  /// Check if a line number is within any folded region
  static bool isLineInFoldedRegion(int line, Map<int, int> foldedRegions) {
    for (final entry in foldedRegions.entries) {
      if (line > entry.key && line <= entry.value) {
        return true;
      }
    }
    return false;
  }

  /// Get the visible lines considering folded regions
  static List<String> getVisibleLines(
    List<String> allLines,
    Map<int, int> foldedRegions,
  ) {
    final visibleLines = <String>[];
    var currentLine = 0;

    while (currentLine < allLines.length) {
      if (foldedRegions.containsKey(currentLine)) {
        // Add the first line of the folded region with placeholder
        visibleLines.add(allLines[currentLine]);
        currentLine = foldedRegions[currentLine]! + 1;
      } else {
        if (!isLineInFoldedRegion(currentLine, foldedRegions)) {
          visibleLines.add(allLines[currentLine]);
        }
        currentLine++;
      }
    }

    return visibleLines;
  }
}

/// Types of foldable regions
enum FoldType {
  block,
  comment,
}

/// Represents a foldable region in the code
class FoldRegion {
  final int startLine;
  final int endLine;
  final FoldType type;

  const FoldRegion({
    required this.startLine,
    required this.endLine,
    required this.type,
  });
}

class _BracketInfo {
  final int line;
  final FoldType type;

  const _BracketInfo(this.line, this.type);
} 