<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE");

$conn = new mysqli("localhost", "root", "", "salon_app");

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Koneksi gagal"]));
}

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

// ✅ GET COUNT - Hitung jumlah favorit user
if ($method == 'GET' && $action == 'count') {
    $user_id = $_GET['user_id'] ?? 0;
    
    $result = $conn->query("SELECT COUNT(*) as total FROM favorites WHERE user_id = $user_id");
    $row = $result->fetch_assoc();
    
    echo json_encode([
        "success" => true,
        "count" => $row['total']
    ]);
}

// ✅ GET - Ambil semua favorit user
elseif ($method == 'GET') {
    $user_id = $_GET['user_id'] ?? 0;
    
    $result = $conn->query("
        SELECT s.* 
        FROM favorites f
        JOIN services s ON f.service_id = s.id
        WHERE f.user_id = $user_id
    ");
    
    $favorites = [];
    while ($row = $result->fetch_assoc()) {
        $row["is_best_seller"] = $row["is_best_seller"] == 1 ? "1" : "0";
        $favorites[] = $row;
    }
    
    echo json_encode([
        "success" => true,
        "data" => $favorites
    ]);
}

// ✅ POST - Tambah favorit
elseif ($method == 'POST') {
    $user_id = $_POST['user_id'] ?? 0;
    $service_id = $_POST['service_id'] ?? 0;
    
    // Cek apakah sudah ada
    $check = $conn->query("SELECT * FROM favorites WHERE user_id=$user_id AND service_id=$service_id");
    
    if ($check->num_rows > 0) {
        echo json_encode([
            "success" => false,
            "message" => "Sudah ada di favorit"
        ]);
    } else {
        $conn->query("INSERT INTO favorites (user_id, service_id) VALUES ($user_id, $service_id)");
        echo json_encode([
            "success" => true,
            "message" => "Berhasil ditambahkan ke favorit"
        ]);
    }
}

// ✅ DELETE - Hapus favorit
elseif ($method == 'DELETE') {
    parse_str(file_get_contents("php://input"), $_DELETE);
    $user_id = $_DELETE['user_id'] ?? 0;
    $service_id = $_DELETE['service_id'] ?? 0;
    
    $conn->query("DELETE FROM favorites WHERE user_id=$user_id AND service_id=$service_id");
    
    echo json_encode([
        "success" => true,
        "message" => "Berhasil dihapus dari favorit"
    ]);
}

$conn->close();
?>