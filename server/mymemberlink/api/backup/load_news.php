<?php

include_once("dbconnect.php");
$result_per_page = 10;

// Determine the page number
$pageno = isset($_GET['pageno']) ? (int)$_GET['pageno'] : 1;

$page_first_result = ($pageno - 1) * $result_per_page;

// Count total results and calculate number of pages
$total_result = $conn->query("SELECT COUNT(*) AS total FROM tbl_news")->fetch_assoc()['total'];
$number_of_page = ceil($total_result / $result_per_page);

// Select required columns with pagination
$sqlloadnews = "SELECT news_id, news_title, news_details, news_date, is_edited 
                FROM tbl_news ORDER BY news_date DESC 
                LIMIT $page_first_result, $result_per_page";

$result = $conn->query($sqlloadnews);

// Check if the query returned any rows
if ($result->num_rows > 0) {
    $newsarray['news'] = array();
    while ($row = $result->fetch_assoc()) {
        $news = array(
            'news_id' => $row['news_id'],
            'news_title' => $row['news_title'],
            'news_details' => $row['news_details'],
            'news_date' => $row['news_date'],
            'is_edited' => $row['is_edited'] == 1
        );

        $newsarray['news'][] = $news; // Append news item to the array
    }

    $response = array(
        'status' => 'success',
        'data' => $newsarray,
        'numofpage' => $number_of_page,
        'numberofresult' => $total_result
    );
} else {
    $response = array(
        'status' => 'failed',
        'data' => null,
        'numofpage' => $number_of_page,
        'numberofresult' => $total_result
    );
}

// Send the JSON response
sendJsonResponse($response);

// Function to send a JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray, JSON_PRETTY_PRINT); // Format JSON for debugging
}
?>
