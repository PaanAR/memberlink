<?php
include_once("dbconnect.php");

$user_id = 1; // Replace with dynamic user identification (e.g., session ID)

// Fetch cart items
$sql = "SELECT c.cart_id, c.quantity, c.price, p.product_name, p.product_filename
        FROM tbl_cart c
        JOIN tbl_products p ON c.product_id = p.product_id
        WHERE c.user_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $cart = array();
    while ($row = $result->fetch_assoc()) {
        $cart[] = $row;
    }
    $response = array('status' => 'success', 'data' => array('cart' => $cart));
} else {
    $response = array('status' => 'failed', 'message' => 'Cart is empty');
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
