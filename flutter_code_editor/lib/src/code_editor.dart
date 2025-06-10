import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/src/controllers/editor_controller.dart';
import 'package:flutter_code_editor/src/models/editor_config.dart';
import 'package:flutter_code_editor/src/models/editor_theme.dart';
import 'package:flutter_code_editor/src/utils/text_input.dart';
import 'package:flutter_code_editor/src/utils/code_folding.dart';
import 'package:flutter_code_editor/src/utils/search_replace.dart';

/// A powerful lightweight text and code editor widget for Flutter
class CodeEditor extends StatefulWidget {
  /// The controller for managing editor state and text manipulation
  final EditorController controller;

  /// The configuration options for the editor
  final EditorConfig config;

  /// The theme configuration for the editor
  final EditorTheme theme;

  /// Callback when the text changes
  final ValueChanged<String>? onChanged;

  /// Callback when the cursor position changes
  final ValueChanged<int>? onCursorPositionChanged;

  const CodeEditor({
    super.key,
    required this.controller,
    this.config = const EditorConfig(),
    this.theme = const EditorTheme(),
    this.onChanged,
    this.onCursorPositionChanged,
  });

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late FocusNode _focusNode;
  late LayerLink _toolbarLayerLink;
  late OverlayEntry? _contextMenuOverlay;
  late TextEditingController _searchController;
  late TextEditingController _replaceController;
  List<SearchMatch> _searchMatches = [];
  int _currentMatchIndex = -1;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _toolbarLayerLink = LayerLink();
    _contextMenuOverlay = null;
    _searchController = TextEditingController();
    _replaceController = TextEditingController();

    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _hideContextMenu();
    _searchController.dispose();
    _replaceController.dispose();
    widget.controller.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
    if (widget.onCursorPositionChanged != null) {
      widget.onCursorPositionChanged!(widget.controller.cursorPosition);
    }
    _updateSearchMatches();
  }

  void _updateSearchMatches() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _searchMatches = SearchReplaceHandler.findMatches(
          widget.controller.text,
          _searchController.text,
          caseSensitive: false,
        );
        _currentMatchIndex = _searchMatches.isNotEmpty ? 0 : -1;
      });
    }
  }

  void _showContextMenu(BuildContext context, Offset position) {
    _hideContextMenu();

    _contextMenuOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: CompositedTransformFollower(
          link: _toolbarLayerLink,
          offset: Offset(0, -24),
          child: Material(
            elevation: 4,
            child: Container(
              padding: EdgeInsets.all(8),
              color: widget.theme.backgroundColor,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.content_cut, color: widget.theme.textColor),
                    onPressed: _handleCut,
                  ),
                  IconButton(
                    icon: Icon(Icons.content_copy, color: widget.theme.textColor),
                    onPressed: _handleCopy,
                  ),
                  IconButton(
                    icon: Icon(Icons.content_paste, color: widget.theme.textColor),
                    onPressed: _handlePaste,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_contextMenuOverlay!);
  }

  void _hideContextMenu() {
    _contextMenuOverlay?.remove();
    _contextMenuOverlay = null;
  }

  Future<void> _handleCut() async {
    if (widget.controller.selection != null) {
      final text = widget.controller.text;
      final selection = widget.controller.selection!;
      final selectedText = text.substring(selection.start, selection.end);
      await Clipboard.setData(ClipboardData(text: selectedText));
      widget.controller.deleteText();
    }
    _hideContextMenu();
  }

  Future<void> _handleCopy() async {
    if (widget.controller.selection != null) {
      final text = widget.controller.text;
      final selection = widget.controller.selection!;
      final selectedText = text.substring(selection.start, selection.end);
      await Clipboard.setData(ClipboardData(text: selectedText));
    }
    _hideContextMenu();
  }

  Future<void> _handlePaste() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData?.text != null) {
      widget.controller.insertText(clipboardData!.text!);
    }
    _hideContextMenu();
  }

  void _handleFoldToggle(int startLine, int endLine) {
    widget.controller.toggleFold(startLine, endLine);
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(8),
      color: widget.theme.backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: widget.theme.textColor),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: widget.theme.textColor.withOpacity(0.5)),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _updateSearchMatches(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_upward, color: widget.theme.textColor),
            onPressed: _searchMatches.isEmpty ? null : _selectPreviousMatch,
          ),
          IconButton(
            icon: Icon(Icons.arrow_downward, color: widget.theme.textColor),
            onPressed: _searchMatches.isEmpty ? null : _selectNextMatch,
          ),
          if (widget.config.enableCodeFolding)
            IconButton(
              icon: Icon(Icons.unfold_less, color: widget.theme.textColor),
              onPressed: _foldAllBlocks,
            ),
        ],
      ),
    );
  }

  void _selectNextMatch() {
    if (_searchMatches.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex + 1) % _searchMatches.length;
      _scrollToMatch(_searchMatches[_currentMatchIndex]);
    });
  }

  void _selectPreviousMatch() {
    if (_searchMatches.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex - 1 + _searchMatches.length) % _searchMatches.length;
      _scrollToMatch(_searchMatches[_currentMatchIndex]);
    });
  }

  void _scrollToMatch(SearchMatch match) {
    final lineNumber = SearchReplaceHandler.getMatchLineNumber(widget.controller.text, match);
    // Implement scrolling to the match
  }

  void _foldAllBlocks() {
    final regions = CodeFoldingHandler.findFoldableRegions(widget.controller.text);
    for (final region in regions) {
      widget.controller.toggleFold(region.startLine, region.endLine);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: CompositedTransformTarget(
            link: _toolbarLayerLink,
            child: GestureDetector(
              onSecondaryTapDown: (details) {
                _showContextMenu(context, details.globalPosition);
              },
              child: Focus(
                focusNode: _focusNode,
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent) {
                    if (TextInputHandler.isSpecialKeyCombination(event)) {
                      return KeyEventResult.handled;
                    }
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      widget.controller.deleteText(forward: false);
                      return KeyEventResult.handled;
                    } else if (event.logicalKey == LogicalKeyboardKey.delete) {
                      widget.controller.deleteText(forward: true);
                      return KeyEventResult.handled;
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: Container(
                  color: widget.theme.backgroundColor,
                  child: Row(
                    children: [
                      if (widget.config.showLineNumbers)
                        _buildLineNumbers(),
                      Expanded(
                        child: _buildEditor(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLineNumbers() {
    final lines = widget.controller.text.split('\n');
    final foldableRegions = CodeFoldingHandler.findFoldableRegions(widget.controller.text);
    
    return Container(
      width: 48,
      color: widget.theme.gutterBackgroundColor,
      child: ListView.builder(
        controller: widget.controller.verticalScrollController,
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final isFoldable = foldableRegions.any((r) => r.startLine == index);
          final isFolded = widget.controller.foldedRegions.containsKey(index);

          return GestureDetector(
            onTap: isFoldable
                ? () {
                    final region = foldableRegions.firstWhere((r) => r.startLine == index);
                    _handleFoldToggle(region.startLine, region.endLine);
                  }
                : null,
            child: Container(
              height: widget.config.fontSize * 1.5,
              padding: EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isFoldable)
                    Icon(
                      isFolded ? Icons.chevron_right : Icons.expand_more,
                      size: 14,
                      color: widget.theme.lineNumberColor,
                    ),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: widget.theme.lineNumberColor,
                      fontSize: widget.config.fontSize,
                      fontFamily: widget.config.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditor() {
    return SingleChildScrollView(
      controller: widget.controller.horizontalScrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: SingleChildScrollView(
          controller: widget.controller.verticalScrollController,
          child: RichText(
            text: TextSpan(
              children: widget.controller.getHighlightedSpans(),
              style: TextStyle(
                fontSize: widget.config.fontSize,
                fontFamily: widget.config.fontFamily,
                color: widget.theme.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 