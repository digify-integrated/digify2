<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();

    $pageTitle = 'Sign Up';

    require('components/global/config/session-check.php');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
    <?php require_once('components/global/view/_head.php'); ?>
</head>

<body>
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
                                <h2 class="mb-2 mt-4 fs-7 fw-bolder">Sign <span class="text-primary">Up</span></h2>
                                <p class="mb-9">Please fill-out the sign up form.</p>
                                <form id="signup-form" method="post" action="#">
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <label for="first_name" class="form-label">First Name <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="200" autocomplete="off">
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <label for="last_name" class="form-label">Last Name <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="200" autocomplete="off">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <label for="middle_name" class="form-label">Middle Name</label>
                                                <input type="text" class="form-control maxlength" id="middle_name" name="middle_name"maxlength="200" autocomplete="off">
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <label for="suffix" class="form-label">Suffix</label>
                                                <input type="text" class="form-control maxlength" id="suffix" name="suffix" maxlength="10" autocomplete="off">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control maxlength" id="username" name="username" maxlength="100" autocomplete="off">
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                                                <input type="email" class="form-control maxlength" id="email" name="email" maxlength="250" autocomplete="off">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                                                </div>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="password" name="password">
                                                    <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                                        <i class="ti ti-eye"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="mb-4">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <label for="confirm_password" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                                                </div>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="confirm_password" name="confirm_password">
                                                    <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                                        <i class="ti ti-eye"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--<div class="cf-turnstile" data-sitekey="0x4AAAAAAAhqvvs5v4iAXvh7"></div>-->
                                    <button id="sign-up" type="submit" class="btn btn-dark w-100 py-8 mb-4 rounded-1">Sign Up</button>
                                    <div class="d-flex align-items-center">
                                        <p class="fs-4 mb-0 text-dark">Already have an Account?</p>
                                        <a class="text-primary fs-4 fw-medium ms-2" href="index.php">Sign In</a>
                                    </div>                                
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
        require_once('./components/global/view/_index_js.php');
    ?>
    <!--<script src="https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onloadTurnstileCallback" defer></script>-->
    <script src="./assets/libs/max-length/bootstrap-maxlength.min.js"></script>
    <script src="./components/authentication/js/sign-up.js?v=<?php echo rand(); ?>"></script>
</body>

</html>