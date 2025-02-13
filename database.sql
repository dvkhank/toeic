CREATE DATABASE toeic;
USE toeic;

-- Bảng Users (Người dùng)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Exam Types (Loại bài test)
CREATE TABLE exam_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Bảng Parts (Phần của đề TOEIC, Part 1 -> Part 7)
CREATE TABLE parts (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Bảng Categories (Dạng bài trong mỗi Part)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    part_id INT NOT NULL,
    FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE
);

-- Bảng Test Sets (Bộ đề ETS)
CREATE TABLE test_sets (
    test_set_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Bảng Questions (Câu hỏi + Đáp án)
CREATE TABLE questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL, -- Nội dung câu hỏi
    answer_a VARCHAR(255) NOT NULL,
    answer_b VARCHAR(255) NOT NULL,
    answer_c VARCHAR(255) NOT NULL,
    answer_d VARCHAR(255) NOT NULL,
    correct_answer ENUM('A', 'B', 'C', 'D') NOT NULL, -- Đáp án đúng
    category_id INT NOT NULL, -- Dạng bài (VD: Sentence Completion)
    test_set_id INT NOT NULL, -- Câu hỏi thuộc bộ test nào
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    FOREIGN KEY (test_set_id) REFERENCES test_sets(test_set_id) ON DELETE CASCADE
);

-- Bảng Exams (Lịch sử bài test của User)
CREATE TABLE exams (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type_id INT NOT NULL, -- Mini Test hay Full Test
    test_set_id INT, -- Nếu là Full Test thì có giá trị này
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES exam_types(type_id) ON DELETE CASCADE,
    FOREIGN KEY (test_set_id) REFERENCES test_sets(test_set_id) ON DELETE CASCADE
);

-- Bảng Exam Questions (Lưu câu hỏi + câu trả lời của user)
CREATE TABLE exam_questions (
    exam_question_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL, -- ID bài thi của user
    question_id INT NOT NULL, -- ID câu hỏi
    user_answer ENUM('A', 'B', 'C', 'D'), -- Đáp án user chọn
    is_correct BOOLEAN, -- Đúng/Sai
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
);

USE toeic;

-- Thêm người dùng
INSERT INTO users (username, email, password_hash) VALUES
('khanhduong', 'khanh@example.com', 'hashed_password_123'),
('john_doe', 'john@example.com', 'hashed_password_456');

-- Thêm loại bài test
INSERT INTO exam_types (name) VALUES
('Mini Test'),
('Full Test');

-- Thêm các phần của đề TOEIC
INSERT INTO parts (name) VALUES
('Part 1 - Photographs'),
('Part 2 - Question-Response'),
('Part 3 - Conversations'),
('Part 4 - Talks'),
('Part 5 - Incomplete Sentences'),
('Part 6 - Text Completion'),
('Part 7 - Reading Comprehension');

-- Thêm dạng bài trong mỗi Part
INSERT INTO categories (name, part_id) VALUES
('Photographs', 1),
('Question-Response', 2),
('Conversations', 3),
('Talks', 4),
('Sentence Completion', 5),
('Text Completion', 6),
('Reading Comprehension', 7);

-- Thêm bộ đề ETS
INSERT INTO test_sets (name, description) VALUES
('ETS 2024 - Test 1', 'Bộ đề TOEIC chính thức năm 2024 - Đề 1'),
('ETS 2024 - Test 2', 'Bộ đề TOEIC chính thức năm 2024 - Đề 2');

-- Thêm câu hỏi vào bộ đề ETS
INSERT INTO questions (content, answer_a, answer_b, answer_c, answer_d, correct_answer, category_id, test_set_id) VALUES
('What is the capital of France?', 'Berlin', 'Madrid', 'Paris', 'Rome', 'C', 5, 1),
('Choose the correct form: "He ____ to school every day."', 'go', 'goes', 'going', 'gone', 'B', 5, 1),
('Which word is a synonym of "happy"?', 'Sad', 'Joyful', 'Angry', 'Tired', 'B', 7, 2),
('What is the opposite of "increase"?', 'Reduce', 'Expand', 'Grow', 'Rise', 'A', 7, 2);

-- Thêm bài thi của người dùng
INSERT INTO exams (user_id, type_id, test_set_id) VALUES
(1, 2, 1), -- User 1 làm Full Test 1
(2, 1, 2); -- User 2 làm Mini Test từ Test 2

-- Thêm câu hỏi vào bài thi của người dùng
INSERT INTO exam_questions (exam_id, question_id, user_answer, is_correct) VALUES
(1, 1, 'C', TRUE),  -- User 1 trả lời đúng câu hỏi 1
(1, 2, 'A', FALSE), -- User 1 trả lời sai câu hỏi 2
(2, 3, 'B', TRUE),  -- User 2 trả lời đúng câu hỏi 3
(2, 4, 'D', FALSE); -- User 2 trả lời sai câu hỏi 4

