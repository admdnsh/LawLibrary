-- Law Library Database Setup
-- Run this in phpMyAdmin or MySQL command line

CREATE DATABASE IF NOT EXISTS law_library;
USE law_library;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    role ENUM('admin', 'officer') DEFAULT 'officer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Laws table
CREATE TABLE IF NOT EXISTS laws (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Chapter VARCHAR(50) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Title TEXT NOT NULL,
    Description TEXT,
    Compound_Fine TEXT,
    Second_Compound_Fine TEXT,
    Third_Compound_Fine TEXT,
    Fourth_Compound_Fine TEXT,
    Fifth_Compound_Fine TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_chapter (Chapter)
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, role) VALUES 
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin')
ON DUPLICATE KEY UPDATE username=username;

-- Insert sample laws data
INSERT INTO laws (Chapter, Category, Title, Description, Compound_Fine, Second_Compound_Fine, Third_Compound_Fine, Fourth_Compound_Fine, Fifth_Compound_Fine) VALUES
('1', 'Traffic', 'Speeding Violations', 'Exceeding posted speed limits', 'RM 300', 'RM 500', 'RM 1000', 'RM 2000', 'RM 5000'),
('2', 'Traffic', 'Parking Violations', 'Illegal parking in restricted areas', 'RM 100', 'RM 200', 'RM 500', 'RM 1000', 'RM 2000'),
('3', 'Business', 'License Violations', 'Operating without proper business license', 'RM 1000', 'RM 2000', 'RM 5000', 'RM 10000', 'RM 20000'),
('4', 'Environmental', 'Pollution Control', 'Violating environmental protection laws', 'RM 500', 'RM 1000', 'RM 2000', 'RM 5000', 'RM 10000'),
('5', 'Safety', 'Workplace Safety', 'Violating occupational safety regulations', 'RM 200', 'RM 500', 'RM 1000', 'RM 2000', 'RM 5000');

-- Create indexes for better performance
CREATE INDEX idx_laws_category ON laws(Category);
CREATE INDEX idx_laws_chapter ON laws(Chapter);
CREATE INDEX idx_users_username ON users(username);
