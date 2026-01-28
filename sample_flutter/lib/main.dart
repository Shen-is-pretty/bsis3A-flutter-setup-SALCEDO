import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' show sin, pi;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "It's Quiz Time",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Question {
  final String questionText;
  final List<String> answers;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  // Quiz state variables
  bool quizStarted = false;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  bool quizEnded = false;
  
  // Timer variables
  Timer? _timer;
  int _secondsRemaining = 30;
  
  // Animation controller for wiggle
  late AnimationController _wiggleController;
  late Animation<double> _wiggleAnimation;
  
  // Animation controller for bird
  late AnimationController _birdController;
  late Animation<double> _birdAnimation;

  // Quiz questions
  final List<Question> questions = [
    Question(
      questionText:
          'Which feature would help LCC Expressmart in Naga City solve their biggest customer service challenge?',
      answers: [
        'Real-time stock availability checker - Customers can check if specific items are in stock before visiting the store, saving them wasted trips for out-of-stock products.',
        'Digital loyalty points tracker - Automatically tracks customer purchases and rewards points through the app, eliminating the need for physical loyalty cards.',
        'Express lane reservation system - Customers can reserve a time slot for quick shopping during peak hours to avoid long checkout lines.',
        'Home delivery with live tracking - Allows customers to order groceries through the app and track their delivery in real-time, similar to food delivery services.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          'The Sari-Sari Store is the backbone of Philippine retail, making up the vast majority of micro-businesses in the country. What is the main "service" these stores provide to their neighborhood?',
      answers: [
        'Tingi (Retail atomization), or selling items in small, affordable portions like single sachets of shampoo or individual cigarettes.',
        'Importing luxury goods from Europe for local farmers.',
        'Providing high-speed fiber internet to the entire barangay.',
        'You can make utang then bayad next year',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          'Filipino businesses often use "Emotional Marketing." When you see a Jollibee or SM commercial, what is the most common theme used to build a bond with the customers?',
      answers: [
        'Detailed technical specifications of their products.',
        'Family values, reunions, and the "joy" of being together.',
        'Aggressive price wars and comparing themselves to competitors by name.',
        'Emotional marketing is not used in the Philippines.',
      ],
      correctAnswerIndex: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize wiggle animation
    _wiggleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _wiggleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _wiggleController, curve: Curves.elasticIn),
    );
    
    // Initialize bird animation
    _birdController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _birdAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _birdController, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wiggleController.dispose();
    _birdController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          
          // Animate bird when time is running out (last 10 seconds)
          if (_secondsRemaining <= 10 && _secondsRemaining > 0) {
            _birdController.forward(from: 0);
          }
        } else {
          // Time's up - end quiz
          _timer?.cancel();
          quizEnded = true;
        }
      });
    });
  }

  void startQuiz() {
    setState(() {
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswerIndex = null;
      isAnswered = false;
      quizEnded = false;
      _secondsRemaining = 30; // Set 30 seconds for entire quiz
      _birdController.reset();
    });
    startTimer();
  }

  void selectAnswer(int index) {
    if (!isAnswered) {
      setState(() {
        selectedAnswerIndex = index;
        isAnswered = true;
        // Don't cancel timer - it keeps running
        
        // Check if answer is correct
        if (index == questions[currentQuestionIndex].correctAnswerIndex) {
          score++;
        } else {
          // Trigger wiggle animation for wrong answer
          _wiggleController.forward(from: 0);
        }
      });
    }
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswered = false;
        _wiggleController.reset();
        // Don't reset timer - it continues running
      } else {
        quizEnded = true;
        _timer?.cancel();
      }
    });
  }

  void restartQuiz() {
    setState(() {
      quizStarted = false;
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswerIndex = null;
      isAnswered = false;
      quizEnded = false;
      _wiggleController.reset();
      _birdController.reset();
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0038A8), // Philippine flag blue
              Color(0xFF0066CC), // Lighter blue
              Color(0xFFFFFFFF), // White (representing peace and purity)
              Color(0xFFFCD116), // Philippine sun yellow
              Color(0xFFCE1126), // Philippine flag red
              Color(0xFFFF4444), // Lighter red
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: !quizStarted
                ? buildStartView()
                : quizEnded
                    ? buildEndView()
                    : buildQuizView(),
          ),
        ),
      ),
    );
  }

  // Start View
  Widget buildStartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.quiz,
              size: 80,
              color: Color(0xFFCE1126),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Filipino Business Quiz',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0038A8),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Test your knowledge with ${questions.length} questions',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              '⏱️ 30 seconds for all questions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFCE1126),
              ),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: startQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0038A8),
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 15,
              ),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }

  // Quiz View
  Widget buildQuizView() {
    final question = questions[currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Timer and Progress with Bird
        Row(
          children: [
            // Timer with bird beside it
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _secondsRemaining <= 10
                        ? Colors.red.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: _secondsRemaining <= 10 ? Colors.white : const Color(0xFF0038A8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_secondsRemaining s',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _secondsRemaining <= 10 ? Colors.white : const Color(0xFF0038A8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bird animation beside the timer
                if (_secondsRemaining <= 10 && !isAnswered)
                  AnimatedBuilder(
                    animation: _birdAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _birdAnimation.value),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.flutter_dash,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(width: 10),
            // Progress
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Question ${currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0038A8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.white.withValues(alpha: 0.5),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 30),

        // Question text
        Container(
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Answer buttons
        Expanded(
          child: ListView.builder(
            itemCount: question.answers.length,
            itemBuilder: (context, index) {
              final isCorrect = index == question.correctAnswerIndex;
              final isSelected = selectedAnswerIndex == index;
              final showCorrect = isAnswered && isCorrect;
              final showWrong = isAnswered && isSelected && !isCorrect;

              return AnimatedBuilder(
                animation: _wiggleAnimation,
                builder: (context, child) {
                  double wiggle = 0;
                  if (showWrong) {
                    wiggle = sin(_wiggleAnimation.value * 4 * pi) * 10;
                  }

                  return Transform.translate(
                    offset: Offset(wiggle, 0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: ElevatedButton(
                        onPressed: isAnswered ? null : () => selectAnswer(index),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: showCorrect
                              ? Colors.green
                              : showWrong
                                  ? Colors.red
                                  : Colors.white.withValues(alpha: 0.95),
                          foregroundColor: showCorrect || showWrong
                              ? Colors.white
                              : const Color(0xFF333333),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: showCorrect
                                  ? Colors.green
                                  : showWrong
                                      ? Colors.red
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: showCorrect
                                    ? Colors.white
                                    : showWrong
                                        ? Colors.white
                                        : const Color(0xFF0038A8).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: showCorrect || showWrong
                                        ? (showCorrect ? Colors.green : Colors.red)
                                        : const Color(0xFF0038A8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                question.answers[index],
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (showCorrect)
                              const Icon(Icons.check_circle, color: Colors.white),
                            if (showWrong)
                              const Icon(Icons.cancel, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Show explanation for wrong answer
        if (isAnswered && selectedAnswerIndex != question.correctAnswerIndex)
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Correct answer: ${String.fromCharCode(65 + question.correctAnswerIndex)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Next button
        if (isAnswered)
          ElevatedButton(
            onPressed: nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0038A8),
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              currentQuestionIndex < questions.length - 1
                  ? 'Next Question →'
                  : 'See Results 🎉',
            ),
          ),
      ],
    );
  }

  // End View
  Widget buildEndView() {
    final percentage = (score / questions.length * 100).toStringAsFixed(1);
    final isPerfect = score == questions.length;
    final isGood = score >= questions.length * 0.7;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPerfect ? Icons.emoji_events : Icons.star,
              size: 80,
              color: isPerfect
                  ? const Color(0xFFFCD116)
                  : isGood
                      ? Colors.orange
                      : const Color(0xFF0038A8),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPerfect
                  ? '🎉 Perfect Score! 🎉'
                  : isGood
                      ? 'Great Job!'
                      : 'Quiz Completed!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0038A8),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Score card
          Container(
            padding: const EdgeInsets.all(40.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Your Score',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '$score / ${questions.length}',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0038A8),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0038A8).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0038A8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Restart button
          ElevatedButton.icon(
            onPressed: restartQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0038A8),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 18,
              ),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}