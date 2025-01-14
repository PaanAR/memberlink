<?php
// Suppress all error reporting for cleaner output in production
// error_reporting(0);

// Check if 'email' and 'password' are set in the POST request
if (!isset($_POST['email']) || !isset($_POST['password'])) {
    $response = array('status' => 'failed', 'data' => null); // Prepare failure response
    sendJsonResponse($response); // Send the response as JSON
    die; // Terminate script execution
}

// Include database connection file to establish connection with the database
include_once("dbconnect.php");

// Retrieve the 'email' and 'password' values from the POST request
$email = $_POST['email'];
$password = sha1($_POST['password']); // Hash the password using SHA-1 for comparison

// SQL query to check if a user with the provided email and hashed password exists in tbl_users
$sqllogin = "SELECT user_id, user_email, user_name, user_phoneNum, user_pass FROM tbl_users WHERE user_email = '$email' AND user_pass = '$password'";

// Perform the query
$result = $conn->query($sqllogin);

// Send response based on the query result
if ($result->num_rows > 0) {
    $userlist = array();
    while ($row = $result->fetch_assoc()) {
        $userlist['userid'] = $row['user_id'];
        $userlist['useremail'] = $row['user_email'];
        $userlist['username'] = $row['user_name'];
        $userlist['userphone'] = $row['user_phoneNum'];
    }
    $response = array('status' => 'success', 'data' => $userlist);
} else {
    $response = array('status' => 'failed', 'data' => null);
}

// Send the JSON response
sendJsonResponse($response);

// Function to send a JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json'); // Set response header to JSON format
    echo json_encode($sentArray); // Convert the array to JSON and output it
}

$conn->close();
?>
