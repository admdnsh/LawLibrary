<?php
// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set headers to allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database connection parameters
$host = 'localhost';
$db = 'law_library';
$user = 'root';
$pass = '';
$port = 3306;

try {
    // Connect to database
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Query to get unique categories
    $stmt = $conn->query("SELECT DISTINCT Category FROM rta_cha_68 ORDER BY Category");
    
    // Fetch all categories
    $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Return the results as JSON
    echo json_encode($categories);
    
} catch (PDOException $e) {
    // Return error as JSON
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
