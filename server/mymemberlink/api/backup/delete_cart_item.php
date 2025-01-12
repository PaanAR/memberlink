<?php

include_once("dbconnect.php");

// Check if `product_id` is provided in the POST request
if (isset($_POST['cart_id'])) {
    $cart_id = $_POST['cart_id'];

    // SQL query to delete the cart item with the given `product_id`
    $sqlDeleteCartItem = "DELETE FROM `tbl_cart` WHERE `cart_id` = ?";

    // Prepare and execute the SQL statement to prevent SQL injection
    $stmt = $conn->prepare($sqlDeleteCartItem);
    $stmt->bind_param("i", $cart_id);

    if ($stmt->execute()) {
        $response = array('status' => 'success', 'message' => 'Cart item deleted successfully');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to delete cart item');
    }

    $stmt->close(); // Close the prepared statement
} else {
    // If `product_id` is not provided
    $response = array('status' => 'failed', 'message' => 'Missing product_id');
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