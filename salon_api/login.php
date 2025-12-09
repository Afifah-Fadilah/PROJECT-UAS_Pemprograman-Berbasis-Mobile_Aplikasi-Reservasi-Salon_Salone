<?php
header('Content-Type: application/json');
include "conn.php";

$email = isset($_POST['email']) ? $_POST['email'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

// Validasi sederhana
if (empty($email) || empty($password)) {
    echo json_encode(["success" => false, "message" => "Email dan password harus diisi!"]);
    exit;
}

// Ambil user berdasarkan email
$check = mysqli_query($mysqli, "SELECT * FROM users WHERE email='$email' LIMIT 1");

if (mysqli_num_rows($check) > 0) {
    $user = mysqli_fetch_assoc($check);
    
    // Verifikasi password
    if (password_verify($password, $user['password'])) {
        // Hapus password dari data yang dikirim ke Flutter
        unset($user['password']);
        echo json_encode(["success" => true, "message" => "Login berhasil", "data" => $user]);
    } else {
        echo json_encode(["success" => false, "message" => "Password salah"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Email tidak ditemukan"]);
}
?>
