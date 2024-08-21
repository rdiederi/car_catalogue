<?php
session_start();
require 'db.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $new_price = $_POST['price'];

    $stmt = $pdo->prepare('UPDATE cars SET price = ? WHERE id = ?');
    $stmt->execute([$new_price, $id]);

    header('Location: car_list.php');
    exit;
} else {
    $id = $_GET['id'];
    $stmt = $pdo->prepare('SELECT * FROM cars WHERE id = ?');
    $stmt->execute([$id]);
    $car = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$car) {
        die("Car not found.");
    }
}
?>