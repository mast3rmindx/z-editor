import 'package:flutter/material.dart';

/// Represents a search match in the text
class SearchMatch {
  final int start;
  final int end;
  final String matchedText;

  const SearchMatch({
    required this.start,
    required this.end,
    required this.matchedText,
  });
}

/// Utility class for handling search and replace operations
class SearchReplaceHandler {
  /// Find all matches for a search term in the text
  static List<SearchMatch> findMatches(
    String text,
    String searchTerm, {
    bool caseSensitive = false,
    bool useRegex = false,
    bool wholeWord = false,
  }) {
    if (searchTerm.isEmpty) return [];

    final matches = <SearchMatch>[];
    
    if (useRegex) {
      try {
        final pattern = RegExp(
          searchTerm,
          caseSensitive: caseSensitive,
          multiLine: true,
        );
        
        for (final match in pattern.allMatches(text)) {
          matches.add(SearchMatch(
            start: match.start,
            end: match.end,
            matchedText: match.group(0) ?? '',
          ));
        }
      } catch (e) {
        // Invalid regex pattern, return empty list
        return [];
      }
    } else {
      var searchPattern = searchTerm;
      if (!caseSensitive) {
        text = text.toLowerCase();
        searchPattern = searchPattern.toLowerCase();
      }

      var startIndex = 0;
      while (true) {
        final index = text.indexOf(searchPattern, startIndex);
        if (index == -1) break;

        if (wholeWord) {
          final beforeChar = index > 0 ? text[index - 1] : ' ';
          final afterChar = index + searchPattern.length < text.length
              ? text[index + searchPattern.length]
              : ' ';

          if (!_isWordBoundary(beforeChar) || !_isWordBoundary(afterChar)) {
            startIndex = index + 1;
            continue;
          }
        }

        matches.add(SearchMatch(
          start: index,
          end: index + searchPattern.length,
          matchedText: text.substring(index, index + searchPattern.length),
        ));
        startIndex = index + 1;
      }
    }

    return matches;
  }

  /// Replace all occurrences of matches with the replacement text
  static String replaceMatches(
    String text,
    List<SearchMatch> matches,
    String replacement,
  ) {
    // Sort matches in reverse order to avoid offset issues
    final sortedMatches = List<SearchMatch>.from(matches)
      ..sort((a, b) => b.start.compareTo(a.start));

    var result = text;
    for (final match in sortedMatches) {
      result = result.replaceRange(match.start, match.end, replacement);
    }

    return result;
  }

  /// Replace a single match with the replacement text
  static String replaceSingleMatch(
    String text,
    SearchMatch match,
    String replacement,
  ) {
    return text.replaceRange(match.start, match.end, replacement);
  }

  /// Check if a character is a word boundary
  static bool _isWordBoundary(String char) {
    return !RegExp(r'[a-zA-Z0-9_]').hasMatch(char);
  }

  /// Get the line number for a match
  static int getMatchLineNumber(String text, SearchMatch match) {
    return text.substring(0, match.start).split('\n').length - 1;
  }

  /// Get all matches in a specific line range
  static List<SearchMatch> getMatchesInLineRange(
    String text,
    List<SearchMatch> matches,
    int startLine,
    int endLine,
  ) {
    return matches.where((match) {
      final line = getMatchLineNumber(text, match);
      return line >= startLine && line <= endLine;
    }).toList();
  }
} 