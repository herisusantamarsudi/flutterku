<?php 
$koneksi = mysqli_connect("localhost","b11_39939643","1S@mp@18","b11_39939643_delayota");
 
// Check connection
if (mysqli_connect_errno()){
	echo "Koneksi database gagal : " . mysqli_connect_error();
}

