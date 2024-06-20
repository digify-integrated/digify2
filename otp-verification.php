<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');
    require('components/authentication/model/authentication-model.php');
 
    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $authenticationModel = new AuthenticationModel($databaseModel);
     
    $pageTitle = 'OTP Verification';
 
    if (isset($_GET['id']) && !empty($_GET['id'])) {
        $id = $_GET['id'];
        $userID = $securityModel->decryptData($id);
 
        $checkLoginCredentialsExist = $authenticationModel->checkLoginCredentialsExist($userID, null);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
 
        if($total > 0){
            $loginCredentialsDetails = $authenticationModel->getLoginCredentials($userID, null);
            $emailObscure = $securityModel->obscureEmail($loginCredentialsDetails['email']);
        }
        else{
            header('location: 404.php');
            exit;
        }
    }
    else {
        header('location: 404.php');
         exit;
     }

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
                                <h2 class="mb-2 mt-4 fs-7 fw-bolder">Two Step <span class="text-primary">Verification</span></h2>
                                <p class="mb-9">We've sent a verification code to your email address. Please check your inbox and enter the code below.</p>
                                <h6 class="fw-bolder"><?php echo $emailObscure; ?></h6>
                                <form id="otp-form" method="post" action="#">
                                    <input type="hidden" id="user_account_id" name="user_account_id" value="<?php echo $userID; ?>">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Type your 6 digit security code</label>
                                        <div class="d-flex align-items-center gap-2 gap-sm-3">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_1" name="otp_code_1" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_2" name="otp_code_2" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_3" name="otp_code_3" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_4" name="otp_code_4" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_5" name="otp_code_5" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_6" name="otp_code_6" autocomplete="off" maxlength="1">
                                        </div>
                                    </div>
                                    <button id="verify" type="submit" class="btn btn-dark w-100 py-8 rounded-1">Verify</button>
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
    <script src="./assets/libs/max-length/bootstrap-maxlength.min.js"></script>
    <script src="./components/authentication/js/otp-verification.js?v=<?php echo rand(); ?>"></script>
</body>

</html>