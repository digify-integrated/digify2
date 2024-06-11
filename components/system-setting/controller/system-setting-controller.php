<?php
session_start();

# -------------------------------------------------------------
#
# Function: SystemSettingController
# Description: 
# The SystemSettingController class handles system setting related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class SystemSettingController {
    private $systemSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided systemSettingModel, AuthenticationModel and SystemModel instances.
    # These instances are used for system setting related, user related operations and system related operations, respectively.
    #
    # Parameters:
    # - @param systemSettingModel $systemSettingModel     The systemSettingModel instance for system setting related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(SystemSettingModel $systemSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->systemSettingModel = $systemSettingModel;
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
                case 'add system setting':
                    $this->addSystemSetting();
                    break;
                case 'update system setting':
                    $this->updateSystemSetting();
                    break;
                case 'get system setting details':
                    $this->getSystemSettingDetails();
                    break;
                case 'delete system setting':
                    $this->deleteSystemSetting();
                    break;
                case 'delete multiple system setting':
                    $this->deleteMultipleSystemSetting();
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
    # Function: addSystemSetting
    # Description: 
    # Inserts a system setting.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addSystemSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['system_setting_name']) && !empty($_POST['system_setting_name']) && isset($_POST['system_setting_description']) && !empty($_POST['system_setting_description']) && isset($_POST['value']) && !empty($_POST['value'])) {
            $userID = $_SESSION['user_account_id'];
            $systemSettingName = htmlspecialchars($_POST['system_setting_name'], ENT_QUOTES, 'UTF-8');
            $systemSettingDescription = htmlspecialchars($_POST['system_setting_description'], ENT_QUOTES, 'UTF-8');
            $value = $_POST['value'];
        
            $systemSettingID = $this->systemSettingModel->insertSystemSetting($systemSettingName, $systemSettingDescription, $value, $userID);
    
            $response = [
                'success' => true,
                'systemSettingID' => $this->securityModel->encryptData($systemSettingID),
                'title' => 'Insert System Setting Success',
                'message' => 'The system setting has been inserted successfully.',
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
    # Function: updateSystemSetting
    # Description: 
    # Updates the system setting if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateSystemSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['system_setting_id']) && !empty($_POST['system_setting_id']) && isset($_POST['system_setting_name']) && !empty($_POST['system_setting_name']) && isset($_POST['system_setting_description']) && !empty($_POST['system_setting_description']) && isset($_POST['value']) && !empty($_POST['value'])) {
            $userID = $_SESSION['user_account_id'];
            $systemSettingID = htmlspecialchars($_POST['system_setting_id'], ENT_QUOTES, 'UTF-8');
            $systemSettingName = htmlspecialchars($_POST['system_setting_name'], ENT_QUOTES, 'UTF-8');
            $systemSettingDescription = htmlspecialchars($_POST['system_setting_description'], ENT_QUOTES, 'UTF-8');
            $value = $_POST['value'];
        
            $checkSystemSettingExist = $this->systemSettingModel->checkSystemSettingExist($systemSettingID);
            $total = $checkSystemSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update System Setting Error',
                    'message' => 'The system setting does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->systemSettingModel->updateSystemSetting($systemSettingID, $systemSettingName, $systemSettingDescription, $value, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update System Setting Success',
                'message' => 'The system setting has been updated successfully.',
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
    # Function: deleteSystemSetting
    # Description: 
    # Delete the system setting if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteSystemSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['system_setting_id']) && !empty($_POST['system_setting_id'])) {
            $systemSettingID = htmlspecialchars($_POST['system_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSystemSettingExist = $this->systemSettingModel->checkSystemSettingExist($systemSettingID);
            $total = $checkSystemSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete System Setting Error',
                    'message' => 'The system setting does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->systemSettingModel->deleteSystemSetting($systemSettingID);
                
            $response = [
                'success' => true,
                'title' => 'Delete System Setting Success',
                'message' => 'The system setting has been deleted successfully.',
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
    # Function: deleteMultipleSystemSetting
    # Description: 
    # Delete the selected system settings if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleSystemSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['system_setting_id']) && !empty($_POST['system_setting_id'])) {
            $systemSettingIDs = $_POST['system_setting_id'];
    
            foreach($systemSettingIDs as $systemSettingID){
                $checkSystemSettingExist = $this->systemSettingModel->checkSystemSettingExist($systemSettingID);
                $total = $checkSystemSettingExist['total'] ?? 0;

                if($total > 0){
                    $this->systemSettingModel->deleteSystemSetting($systemSettingID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple System Setting Success',
                'message' => 'The selected system settings have been deleted successfully.',
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
    # Function: getSystemSettingDetails
    # Description: 
    # Handles the retrieval of system setting details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getSystemSettingDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['system_setting_id']) && !empty($_POST['system_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $systemSettingID = htmlspecialchars($_POST['system_setting_id'], ENT_QUOTES, 'UTF-8');

            $checkSystemSettingExist = $this->systemSettingModel->checkSystemSettingExist($systemSettingID);
            $total = $checkSystemSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get System Setting Details Error',
                    'message' => 'The system setting does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $systemSettingDetails = $this->systemSettingModel->getSystemSetting($systemSettingID);

            $response = [
                'success' => true,
                'systemSettingName' => $systemSettingDetails['system_setting_name'] ?? null,
                'systemSettingDescription' => $systemSettingDetails['system_setting_description'] ?? null,
                'value' => $systemSettingDetails['value'] ?? null
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
require_once '../../system-setting/model/system-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new SystemSettingController(new systemSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>