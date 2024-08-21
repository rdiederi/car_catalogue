<?php
session_start();
require 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    $stmt = $pdo->prepare('SELECT * FROM users WHERE username = ?');
    $stmt->execute([$username]);
    $user = $stmt->fetch();

    if ($user) {
        if (password_verify($password, $user['password'])) {
            $_SESSION['user_id'] = $user['id'];
            header('Location: car_list.php');
            exit;
        } else {
            error_log("Login failed: Incorrect password for user $username");
            $error = "Invalid login credentials.";
        }
    } else {
        error_log("Login failed: No user found with username $username");
        $error = "Invalid login credentials.";
    }
}
?>