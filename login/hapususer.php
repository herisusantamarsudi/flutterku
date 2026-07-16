<?php
include 'koneksi.php';

$id = $_POST['id'];

// Gunakan prepared statement biar aman dari SQL Injection
$stmt = $koneksi->prepare("DELETE FROM users WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Data berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => $stmt->error
    ]);
}

$stmt->close();
$koneksi->close();
?>