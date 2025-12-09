<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");

$conn = new mysqli("localhost", "root", "", "salon_app");

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Koneksi gagal"]));
}

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

// ✅ GET COUNT - Hitung jumlah booking user
if ($method == 'GET' && $action == 'count') {
    $user_id = $_GET['user_id'] ?? 0;
    
    $result = $conn->query("SELECT COUNT(*) as total FROM bookings WHERE user_id = $user_id");
    $row = $result->fetch_assoc();
    
    echo json_encode([
        "success" => true,
        "count" => $row['total']
    ]);
}

// ✅ GET - Ambil semua booking user
elseif ($method == 'GET') {
    $user_id = $_GET['user_id'] ?? 0;
    
    $result = $conn->query("
        SELECT * FROM bookings 
        WHERE user_id = $user_id 
        ORDER BY created_at ASC
    ");
    
    $bookings = [];
    while ($booking = $result->fetch_assoc()) {
        // Ambil items untuk booking ini
        $items_result = $conn->query("
            SELECT bi.*, s.name, s.image, s.category, s.duration, s.description, 
                   s.rating, s.reviews, s.is_best_seller
            FROM booking_items bi
            JOIN services s ON bi.service_id = s.id
            WHERE bi.booking_id = '{$booking['id']}'
        ");
        
        $items = [];
        while ($item = $items_result->fetch_assoc()) {
            $items[] = [
                "service" => [
                    "id" => $item["service_id"],
                    "name" => $item["name"],
                    "price" => $item["price"],
                    "rating" => $item["rating"],
                    "reviews" => $item["reviews"],
                    "category" => $item["category"],
                    "image" => $item["image"],
                    "description" => $item["description"],
                    "duration" => $item["duration"],
                    "is_best_seller" => $item["is_best_seller"] == 1 ? "1" : "0"
                ],
                "quantity" => $item["quantity"]
            ];
        }
        
        $bookings[] = [
            "id" => $booking["id"],
            "customer_name" => $booking["customer_name"],
            "booking_date" => $booking["booking_date"],
            "time_slot" => $booking["time_slot"],
            "total_price" => $booking["total_price"],
            "payment_method" => $booking["payment_method"],
            "status" => $booking["status"],
            "created_at" => $booking["created_at"],
            "items" => $items
        ];
    }
    
    echo json_encode([
        "success" => true,
        "data" => $bookings
    ]);
}

// ✅ POST - Buat booking baru
elseif ($method == 'POST') {
    $user_id = $_POST['user_id'] ?? 0;
    $booking_id = $_POST['booking_id'] ?? '';
    $customer_name = $_POST['customer_name'] ?? '';
    $booking_date = $_POST['booking_date'] ?? '';
    $time_slot = $_POST['time_slot'] ?? '';
    $total_price = $_POST['total_price'] ?? 0;
    $payment_method = $_POST['payment_method'] ?? '';
    $status = $_POST['status'] ?? 'pending';
    $items = json_decode($_POST['items'], true);
    
    // Insert booking
    $stmt = $conn->prepare("
        INSERT INTO bookings (id, user_id, customer_name, booking_date, time_slot, total_price, payment_method, status) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ");
    $stmt->bind_param("sissssss", $booking_id, $user_id, $customer_name, $booking_date, $time_slot, $total_price, $payment_method, $status);
    
    if ($stmt->execute()) {
        // Insert booking items
        foreach ($items as $item) {
            $service_id = $item['service_id'];
            $quantity = $item['quantity'];
            $price = $item['price'];
            
            $conn->query("
                INSERT INTO booking_items (booking_id, service_id, quantity, price) 
                VALUES ('$booking_id', $service_id, $quantity, $price)
            ");
        }
        
        echo json_encode([
            "success" => true,
            "message" => "Booking berhasil dibuat",
            "booking_id" => $booking_id
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Gagal membuat booking: " . $stmt->error
        ]);
    }
}

$conn->close();
?>