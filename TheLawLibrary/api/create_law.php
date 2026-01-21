<?php
// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set headers to allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Handle preflight requests for CORS
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

// Get the raw POST data (Flutter sends JSON body)
$json_data = file_get_contents("php://input");
$data = json_decode($json_data, true); // Decode JSON into an associative array

// Check if JSON decoding was successful and data is an array
if (json_last_error() !== JSON_ERROR_NONE || !is_array($data)) {
    echo json_encode(['success' => false, 'message' => 'Invalid JSON input or empty data received.']);
    exit();
}

// Get data from the decoded JSON array
// Use empty string as default if key is not set, to prevent warnings
$chapter = isset($data['Chapter']) ? $data['Chapter'] : '';
$category = isset($data['Category']) ? $data['Category'] : '';
$title = isset($data['Title']) ? $data['Title'] : '';
$description = isset($data['Description']) ? $data['Description'] : '';
$compoundFine = isset($data['Compound_Fine']) ? $data['Compound_Fine'] : '';
$secondCompoundFine = isset($data['Second_Compound_Fine']) ? $data['Second_Compound_Fine'] : '';
$thirdCompoundFine = isset($data['Third_Compound_Fine']) ? $data['Third_Compound_Fine'] : '';
$fourthCompoundFine = isset($data['Fourth_Compound_Fine']) ? $data['Fourth_Compound_Fine'] : '';
$fifthCompoundFine = isset($data['Fifth_Compound_Fine']) ? $data['Fifth_Compound_Fine'] : '';

// Validate required fields
if (empty($chapter) || empty($category) || empty($title)) {
    echo json_encode(['success' => false, 'message' => 'Chapter, Category, and Title are required.']);
    exit();
}

try {
    // Connect to database
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Check if chapter already exists (assuming Chapter is unique)
    $checkStmt = $conn->prepare("SELECT COUNT(*) FROM rta_cha_68 WHERE Chapter = :chapter");
    $checkStmt->bindParam(':chapter', $chapter);
    $checkStmt->execute();
    
    if ($checkStmt->fetchColumn() > 0) {
        echo json_encode(['success' => false, 'message' => 'A law with this chapter already exists.']);
        exit();
    }
    
    // Prepare the insert statement
    $stmt = $conn->prepare("INSERT INTO rta_cha_68 (Chapter, Category, Title, Description, Compound_Fine, Second_Compound_Fine, Third_Compound_Fine, Fourth_Compound_Fine, Fifth_Compound_Fine) 
                            VALUES (:chapter, :category, :title, :description, :compound_fine, :second_compound_fine, :third_compound_fine, :fourth_compound_fine, :fifth_compound_fine)");
    
    // Bind parameters
    $stmt->bindParam(':chapter', $chapter);
    $stmt->bindParam(':category', $category);
    $stmt->bindParam(':title', $title);
    $stmt->bindParam(':description', $description);
    $stmt->bindParam(':compound_fine', $compoundFine);
    $stmt->bindParam(':second_compound_fine', $secondCompoundFine);
    $stmt->bindParam(':third_compound_fine', $thirdCompoundFine);
    $stmt->bindParam(':fourth_compound_fine', $fourthCompoundFine);
    $stmt->bindParam(':fifth_compound_fine', $fifthCompoundFine);
    
    // Execute the statement
    $stmt->execute();
    
    echo json_encode(['success' => true, 'message' => 'Law created successfully!']);
    
} catch (PDOException $e) {
    // Log the actual database error for debugging on the server side
    error_log("Database error in create_law.php: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
