<?php
if (!isset($_POST['transaction_id']) || !isset($_POST['status'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

try {
    $transactionId = $_POST['transaction_id'];
    $status = $_POST['status'];

    $sql = "UPDATE tbl_membership_purchases SET payment_status = ? WHERE transaction_id = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $status, $transactionId);
    
    if ($stmt->execute()) {
        $response = array(
            'status' => 'success',
            'message' => 'Payment status updated successfully'
        );
    } else {
        throw new Exception("Failed to update payment status");
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