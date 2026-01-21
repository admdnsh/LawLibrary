-- Create admin_users table
CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    token VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create rta_cha_68 table
CREATE TABLE IF NOT EXISTS rta_cha_68 (
    Chapter VARCHAR(20) PRIMARY KEY,
    Category VARCHAR(100) NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Description TEXT NOT NULL,
    Compound_Fine VARCHAR(100) NOT NULL,
    Second_Compound_Fine VARCHAR(100),
    Third_Compound_Fine VARCHAR(100),
    Fourth_Compound_Fine VARCHAR(100),
    Fifth_Compound_Fine VARCHAR(100)
);

-- Insert sample admin user (password: admin123)
INSERT INTO admin_users (username, password, email) VALUES
('admin', '$2y$10$8H1v5JUiMNL9Qz3TSbUQ9eMbxh6wuCu0Xk.dH2TDEjFHiGo0Ywjne', 'admin@example.com');

-- Insert sample law entries
INSERT INTO rta_cha_68 (Chapter, Category, Title, Description, Compound_Fine, Second_Compound_Fine, Third_Compound_Fine) VALUES
('A1', 'General', 'Speeding', 'Exceeding the speed limit on any road', '$100', '$200', '$300'),
('A2', 'General', 'Running Red Light', 'Failure to stop at a red traffic light', '$150', '$250', '$350'),
('B1', 'Registration', 'Expired Registration', 'Operating a vehicle with expired registration', '$75', '$150', ''),
('B2', 'Registration', 'No Registration', 'Operating a vehicle without proper registration', '$200', '$400', '$600'),
('C1', 'Licensing', 'Driving Without License', 'Operating a vehicle without a valid driver license', '$250', '$500', '$750'),
('C2', 'Licensing', 'Expired License', 'Driving with an expired driver license', '$100', '$200', ''),
('D1', 'Equipment', 'Defective Brakes', 'Operating a vehicle with defective brakes', '$300', '$600', '$900'),
('D2', 'Equipment', 'Defective Lights', 'Operating a vehicle with defective lights', '$75', '$150', '');