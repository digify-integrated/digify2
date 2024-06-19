<?php
session_start();

# -------------------------------------------------------------
#
# Function: SecuritySettingController
# Description: 
# The SecuritySettingController class handles security setting related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class SecuritySettingController {
    private $securitySettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided securitySettingModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for security setting related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param securitySettingModel $securitySettingModel     The securitySettingModel instance for security setting related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(SecuritySettingModel $securitySettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->securitySettingModel = $securitySettingModel;
        $this->authenticationModel = $authenticationModel;
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
            $userID = $_SESSION['user_account_id'];
            $sessionToken = $_SESSION['session_token'];

            $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist($userID, null);
            $total = $checkLoginCredentialsExist['total'] ?? 0;

            if ($total === 0) {
                $response = [
                    'success' => false,
                    'userNotExist' => true,
                    'title' => 'User Account Not Exist',
                    'message' => 'The user account specified does not exist. Please contact the administrator for assistance.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials($userID, null);
            $active = $loginCredentialsDetails['active'];
            $locked = $loginCredentialsDetails['locked'];
            $multipleSession = $loginCredentialsDetails['multiple_session'];
            $sessionToken = $this->securityModel->decryptData($loginCredentialsDetails['session_token']);

            if ($active === 'No') {
                $response = [
                    'success' => false,
                    'userInactive' => true,
                    'title' => 'User Account Inactive',
                    'message' => 'Your account is currently inactive. Kindly reach out to the administrator for further assistance.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            if ($locked === 'Yes') {
                $response = [
                    'success' => false,
                    'userLocked' => true,
                    'title' => 'User Account Locked',
                    'message' => 'Your account is currently locked. Kindly reach out to the administrator for assistance in unlocking it.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if ($sessionToken != $sessionToken && $multipleSession == 'No') {
                $response = [
                    'success' => false,
                    'sessionExpired' => true,
                    'title' => 'Session Expired',
                    'message' => 'Your session has expired. Please log in again to continue',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $transaction = isset($_POST['transaction']) ? $_POST['transaction'] : null;

            switch ($transaction) {
                case 'update security settings':
                    $this->updateSecuritySetting();
                    break;
                case 'get security setting details':
                    $this->getSecuritySettingDetails();
                    break;
                default:
                    $response = [
                        'success' => false,
                        'title' => 'Transaction Error',
                        'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    break;
            }
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSecuritySetting
    # Description: 
    # Updates the security setting if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateSecuritySetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['max_failed_login']) && !empty($_POST['max_failed_login']) && isset($_POST['max_failed_otp_attempt']) && !empty($_POST['max_failed_otp_attempt']) && isset($_POST['password_expiry_duration']) && !empty($_POST['password_expiry_duration']) && isset($_POST['otp_duration']) && !empty($_POST['otp_duration']) && isset($_POST['reset_password_token_duration']) && !empty($_POST['reset_password_token_duration']) && isset($_POST['session_inactivity_limit']) && !empty($_POST['session_inactivity_limit']) && isset($_POST['password_recovery_link']) && !empty($_POST['password_recovery_link'])) {
            $userID = $_SESSION['user_account_id'];
            $maxFailedLogin = htmlspecialchars($_POST['max_failed_login'], ENT_QUOTES, 'UTF-8');
            $max_FailedOTPAttempt = htmlspecialchars($_POST['max_failed_otp_attempt'], ENT_QUOTES, 'UTF-8');
            $passwordExpiryDuration = htmlspecialchars($_POST['password_expiry_duration'], ENT_QUOTES, 'UTF-8');
            $otpDuration = htmlspecialchars($_POST['otp_duration'], ENT_QUOTES, 'UTF-8');
            $resetPasswordTokenDuration = htmlspecialchars($_POST['reset_password_token_duration'], ENT_QUOTES, 'UTF-8');
            $sessionInactivityLimit = htmlspecialchars($_POST['session_inactivity_limit'], ENT_QUOTES, 'UTF-8');
            $passwordRecoveryLink = $_POST['password_recovery_link'];

            $this->securitySettingModel->updateSecuritySetting($maxFailedLogin, $max_FailedOTPAttempt, $passwordExpiryDuration, $otpDuration, $resetPasswordTokenDuration, $sessionInactivityLimit, $passwordRecoveryLink, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Security Setting Success',
                'message' => 'The security setting has been updated successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get details methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSecuritySettingDetails
    # Description: 
    # Handles the retrieval of security setting details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getSecuritySettingDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $userID = $_SESSION['user_account_id'];

        $response = [
            'success' => true,
            'maxFailedLogin' => $this->securitySettingModel->getSecuritySetting(1)['value'] ?? MAX_FAILED_LOGIN_ATTEMPTS,
            'maxFailedOTPAttempt' => $this->securitySettingModel->getSecuritySetting(2)['value'] ?? MAX_FAILED_OTP_ATTEMPTS,
            'passwordRecoveryLink' => $this->securitySettingModel->getSecuritySetting(3)['value'] ?? DEFAULT_PASSWORD_RECOVERY_LINK,
            'passwordExpiryDuration' => $this->securitySettingModel->getSecuritySetting(4)['value'] ?? DEFAULT_PASSWORD_DURATION,
            'sessionInactivityLimit' => $this->securitySettingModel->getSecuritySetting(5)['value'] ?? DEFAULT_SESSION_INACTIVITY,
            'otpDuration' => $this->securitySettingModel->getSecuritySetting(6)['value'] ?? DEFAULT_OTP_DURATION,
            'resetPasswordTokenDuration' => $this->securitySettingModel->getSecuritySetting(7)['value'] ?? RESET_PASSWORD_TOKEN_DURATION
        ];

        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------
}
# -------------------------------------------------------------

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../general-settings/model/security-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new SecuritySettingController(new SecuritySettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>