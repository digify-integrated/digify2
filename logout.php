<?php
session_start();

if (isset($_GET['logout'])) {
    session_unset();
    session_destroy();

    header('Location: index.php');
    echo 'asd';
    exit;
}

if (!isset($_SESSION['user_id']) || empty($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}

header('Location: dashboard.php');
exit;
?>
