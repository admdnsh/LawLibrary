<?php
// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set headers to allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
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

// Check if request is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Only POST requests are allowed']);
    exit();
}

// Get JSON input from the request body
$input = json_decode(file_get_contents('php://input'), true);

// Get chapter from the decoded JSON data
$chapter = isset($input['Chapter']) ? $input['Chapter'] : ''; // Corrected to use $input and 'Chapter'

if (empty($chapter)) {
    echo json_encode(['success' => false, 'message' => 'Chapter is required']);
    exit();
}

try {
    // Connect to database
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Check if chapter exists
    $checkStmt = $conn->prepare("SELECT COUNT(*) FROM rta_cha_68 WHERE Chapter = :chapter");
    $checkStmt->bindParam(':chapter', $chapter);
    $checkStmt->execute();
    
    if ($checkStmt->fetchColumn() == 0) {
        echo json_encode(['success' => false, 'message' => 'Law not found']);
        exit();
    }
    
    // Prepare and execute the delete statement
    $stmt = $conn->prepare("DELETE FROM rta_cha_68 WHERE Chapter = :chapter");
    $stmt->bindParam(':chapter', $chapter);
    $stmt->execute();
    
    echo json_encode(['success' => true, 'message' => 'Law deleted successfully']);
    
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
