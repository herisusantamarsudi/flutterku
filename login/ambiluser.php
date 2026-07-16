<?php
include 'koneksi.php';

header('Content-Type: application/json; charset=utf-8');

$sql = "SELECT * FROM users";
$hasilQuery = $koneksi->query($sql);

if (!$hasilQuery) {
    echo json_encode([
        "status" => "error",
        "message" => $koneksi->error
    ]);
    exit;
}

$hasil = [];
while ($row = $hasilQuery->fetch_assoc()) {
    $hasil[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $hasil
]);
?>