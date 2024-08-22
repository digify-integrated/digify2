<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');
    require('components/authentication/model/authentication-model.php');

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $authenticationModel = new AuthenticationModel($databaseModel);

    $pageTitle = 'Registration Success';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
    <?php require_once('components/global/view/_head.php'); ?>
    <link rel="stylesheet" href="./assets/libs/sweetalert2/dist/sweetalert2.min.css">
</head>

<body>
    <div id="main-wrapper">
        <div class="position-relative overflow-hidden min-vh-100 w-100 d-flex align-items-center justify-content-center">
            <div class="d-flex align-items-center justify-content-center w-100">
                <div class="row justify-content-center w-100 mb-5">
                    <div class="col-lg-7">
                        <div class="text-center">
                            <img src="./assets/images/backgrounds/maintenance.svg" alt="matdash-img" class="img-fluid" width="400">
                            <h1 class="fw-semibold my-7 fs-9">Account Created Successfully! You’re all set!</h1>
                            <h6 class="fw-semibold mb-7">We've sent a user account verification link to your registered email address. Please check your inbox and follow the provided instructions to verify your user account. If you don't receive the email within a few minutes, please also check your spam folder.</h6>
                            <a class="btn btn-info" href="index.php" role="button">Go Back to Home</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <?php 
        require_once('components/global/view/_error_modal.php');
        require_once('./components/global/view/_index_js.php');
    ?>
    <script src="./assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>
    <script src="./components/authentication/js/registration-verification.js?v=<?php echo rand(); ?>"></script>
</body>

</html>