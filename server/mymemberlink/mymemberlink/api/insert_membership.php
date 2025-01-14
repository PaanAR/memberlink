<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$name = addslashes($_POST['name']);
$description = addslashes($_POST['description']);
$price = $_POST['price'];
$duration = $_POST['duration'];
$benefits = addslashes($_POST['benefits']);
$terms = addslashes($_POST['terms']);

$sqlinsert = "INSERT INTO `tbl_memberships` 
    (`membership_name`, `membership_desc`, `membership_price`, 
     `membership_duration`, `membership_benefits`, `membership_terms`) 
    VALUES ('$name','$description','$price','$duration','$benefits','$terms')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>