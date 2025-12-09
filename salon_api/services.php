<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "salon_app");

$result = $conn->query("SELECT * FROM services");

$data = [];

while($row = $result->fetch_assoc()){
    $row["is_best_seller"] = $row["is_best_seller"] == 1 ? "1" : "0";
    $row["image_url"] = $row["image"]; // ← penting
    $data[] = $row;
}

echo json_encode($data);
?>
