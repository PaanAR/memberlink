<?php

include_once("dbconnect.php");

// Check if `news_id` is provided in the POST request
if (isset($_POST['news_id'])) {
    $news_id = $_POST['news_id'];

    // SQL query to delete the news item with the given `news_id`
    $sqlDeleteNews = "DELETE FROM `tbl_news` WHERE `news_id` = ?";

    // Prepare and execute the SQL statement to prevent SQL injection
    $stmt = $conn->prepare($sqlDeleteNews);
    $stmt->bind_param("i", $news_id);

    if ($stmt->execute()) {
        $response = array('status' => 'success', 'message' => 'News deleted successfully');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to delete news');
    }

    $stmt->close(); // Close the prepared statement
} else {
    // If `news_id` is not provided
    $response = array('status' => 'failed', 'message' => 'Missing news_id');
}

$conn->close(); // Close the database connection

sendJsonResponse($response); // Send the JSON response

// Function to send a JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json'); // Set response header to JSON format
    echo json_encode($sentArray); // Convert the array to JSON and output it
}
?>
