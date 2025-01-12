<?php
if (!isset($_POST['user_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userId = $_POST['user_id'];

// First get user details with correct column names
$userSql = "SELECT user_name, user_email, user_phoneNum FROM tbl_users WHERE user_id = ?";

try {
    $userStmt = $conn->prepare($userSql);
    $userStmt->bind_param("i", $userId);
    $userStmt->execute();
    $userResult = $userStmt->get_result();
    $userDetails = $userResult->fetch_assoc();

    // Then get payments with membership details
    $sql = "SELECT p.*, m.membership_name, u.user_name, u.user_email, u.user_phoneNum 
            FROM tbl_membership_purchases p 
            JOIN tbl_memberships m ON p.membership_id = m.membership_id 
            JOIN tbl_users u ON p.user_id = u.user_id 
            WHERE p.user_id = ? 
            ORDER BY p.purchase_date DESC";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $payments = array();
    while ($row = $result->fetch_assoc()) {
        $payments[] = $row;
    }
    
    if (count($payments) > 0) {
        $response = array(
            'status' => 'success',
            'data' => array(
                'payments' => $payments,
                'user_name' => $userDetails['user_name'],
                'user_email' => $userDetails['user_email'],
                'user_phone' => $userDetails['user_phoneNum']  // Note: keeping 'user_phone' in response for consistency
            )
        );
    } else {
        $response = array(
            'status' => 'success',
            'data' => array(
                'payments' => array(),
                'user_name' => $userDetails['user_name'],
                'user_email' => $userDetails['user_email'],
                'user_phone' => $userDetails['user_phoneNum']  // Note: keeping 'user_phone' in response for consistency
            )
        );
    }
} catch (Exception $e) {
    $response = array(
        'status' => 'failed',
        'message' => $e->getMessage()
    );
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>