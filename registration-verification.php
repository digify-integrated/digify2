<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');
    require('components/authentication/model/authentication-model.php');

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $authenticationModel = new AuthenticationModel($databaseModel);

    $pageTitle = 'Account Verification';

    if (isset($_GET['id']) && !empty($_GET['id']) && isset($_GET['token']) && !empty($_GET['token'])) {
        $id = $_GET['id'];
        $token = $_GET['token'];
        $userID = $securityModel->decryptData($id);
        $token = $securityModel->decryptData($token);

        $heading = '';
        $description = '';

        $loginCredentialsDetails = $authenticationModel->getLoginCredentials($userID, null);
        $registrationVerificationToken =  $securityModel->decryptData($loginCredentialsDetails['registration_verification_token']);
        $registrationVerificationTokenExpiryDate = $loginCredentialsDetails['registration_verification_token_expiry_date'];
        $userVerified = $loginCredentialsDetails['user_verified'];

        $heading = '<h1 class="fw-bold my-7 fs-9">Account Verification Successful</h1>';
        $description = '<h5 class="fw-semibold mb-7">Congratulations! Your account has been successfully verified. You can now access all features.</h5>';
        $button = '';

        if($userVerified == 'Yes' && ($token != $registrationVerificationToken || strtotime(date('Y-m-d H:i:s')) > strtotime($registrationVerificationTokenExpiryDate))){
            $heading = '<h1 class="fw-semibold my-7 fs-9">Account Verification Notice</h1>';
            $description = '<h5 class="fw-semibold mb-7">It seems that you have already verified your user account.</h5>';
        }
        else if($userVerified == 'No' && ($token != $registrationVerificationToken || strtotime(date('Y-m-d H:i:s')) > strtotime($registrationVerificationTokenExpiryDate))){
            $heading = '<h1 class="fw-semibold my-7 fs-9">Account Verification Notice</h1>';
            $description = '<h5 class="fw-semibold mb-7">The verification link has expired. Please request a new verification link.</h5>';
            $button = '<button class="btn btn-success me-2" id="resend-verification">Resend Verification</button>';
        }
        else{
            $registrationVerificationTokenExpiryDate = date('Y-m-d H:i:s', strtotime('-1 year'));
            $authenticationModel->verifyUserAccount($userID, $registrationVerificationTokenExpiryDate, 1);
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
    <?php require_once('components/global/view/_head.php'); ?>
    <link rel="stylesheet" href="./assets/libs/sweetalert2/dist/sweetalert2.min.css">
</head>

<body>
    <div id="main-wrapper">
        <div class="position-relative overflow-hidden min-vh-100 w-100 d-flex align-items-center justify-content-center">
            <div class="d-flex align-items-center justify-content-center w-100">
                <div class="row justify-content-center w-100">
                    <div class="col-lg-6">
                        <div class="text-center">
                            <img src="./assets/images/backgrounds/maintenance.svg" alt="matdash-img" class="img-fluid" width="400">
                            <input type="hidden" id="user_account_id" value="<?php echo $userID; ?>">
                            <?php
                                echo $heading;
                                echo $description;
                                echo $button;
                            ?>
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