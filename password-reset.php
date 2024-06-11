<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');
    require('components/authentication/model/authentication-model.php');

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $authenticationModel = new AuthenticationModel($databaseModel);

    $pageTitle = 'Password Reset';

    if (isset($_GET['id']) && !empty($_GET['id']) && isset($_GET['token']) && !empty($_GET['token'])) {
        $id = $_GET['id'];
        $token = $_GET['token'];
        $userID = $securityModel->decryptData($id);
        $token = $securityModel->decryptData($token);

        $loginCredentialsDetails = $authenticationModel->getLoginCredentials($userID, null);
        $resetToken =  $securityModel->decryptData($loginCredentialsDetails['reset_token']);
        $resetTokenExpiryDate = $loginCredentialsDetails['reset_token_expiry_date'];

        if($token != $resetToken || strtotime(date('Y-m-d H:i:s')) > strtotime($resetTokenExpiryDate)){
            header('location: 404.php');
            exit;
        }
    }
    else{
        header('location: index.php');
        exit;
    }
    
    require('components/global/config/session-check.php');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
    <?php include_once('components/global/view/_head.php'); ?>
</head>

<body>
    <?php include_once('components/global/view/_preloader.php'); ?>
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
                                <h2 class="mb-2 mt-4 fs-7 fw-bolder">Password <span class="text-primary">Reset</span></h2>
                                <p class="mb-9">Enter your new password.</p>
                                <form id="password-reset-form" method="post" action="#">
                                    <input type="hidden" id="user_account_id" name="user_account_id" value="<?php echo $userID; ?>">
                                    <div class="mb-3">
                                        <label for="new_password" class="form-label">New Password</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="new_password" name="new_password">
                                            <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                                <i class="ti ti-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="confirm_password" class="form-label">Confirm Password</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="confirm_password" name="confirm_password">
                                            <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                                <i class="ti ti-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <button id="reset" type="submit" class="btn btn-dark w-100 py-8 rounded-1">Reset Password</button>
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
        include_once('components/global/view/_error_modal.php');
        include_once('components/global/view/_global_js.php');
    ?>
    <script src="./components/authentication/js/password-reset.js?v=<?php echo rand(); ?>"></script>
</body>

</html>