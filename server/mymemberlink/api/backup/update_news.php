<?php
include_once("dbconnect.php");

// Check if all required POST parameters are provided
if (!empty($_POST['news_id']) && !empty($_POST['news_title']) && !empty($_POST['news_details'])) {
    $news_id = $_POST['news_id'];
    $news_title = $_POST['news_title'];
    $news_details = $_POST['news_details'];

    // SQL query to update news
    $sqlUpdateNews = "UPDATE `tbl_news` 
                      SET `news_title` = ?, 
                          `news_details` = ?, 
                          `is_edited` = 1
                      WHERE `news_id` = ?";

    // Prepare and execute the statement
    $stmt = $conn->prepare($sqlUpdateNews);
    if ($stmt) {
        $stmt->bind_param("ssi", $news_title, $news_details, $news_id);

        if ($stmt->execute()) {
            // Success response
            $response = array(
                'status' => 'success',
                'message' => 'News updated successfully',
                'updated_news_id' => $news_id
            );
        } else {
            // Failure response with MySQL error
            $response = array(
                'status' => 'failed',
                'message' => 'Failed to update news: ' . $stmt->error
            );
        }

        $stmt->close();
    } else {
        // Failure response for statement preparation error
        $response = array(
            'status' => 'failed',
            'message' => 'Failed to prepare statement: ' . $conn->error
        );
    }
} else {
    // Missing required parameters
    $response = array(
        'status' => 'failed',
        'message' => 'Missing required parameters'
    );
}

// Close the database connection
$conn->close();

// Send JSON response
sendJsonResponse($response);

// Function to send a JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
