
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Card Game',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: DifficultyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DifficultyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(title: Text("Select Difficulty")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DifficultyButton(label: "Easy", pairCount: 4),
            SizedBox(height: 10,),
            DifficultyButton(label: "Medium", pairCount: 6),
            SizedBox(height: 10,),
            DifficultyButton(label: "Hard", pairCount: 8),
          ],
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String label;
  final int pairCount;

  DifficultyButton({required this.label, required this.pairCount});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(label, style: TextStyle(fontSize: 20)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MemoryGame(pairCount: pairCount),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }
}

class CardModel {
  String content;
  bool isFlipped;
  bool isMatched;

  CardModel({required this.content, this.isFlipped = false, this.isMatched = false});
}

class MemoryGame extends StatefulWidget {
  final int pairCount;

  MemoryGame({required this.pairCount});

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<CardModel> _cards = [];
  CardModel? _firstSelected;
  int _score = 0;
  Timer? _timer;
  int _seconds = 0;

  List<String> _emojis = ["🍎", "🚗", "🐶", "🏀", "🎵", "🚀", "🌟", "🍔", "🧠", "📚", "🎮", "🎲"];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _score = 0;
    _seconds = 0;
    _firstSelected = null;
    _timer?.cancel();
    _startTimer();

    final shuffled = [..._emojis]..shuffle();
    final selected = shuffled.take(widget.pairCount).toList();
    final allCards = [...selected, ...selected]..shuffle();
    _cards = allCards.map((e) => CardModel(content: e)).toList();

    setState(() {});
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _onCardTap(int index) {
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstSelected == null) {
      _firstSelected = _cards[index];
    } else {
      if (_firstSelected!.content == _cards[index].content) {
        setState(() {
          _firstSelected!.isMatched = true;
          _cards[index].isMatched = true;
          _score += 10;
          _firstSelected = null;
        });
        // Optionally play match sound
      } else {
        Future.delayed(Duration(milliseconds: 700), () {
          setState(() {
            _firstSelected!.isFlipped = false;
            _cards[index].isFlipped = false;
            _firstSelected = null;
          });
          // Optionally play mismatch sound
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildCard(CardModel card, int index) {
    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched ? Colors.white : Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
        ),
        child: Center(
          child: Text(
            card.isFlipped || card.isMatched ? card.content : "",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWon = _cards.isNotEmpty && _cards.every((card) => card.isMatched);

    return Scaffold(
      appBar: AppBar(
        title: Text("Memory - ${widget.pairCount * 2} Cards"),
        actions: [
          IconButton(onPressed: _startGame, icon: Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text("Score: $_score   |   Time: $_seconds sec", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _cards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (_, i) => _buildCard(_cards[i], i),
            ),
          ),
          if (isWon)
            Column(
              children: [
                Text("🎉 You Won!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: _startGame, child: Text("Play Again"))
              ],
            ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
