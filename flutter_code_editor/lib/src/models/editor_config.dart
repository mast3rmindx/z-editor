import 'package:flutter/material.dart';

/// Configuration options for the code editor
class EditorConfig {
  /// Whether to show line numbers
  final bool showLineNumbers;

  /// Whether to enable text wrapping
  final bool enableLineWrapping;

  /// Font size for the editor
  final double fontSize;

  /// Font family for the editor
  final String fontFamily;

  /// Tab size in spaces
  final int tabSize;

  /// Whether to enable syntax highlighting
  final bool enableSyntaxHighlighting;

  /// Whether to enable code folding
  final bool enableCodeFolding;

  /// Whether to show the current line highlight
  final bool highlightCurrentLine;

  const EditorConfig({
    this.showLineNumbers = true,
    this.enableLineWrapping = false,
    this.fontSize = 14.0,
    this.fontFamily = 'monospace',
    this.tabSize = 2,
    this.enableSyntaxHighlighting = true,
    this.enableCodeFolding = true,
    this.highlightCurrentLine = true,
  });

  /// Creates a copy of this configuration with the given fields replaced with new values
  EditorConfig copyWith({
    bool? showLineNumbers,
    bool? enableLineWrapping,
    double? fontSize,
    String? fontFamily,
    int? tabSize,
    bool? enableSyntaxHighlighting,
    bool? enableCodeFolding,
    bool? highlightCurrentLine,
  }) {
    return EditorConfig(
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      enableLineWrapping: enableLineWrapping ?? this.enableLineWrapping,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      tabSize: tabSize ?? this.tabSize,
      enableSyntaxHighlighting: enableSyntaxHighlighting ?? this.enableSyntaxHighlighting,
      enableCodeFolding: enableCodeFolding ?? this.enableCodeFolding,
      highlightCurrentLine: highlightCurrentLine ?? this.highlightCurrentLine,
    );
  }
} 