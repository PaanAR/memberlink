<?php
// Suppress all error reporting for cleaner output in production
// error_reporting(0);

// Check if required POST variables are set
if (!isset($_POST['email'], $_POST['password'])) {
    $response = array('status' => 'failed', 'data' => null); // Prepare failure response
    sendJsonResponse($response); // Send the response as JSON
    die; // Terminate script execution
}

// Include database connection file to establish connection with the database
include_once("dbconnect.php");

// Retrieve the values from the POST request
$email = $_POST['email'];
$password = sha1($_POST['password']); // Hash the password using SHA-1 for security

// SQL query to insert a new admin into `tbl_admins`
$sqlregister = "INSERT INTO `tbl_admins` (`admin_email`, `admin_pass`) VALUES ('$email', '$password')";
$result = $conn->query($sqlregister); // Execute the query

// Check if the query was successful
if ($result === TRUE) {
    $response = array('status' => 'success', 'data' => null); // Prepare success response
} else {
    $response = array('status' => 'failed', 'data' => null); // Prepare failure response
}

sendJsonResponse($response); // Send the JSON response

// Function to send a JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json'); // Set response header to JSON format
    echo json_encode($sentArray); // Convert the array to JSON and output it
}
?>
