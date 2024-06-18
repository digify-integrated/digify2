<?php
session_start();

# -------------------------------------------------------------
#
# Function: AuthenticationController
# Description: 
# The AuthenticationController class handles authentication related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class AuthenticationController {
    private $authenticationModel;
    private $securitySettingModel;
    private $emailSettingModel;
    private $notificationSettingModel;
    private $systemModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided AuthenticationModel, SystemModel and SecurityModel instances.
    # These instances are used for address type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param AuthenticationModel $authenticationModel     The authenticationModel instance for authentication related operations.
    # - @param SecuritySettingModel $securitySettingModel     The securitySettingModel instance for security setting related operations.
    # - @param EmailSettingModel $emailSettingModel     The emailSettingModel instance for email setting related operations.
    # - @param NotificationSettingModel $notificationSettingModel     The notificationSettingModel instance for notification setting related operations.
    # - @param SystemModel $systemModel     The SystemModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(AuthenticationModel $authenticationModel, SecuritySettingModel $securitySettingModel, EmailSettingModel $emailSettingModel, NotificationSettingModel $notificationSettingModel, SystemModel $systemModel, SecurityModel $securityModel) {
        $this->authenticationModel = $authenticationModel;
        $this->securitySettingModel = $securitySettingModel;
        $this->emailSettingModel = $emailSettingModel;
        $this->notificationSettingModel = $notificationSettingModel;
        $this->systemModel = $systemModel;
        $this->securityModel = $securityModel;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleRequest
    # Description: 
    # This method checks the request method and dispatches the corresponding transaction based on the provided transaction parameter.
    # The transaction determines which action should be performed.
    #
    # Parameters:
    # - $transaction (string): The type of transaction.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function handleRequest(){
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $transaction = isset($_POST['transaction']) ? $_POST['transaction'] : null;

            switch ($transaction) {
                case 'authenticate':
                    $this->authenticate();
                    break; 
                case 'otp verification':
                    $this->verifyOTP();
                    break;
                case 'forgot password':
                    $this->forgotPassword();
                    break;
                case 'password reset':
                    $this->passwordReset();
                    break;
                case 'resend otp':
                    $this->resendOTP();
                    break; 
                default:
                    $response = [
                        'success' => false,
                        'title' => 'Authentication Error',
                        'message' => 'Invalid transaction.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    break;
            }
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Authenticate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: authenticate
    # Description: 
    # Handles the login process, including two-factor authentication and account locking.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function authenticate() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $email = htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8');
        $password = htmlspecialchars($_POST['password'], ENT_QUOTES, 'UTF-8');

        $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist(null, $email);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
    
        if ($total === 0) {
            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => 'The email or password you entered is invalid. Please double-check your credentials and try again.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials(null, $email);
        $userAccountID = $loginCredentialsDetails['user_account_id'];
        $active = $loginCredentialsDetails['active'];
        $userPassword = $this->securityModel->decryptData($loginCredentialsDetails['password']);
        $locked = $loginCredentialsDetails['locked'];
        $failedLoginAttempts = $loginCredentialsDetails['failed_login_attempts'];
        $passwordExpiryDate = $loginCredentialsDetails['password_expiry_date'];
        $accountLockDuration = $loginCredentialsDetails['account_lock_duration'];
        $lastFailedLoginAttempt = $loginCredentialsDetails['last_failed_login_attempt'];
        $twoFactorAuth = $loginCredentialsDetails['two_factor_auth'];
        $encryptedUserID = $this->securityModel->encryptData($userAccountID);
    
        if ($password !== $userPassword) {
            $this->handleInvalidCredentials($userAccountID, $failedLoginAttempts);
            return;
        }
    
        if ($active === 'No') {
            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => 'Your account is currently inactive. Kindly reach out to the administrator for further assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    
        if ($this->passwordHasExpired($passwordExpiryDate)) {
            $this->handlePasswordExpiration($userAccountID, $email, $encryptedUserID);
            exit;
        }
    
        if ($locked === 'Yes') {
            $this->handleAccountLock($userAccountID, $accountLockDuration, $lastFailedLoginAttempt);
            exit;
        }
    
        $this->authenticationModel->updateLoginAttempt($userAccountID, 0, null);
    
        if ($twoFactorAuth === 'Yes') {
            $this->handleTwoFactorAuth($userAccountID, $email, $encryptedUserID);
            exit;
        }

        $sessionToken = $this->generateToken(6, 6);
        $encryptedSessionToken = $this->securityModel->encryptData($sessionToken);

        $this->authenticationModel->updateLastConnection($userAccountID, $encryptedSessionToken, date('Y-m-d H:i:s'));

        $_SESSION['user_account_id'] = $userAccountID;
        $_SESSION['session_token'] = $sessionToken;

        $response = [
            'success' => true,
            'redirectLink' => 'apps.php'
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Verify methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: verifyOTP
    # Description: 
    # Handles the verfication OTP code.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function verifyOTP() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        $otpCode1 = htmlspecialchars($_POST['otp_code_1'], ENT_QUOTES, 'UTF-8');
        $otpCode2 = htmlspecialchars($_POST['otp_code_2'], ENT_QUOTES, 'UTF-8');
        $otpCode3 = htmlspecialchars($_POST['otp_code_3'], ENT_QUOTES, 'UTF-8');
        $otpCode4 = htmlspecialchars($_POST['otp_code_4'], ENT_QUOTES, 'UTF-8');
        $otpCode5 = htmlspecialchars($_POST['otp_code_5'], ENT_QUOTES, 'UTF-8');
        $otpCode6 = htmlspecialchars($_POST['otp_code_6'], ENT_QUOTES, 'UTF-8');
        $otpVerificationCode = $otpCode1 . $otpCode2 . $otpCode3 . $otpCode4 . $otpCode5 . $otpCode6;

        $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist($userAccountID, null);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
    
        if ($total === 0) {
            $response = [
                'success' => false,
                'notExist' => true,
                'title' => 'Authentication Error',
                'message' => 'The user account specified does not exist. Please contact the administrator for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials($userAccountID, null);
        $otp = $this->securityModel->decryptData($loginCredentialsDetails['otp']);
        $failedOTPAttempts = $loginCredentialsDetails['failed_otp_attempts'];
        $otpExpiryDate = $loginCredentialsDetails['otp_expiry_date'];
        $active = $loginCredentialsDetails['active'];
        $locked = $loginCredentialsDetails['locked'];
    
        if ($active === 'No') {
            $response = [
                'success' => false,
                'notActive' => true,
                'title' => 'OTP Verification Error',
                'message' => 'Your account is currently inactive. Kindly reach out to the administrator for further assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    
        if ($locked === 'Yes') {
            $response = [
                'success' => false,
                'locked' => true,
                'title' => 'OTP Verification Error',
                'message' => 'Your account is currently locked. Kindly reach out to the administrator for assistance in unlocking it.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        if ($otpVerificationCode !== $otp) {
            $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(2);
            $maxFailedOTPAttempts = $securitySettingDetails['value'] ?? MAX_FAILED_OTP_ATTEMPTS;

            if ($failedOTPAttempts >= $maxFailedOTPAttempts) {
                $otpExpiryDate = date('Y-m-d H:i:s', strtotime('-1 year'));
                $this->authenticationModel->updateOTPAsExpired($userAccountID, $otpExpiryDate);

                $response = [
                    'success' => false,
                    'otpMaxFailedAttempt' => true,
                    'title' => 'OTP Verification Error',
                    'message' => 'Invalid OTP code. Please request a new one.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $this->authenticationModel->updateFailedOTPAttempts($userAccountID, $failedOTPAttempts + 1);

            $response = [
                'success' => false,
                'incorrectOTPCode' => true,
                'title' => 'OTP Verification Error',
                'message' => 'The OTP code you entered is incorrect.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        if (strtotime(date('Y-m-d H:i:s')) > strtotime($otpExpiryDate)) {
            $response = [
                'success' => false,
                'expiredOTP' => true,
                'title' => 'OTP Verification Error',
                'message' => 'Expired OTP code. Please request a new one.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $sessionToken = $this->generateToken(6, 6);
        $encryptedSessionToken = $this->securityModel->encryptData($sessionToken);

        $this->authenticationModel->updateLastConnection($userAccountID, $encryptedSessionToken, date('Y-m-d H:i:s'));

        $_SESSION['user_account_id'] = $userAccountID;
        $_SESSION['session_token'] = $sessionToken;

        $response = [
            'success' => true,
            'redirectLink' => 'apps.php'
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Reset methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: passwordReset
    # Description: 
    # Handles the reset password.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function passwordReset() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        $newPassword = htmlspecialchars($_POST['new_password'], ENT_QUOTES, 'UTF-8');
        $encryptedPassword = $this->securityModel->encryptData($newPassword);

        $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist($userAccountID, null);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
    
        if ($total === 0) {
            $response = [
                'success' => false,
                'notExist' => true,
                'title' => 'Authentication Error',
                'message' => 'The user account specified does not exist. Please contact the administrator for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials($userAccountID, null);
        $email = $loginCredentialsDetails['email'];
        $active = $loginCredentialsDetails['active'];
        $locked = $loginCredentialsDetails['locked'];
        $resetTokenExpiryDate = $loginCredentialsDetails['reset_token_expiry_date'];
    
        if ($active === 'No') {
            $response = [
                'success' => false,
                'title' => 'Password Reset Error',
                'message' => 'Your account is currently inactive. Kindly reach out to the administrator for further assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    
        if ($locked === 'Yes') {
            $response = [
                'success' => false,
                'title' => 'Password Reset Error',
                'message' => 'Your account is currently locked. Kindly reach out to the administrator for assistance in unlocking it.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }       

        if(strtotime(date('Y-m-d H:i:s')) > strtotime($resetTokenExpiryDate)){
            $response = [
                'success' => false,
                'title' => 'Password Reset Error',
                'message' => 'The password reset link has expired. Please request a new link to reset your password.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $checkPasswordHistory = $this->checkPasswordHistory($userAccountID, $email, $newPassword);
    
        if ($checkPasswordHistory > 0) {
            $response = [
                'success' => false,
                'passwordExist' => true,
                'title' => 'Password Reset Error',
                'message' => 'Your new password cannot be identical to your previous one for security reasons. Please choose a different password to proceed.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(4);
        $defaultPasswordDuration = $securitySettingDetails['value'] ?? DEFAULT_PASSWORD_DURATION;
    
        $passwordExpiryDate = date('Y-m-d', strtotime('+'. $defaultPasswordDuration .' days'));

        $this->authenticationModel->updateUserPassword($userAccountID, $email, $encryptedPassword, $passwordExpiryDate);
        $this->authenticationModel->insertPasswordHistory($userAccountID, $email, $encryptedPassword);

        $resetTokenExpiryDate = date('Y-m-d H:i:s', strtotime('-1 year'));
        $this->authenticationModel->updateResetTokenAsExpired($userAccountID, $resetTokenExpiryDate);

        $response = [
            'success' => true,
            'title' => 'Password Reset Success',
            'message' => 'Your password has been successfully updated. For security reasons, please use your new password to log in.',
            'messageType' => 'success'            
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Forgot methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: forgotPassword
    # Description: 
    # Handles the forgot password.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function forgotPassword() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $email = htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8');

        $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist(null, $email);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
    
        if ($total === 0) {
            $response = [
                'success' => false,
                'notExist' => true,
                'title' => 'Authentication Error',
                'message' => 'The user account specified does not exist. Please contact the administrator for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials(null, $email);
        $userAccountID = $loginCredentialsDetails['user_account_id'];
        $active = $loginCredentialsDetails['active'];
        $locked = $loginCredentialsDetails['locked'];
        $encryptedUserID = $this->securityModel->encryptData($userAccountID);
    
        if ($active === 'No') {
            $response = [
                'success' => false,
                'notActive' => true,
                'title' => 'OTP Verification Error',
                'message' => 'Your account is currently inactive. Kindly reach out to the administrator for further assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    
        if ($locked === 'Yes') {
            $response = [
                'success' => false,
                'locked' => true,
                'title' => 'OTP Verification Error',
                'message' => 'Your account is currently locked. Kindly reach out to the administrator for assistance in unlocking it.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(6);
        $resetPasswordTokenDuration = $securitySettingDetails['value'] ?? RESET_PASSWORD_TOKEN_DURATION;

        $resetToken = $this->generateResetToken();
        $encryptedResetToken = $this->securityModel->encryptData($resetToken);
        $resetTokenExpiryDate = date('Y-m-d H:i:s', strtotime('+'. $resetPasswordTokenDuration .' minutes'));
    
        $this->authenticationModel->updateResetToken($userAccountID, $encryptedResetToken, $resetTokenExpiryDate);
        $this->sendPasswordReset($email, $encryptedUserID, $encryptedResetToken, $resetPasswordTokenDuration);

        $response = [
            'success' => true,
            'title' => 'Password Reset Success',
            'message' => "We've sent a password reset link to your registered email address. Please check your inbox and follow the provided instructions to securely reset your password. If you don't receive the email within a few minutes, please also check your spam folder.",
            'messageType' => 'success'
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Resend methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: resendOTP
    # Description: 
    # Handles the resending OTP code.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function resendOTP() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');

        $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist($userAccountID, null);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
    
        if ($total === 0) {
            $response = [
                'success' => false,
                'notExist' => true,
                'title' => 'Authentication Error',
                'message' => 'The user account specified does not exist. Please contact the administrator for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials($userAccountID, null);
        $email = $loginCredentialsDetails['email'];
        $active = $loginCredentialsDetails['active'];
        $locked = $loginCredentialsDetails['locked'];
    
        if ($active === 'No') {
            $response = [
                'success' => false,
                'notActive' => true,
                'title' => 'Authentication Error',
                'message' => 'Your account is currently inactive. Kindly reach out to the administrator for further assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    
        if ($locked === 'Yes') {
            $response = [
                'success' => false,
                'locked' => true,
                'title' => 'Authentication Error',
                'message' => 'Your account is currently locked. Kindly reach out to the administrator for assistance in unlocking it.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $this->resendOTPCode($userAccountID, $email);

        $response = [
            'success' => true
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: resendOTPCode
    # Description:
    # Generates and encrypts an OTP, sets the OTP expiry date, and sends the OTP to the user's email.
    #
    # Parameters: 
    # - $userAccountID (int): The user ID.
    # - $email (string): The email address of the user.
    # - $encryptedUserID (string): The encrypted user ID.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function resendOTPCode($userAccountID, $email) {
        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(6);
        $otpDuration = $securitySettingDetails['value'] ?? DEFAULT_OTP_DURATION;

        $otp = $this->generateToken(6, 6);
        $encryptedOTP = $this->securityModel->encryptData($otp);
        $otpExpiryDate = date('Y-m-d H:i:s', strtotime('+'. $otpDuration .' minutes'));
    
        $this->authenticationModel->updateOTP($userAccountID, $encryptedOTP, $otpExpiryDate);
        $this->sendOTP($email, $otp);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Handle methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleInvalidCredentials
    # Description:
    # Updates the failed login attempts and, if the maximum attempts are reached, locks the account.
    #
    # Parameters: 
    # - $loginCredentialsDetails (array): The login credentials details.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function handleInvalidCredentials($userAccountID, $failedAttempts) {
        $failedAttempts = $failedAttempts + 1;
        $lastFailedLogin = date('Y-m-d H:i:s');
    
        $this->authenticationModel->updateLoginAttempt($userAccountID, $failedAttempts, $lastFailedLogin);

        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(1);
        $maxFailedLoginAttempts = $securitySettingDetails['value'] ?? MAX_FAILED_LOGIN_ATTEMPTS;

        $userAccountLockDurationSettingDetails = $this->securitySettingModel->getSecuritySetting(8);
        $baseLockDuration = $userAccountLockDurationSettingDetails['value'] ?? BASE_USER_ACCOUNT_DURATION;

        if ($failedAttempts > $maxFailedLoginAttempts) {
            $lockDuration = pow(2, ($failedAttempts - $maxFailedLoginAttempts)) * 5;
            $this->authenticationModel->updateAccountLock($userAccountID, 'Yes', $lockDuration);
            
            $durationParts = $this->formatDuration($lockDuration);
            
            $message = 'You have reached the maximum number of failed login attempts. Your account has been locked';
            
            if (count($durationParts) > 0) {
                $message .= ' for ' . implode(', ', $durationParts);
            }
            
            $message .= '.';

            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => $message, 
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
        else {
            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => 'The email or password you entered is invalid. Please double-check your credentials and try again.', 
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleAccountLock
    # Description:
    # Checks the account lock duration and displays the remaining lock time.
    # If the lock time has expired, unlocks the account.
    #
    # Parameters: 
    # - $userAccountID (int): The user ID.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function handleAccountLock($userAccountID, $accountLockDuration, $lastFailedLoginAttempt) {
        $unlockTime = strtotime('+'. $accountLockDuration .' minutes', strtotime($lastFailedLoginAttempt));
    
        if (time() < $unlockTime) {
            $durationParts = $this->formatDuration(round(($unlockTime - time()) / 60));

            $message = 'Your account has been locked. Please try again in ';

            if (count($durationParts) > 0) {
                $message .= implode(', ', $durationParts);
            }

            $message .= '.';

            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => $message, 
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
        else {
            $this->authenticationModel->updateAccountLock($userAccountID, 'No', null);
        }
    
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handlePasswordExpiration
    # Description:
    # Handles the process when the user account's password is expired.
    #
    # Parameters: 
    # - $userAccountID (int): The user ID.
    # - $email (string): The email address of the user.
    # - $encryptedUserID (string): The encrypted user ID.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function handlePasswordExpiration($userAccountID, $email, $encryptedUserID) {
        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(3);
        $defaultForgotPasswordLink = $securitySettingDetails['value'];

        $resetPasswordTokenDurationDetails = $this->securitySettingModel->getSecuritySetting(6);
        $resetPasswordTokenDuration = $resetPasswordTokenDurationDetails['value'] ?? RESET_PASSWORD_TOKEN_DURATION;

        $resetToken = $this->generateResetToken();
        $encryptedResetToken = $this->securityModel->encryptData($resetToken);
        $encryptedUserAccountID = $this->securityModel->encryptData($userAccountID);
        $resetTokenExpiryDate = date('Y-m-d H:i:s', strtotime('+'. $resetPasswordTokenDuration .' minutes'));
    
        $this->authenticationModel->updateResetToken($userAccountID, $encryptedResetToken, $resetTokenExpiryDate);
    
        $response = [
            'success' => false,
            'passwordExpired' => true,
            'title' => 'Authentication Error',
            'message' => 'Your password has expired. Please reset it to continue.',
            'redirectLink' => $defaultForgotPasswordLink . $encryptedUserAccountID .'&token=' . $encryptedResetToken,
            'messageType' => 'error'
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleTwoFactorAuth
    # Description:
    # Generates and encrypts an OTP, sets the OTP expiry date, and sends the OTP to the user's email.
    #
    # Parameters: 
    # - $userAccountID (int): The user ID.
    # - $email (string): The email address of the user.
    # - $encryptedUserID (string): The encrypted user ID.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function handleTwoFactorAuth($userAccountID, $email, $encryptedUserID) {
        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(6);
        $otpDuration = $securitySettingDetails['value'] ?? DEFAULT_OTP_DURATION;

        $otp = $this->generateToken(6, 6);
        $encryptedOTP = $this->securityModel->encryptData($otp);
        $otpExpiryDate = date('Y-m-d H:i:s', strtotime('+'. $otpDuration .' minutes'));
    
        $this->authenticationModel->updateOTP($userAccountID, $encryptedOTP, $otpExpiryDate);
        $this->sendOTP($email, $otp);
    
        $response = [
            'success' => true,
            'redirectLink' => 'otp-verification.php?id=' . $encryptedUserID
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: formatDuration
    # Description:
    # Updates the failed login attempts and, if the maximum attempts are reached, locks the account.
    #
    # Parameters: 
    # - $lockDuration (int): The duration in seconds that needs to be formatted. This value represents the total duration that you want to convert into a human-readable format.
    #
    # Returns: 
    #  Returns a formatted string representing the duration in a human-readable format. 
    #  The format includes years, months, days, hours, and minutes, as applicable. 
    #  The function constructs this string based on the provided $lockDuration parameter.
    #
    # -------------------------------------------------------------
    private function formatDuration($lockDuration) {
        $durationParts = [];

        $timeUnits = [
            ['year', 60 * 60 * 24 * 30 * 12],
            ['month', 60 * 60 * 24 * 30],
            ['day', 60 * 60 * 24],
            ['hour', 60 * 60],
            ['minute', 60]
        ];

        foreach ($timeUnits as list($unit, $seconds)) {
            $value = floor($lockDuration / $seconds);
            $lockDuration %= $seconds;

            if ($value > 0) {
                $durationParts[] = number_format($value) . ' ' . $unit . ($value > 1 ? 's' : '');
            }
        }

        return $durationParts;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: passwordHasExpired
    # Description:
    # Checks if the user's password is expired.
    #
    # Parameters: 
    # - $userAccountID (int): The user ID.
    #
    # Returns: Bool
    #
    # -------------------------------------------------------------
    private function passwordHasExpired($passwordExpiryDate) {
        $passwordExpiryDate = new DateTime($passwordExpiryDate);
        $currentDate = new DateTime();
        
        if ($currentDate > $passwordExpiryDate) {
            return true;
        }
        
        return false;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkPasswordHistory
    # Description: 
    # Checks the password history for a given user ID and email to determine if the new password matches any previous passwords.
    #
    # Parameters: 
    # - $p_user_account_id (array): The user ID.
    # - $p_email (string): The email address of the user.
    # - $p_password (string): The password of the user.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function checkPasswordHistory($p_user_account_id, $p_email, $p_password) {
        $total = 0;
        $passwordHistory = $this->authenticationModel->getPasswordHistory($p_user_account_id, $p_email);
    
        foreach ($passwordHistory as $history) {
            $password = $this->securityModel->decryptData($history['password']);
    
            if ($password === $p_password) {
                $total++;
            }
        }
    
        return $total;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateToken
    # Description: 
    # Generates a random token/OTP (One-Time Password) of specified length.
    #
    # Parameters: 
    # - $minLength (int): The minimum length of the generated token. Default is 4.
    # - $maxLength (int): The maximum length of the generated token. Default is 4.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function generateToken($minLength = 4, $maxLength = 4) {
        $length = mt_rand($minLength, $maxLength);
        $minValue = pow(10, $length - 1);
        $maxValue = pow(10, $length) - 1;
    
        $token = random_int($minValue, $maxValue);
        
        return (string) $token;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateResetToken
    # Description: 
    # Generates a random reset token of specified length.
    #
    # Parameters: 
    # - $minLength (int): The minimum length of the generated token. Default is 10.
    # - $maxLength (int): The maximum length of the generated token. Default is 12.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function generateResetToken($minLength = 10, $maxLength = 12) {
        $length = mt_rand($minLength, $maxLength);
        $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        
        $resetToken = substr(str_shuffle($characters), 0, $length);
        
        return $resetToken;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Send methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: sendOTP
    # Description: 
    # Sends an OTP (One-Time Password) to the user's email address.
    #
    # Parameters: 
    # - $email (string): The email address of the user.
    # - $otp (string): The OTP generated.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function sendOTP($email, $otp) {
        $emailSetting = $this->emailSettingModel->getEmailSetting(1);
        $mailFromName = $emailSetting['mail_from_name'] ?? null;
        $mailFromEmail = $emailSetting['mail_from_email'] ?? null;

        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(6);
        $otpDuration = $securitySettingDetails['value'] ?? DEFAULT_OTP_DURATION;

        $notificationSettingDetails = $this->notificationSettingModel->getEmailNotificationTemplate(1);
        $emailSubject = $notificationSettingDetails['email_notification_subject'] ?? null;
        $emailBody = $notificationSettingDetails['email_notification_body'] ?? null;
        $emailBody = str_replace('#{OTP_CODE}', $otp, $emailBody);
        $emailBody = str_replace('#{OTP_CODE_VALIDITY}', $otpDuration . ' minutes', $emailBody);

        $message = file_get_contents('../../notification-setting/template/default-email.html');
        $message = str_replace('{EMAIL_SUBJECT}', $emailSubject, $message);
        $message = str_replace('{EMAIL_CONTENT}', $emailBody, $message);
    
        $mailer = new PHPMailer\PHPMailer\PHPMailer();
        $this->configureSMTP(1, $mailer);
        
        $mailer->setFrom($mailFromEmail, $mailFromName);
        $mailer->addAddress($email);
        $mailer->Subject = $emailSubject;
        $mailer->Body = $message;
    
        if ($mailer->send()) {
            return true;
        }
        else {
            return 'Failed to send OTP. Error: ' . $mailer->ErrorInfo;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: sendPasswordReset
    # Description: 
    # Sends a password reset email containing a password reset link to the user's email address.
    #
    # Parameters: 
    # - $email (string): The email address of the user.
    # - $userAccountID (int): The user ID.
    # - $resetToken (string): The reset token generated.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function sendPasswordReset($email, $userAccountID, $resetToken, $resetPasswordTokenDuration) {
        $emailSetting = $this->emailSettingModel->getEmailSetting(1);
        $mailFromName = $emailSetting['mail_from_name'];
        $mailFromEmail = $emailSetting['mail_from_email'];

        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(3);
        $defaultForgotPasswordLink = $securitySettingDetails['value'];

        $notificationSettingDetails = $this->notificationSettingModel->getEmailNotificationTemplate(2);
        $emailSubject = $notificationSettingDetails['email_notification_subject'] ?? null;
        $emailBody = $notificationSettingDetails['email_notification_body'] ?? null;
        $emailBody = str_replace('#{RESET_LINK}', $defaultForgotPasswordLink . $userAccountID .'&token=' . $resetToken, $emailBody);
        $emailBody = str_replace('#{RESET_LINK_VALIDITY}', $resetPasswordTokenDuration . ' minute', $emailBody);

        $message = file_get_contents('../../notification-setting/template/default-email.html');
        $message = str_replace('{EMAIL_SUBJECT}', $emailSubject, $message);
        $message = str_replace('{EMAIL_CONTENT}', $emailBody, $message);
    
        $mailer = new PHPMailer\PHPMailer\PHPMailer();
        $this->configureSMTP(1, $mailer);
        
        $mailer->setFrom($mailFromEmail, $mailFromName);
        $mailer->addAddress($email);
        $mailer->Subject = $emailSubject;
        $mailer->Body = $message;
    
        if ($mailer->send()) {
            return true;
        } 
        else {
            return 'Failed to send password reset email. Error: ' . $mailer->ErrorInfo;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Configure methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: configureSMTP
    # Description: 
    # Sets the SMTP configuration
    #
    # Parameters: 
    # - $mailer (array): The PHP mailer.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    private function configureSMTP($emailSettingID, $mailer, $isHTML = true) {
        $emailSetting = $this->emailSettingModel->getEmailSetting($emailSettingID);
        $mailHost = $emailSetting['mail_host'] ?? MAIL_HOST;
        $smtpAuth = empty($emailSetting['smtp_auth']) ? false : true;
        $mailUsername = $emailSetting['mail_username'] ?? MAIL_USERNAME;
        $mailPassword = !empty($password) ? $this->securityModel->decryptData($emailSetting['mail_password']) : MAIL_PASSWORD;
        $mailEncryption = $emailSetting['mail_encryption'] ?? MAIL_SMTP_SECURE;
        $port = $emailSetting['port'] ?? MAIL_PORT;
        
        $mailer->isSMTP();
        $mailer->isHTML(true);
        $mailer->Host = $mailHost;
        $mailer->SMTPAuth = $smtpAuth;
        $mailer->Username = $mailUsername;
        $mailer->Password = $mailPassword;
        $mailer->SMTPSecure = $mailEncryption;
        $mailer->Port = $port;
    }
    # -------------------------------------------------------------
}

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../authentication/model/authentication-model.php';
require_once '../../general-settings/model/security-setting-model.php';
require_once '../../email-setting/model/email-setting-model.php';
require_once '../../notification-setting/model/notification-setting-model.php';
require_once '../../../assets/libs/phpmailer/src/PHPMailer.php';
require_once '../../../assets/libs/phpmailer/src/Exception.php';
require_once '../../../assets/libs/phpmailer/src/SMTP.php';

$controller = new AuthenticationController(new AuthenticationModel(new DatabaseModel), new SecuritySettingModel(new DatabaseModel), new EmailSettingModel(new DatabaseModel), new NotificationSettingModel(new DatabaseModel), new SystemModel(), new SecurityModel());
$controller->handleRequest();
?>