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
                case 'add security setting':
                    $this->addSecuritySetting();
                    break;
                case 'update security setting':
                    $this->updateSecuritySetting();
                    break;
                case 'get security setting details':
                    $this->getSecuritySettingDetails();
                    break;
                case 'delete security setting':
                    $this->deleteSecuritySetting();
                    break;
                case 'delete multiple security setting':
                    $this->deleteMultipleSecuritySetting();
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
    #   Add methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: addSecuritySetting
    # Description: 
    # Inserts a security setting.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addSecuritySetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['security_setting_name']) && !empty($_POST['security_setting_name']) && isset($_POST['security_setting_description']) && !empty($_POST['security_setting_description']) && isset($_POST['value']) && !empty($_POST['value'])) {
            $userID = $_SESSION['user_account_id'];
            $securitySettingName = htmlspecialchars($_POST['security_setting_name'], ENT_QUOTES, 'UTF-8');
            $securitySettingDescription = htmlspecialchars($_POST['security_setting_description'], ENT_QUOTES, 'UTF-8');
            $value = $_POST['value'];
        
            $securitySettingID = $this->securitySettingModel->insertSecuritySetting($securitySettingName, $securitySettingDescription, $value, $userID);
    
            $response = [
                'success' => true,
                'securitySettingID' => $this->securityModel->encryptData($securitySettingID),
                'title' => 'Insert Security Setting Success',
                'message' => 'The security setting has been inserted successfully.',
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
        
        if (isset($_POST['security_setting_id']) && !empty($_POST['security_setting_id']) && isset($_POST['security_setting_name']) && !empty($_POST['security_setting_name']) && isset($_POST['security_setting_description']) && !empty($_POST['security_setting_description']) && isset($_POST['value']) && !empty($_POST['value'])) {
            $userID = $_SESSION['user_account_id'];
            $securitySettingID = htmlspecialchars($_POST['security_setting_id'], ENT_QUOTES, 'UTF-8');
            $securitySettingName = htmlspecialchars($_POST['security_setting_name'], ENT_QUOTES, 'UTF-8');
            $securitySettingDescription = htmlspecialchars($_POST['security_setting_description'], ENT_QUOTES, 'UTF-8');
            $value = $_POST['value'];
        
            $checkSecuritySettingExist = $this->securitySettingModel->checkSecuritySettingExist($securitySettingID);
            $total = $checkSecuritySettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Security Setting Error',
                    'message' => 'The security setting does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->securitySettingModel->updateSecuritySetting($securitySettingID, $securitySettingName, $securitySettingDescription, $value, $userID);
                
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
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteSecuritySetting
    # Description: 
    # Delete the security setting if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteSecuritySetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['security_setting_id']) && !empty($_POST['security_setting_id'])) {
            $securitySettingID = htmlspecialchars($_POST['security_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSecuritySettingExist = $this->securitySettingModel->checkSecuritySettingExist($securitySettingID);
            $total = $checkSecuritySettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Security Setting Error',
                    'message' => 'The security setting does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->securitySettingModel->deleteSecuritySetting($securitySettingID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Security Setting Success',
                'message' => 'The security setting has been deleted successfully.',
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
    #
    # Function: deleteMultipleSecuritySetting
    # Description: 
    # Delete the selected security settings if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleSecuritySetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['security_setting_id']) && !empty($_POST['security_setting_id'])) {
            $securitySettingIDs = $_POST['security_setting_id'];
    
            foreach($securitySettingIDs as $securitySettingID){
                $checkSecuritySettingExist = $this->securitySettingModel->checkSecuritySettingExist($securitySettingID);
                $total = $checkSecuritySettingExist['total'] ?? 0;

                if($total > 0){
                    $this->securitySettingModel->deleteSecuritySetting($securitySettingID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Security Setting Success',
                'message' => 'The selected security settings have been deleted successfully.',
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
    
        if (isset($_POST['security_setting_id']) && !empty($_POST['security_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $securitySettingID = htmlspecialchars($_POST['security_setting_id'], ENT_QUOTES, 'UTF-8');

            $checkSecuritySettingExist = $this->securitySettingModel->checkSecuritySettingExist($securitySettingID);
            $total = $checkSecuritySettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Security Setting Details Error',
                    'message' => 'The security setting does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $securitySettingDetails = $this->securitySettingModel->getSecuritySetting($securitySettingID);

            $response = [
                'success' => true,
                'securitySettingName' => $securitySettingDetails['security_setting_name'] ?? null,
                'securitySettingDescription' => $securitySettingDetails['security_setting_description'] ?? null,
                'value' => $securitySettingDetails['value'] ?? null
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
}
# -------------------------------------------------------------

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../security-setting/model/security-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new SecuritySettingController(new securitySettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>