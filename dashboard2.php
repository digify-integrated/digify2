<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');
    require('components/global/model/system-model.php');
    require('components/authentication/model/authentication-model.php');
   
    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $systemModel = new SystemModel();
    $authenticationModel = new AuthenticationModel($databaseModel);

    $pageTitle = 'Dashboard';

    require('components/global/config/session.php');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical" data-boxed-layout="full">
<head>
    <?php include_once('components/global/view/_head.php'); ?>
</head>
<body>
    <?php include_once('components/global/view/_preloader.php'); ?>
    
</body>

</html>