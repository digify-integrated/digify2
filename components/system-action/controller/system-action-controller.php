<?php
session_start();

# -------------------------------------------------------------
#
# Function: SystemActionController
# Description: 
# The SystemActionController class handles system action related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class SystemActionController {
    private $systemActionModel;
    private $roleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided RoleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for role related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param SystemActionModel $systemActionModel     The SystemActionModel instance for system action related operations.
    # - @param RoleModel $roleModel     The RoleModel instance for role related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(SystemActionModel $systemActionModel, RoleModel $roleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->systemActionModel = $systemActionModel;
        $this->roleModel = $roleModel;
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
                case 'add system action':
                    $this->addSystemAction();
                    break;
                case 'update system action':
                    $this->updateSystemAction();
                    break;
                case 'get system action details':
                    $this->getSystemActionDetails();
                    break;
                case 'delete system action':
                    $this->deleteSystemAction();
                    break;
                case 'delete multiple system action':
                    $this->deleteMultipleSystemAction();
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
    # Function: addSystemAction
    # Description: 
    # Inserts a system action.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addSystemAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['system_action_name']) && !empty($_POST['system_action_name']) && isset($_POST['system_action_description']) && !empty($_POST['system_action_description'])) {
            $userID = $_SESSION['user_account_id'];
            $systemActionName = htmlspecialchars($_POST['system_action_name'], ENT_QUOTES, 'UTF-8');
            $systemActionDescription = htmlspecialchars($_POST['system_action_description'], ENT_QUOTES, 'UTF-8');
        
            $systemActionID = $this->systemActionModel->insertSystemAction($systemActionName, $systemActionDescription, $userID);
    
            $response = [
                'success' => true,
                'systemActionID' => $this->securityModel->encryptData($systemActionID),
                'title' => 'Insert System Action Success',
                'message' => 'The system action has been inserted successfully.',
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
    # Function: updateSystemAction
    # Description: 
    # Updates the system action if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateSystemAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['system_action_id']) && !empty($_POST['system_action_id']) && isset($_POST['system_action_name']) && !empty($_POST['system_action_name']) && isset($_POST['system_action_description']) && !empty($_POST['system_action_description'])) {
            $userID = $_SESSION['user_account_id'];
            $systemActionID = htmlspecialchars($_POST['system_action_id'], ENT_QUOTES, 'UTF-8');
            $systemActionName = htmlspecialchars($_POST['system_action_name'], ENT_QUOTES, 'UTF-8');
            $systemActionDescription = htmlspecialchars($_POST['system_action_description'], ENT_QUOTES, 'UTF-8');
        
            $checkSystemActionExist = $this->systemActionModel->checkSystemActionExist($systemActionID);
            $total = $checkSystemActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update System Action Error',
                    'message' => 'The system action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->systemActionModel->updateSystemAction($systemActionID, $systemActionName, $systemActionDescription, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update System Action Success',
                'message' => 'The system action has been updated successfully.',
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
    # Function: deleteSystemAction
    # Description: 
    # Delete the system action if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteSystemAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['system_action_id']) && !empty($_POST['system_action_id'])) {
            $systemActionID = htmlspecialchars($_POST['system_action_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSystemActionExist = $this->systemActionModel->checkSystemActionExist($systemActionID);
            $total = $checkSystemActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete System Action Error',
                    'message' => 'The system action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->systemActionModel->deleteSystemAction($systemActionID);
                
            $response = [
                'success' => true,
                'title' => 'Delete System Action Success',
                'message' => 'The system action has been deleted successfully.',
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
    # Function: deleteMultipleSystemAction
    # Description: 
    # Delete the selected system actions if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleSystemAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['system_action_id']) && !empty($_POST['system_action_id'])) {
            $systemActionIDs = $_POST['system_action_id'];
    
            foreach($systemActionIDs as $systemActionID){
                $checkSystemActionExist = $this->systemActionModel->checkSystemActionExist($systemActionID);
                $total = $checkSystemActionExist['total'] ?? 0;

                if($total > 0){
                    $this->systemActionModel->deleteSystemAction($systemActionID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple System Action Success',
                'message' => 'The selected system actions have been deleted successfully.',
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
    # Function: getSystemActionDetails
    # Description: 
    # Handles the retrieval of system action details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getSystemActionDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['system_action_id']) && !empty($_POST['system_action_id'])) {
            $userID = $_SESSION['user_account_id'];
            $systemActionID = htmlspecialchars($_POST['system_action_id'], ENT_QUOTES, 'UTF-8');

            $checkSystemActionExist = $this->systemActionModel->checkSystemActionExist($systemActionID);
            $total = $checkSystemActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get System Action Details Error',
                    'message' => 'The system action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $systemActionDetails = $this->systemActionModel->getSystemAction($systemActionID);

            $response = [
                'success' => true,
                'systemActionName' => $systemActionDetails['system_action_name'] ?? null,
                'systemActionDescription' => $systemActionDetails['system_action_description'] ?? null
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
require_once '../../system-action/model/system-action-model.php';
require_once '../../role/model/role-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new SystemActionController(new SystemActionModel(new DatabaseModel), new RoleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>