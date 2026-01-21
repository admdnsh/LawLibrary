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

// Read the raw POST data
$input = file_get_contents('php://input');
// Decode the JSON data
$data = json_decode($input, true); // true for associative array

// Get data from the decoded JSON
$chapter = isset($data['Chapter']) ? $data['Chapter'] : ''; // This is the NEW chapter value
$originalChapter = isset($data['Original_Chapter']) ? $data['Original_Chapter'] : $chapter; // Get original chapter, default to new if not provided
$category = isset($data['Category']) ? $data['Category'] : '';
$title = isset($data['Title']) ? $data['Title'] : '';
$description = isset($data['Description']) ? $data['Description'] : '';
$compoundFine = isset($data['Compound_Fine']) ? $data['Compound_Fine'] : '';
$secondCompoundFine = isset($data['Second_Compound_Fine']) ? $data['Second_Compound_Fine'] : '';
$thirdCompoundFine = isset($data['Third_Compound_Fine']) ? $data['Third_Compound_Fine'] : '';
$fourthCompoundFine = isset($data['Fourth_Compound_Fine']) ? $data['Fourth_Compound_Fine'] : '';
$fifthCompoundFine = isset($data['Fifth_Compound_Fine']) ? $data['Fifth_Compound_Fine'] : '';

// Validate required fields
// Ensure all necessary fields are present in the decoded JSON
if (empty($chapter) || empty($category) || empty($title) || empty($originalChapter)) {
    echo json_encode(['success' => false, 'message' => 'Original Chapter, Chapter, Category, and Title are required']);
    exit();
}

try {
    // Connect to database
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // If the chapter value itself is being changed, we need to ensure the new chapter doesn't already exist
    if ($chapter !== $originalChapter) {
        $checkNewChapterStmt = $conn->prepare("SELECT COUNT(*) FROM rta_cha_68 WHERE Chapter = :newChapter");
        $checkNewChapterStmt->bindParam(':newChapter', $chapter);
        $checkNewChapterStmt->execute();
        if ($checkNewChapterStmt->fetchColumn() > 0) {
            echo json_encode(['success' => false, 'message' => 'The new chapter value already exists for another law.']);
            exit();
        }
    }
    
    // Check if the original law exists before attempting to update
    $checkOriginalStmt = $conn->prepare("SELECT COUNT(*) FROM rta_cha_68 WHERE Chapter = :originalChapter");
    $checkOriginalStmt->bindParam(':originalChapter', $originalChapter);
    $checkOriginalStmt->execute();
    
    if ($checkOriginalStmt->fetchColumn() == 0) {
        echo json_encode(['success' => false, 'message' => 'Original law not found for update']);
        exit();
    }
    
    // Prepare the update statement
    $stmt = $conn->prepare("UPDATE rta_cha_68 SET 
                            Chapter = :chapter,
                            Category = :category,
                            Title = :title,
                            Description = :description,
                            Compound_Fine = :compound_fine,
                            Second_Compound_Fine = :second_compound_fine,
                            Third_Compound_Fine = :third_compound_fine,
                            Fourth_Compound_Fine = :fourth_compound_fine,
                            Fifth_Compound_Fine = :fifth_compound_fine,
                            updated_at = CURRENT_TIMESTAMP()
                            WHERE Chapter = :originalChapter"); // Use originalChapter in WHERE clause
    
    // Bind parameters
    $stmt->bindParam(':chapter', $chapter); // This is the potentially new chapter
    $stmt->bindParam(':category', $category);
    $stmt->bindParam(':title', $title);
    $stmt->bindParam(':description', $description);
    $stmt->bindParam(':compound_fine', $compoundFine);
    $stmt->bindParam(':second_compound_fine', $secondCompoundFine);
    $stmt->bindParam(':third_compound_fine', $thirdCompoundFine);
    $stmt->bindParam(':fourth_compound_fine', $fourthCompoundFine);
    $stmt->bindParam(':fifth_compound_fine', $fifthCompoundFine);
    $stmt->bindParam(':originalChapter', $originalChapter); // Bind the original chapter
    
    // Execute the statement
    $stmt->execute();
    
    echo json_encode(['success' => true, 'message' => 'Law updated successfully']);
    
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
