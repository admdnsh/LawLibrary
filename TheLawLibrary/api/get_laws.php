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

// Get page and limit parameters
$page = isset($_GET['page']) ? intval($_GET['page']) : 1;
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : 10;
$offset = ($page - 1) * $limit;

// Get search and filter parameters
$search = isset($_GET['search']) ? $_GET['search'] : '';
$category = isset($_GET['category']) ? $_GET['category'] : '';

try {
    // Connect to database
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Build the query base
    $query = "SELECT * FROM rta_cha_68 WHERE 1=1";
    $params = [];
    
    // Add search condition if provided
    if (!empty($search)) {
        $query .= " AND (Chapter LIKE :search OR Title LIKE :search OR Description LIKE :search)";
        $searchParam = "%$search%";
        $params[':search'] = $searchParam;
    }
    
    // Add category filter if provided
    if (!empty($category)) {
        $query .= " AND Category = :category";
        $params[':category'] = $category;
    }
    
    // Add pagination
    $query .= " ORDER BY Chapter LIMIT :limit OFFSET :offset";
    $params[':limit'] = $limit;
    $params[':offset'] = $offset;
    
    // Prepare and execute the query
    $stmt = $conn->prepare($query);
    
    // Bind parameters
    foreach ($params as $key => $value) {
        if ($key === ':limit' || $key === ':offset') {
            $stmt->bindValue($key, $value, PDO::PARAM_INT);
        } else {
            $stmt->bindValue($key, $value, PDO::PARAM_STR);
        }
    }
    
    $stmt->execute();
    
    // Fetch the results
    $laws = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Return the results as JSON
    echo json_encode($laws);
    
} catch (PDOException $e) {
    // Return error as JSON
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
