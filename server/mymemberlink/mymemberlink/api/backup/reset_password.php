<?php
header("Content-Type: application/json");

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$email = $_POST['email'];
$newPassword = $_POST['password'];

if (empty($email) || empty($newPassword)) {
    $response = array('status' => 'failed', 'data' => null, 'message' => 'Email and password are required');
    sendJsonResponse($response);
    die;
}

$checkEmailQuery = "SELECT * FROM tbl_users WHERE user_email = ?";
$stmt = $conn->prepare($checkEmailQuery);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $hashedPassword = sha1($newPassword);
    $updatePasswordQuery = "UPDATE tbl_users SET user_pass = ? WHERE user_email = ?";
    $stmt = $conn->prepare($updatePasswordQuery);
    $stmt->bind_param("ss", $hashedPassword, $email);

    if ($stmt->execute()) {
        $response = array('status' => 'success', 'data' => null, 'message' => 'Password reset successful');
    } else {
        $error = $stmt->error;
        $response = array('status' => 'failed', 'data' => null, 'message' => 'Failed to reset password: ' . $error);
    }
} else {
    $response = array('status' => 'failed', 'data' => null, 'message' => 'Email not found');
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>