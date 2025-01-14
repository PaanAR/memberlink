<?php
if (!isset($_POST['product_id']) || !isset($_POST['quantity'])) {
    $response = array('status' => 'failed', 'message' => 'Invalid parameters');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$product_id = $_POST['product_id'];
$quantity = $_POST['quantity'];
$user_id = 1; // Replace with dynamic user identification (e.g., session ID)

// Fetch product details to calculate price
$sql = "SELECT product_price FROM tbl_products WHERE product_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $price = $row['product_price'] * $quantity;

    // Check if the product already exists in the cart
    $check_cart_sql = "SELECT * FROM tbl_cart WHERE product_id = ? AND user_id = ?";
    $check_cart_stmt = $conn->prepare($check_cart_sql);
    $check_cart_stmt->bind_param("ii", $product_id, $user_id);
    $check_cart_stmt->execute();
    $check_cart_result = $check_cart_stmt->get_result();

    if ($check_cart_result->num_rows > 0) {
        // Update the quantity and price
        $update_sql = "UPDATE tbl_cart SET quantity = quantity + ?, price = price + ? WHERE product_id = ? AND user_id = ?";
        $update_stmt = $conn->prepare($update_sql);
        $update_stmt->bind_param("idii", $quantity, $price, $product_id, $user_id);
        $update_stmt->execute();
    } else {
        // Insert new cart entry
        $insert_sql = "INSERT INTO tbl_cart (product_id, quantity, price, user_id) VALUES (?, ?, ?, ?)";
        $insert_stmt = $conn->prepare($insert_sql);
        $insert_stmt->bind_param("iidi", $product_id, $quantity, $price, $user_id);
        $insert_stmt->execute();
    }

    $response = array('status' => 'success', 'message' => 'Product added to cart');
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'Product not found');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
