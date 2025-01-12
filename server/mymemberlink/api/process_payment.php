<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

try {
    $userId = $_POST['user_id'];
    $membershipId = $_POST['membership_id'];
    $amount = $_POST['amount'];
    $paymentMethod = $_POST['payment_method'];
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
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        $stmt = $conn->prepare($sqlinsert);
        // Set initial payment status as 'pending'
        $paymentStatus = 'pending';
        $stmt->bind_param("iidsssss", 
            $userId, 
            $membershipId, 
            $amount, 
            $paymentStatus,
            $transactionId, 
            $paymentMethod, 
            $paymentProvider, 
            $expiryDate
        );
        
        if ($stmt->execute()) {
            $response = array(
                'status' => 'success',
                'data' => array(
                    'transaction_id' => $transactionId,
                    'expiry_date' => $expiryDate,
                    'payment_status' => $paymentStatus
                )
            );
        } else {
            throw new Exception("Failed to insert purchase record");
        }
    } else {
        throw new Exception("Invalid membership");
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