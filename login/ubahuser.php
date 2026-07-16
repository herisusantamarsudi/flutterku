<?php
include 'koneksi.php';

$id       = $_POST['id'] ?? null;
$username = $_POST['username'] ?? null;
$password = $_POST['password'] ?? null;
$email    = $_POST['email'] ?? null;

if (!$id || !$username || !$email) {
    echo json_encode([
        "status" => "error",
        "message" => "Data tidak lengkap"
    ]);
    exit;
}

// kalau password kosong, jangan update password
if (empty($password)) {
    $stmt = $koneksi->prepare("UPDATE users SET username=?, email=? WHERE id=?");
    $stmt->bind_param("ssi", $username, $email, $id);
} else {
    $stmt = $koneksi->prepare("UPDATE users SET username=?, password=?, email=? WHERE id=?");
    $stmt->bind_param("sssi", $username, $password, $email, $id);
}

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Update berhasil"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Error: " . $stmt->error
    ]);
}

$stmt->close();
$koneksi->close();
?>