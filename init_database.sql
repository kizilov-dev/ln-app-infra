-- Initialize database
CREATE DATABASE IF NOT EXISTS language_learning_app;
USE language_learning_app;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    target_language VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Topics table
CREATE TABLE IF NOT EXISTS topics (
    topic_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    difficulty_level ENUM('beginner', 'intermediate', 'advanced') NOT NULL,
    min_duration_seconds INT NOT NULL DEFAULT 60,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Useful phrases table
CREATE TABLE IF NOT EXISTS phrases (
    phrase_id INT PRIMARY KEY AUTO_INCREMENT,
    phrase_text VARCHAR(255) NOT NULL,
    translation TEXT,
    difficulty_level ENUM('beginner', 'intermediate', 'advanced') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Link between topics and phrases
CREATE TABLE IF NOT EXISTS topic_phrases (
    topic_id INT,
    phrase_id INT,
    PRIMARY KEY (topic_id, phrase_id),
    FOREIGN KEY (topic_id) REFERENCES topics(topic_id) ON DELETE CASCADE,
    FOREIGN KEY (phrase_id) REFERENCES phrases(phrase_id) ON DELETE CASCADE
);

-- User recordings table
CREATE TABLE IF NOT EXISTS recordings (
    recording_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    topic_id INT NOT NULL,
    audio_file_path VARCHAR(255) NOT NULL,
    transcribed_text TEXT,
    corrected_text TEXT,
    ai_audio_file_path VARCHAR(255),
    duration_seconds INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES topics(topic_id) ON DELETE CASCADE
);

-- User progress table
CREATE TABLE IF NOT EXISTS user_progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_activity_date DATE,
    total_recordings INT DEFAULT 0,
    total_practice_time_seconds INT DEFAULT 0,
    level_points INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Add some indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_recordings_user_id ON recordings(user_id);
CREATE INDEX idx_recordings_topic_id ON recordings(topic_id);
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_topic_phrases_topic_id ON topic_phrases(topic_id);
