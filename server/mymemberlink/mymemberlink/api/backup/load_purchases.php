<?php
if (!isset($_GET['user_id'])) {
    $response = array('status' => 'failed', 'message' => 'No user ID provided');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$userId = $_GET['user_id'];

$sqlloadpurchases = "SELECT p.*, m.membership_name 
    FROM tbl_membership_purchases p 
    JOIN tbl_memberships m ON p.membership_id = m.membership_id 
    WHERE p.user_id = '$userId' 
    ORDER BY p.purchase_date DESC";

$result = $conn->query($sqlloadpurchases);

if ($result->num_rows > 0) {
    $purchasesarray["purchases"] = array();
    while ($row = $result->fetch_assoc()) {
        $purchase = array();
        $purchase['purchase_id'] = $row['purchase_id'];
        $purchase['membership_id'] = $row['membership_id'];
        $purchase['membership_name'] = $row['membership_name'];
        $purchase['purchase_amount'] = $row['purchase_amount'];
        $purchase['purchase_date'] = $row['purchase_date'];
        $purchase['payment_status'] = $row['payment_status'];
        $purchase['transaction_id'] = $row['transaction_id'];
        $purchase['payment_method'] = $row['payment_method'];
        $purchase['expiry_date'] = $row['expiry_date'];
        array_push($purchasesarray["purchases"], $purchase);
    }
    $response = array('status' => 'success', 'data' => $purchasesarray);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'No purchases found');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>