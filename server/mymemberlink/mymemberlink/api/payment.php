<?php
//error_reporting(0);

$email = $_GET['email']; //email
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$userid = $_GET['userid'];
$amount = $_GET['amount']; 
$membershipId = isset($_GET['membershipId']) ? $_GET['membershipId'] : null;

$api_key = '6afacf10-4592-4fb3-b6b1-75d8f3552745';
$collection_id = '0f4fgwpo';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

// Build redirect URL with membership ID if present
$redirect_url = "https://humancc.site/ndhos/mmlink/mymemberlink/api/payment_update.php?userid=$userid&email=$email&phone=$phone&amount=$amount&name=$name";
if ($membershipId) {
    $redirect_url .= "&membershipId=$membershipId";
}

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $phone,
          'name' => $name,
          'amount' => ($amount) * 100, // RM20
          'description' => 'Payment for order by '.$name,
          'callback_url' => "https://humancc.site/ndhos/mmlink/mymemberlink/return_url",
          'redirect_url' => $redirect_url
);

// Debugging input parameters
var_dump($data); // Print the data array to ensure parameters are set correctly

// Send the API request
$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data));

// Capture the response
$return = curl_exec($process);

// Check for any cURL errors
if ($return === false) {
    echo 'cURL Error: ' . curl_error($process);
}

curl_close($process);

// Decode the response
$bill = json_decode($return, true);

// Debug the response
var_dump($bill); // Print the response to see if the URL is returned

// Check if the 'url' key exists and redirect
if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
} else {
    echo "Error: No URL received from BillPlz.";
}
?>