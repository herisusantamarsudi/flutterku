<?php
header("Content-Type: application/json; charset=UTF-8");
include "koneksi.php"; // file koneksi database

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = isset($_POST['id']) ? intval($_POST['id']) : 0;

    if ($id > 0) {
        $query = "DELETE FROM users WHERE id = $id";
        $result = mysqli_query($conn, $query);

        if ($result) {
            echo json_encode([
                "status" => "success",
                "message" => "User berhasil dihapus"
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Gagal menghapus user"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "ID tidak valid"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Metode tidak valid"
    ]);
}
?>
