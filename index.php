<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');

    $pageTitle = 'CGMI Digital Solutions';

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
                                <h2 class="mb-2 mt-4 fs-7 fw-bolder">Welcome to <span class="text-primary">CGMI Digital Solutions</span></h2>
                                <p class="mb-9">Empowering Futures, Crafting Digital Excellence</p>
                                <form id="signin-form" method="post" action="#">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">Username/Email Address</label>
                                        <input type="text" class="form-control" id="username" name="username" autocomplete="off">
                                    </div>
                                    <div class="mb-4">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <label for="password" class="form-label">Password</label>
                                            <a class="text-primary link-dark fs-2" href="forgot-password.php" tabindex="100">Forgot Password?</a>
                                        </div>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="password" name="password">
                                            <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                                <i class="ti ti-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <button id="signin" type="submit" class="btn btn-dark w-100 py-8 mb-4 rounded-1">Login</button>
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
        require_once('./components/global/view/_error_modal.php');
        require_once('./components/global/view/_global_js.php');
    ?>
    <script src="./components/authentication/js/index.js?v=<?php echo rand(); ?>"></script>
</body>

</html>