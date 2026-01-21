<?php
// Database connection configuration for Docker
$host = 'mysql';  // Docker service name
$db = 'law_library';
$user = 'root';
$pass = 'lawlibrary123';  // Docker MySQL password
$port = 3306;

try {
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db;charset=utf8mb4", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    return $conn;
} catch (PDOException $e) {
    die(json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]));
}
?>
