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
  List<Map<String, String>> notes = [];

  Future<void> _navigateToNewNotePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewNotePage(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        notes.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: notes.isEmpty
          ? Center(
        child: Text(
          'No notes available. Tap the "+" button to add a new note.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]['title'] ?? ''),
            subtitle: Text(notes[index]['description'] ?? ''),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewNotePage,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewNotePage extends StatefulWidget {
  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveNote() {
    final note = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };
    if(note["title"] == null || note["description"] == null){
      _showToast(context, "please enter a title and description");
    }
    else if(note["title"]!.isEmpty || note["description"]!.isEmpty){
      _showToast(context, "please enter a title and description");
    }

    else{
      Navigator.pop(context, note);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back without saving
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
  void _showToast(BuildContext context, String toastText) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(toastText),
        //action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}


