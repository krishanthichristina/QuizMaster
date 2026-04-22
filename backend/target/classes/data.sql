INSERT INTO users(name, email, password) VALUES ('Alice', 'alice@example.com', 'password123');
INSERT INTO questions(difficulty, title, option_a, option_b, option_c, option_d, correct_index) VALUES
('easy', 'What is 2 + 2?', '3', '4', '5', '6', 1),
('easy', 'Which planet is known as the Red Planet?', 'Earth', 'Mars', 'Jupiter', 'Venus', 1),
('easy', 'Which language is mainly used in Flutter?', 'Java', 'Dart', 'Kotlin', 'Swift', 1),
('medium', 'Which data structure follows FIFO?', 'Stack', 'Queue', 'Tree', 'Graph', 1),
('medium', 'HTTP status code for success?', '200', '404', '500', '301', 0),
('medium', 'Which widget updates UI reactively in Flutter?', 'setState/State management', 'File', 'Package', 'Compiler', 0),
('hard', 'What design pattern separates abstraction from data access?', 'Singleton', 'Repository', 'Factory', 'Adapter', 1),
('hard', 'Which SQL clause groups rows with aggregate functions?', 'ORDER BY', 'HAVING', 'GROUP BY', 'LIMIT', 2),
('hard', 'Which principle encourages depending on abstractions, not concretions?', 'DIP', 'SRP', 'OCP', 'LSP', 0);
