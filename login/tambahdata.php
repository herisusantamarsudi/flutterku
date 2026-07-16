<?php
include 'koneksi.php';

$username = $_POST['username'];
$password = $_POST['password'];
$email    = $_POST['email'];
//$passwordHash = password_hash($_POST['password'], PASSWORD_DEFAULT);
$sql = "INSERT INTO users (username, password, email) 
        VALUES ('$username', '$password', '$email')";

if ($koneksi->query($sql) === TRUE) {
    echo "success";
} else {
    echo "Error: " . $koneksi->error;
}
?>