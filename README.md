# Filipino Business Quiz
A Flutter quiz application about Filipino business practices, retail culture, and marketing strategies. Features a gradient background inspired by the Philippine flag colors.

## Features
- 30-second timed quiz challenge
- Philippine flag color gradient background
- Interactive feedback with animations
- Real-time scoring
- Results screen with percentage

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+

### Installation
git clone Shen-is-pretty/bsis3A-flutter-setup-SALCEDO
cd filipino-business-quiz
flutter pub get
flutter run


## How to Play
1. Tap "Start Quiz"
2. Answer 3 questions within 30 seconds
3. View your score and restart

## Customization

### Add Questions
Edit the `questions` list in `main.dart`:

dart
Question(
  questionText: 'Your question?',
  answers: ['A', 'B', 'C', 'D'],
  correctAnswerIndex: 0,
)


### Change Timer
Modify in `startQuiz()` method:

dart
_secondsRemaining = 30; // your desired seconds


## Built With
- Flutter
- Dart
- Material Design 3

## License
MIT License

## Author
Shenna A. Salcedo
- GitHub: [@Shen-is-pretty](https://github.com/Shen-is-pretty/bsis3A-flutter-setup-SALCEDO)
