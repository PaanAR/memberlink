<?php
ob_start(); // Start output buffering
ini_set('display_errors', 0); // Disable displaying errors
error_reporting(0); // Turn off error reporting
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (!isset($_POST['cart_id']) || !isset($_POST['quantity'])) {
    $response = array('status' => 'failed', 'message' => 'Invalid parameters');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$cart_id = $_POST['cart_id'];
$quantity = $_POST['quantity'];

if ($quantity <= 0) {
    $response = array('status' => 'failed', 'message' => 'Quantity must be greater than 0');
    sendJsonResponse($response);
    die;
}

// Update the quantity in the cart
$update_sql = "UPDATE tbl_cart SET quantity = ?, price = (quantity * product_price) WHERE cart_id = ?";
$stmt = $conn->prepare($update_sql);
$stmt->bind_param("ii", $quantity, $cart_id);

if (!$stmt->execute()) {
    $response = array('status' => 'failed', 'message' => 'SQL Error: ' . $stmt->error);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'success', 'message' => 'Cart item updated successfully');
    sendJsonResponse($response);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    ob_clean(); // Clean any previous output
    echo json_encode($sentArray);
    exit;
}
