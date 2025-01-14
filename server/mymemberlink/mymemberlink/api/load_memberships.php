<?php
include_once("dbconnect.php");

$sqlloadmemberships = "SELECT * FROM tbl_memberships WHERE membership_status = 'active' ORDER BY membership_price ASC";
$result = $conn->query($sqlloadmemberships);

if ($result->num_rows > 0) {
    $membershipsarray["memberships"] = array();
    while ($row = $result->fetch_assoc()) {
        $membership = array();
        $membership['membership_id'] = $row['membership_id'];
        $membership['membership_name'] = $row['membership_name'];
        $membership['membership_desc'] = $row['membership_desc'];
        $membership['membership_price'] = $row['membership_price'];
        $membership['membership_duration'] = $row['membership_duration'];
        $membership['membership_benefits'] = $row['membership_benefits'];
        $membership['membership_terms'] = $row['membership_terms'];
        $membership['membership_status'] = $row['membership_status'];
        $membership['membership_date'] = $row['membership_date'];
        array_push($membershipsarray["memberships"], $membership);
    }
    $response = array('status' => 'success', 'data' => $membershipsarray);
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