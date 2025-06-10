<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Code Editor

A powerful lightweight text and code editor widget for Flutter, specifically designed for displaying and editing multi-line text with advanced features.

## Features

- Two-way horizontal and vertical scrolling
- Syntax highlighting using re_highlight package
- Content collapsing and expanding
- Search and replace functionality
- Custom context menu
- Large text display and editing
- Line numbers and focus line highlighting
- Smart input handling
- High performance optimized for large texts

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_code_editor: ^0.0.1
```

## Usage

Here's a simple example of how to use the Flutter Code Editor:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CodeEditor(
          controller: EditorController(
            text: 'Hello, World!',
            language: 'plaintext',
          ),
          config: const EditorConfig(
            fontSize: 14.0,
            fontFamily: 'monospace',
            showLineNumbers: true,
            enableLineWrapping: false,
          ),
        ),
      ),
    );
  }
}
```

### Configuration

The editor can be customized using `EditorConfig`:

```dart
EditorConfig(
  fontSize: 14.0,
  fontFamily: 'monospace',
  showLineNumbers: true,
  enableLineWrapping: false,
  enableCodeFolding: true,
  enableSyntaxHighlighting: true,
  tabSize: 2,
  highlightCurrentLine: true,
)
```

### Theming

Customize the editor's appearance using `EditorTheme`:

```dart
EditorTheme(
  backgroundColor: Color(0xFF1E1E1E),
  textColor: Color(0xFFD4D4D4),
  currentLineColor: Color(0xFF282828),
  lineNumberColor: Color(0xFF858585),
  selectionColor: Color(0xFF264F78),
  bracketMatchColor: Color(0xFF327D7D),
  syntaxTheme: {
    'keyword': TextStyle(color: Color(0xFF569CD6)),
    'string': TextStyle(color: Color(0xFFCE9178)),
    'number': TextStyle(color: Color(0xFFB5CEA8)),
    'comment': TextStyle(color: Color(0xFF6A9955)),
    'class': TextStyle(color: Color(0xFF4EC9B0)),
    'function': TextStyle(color: Color(0xFFDCDCAA)),
  },
)
```

### Controller

The `EditorController` manages the editor's state and provides methods for text manipulation:

```dart
final controller = EditorController(
  text: 'Initial text',
  language: 'dart',
);

// Insert text at cursor position
controller.insertText('New text');

// Delete text
controller.deleteText();

// Get highlighted spans
final spans = controller.getHighlightedSpans();

// Dispose when done
controller.dispose();
```

## Features in Detail

### Code Folding

The editor supports code folding for blocks and comments:

```dart
// Toggle fold for a specific region
controller.toggleFold(startLine, endLine);

// Check if a line is folded
final isFolded = controller.foldedRegions.containsKey(lineNumber);
```

### Search and Replace

Perform search and replace operations:

```dart
// Find matches
final matches = SearchReplaceHandler.findMatches(
  text,
  searchTerm,
  caseSensitive: false,
  useRegex: false,
  wholeWord: false,
);

// Replace matches
final newText = SearchReplaceHandler.replaceMatches(
  text,
  matches,
  replacement,
);
```

## Example

Check out the [example](example) folder for a complete demo application showcasing all features.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
