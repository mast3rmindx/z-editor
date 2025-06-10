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
      title: 'Flutter Code Editor Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late EditorController _controller;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _controller = EditorController(
      text: _sampleCode,
      language: 'dart',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Code Editor Demo'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: CodeEditor(
                controller: _controller,
                config: const EditorConfig(
                  fontSize: 14.0,
                  fontFamily: 'JetBrains Mono',
                  showLineNumbers: true,
                  enableLineWrapping: false,
                  enableCodeFolding: true,
                  enableSyntaxHighlighting: true,
                ),
                theme: _isDarkMode ? const EditorTheme() : const EditorTheme(
                  backgroundColor: Color(0xFFFFFFFF),
                  textColor: Color(0xFF000000),
                  currentLineColor: Color(0xFFF5F5F5),
                  lineNumberColor: Color(0xFF999999),
                  selectionColor: Color(0xFFB3D7FF),
                  bracketMatchColor: Color(0xFF90CAF9),
                  gutterBackgroundColor: Color(0xFFFAFAFA),
                  syntaxTheme: {
                    'keyword': TextStyle(color: Color(0xFF0033B3)),
                    'string': TextStyle(color: Color(0xFF067D17)),
                    'number': TextStyle(color: Color(0xFF1750EB)),
                    'comment': TextStyle(color: Color(0xFF8C8C8C)),
                    'class': TextStyle(color: Color(0xFF00627A)),
                    'function': TextStyle(color: Color(0xFF7A3E00)),
                  },
                ),
                onChanged: (text) {
                  print('Text changed: ${text.length} characters');
                },
                onCursorPositionChanged: (position) {
                  print('Cursor position changed: $position');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _sampleCode = '''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '\$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
'''; 