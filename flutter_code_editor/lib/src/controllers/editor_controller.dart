import 'package:flutter/material.dart';
import 'package:re_highlight/re_highlight.dart';

/// Controller for managing the code editor's state and text manipulation
class EditorController extends ChangeNotifier {
  /// The text content of the editor
  String _text = '';

  /// The current cursor position
  int _cursorPosition = 0;

  /// The current selection, if any
  TextSelection? _selection;

  /// Map of folded regions (start line -> end line)
  final Map<int, int> _foldedRegions = {};

  /// The syntax highlighter instance
  final Highlighter _highlighter;

  /// Scroll controllers for horizontal and vertical scrolling
  final ScrollController horizontalScrollController;
  final ScrollController verticalScrollController;

  EditorController({
    String text = '',
    String language = 'plaintext',
  }) : _highlighter = Highlighter(language: language),
       horizontalScrollController = ScrollController(),
       verticalScrollController = ScrollController() {
    this.text = text;
  }

  /// Get the current text content
  String get text => _text;

  /// Set new text content
  set text(String newText) {
    _text = newText;
    _updateHighlighting();
    notifyListeners();
  }

  /// Get the current cursor position
  int get cursorPosition => _cursorPosition;

  /// Set new cursor position
  set cursorPosition(int position) {
    _cursorPosition = position.clamp(0, _text.length);
    notifyListeners();
  }

  /// Get the current selection
  TextSelection? get selection => _selection;

  /// Set new selection
  set selection(TextSelection? newSelection) {
    _selection = newSelection;
    notifyListeners();
  }

  /// Get the list of folded regions
  Map<int, int> get foldedRegions => Map.unmodifiable(_foldedRegions);

  /// Toggle code folding for a specific line
  void toggleFold(int startLine, int endLine) {
    if (_foldedRegions.containsKey(startLine)) {
      _foldedRegions.remove(startLine);
    } else {
      _foldedRegions[startLine] = endLine;
    }
    notifyListeners();
  }

  /// Insert text at the current cursor position
  void insertText(String text) {
    if (_selection != null && _selection!.isValid) {
      _text = _text.replaceRange(_selection!.start, _selection!.end, text);
      _cursorPosition = _selection!.start + text.length;
      _selection = null;
    } else {
      _text = _text.replaceRange(_cursorPosition, _cursorPosition, text);
      _cursorPosition += text.length;
    }
    _updateHighlighting();
    notifyListeners();
  }

  /// Delete text at the current cursor position
  void deleteText({bool forward = true}) {
    if (_selection != null && _selection!.isValid) {
      _text = _text.replaceRange(_selection!.start, _selection!.end, '');
      _cursorPosition = _selection!.start;
      _selection = null;
    } else if (forward && _cursorPosition < _text.length) {
      _text = _text.replaceRange(_cursorPosition, _cursorPosition + 1, '');
    } else if (!forward && _cursorPosition > 0) {
      _text = _text.replaceRange(_cursorPosition - 1, _cursorPosition, '');
      _cursorPosition--;
    }
    _updateHighlighting();
    notifyListeners();
  }

  /// Update syntax highlighting
  void _updateHighlighting() {
    _highlighter.highlight(_text);
  }

  /// Get highlighted spans for the current text
  List<TextSpan> getHighlightedSpans() {
    return _highlighter.getHighlightedSpans();
  }

  @override
  void dispose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.dispose();
  }
} 