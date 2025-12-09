<?php
header('Content-Type: application/json'); // Supaya output JSON
include "conn.php";

$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['password'];

$check = mysqli_query($mysqli, "SELECT * FROM users WHERE email='$email'");
if (mysqli_num_rows($check) > 0) {
    echo json_encode(["success" => false, "message" => "Email sudah digunakan!"]);
    exit;
}

// Hash password sebelum disimpan
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

$insert = mysqli_query($mysqli, "INSERT INTO users(name,email,password) 
VALUES('$name', '$email', '$hashedPassword')");

if ($insert) {
    echo json_encode(["success" => true, "message" => "Registrasi berhasil"]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal mendaftar"]);
}
