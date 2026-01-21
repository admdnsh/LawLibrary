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

// Get the chapter parameter
$chapter = isset($_GET['chapter']) ? $_GET['chapter'] : '';

if (empty($chapter)) {
    echo json_encode(['error' => 'Chapter parameter is required']);
    exit();
}

try {
    // Connect to database
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Prepare and execute the query
    $stmt = $conn->prepare("SELECT * FROM rta_cha_68 WHERE Chapter = :chapter");
    $stmt->bindParam(':chapter', $chapter);
    $stmt->execute();
    
    // Check if law exists
    if ($stmt->rowCount() > 0) {
        $law = $stmt->fetch(PDO::FETCH_ASSOC);
        echo json_encode($law);
    } else {
        echo json_encode(['error' => 'Law not found']);
    }
    
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
