<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");

$conn = new mysqli("localhost", "root", "", "salon_app");

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Koneksi gagal"]));
}

$method = $_SERVER['REQUEST_METHOD'];

// ✅ GET - Ambil semua cart user
if ($method == 'GET') {
    $user_id = $_GET['user_id'] ?? 0;
    
    $result = $conn->query("
        SELECT c.*, s.* 
        FROM cart c
        JOIN services s ON c.service_id = s.id
        WHERE c.user_id = $user_id
    ");
    
    $cartItems = [];
    while ($row = $result->fetch_assoc()) {
        $row["is_best_seller"] = $row["is_best_seller"] == 1 ? "1" : "0";
        $cartItems[] = [
            "cart_id" => $row["id"],
            "quantity" => $row["quantity"],
            "service" => [
                "id" => $row["service_id"],
                "name" => $row["name"],
                "price" => $row["price"],
                "rating" => $row["rating"],
                "reviews" => $row["reviews"],
                "category" => $row["category"],
                "image" => $row["image"],
                "description" => $row["description"],
                "duration" => $row["duration"],
                "is_best_seller" => $row["is_best_seller"]
            ]
        ];
    }
    
    echo json_encode([
        "success" => true,
        "data" => $cartItems
    ]);
}

// ✅ POST - Tambah item ke cart
elseif ($method == 'POST') {
    $user_id = $_POST['user_id'] ?? 0;
    $service_id = $_POST['service_id'] ?? 0;
    $quantity = $_POST['quantity'] ?? 1;
    
    // Cek apakah sudah ada di cart
    $check = $conn->query("SELECT * FROM cart WHERE user_id=$user_id AND service_id=$service_id");
    
    if ($check->num_rows > 0) {
        // Update quantity jika sudah ada
        $row = $check->fetch_assoc();
        $newQuantity = $row['quantity'] + $quantity;
        $conn->query("UPDATE cart SET quantity=$newQuantity WHERE user_id=$user_id AND service_id=$service_id");
        
        echo json_encode([
            "success" => true,
            "message" => "Quantity berhasil diupdate"
        ]);
    } else {
        // Insert baru
        $conn->query("INSERT INTO cart (user_id, service_id, quantity) VALUES ($user_id, $service_id, $quantity)");
        
        echo json_encode([
            "success" => true,
            "message" => "Berhasil ditambahkan ke cart"
        ]);
    }
}

// ✅ PUT - Update quantity
elseif ($method == 'PUT') {
    parse_str(file_get_contents("php://input"), $_PUT);
    $user_id = $_PUT['user_id'] ?? 0;
    $service_id = $_PUT['service_id'] ?? 0;
    $quantity = $_PUT['quantity'] ?? 1;
    
    if ($quantity > 0) {
        $conn->query("UPDATE cart SET quantity=$quantity WHERE user_id=$user_id AND service_id=$service_id");
        echo json_encode(["success" => true, "message" => "Quantity berhasil diupdate"]);
    } else {
        // Hapus jika quantity 0
        $conn->query("DELETE FROM cart WHERE user_id=$user_id AND service_id=$service_id");
        echo json_encode(["success" => true, "message" => "Item dihapus dari cart"]);
    }
}

// ✅ DELETE - Hapus semua cart user (setelah checkout)
elseif ($method == 'DELETE') {
    parse_str(file_get_contents("php://input"), $_DELETE);
    $user_id = $_DELETE['user_id'] ?? 0;
    
    $conn->query("DELETE FROM cart WHERE user_id=$user_id");
    
    echo json_encode([
        "success" => true,
        "message" => "Cart berhasil dikosongkan"
    ]);
}

$conn->close();
?>