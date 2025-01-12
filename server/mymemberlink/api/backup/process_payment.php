<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$userId = $_POST['user_id'];
$membershipId = $_POST['membership_id'];
$amount = $_POST['amount'];
$paymentMethod = $_POST['payment_method'];
// Add payment_provider to the database table and insert query
$paymentProvider = $_POST['payment_provider'];

// Get membership details to calculate expiry date
$sqlmembership = "SELECT membership_duration FROM tbl_memberships WHERE membership_id = '$membershipId'";
$result = $conn->query($sqlmembership);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $duration = $row['membership_duration'];
    
    // Calculate expiry date
    $expiryDate = date('Y-m-d H:i:s', strtotime("+$duration months"));
    
    // Generate transaction ID
    $transactionId = uniqid('TRX');
    
    $sqlinsert = "INSERT INTO `tbl_membership_purchases` 
    (`user_id`, `membership_id`, `purchase_amount`, `payment_status`, 
     `transaction_id`, `payment_method`, `payment_provider`, `expiry_date`) 
    VALUES ('$userId', '$membershipId', '$amount', 'paid', 
            '$transactionId', '$paymentMethod', '$paymentProvider', '$expiryDate')";
    
    if ($conn->query($sqlinsert) === TRUE) {
        $response = array('status' => 'success', 'data' => array(
            'transaction_id' => $transactionId,
            'expiry_date' => $expiryDate
        ));
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Database error');
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'message' => 'Invalid membership');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>