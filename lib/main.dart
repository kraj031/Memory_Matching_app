import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MemoryMatchGame());
}

class MemoryMatchGame extends StatelessWidget {
  const MemoryMatchGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Memory Match Game",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: "Arial",
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  /// EMOJIS
  List<String> emojis = [
    "🦊",
    "🐶",
    "🐼",
    "🐸",
    "🦁",
    "🐵",
    "🦊",
    "🐶",
    "🐼",
    "🐸",
    "🦁",
    "🐵",
    "🐱",
    "🐰",
    "🐨",
    "🐯",
    "🐱",
    "🐰",
    "🐨",
    "🐯",
  ];

  /// CARD STATUS
  List<bool> flipped = [];
  List<bool> matched = [];

  int? firstCard;
  int? secondCard;

  int moves = 0;
  int score = 0;

  Timer? gameTimer;
  int seconds = 0;

  /// CARD COLORS
  List<Color> cardColors = [
    const Color(0xFF6C3CC9),
    const Color(0xFFFF9800),
    const Color(0xFF63E6AE),
    const Color(0xFFFF4081),
    const Color(0xFF1BB7D0),
    const Color(0xFFFFC107),
    const Color(0xFF0D9B8F),
    const Color(0xFFD13CF2),
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  /// START GAME
  void startGame() {

    emojis.shuffle(Random());

    flipped = List.generate(emojis.length, (_) => false);
    matched = List.generate(emojis.length, (_) => false);

    firstCard = null;
    secondCard = null;

    moves = 0;
    score = 0;

    seconds = 0;

    gameTimer?.cancel();

    gameTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {

        setState(() {
          seconds++;
        });

      },
    );

    setState(() {});
  }

  /// FLIP CARD
  void flipCard(int index) {

    if (secondCard != null) return;

    if (flipped[index] || matched[index]) return;

    setState(() {
      flipped[index] = true;
    });

    if (firstCard == null) {

      firstCard = index;

    } else {

      secondCard = index;

      moves++;

      /// MATCH
      if (emojis[firstCard!] == emojis[secondCard!]) {

        matched[firstCard!] = true;
        matched[secondCard!] = true;

        score += 10;

        firstCard = null;
        secondCard = null;

        checkWinner();

      }

      /// NOT MATCH
      else {

        Timer(
          const Duration(milliseconds: 700),
              () {

            setState(() {

              flipped[firstCard!] = false;
              flipped[secondCard!] = false;

              firstCard = null;
              secondCard = null;

            });

          },
        );
      }
    }

    setState(() {});
  }

  /// WIN CHECK
  void checkWinner() {

    if (matched.every((element) => element)) {

      gameTimer?.cancel();

      showDialog(

        context: context,

        barrierDismissible: false,

        builder: (context) {

          return BackdropFilter(

            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),

            child: AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              title: const Text(
                "🎉 Congratulations!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  const SizedBox(height: 10),

                  Text(
                    "You completed the game successfully!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "🏆 Score: $score",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "🎯 Moves: $moves",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "⏱ Time: $seconds sec",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              actions: [

                Center(
                  child: ElevatedButton.icon(

                    onPressed: () {

                      Navigator.pop(context);
                      startGame();

                    },

                    icon: const Icon(Icons.refresh),

                    label: const Text(
                      "Play Again",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }

  /// CARD COLOR
  Color getCardColor(int index) {
    return cardColors[index % cardColors.length];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFFDF9F1),

      /// APP BAR
      appBar: AppBar(

        elevation: 0,

        backgroundColor: const Color(0xFFFDF9F1),

        leading: Padding(
          padding: const EdgeInsets.all(10),

          child: Container(

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.deepPurple,
            ),
          ),
        ),

        centerTitle: true,

        title: const Text(
          "Memory Match",

          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 14),

            child: Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color: const Color(0xFFEADDFE),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(

                children: [

                  const Text(
                    "🎯",
                    style: TextStyle(fontSize: 24),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    "$score",

                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// BODY
      body: Padding(

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        child: Column(

          children: [

            const SizedBox(height: 5),

            const Text(
              "Find all matching pairs! 🐾",

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 18),

            /// TOP INFO
            Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,

              children: [

                infoCard(
                  title: "Moves",
                  value: "$moves",
                  icon: Icons.touch_app,
                ),

                infoCard(
                  title: "Time",
                  value: "${seconds}s",
                  icon: Icons.timer,
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// GRID
            Expanded(

              child: GridView.builder(

                itemCount: emojis.length,

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 4,

                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,

                  childAspectRatio: 0.78,
                ),

                itemBuilder: (context, index) {

                  bool showEmoji =
                      flipped[index] || matched[index];

                  return GestureDetector(

                    onTap: () => flipCard(index),

                    child: AnimatedContainer(

                      duration:
                      const Duration(milliseconds: 350),

                      curve: Curves.easeInOut,

                      decoration: BoxDecoration(

                        color: showEmoji
                            ? Colors.white
                            : getCardColor(index),

                        borderRadius:
                        BorderRadius.circular(24),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(3, 5),
                          )
                        ],
                      ),

                      child: Center(

                        child: AnimatedSwitcher(

                          duration:
                          const Duration(milliseconds: 300),

                          transitionBuilder:
                              (child, animation) {

                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },

                          child: Text(

                            showEmoji
                                ? emojis[index]
                                : "?",

                            key: ValueKey(showEmoji),

                            style: TextStyle(

                              fontSize:
                              showEmoji ? 40 : 55,

                              fontWeight:
                              FontWeight.bold,

                              color: showEmoji
                                  ? Colors.black
                                  : Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            /// RESTART BUTTON
            SizedBox(

              width: double.infinity,
              height: 68,

              child: ElevatedButton.icon(

                onPressed: startGame,

                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 30,
                ),

                label: const Text(

                  "Restart Game",

                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.deepPurple,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),

                  elevation: 5,
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// INFO CARD
  Widget infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 14,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 4),
          )
        ],
      ),

      child: Column(

        children: [

          Icon(
            icon,
            color: Colors.deepPurple,
            size: 28,
          ),

          const SizedBox(height: 6),

          Text(
            title,

            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}