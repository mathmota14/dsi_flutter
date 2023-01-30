import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Gerador de Nomes para Startups', home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 20);
  bool isList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gerador de Nomes para Startups'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border_sharp),
              onPressed: _pushSaved,
              tooltip: 'Favoritos',
            ),
            IconButton(
              icon:
                  isList ? const Icon(Icons.grid_view) : const Icon(Icons.list),
              onPressed: () {
                setState(() {
                  isList = !isList;
                });
              },
              tooltip: isList ? 'Modo card' : 'Modo lista',
            ),
          ],
        ),
        body: isList ? lista() : cards());
  }

  Widget lista() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return favorites(_suggestions[index]);
      },
    );
  }

  Widget cards() {
    return GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            mainAxisExtent: 100),
        itemBuilder: (context, i) {
          if (i >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return Card(child: favorites(_suggestions[i]));
        });
  }

  Widget favorites(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
              color: alreadySaved ? Colors.red : null,
              tooltip: alreadySaved ? 'Desfavoritar' : 'Favoritar',
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.black87,
              tooltip: 'Remover da lista',
              onPressed: () {
                setState(() {
                  _suggestions.remove(pair);
                  _saved.remove(pair);
                });
              },
            ),
          ],
        ));
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favoritos'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
