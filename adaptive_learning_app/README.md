# Adaptive LMS Quiz App

A comprehensive Flutter mobile application for lecturers and students, featuring adaptive quizzes and detailed performance analytics.

## 🔹 Main Features

### 👨‍🏫 Lecturer Dashboard
- **Question Creation**: Create multiple question types:
  - **MCQ**: Multiple Choice Questions with one correct answer.
  - **True/False**: Simple binary choice questions.
  - **Drag & Drop**: Ordering questions where students must arrange items correctly.
- **Set Difficulty**: Categorize questions as Easy, Medium, or Hard.
- **Student Analytics**: View aggregated performance data.

### 🎓 Student Experience
- **Adaptive Quiz Engine**: Quizzes are categorized by difficulty to provide a personalized learning path.
- **Sequential Questions**: Questions are presented one by one for focused learning.
- **Timed Quizzes**: Real-time timer to challenge students.
- **Drag & Drop Interaction**: Interactive ordering questions using Flutter's ReorderableListView.
- **Auto-Evaluation**: Instant scoring for all question types.

### 📊 Analytics Dashboard
- **Score History**: View a chronological list of past quiz results.
- **Accuracy %**: Performance breakdown by question difficulty (Easy, Medium, Hard).
- **Progress Tracking**: Key stats like Total Quizzes, Average Score, and Best Score.

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Charts**: FL Chart
- **Backend**: Spring Boot (Java)
- **Database**: H2 (In-memory)

## 🚀 Getting Started

### Backend Setup
1. Navigate to the `backend` folder.
2. Run the application:
   ```bash
   mvn spring-boot:run
   ```
   Backend will be available at `http://localhost:8080`.

### Frontend Setup
1. Navigate to the `adaptive_learning_app` folder.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

Note: For Android emulators, ensure the API base URL in `lib/services/api_service.dart` is set to `10.0.2.2`.
