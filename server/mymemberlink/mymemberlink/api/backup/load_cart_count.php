<?php
include_once("dbconnect.php");

$sqlloadcartcount = "SELECT COUNT(*) AS cart_count FROM tbl_cart";
$result = $conn->query($sqlloadcartcount);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response = array('status' => 'success', 'cart_count' => (int)$row['cart_count']);
} else {
    $response = array('status' => 'failed', 'cart_count' => 0);
}

header('Content-Type: application/json');
echo json_encode($response);
?>
