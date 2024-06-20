<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();

    $pageTitle = 'Forgot Password';

    require('components/global/config/session-check.php');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
    <?php require_once('components/global/view/_head.php'); ?>
</head>

<body>
    <?php require_once('components/global/view/_preloader.php'); ?>
    <div id="main-wrapper">
        <div class="position-relative overflow-hidden radial-gradient min-vh-100 w-100">
            <div class="position-relative z-index-5">
                <div class="row gx-0">
                    <div class="col-lg-6 col-xl-5 col-xxl-4">
                        <div class="min-vh-100 bg-body row justify-content-center align-items-center p-5">
                            <div class="col-12 auth-card">
                                <a href="index.php" class="text-nowrap logo-img d-block w-100">
                                    <img src="./assets/images/logos/dark-logo.svg" class="dark-logo" alt="Logo-Dark" />
                                </a>
                                <h2 class="mb-2 mt-4 fs-7 fw-bolder">Forgot <span class="text-primary">Password</span></h2>
                                <p class="mb-9">Please enter the email address associated with your account. We will send you a link to reset your password.</p>
                                <form id="forgot-password-form" method="post" action="#">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email Address</label>
                                        <input type="email" class="form-control" id="email" name="email" autocomplete="off">
                                    </div>
                                    <button id="forgot-password" type="submit" class="btn btn-dark w-100 py-8 mb-3 rounded-1">Forgot Password</button>
                                    <a href="index.php" class="btn bg-primary-subtle text-primary w-100 py-8 rounded-1">Back to Login</a>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 col-xl-7 col-xxl-8 position-relative overflow-hidden bg-dark d-none d-lg-block">
                        <div class="circle-top"></div>
                        <div class="d-lg-flex align-items-center z-index-5 position-relative h-n80">
                            <div class="row justify-content-center w-100">
                                <div class="col-lg-6">
                                    <h2 class="text-white fs-10 mb-3 lh-sm">
                                        Welcome to
                                        <br />
                                        Modernize
                                    </h2>
                                    <span class="opacity-75 fs-3 text-white d-block mb-3">
                                        Designed to assist businesses in their journey towards modernization and automation, <strong>Modernize</strong> offers a suite of organized and well-coded dashboards, complete with beautiful and functional modules.
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <?php 
        require_once('components/global/view/_error_modal.php');
        require_once('components/global/view/_global_js.php');
    ?>
    <script src="./components/authentication/js/forgot-password.js?v=<?php echo rand(); ?>"></script>
</body>

</html>