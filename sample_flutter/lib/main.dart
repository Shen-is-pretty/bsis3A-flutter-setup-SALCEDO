import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Quiz state variables
  bool quizStarted = false;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  bool quizEnded = false;

  // Quiz questions
  final List<Question> questions = [
    Question(
      questionText:
          'Which film was the very first to be independently produced by Marvel Studios, kicking off the Marvel Cinematic Universe (MCU) in 2008?',
      answers: [
        'Iron Man',
        'The Incredible Hulk',
        'Thor',
        'Captain America: The First Avenger',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'During the filming of the 2012 film The Avengers, what was the secret production codename used on set and on scripts to keep the project under wraps?',
      answers: [
        'Group Hog',
        'Assembled',
        'Blue Harvest',
        'The Initiative',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'In the MCU, Captain America’s shield and the Black Panther’s suit are both made primarily from which rare, fictional African metal?',
      answers: [
        'Adamantium',
        'Uru',
        'Vibranium',
        'Promethium',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What is the largest ocean on Earth?',
      answers: [
        'Atlantic Ocean',
        'Indian Ocean',
        'Arctic Ocean',
        'Pacific Ocean',
      ],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: 'Who painted the Mona Lisa?',
      answers: [
        'Vincent van Gogh',
        'Leonardo da Vinci',
        'Pablo Picasso',
        'Michelangelo',
      ],
      correctAnswerIndex: 1,
    ),
  ];

  void startQuiz() {
    setState(() {
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswerIndex = null;
      isAnswered = false;
      quizEnded = false;
    });
  }

  void selectAnswer(int index) {
    if (!isAnswered) {
      setState(() {
        selectedAnswerIndex = index;
        isAnswered = true;
        
        // Check if answer is correct
        if (index == questions[currentQuestionIndex].correctAnswerIndex) {
          score++;
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
      } else {
        quizEnded = true;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: !quizStarted
            ? buildStartView()
            : quizEnded
                ? buildEndView()
                : buildQuizView(),
      ),
    );
  }

  // Start View
  Widget buildStartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.quiz,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 30),
          const Text(
            'Welcome to Quiz App',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Test your knowledge with ${questions.length} questions',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: startQuiz,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 15,
              ),
              textStyle: const TextStyle(fontSize: 18),
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
        // Progress indicator
        LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / questions.length,
          backgroundColor: Colors.grey[300],
          minHeight: 8,
        ),
        const SizedBox(height: 20),
        
        // Question number
        Text(
          'Question ${currentQuestionIndex + 1} of ${questions.length}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        
        // Question text
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        
        // Answer buttons
        ...List.generate(
          question.answers.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ElevatedButton(
              onPressed: isAnswered ? null : () => selectAnswer(index),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: selectedAnswerIndex == index
                    ? (index == question.correctAnswerIndex
                        ? Colors.green
                        : Colors.red)
                    : (isAnswered && index == question.correctAnswerIndex
                        ? Colors.green
                        : null),
                foregroundColor: selectedAnswerIndex == index || 
                    (isAnswered && index == question.correctAnswerIndex)
                    ? Colors.white
                    : null,
              ),
              child: Text(
                question.answers[index],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        
        const Spacer(),
        
        // Next button (shown after answering)
        if (isAnswered)
          ElevatedButton(
            onPressed: nextQuestion,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: Text(
              currentQuestionIndex < questions.length - 1
                  ? 'Next Question'
                  : 'See Results',
            ),
          ),
      ],
    );
  }

  // End View
  Widget buildEndView() {
    final percentage = (score / questions.length * 100).toStringAsFixed(1);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 100,
            color: Colors.amber,
          ),
          const SizedBox(height: 30),
          const Text(
            'Quiz Completed!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          
          // Score card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$score / ${questions.length}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 50),
          
          // Restart button
          ElevatedButton.icon(
            onPressed: restartQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart Quiz'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}