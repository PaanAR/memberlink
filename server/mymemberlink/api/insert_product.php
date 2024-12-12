<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$name = addslashes($_POST['name']);
$description = addslashes($_POST['description']);
$quantity = $_POST['quantity'];
$price = $_POST['price'];
$status = $_POST['status'];
$image = ($_POST['image']);
$decoded_image = base64_decode($image);

$filename = "product-".randomfilename(10).".jpg";

 $sqlinsertevent="INSERT INTO `tbl_products`(`product_name`, `product_desc`, `product_price`,`product_qty`,`product_status`, `product_filename`) VALUES ('$name','$description','$price','$quantity','$status','$filename')";

if ($conn->query($sqlinsertevent) === TRUE) {
    $path = "../assets/products/". $filename;
    file_put_contents($path, $decoded_image);
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function randomfilename($length) {
    $key = '';
    $keys = array_merge(range(0, 9), range('a', 'z'));

    for ($i = 0; $i < $length; $i++) {
        $key .= $keys[array_rand($keys)];
    }
    return $key;
}
	

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>