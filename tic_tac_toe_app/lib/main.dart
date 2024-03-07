import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.red.shade300,
        cardColor: Colors.amber,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> board = List.generate(9, (index) => index);
  final List<int> _player1 = [];
  final List<int> _player2 = [];
  List<int> winningTile = [];
  bool isPlayer1 = true;
  bool? isPlayer1Won;

  int player1WinCount = 0;
  int player2WinCount = 0;

  List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  bool isWinner(List<int> playerTiles) {
    for (var combo in winningCombinations) {
      if (combo.every((element) => playerTiles.contains(element))) {
        winningTile = combo;
        return true;
      }
    }
    return false;
  }

  Color getColor(int element) {
    if (isPlayer1Won == null) {
      if (_player1.contains(element)) {
        return Colors.blue;
      } else {
        return Colors.green;
      }
    } else {
      if (isPlayer1Won! && winningTile.contains(element) ||
          !isPlayer1Won! && winningTile.contains(element)) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic-Tac-Toe"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 5.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemCount: board.length,
                  itemBuilder: (context, index) {
                    int element = board[index];
                    return GestureDetector(
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 4.0,
                        child: Center(
                          child: Text(
                              !_player1.contains(element) &&
                                      !_player2.contains(element)
                                  ? ''
                                  : _player1.contains(element)
                                      ? 'x'
                                      : 'o',
                              style: TextStyle(
                                fontSize: 60,
                                color: getColor(element),
                              )),
                        ),
                      ),
                      onTap: () {
                        if (isPlayer1Won != null) {
                          return;
                        }
                        if (_player1.contains(element) ||
                            _player2.contains(element)) {
                          return;
                        } else {
                          setState(() {
                            isPlayer1
                                ? _player1.add(element)
                                : _player2.add(element);
                            isPlayer1 = !isPlayer1;
                          });

                          if (isWinner(_player1)) {
                            setState(() {
                              isPlayer1Won = true;
                              player1WinCount++;
                            });
                          } else if (isWinner(_player2)) {
                            setState(() {
                              isPlayer1Won = false;
                              player2WinCount++;
                            });
                          }

                          if (isPlayer1Won != null) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Player ${isPlayer1Won! ? '1' : '2'} Won this match!'),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _player1.clear();
                    _player2.clear();
                    isPlayer1 = true;
                    isPlayer1Won = null;
                    winningTile = [];
                  });
                },
                child: Text(
                  'RESET',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Player 1',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$player1WinCount',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Player 2',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$player2WinCount',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
