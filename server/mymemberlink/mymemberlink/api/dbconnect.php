<?php
$servername = "localhost"; // or your specific port
$username   = "humancmt_mmlink";
$password   = "kW;oU)wm=4J9";
$dbname     = "humancmt_mmlink";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error); // Connection failed message
} 
// Removed the "Connected successfully" echo statement to prevent extra output
?>
