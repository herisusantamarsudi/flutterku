<?php
include 'koneksi.php';

$username = $_POST["username"];
$password = $_POST["password"];

$stmt = $koneksi->prepare("SELECT * FROM users WHERE username=? AND password=? LIMIT 1");
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode([
        "status" => "success",
        "data" => $row
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Username atau password salah"
    ]);
}