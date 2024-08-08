<?php
session_start();

# -------------------------------------------------------------
#
# Function: MenuGroupController
# Description: 
# The MenuGroupController class handles menu group related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class MenuGroupController {
    private $menuGroupModel;
    private $appModuleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided MenuGroupModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for menu group related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param MenuGroupModel $menuGroupModel     The MenuGroupModel instance for menu group related operations.
    # - @param AppModuleModel $appModuleModel     The AppModuleModel instance for app module related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(MenuGroupModel $menuGroupModel, AppModuleModel $appModuleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->menuGroupModel = $menuGroupModel;
        $this->appModuleModel = $appModuleModel;
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
                case 'add menu group':
                    $this->addMenuGroup();
                    break;
                case 'update menu group':
                    $this->updateMenuGroup();
                    break;
                case 'get menu group details':
                    $this->getMenuGroupDetails();
                    break;
                case 'delete menu group':
                    $this->deleteMenuGroup();
                    break;
                case 'delete multiple menu group':
                    $this->deleteMultipleMenuGroup();
                    break;
                default:
                    $response = [
                        'success' => false,
                        'title' => 'Error: Transaction Failed',
                        'message' => 'An error occurred while processing your transaction. Please try again or contact our support team for assistance.',
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
    # Function: addMenuGroup
    # Description: 
    # Inserts a menu group.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addMenuGroup() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['menu_group_name']) && !empty($_POST['menu_group_name']) && isset($_POST['app_module_id']) && !empty($_POST['app_module_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $menuGroupName = htmlspecialchars($_POST['menu_group_name'], ENT_QUOTES, 'UTF-8');
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');

            $appModuleDetails = $this->appModuleModel->getAppModule($appModuleID);
            $appModuleName = $appModuleDetails['app_module_name'];
        
            $menuGroupID = $this->menuGroupModel->insertMenuGroup($menuGroupName, $appModuleID, $appModuleName, $orderSequence, $userID);
    
            $response = [
                'success' => true,
                'menuGroupID' => $this->securityModel->encryptData($menuGroupID),
                'title' => 'Insert Menu Group Success',
                'message' => 'The menu group has been inserted successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again or contact our support team for assistance.',
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
    # Function: updateMenuGroup
    # Description: 
    # Updates the menu group if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateMenuGroup() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['menu_group_name']) && !empty($_POST['menu_group_name']) && isset($_POST['app_module_id']) && !empty($_POST['app_module_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $menuGroupID = htmlspecialchars($_POST['menu_group_id'], ENT_QUOTES, 'UTF-8');
            $menuGroupName = htmlspecialchars($_POST['menu_group_name'], ENT_QUOTES, 'UTF-8');
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');
        
            $checkMenuGroupExist = $this->menuGroupModel->checkMenuGroupExist($menuGroupID);
            $total = $checkMenuGroupExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Menu Group Error',
                    'message' => 'The menu group does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $appModuleDetails = $this->appModuleModel->getAppModule($appModuleID);
            $appModuleName = $appModuleDetails['app_module_name'];

            $this->menuGroupModel->updateMenuGroup($menuGroupID, $menuGroupName, $appModuleID, $appModuleName, $orderSequence, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Menu Group Success',
                'message' => 'The menu group has been updated successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again or contact our support team for assistance.',
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
    # Function: deleteMenuGroup
    # Description: 
    # Delete the menu group if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMenuGroup() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['menu_group_id']) && !empty($_POST['menu_group_id'])) {
            $menuGroupID = htmlspecialchars($_POST['menu_group_id'], ENT_QUOTES, 'UTF-8');
        
            $checkMenuGroupExist = $this->menuGroupModel->checkMenuGroupExist($menuGroupID);
            $total = $checkMenuGroupExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Menu Group Error',
                    'message' => 'The menu group does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->menuGroupModel->deleteMenuGroup($menuGroupID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Menu Group Success',
                'message' => 'The menu group has been deleted successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again or contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteMultipleMenuGroup
    # Description: 
    # Delete the selected menu groups if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleMenuGroup() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['menu_group_id']) && !empty($_POST['menu_group_id'])) {
            $menuGroupIDs = $_POST['menu_group_id'];
    
            foreach($menuGroupIDs as $menuGroupID){
                $checkMenuGroupExist = $this->menuGroupModel->checkMenuGroupExist($menuGroupID);
                $total = $checkMenuGroupExist['total'] ?? 0;

                if($total > 0){
                    $this->menuGroupModel->deleteMenuGroup($menuGroupID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Menu Group Success',
                'message' => 'The selected menu groups have been deleted successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again or contact our support team for assistance.',
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
    # Function: getMenuGroupDetails
    # Description: 
    # Handles the retrieval of menu group details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getMenuGroupDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['menu_group_id']) && !empty($_POST['menu_group_id'])) {
            $userID = $_SESSION['user_account_id'];
            $menuGroupID = htmlspecialchars($_POST['menu_group_id'], ENT_QUOTES, 'UTF-8');

            $checkMenuGroupExist = $this->menuGroupModel->checkMenuGroupExist($menuGroupID);
            $total = $checkMenuGroupExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Menu Group Details Error',
                    'message' => 'The menu group does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $menuGroupDetails = $this->menuGroupModel->getMenuGroup($menuGroupID);

            $response = [
                'success' => true,
                'menuGroupName' => $menuGroupDetails['menu_group_name'] ?? null,
                'appModuleID' => $menuGroupDetails['app_module_id'] ?? null,
                'appModuleName' => $menuGroupDetails['app_module_name'] ?? null,
                'orderSequence' => $menuGroupDetails['order_sequence'] ?? null,
            ];

            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again or contact our support team for assistance.',
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
require_once '../../menu-group/model/menu-group-model.php';
require_once '../../app-module/model/app-module-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new MenuGroupController(new MenuGroupModel(new DatabaseModel), new AppModuleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>