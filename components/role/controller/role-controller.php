<?php
session_start();

# -------------------------------------------------------------
#
# Function: RoleController
# Description: 
# The RoleController class handles role related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class RoleController {
    private $roleModel;
    private $userAccountModel;
    private $menuItemModel;
    private $systemActionModel;
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
    # - @param RoleModel $roleModel     The RoleModel instance for role related operations.
    # - @param UserAccountModel $userAccountModel     The UserAccountModel instance for user account related operations.
    # - @param MenuItemModel $menuItemModel     The MenuItemModel instance for menu item related operations.
    # - @param SystemActionModel $systemActionModel     The SystemActionModel instance for system action related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(RoleModel $roleModel, UserAccountModel $userAccountModel, MenuItemModel $menuItemModel, SystemActionModel $systemActionModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->roleModel = $roleModel;
        $this->userAccountModel = $userAccountModel;
        $this->menuItemModel = $menuItemModel;
        $this->systemActionModel = $systemActionModel;
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
                case 'add role':
                    $this->addRole();
                    break;
                case 'assign role permission':
                    $this->assignRolePermission();
                    break;
                case 'assign menu item role permission':
                    $this->assignMenuItemRolePermission();
                    break;
                case 'assign role system action permission':
                    $this->assignRoleSystemActionPermission();
                    break;
                case 'assign system action role permission':
                    $this->assignSystemActionRolePermission();
                    break;
                case 'assign role user account':
                    $this->assignRoleUserAccount();
                    break;
                case 'assign user account role':
                    $this->assignUserAccountRole();
                    break;
                case 'update role':
                    $this->updateRole();
                    break;
                case 'update role permission':
                    $this->updateRolePermission();
                    break;
                case 'update role system action permission':
                    $this->updateRoleSystemActionPermission();
                    break;
                case 'get role details':
                    $this->getRoleDetails();
                    break;
                case 'delete role':
                    $this->deleteRole();
                    break;
                case 'delete role permission':
                    $this->deleteRolePermission();
                    break;
                case 'delete role system action permission':
                    $this->deleteRoleSystemActionPermission();
                    break;
                case 'delete role user account':
                    $this->deleteRoleUserAccount();
                    break;
                case 'delete user account role':
                    $this->deleteUserAccountRole();
                    break;
                case 'delete multiple role':
                    $this->deleteMultipleRole();
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
    # Function: addRole
    # Description: 
    # Inserts a role.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_name']) && !empty($_POST['role_name']) && isset($_POST['role_description']) && !empty($_POST['role_description'])) {
            $userID = $_SESSION['user_account_id'];
            $roleName = htmlspecialchars($_POST['role_name'], ENT_QUOTES, 'UTF-8');
            $roleDescription = htmlspecialchars($_POST['role_description'], ENT_QUOTES, 'UTF-8');
        
            $roleID = $this->roleModel->insertRole($roleName, $roleDescription, $userID);
    
            $response = [
                'success' => true,
                'roleID' => $this->securityModel->encryptData($roleID),
                'title' => 'Insert Role Success',
                'message' => 'The role has been inserted successfully.',
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
    # Function: updateRole
    # Description: 
    # Updates the role if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['role_id']) && !empty($_POST['role_id']) && isset($_POST['role_name']) && !empty($_POST['role_name']) && isset($_POST['role_description']) && !empty($_POST['role_description'])) {
            $userID = $_SESSION['user_account_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
            $roleName = htmlspecialchars($_POST['role_name'], ENT_QUOTES, 'UTF-8');
            $roleDescription = htmlspecialchars($_POST['role_description'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
            $total = $checkRoleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Role Error',
                    'message' => 'The role does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->updateRole($roleID, $roleName, $roleDescription, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Role Success',
                'message' => 'The role has been updated successfully.',
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
    # Function: updateRolePermission
    # Description: 
    # Update the role permission if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateRolePermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_permission_id']) && !empty($_POST['role_permission_id']) && isset($_POST['access_type']) && !empty($_POST['access_type']) && isset($_POST['access'])) {
            $userID = $_SESSION['user_account_id'];
            $rolePermissionID = htmlspecialchars($_POST['role_permission_id'], ENT_QUOTES, 'UTF-8');
            $accessType = htmlspecialchars($_POST['access_type'], ENT_QUOTES, 'UTF-8');
            $access = htmlspecialchars($_POST['access'], ENT_QUOTES, 'UTF-8');
        
            $checkRolePermissionExist = $this->roleModel->checkRolePermissionExist($rolePermissionID);
            $total = $checkRolePermissionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Role Permission Error',
                    'message' => 'The role permission does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->updateRolePermission($rolePermissionID, $accessType, $access, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Role Permission Success',
                'message' => 'The role permission has been updated successfully.',
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
    # Function: updateRoleSystemActionPermission
    # Description: 
    # Update the role permission if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateRoleSystemActionPermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_system_action_permission_id']) && !empty($_POST['role_system_action_permission_id']) && isset($_POST['system_action_access'])) {
            $userID = $_SESSION['user_account_id'];
            $roleSystemActionPermissionID = htmlspecialchars($_POST['role_system_action_permission_id'], ENT_QUOTES, 'UTF-8');
            $systemActionAccess = htmlspecialchars($_POST['system_action_access'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleSystemActionPermissionExist = $this->roleModel->checkRoleSystemActionPermissionExist($roleSystemActionPermissionID);
            $total = $checkRoleSystemActionPermissionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Role Permission Error',
                    'message' => 'The role permission does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->updateRoleSystemActionPermission($roleSystemActionPermissionID, $systemActionAccess, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Role Permission Success',
                'message' => 'The role permission has been updated successfully.',
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
    #   Assign methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: assignRolePermission
    # Description: 
    # Assigns a role permission.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignRolePermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            if(!isset($_POST['menu_item_id']) || empty($_POST['menu_item_id'])){
                $response = [
                    'success' => false,
                    'title' => 'Permission Selection Required',
                    'message' => 'Please select the menu item(s) you wish to assign to the role.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_account_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
            $menuItemIDs = $_POST['menu_item_id'];
            
            $roleDetails = $this->roleModel->getRole($roleID);
            $roleName = $roleDetails['role_name'] ?? null;

            foreach ($menuItemIDs as $menuItemID) {
                $menuItemDetails = $this->menuItemModel->getMenuItem($menuItemID);
                $menuItemName = $menuItemDetails['menu_item_name'] ?? null;

                $this->roleModel->insertRolePermission($roleID, $roleName, $menuItemID, $menuItemName, $userID);
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign Role Permission Success',
                'message' => 'The role permission has been assigned successfully.',
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
    # Function: assignRoleUserAccount
    # Description: 
    # Assigns a role user account.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignRoleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            if(!isset($_POST['user_account_id']) || empty($_POST['user_account_id'])){
                $response = [
                    'success' => false,
                    'title' => 'User Account Selection Required',
                    'message' => 'Please select the user account(s) you wish to assign to the role.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_account_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
            $userAccountIDs = $_POST['user_account_id'];
            
            $roleDetails = $this->roleModel->getRole($roleID);
            $roleName = $roleDetails['role_name'] ?? null;

            foreach ($userAccountIDs as $userAccountID) {
                $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);
                $fileAs = $userAccountDetails['file_as'] ?? null;

                $this->roleModel->insertRoleUserAccount($roleID, $roleName, $userAccountID, $fileAs, $userID);
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign User Account Success',
                'message' => 'The user account has been assigned successfully.',
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
    # Function: assignUserAccountRole
    # Description: 
    # Assigns a user account role.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignUserAccountRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            if(!isset($_POST['role_id']) || empty($_POST['role_id'])){ 
                $response = [
                    'success' => false,
                    'title' => 'Role Selection Required',
                    'message' => 'Please select the role(s) you wish to assign to the user account.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
            $roleIDs = $_POST['role_id'];

            $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);
            $fileAs = $userAccountDetails['file_as'] ?? null;

            foreach ($roleIDs as $roleID) {
                if(strpos($roleID, '_helper2') === false) {
                    $roleDetails = $this->roleModel->getRole($roleID);
                    $roleName = $roleDetails['role_name'] ?? null;
    
                    $this->roleModel->insertRoleUserAccount($roleID, $roleName, $userAccountID, $fileAs, $userID);
                }
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign Role Success',
                'message' => 'The role has been assigned successfully.',
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
    # Function: assignRoleSystemActionPermission
    # Description: 
    # Assigns a role system action permission.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignRoleSystemActionPermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            if(!isset($_POST['system_action_id']) || empty($_POST['system_action_id'])){
                $response = [
                    'success' => false,
                    'title' => 'Permission Selection Required',
                    'message' => 'Please select the system action(s) you wish to assign to the role.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_account_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
            $systemActionIDs = $_POST['system_action_id'];
            
            $roleDetails = $this->roleModel->getRole($roleID);
            $roleName = $roleDetails['role_name'] ?? null;

            foreach ($systemActionIDs as $systemActionID) {
                $systemActionDetails = $this->systemActionModel->getSystemAction($systemActionID);
                $systemActionName = $systemActionDetails['system_action_name'] ?? null;

                $this->roleModel->insertRoleSystemActionPermission($roleID, $roleName, $systemActionID, $systemActionName, $userID);
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign System Action Permission Success',
                'message' => 'The system action permission has been assigned successfully.',
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
    # Function: assignMenuItemRolePermission
    # Description: 
    # Assigns a menu item role permission.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignMenuItemRolePermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])) {
            if(!isset($_POST['role_id']) || empty($_POST['role_id'])){
                $response = [
                    'success' => false,
                    'title' => 'Permission Selection Required',
                    'message' => 'Please select the role(s) you wish to assign to the menu item.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_account_id'];
            $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');
            $roleIDs = $_POST['role_id'];

            $menuItemDetails = $this->menuItemModel->getMenuItem($menuItemID);
            $menuItemName = $menuItemDetails['menu_item_name'] ?? null;

            foreach ($roleIDs as $roleID) {
                $roleDetails = $this->roleModel->getRole($roleID);
                $roleName = $roleDetails['role_name'] ?? null;

                $this->roleModel->insertRolePermission($roleID, $roleName, $menuItemID, $menuItemName, $userID);
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign Role Permission Success',
                'message' => 'The role permission has been assigned successfully.',
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
    # Function: assignSystemActionRolePermission
    # Description: 
    # Assigns a menu item role system action permission.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignSystemActionRolePermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['system_action_id']) && !empty($_POST['system_action_id'])) {
            if(!isset($_POST['role_id']) || empty($_POST['role_id'])){
                $response = [
                    'success' => false,
                    'title' => 'Permission Selection Required',
                    'message' => 'Please select the role(s) you wish to assign to the system action.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_account_id'];
            $systemActionID = htmlspecialchars($_POST['system_action_id'], ENT_QUOTES, 'UTF-8');
            $roleIDs = $_POST['role_id'];

            $systemActionDetails = $this->systemActionModel->getSystemAction($systemActionID);
            $systemActionName = $systemActionDetails['system_action_name'] ?? null;

            foreach ($roleIDs as $roleID) {
                $roleDetails = $this->roleModel->getRole($roleID);
                $roleName = $roleDetails['role_name'] ?? null;

                $this->roleModel->insertRoleSystemActionPermission($roleID, $roleName, $systemActionID, $systemActionName, $userID);
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign Role Permission Success',
                'message' => 'The role permission has been assigned successfully.',
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
    # Function: deleteRole
    # Description: 
    # Delete the role if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
            $total = $checkRoleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Role Error',
                    'message' => 'The role does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->deleteRole($roleID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Role Success',
                'message' => 'The role has been deleted successfully.',
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
    # Function: deleteRolePermission
    # Description: 
    # Delete the role permission if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteRolePermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_permission_id']) && !empty($_POST['role_permission_id'])) {
            $rolePermissionID = htmlspecialchars($_POST['role_permission_id'], ENT_QUOTES, 'UTF-8');
        
            $checkRolePermissionExist = $this->roleModel->checkRolePermissionExist($rolePermissionID);
            $total = $checkRolePermissionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Role Permission Error',
                    'message' => 'The role permission does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->deleteRolePermission($rolePermissionID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Role Permission Success',
                'message' => 'The role permission has been deleted successfully.',
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
    # Function: deleteRoleSystemActionPermission
    # Description: 
    # Delete the role system action permission if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteRoleSystemActionPermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_system_action_permission_id']) && !empty($_POST['role_system_action_permission_id'])) {
            $roleSystemActionPermissionID = htmlspecialchars($_POST['role_system_action_permission_id'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleSystemActionPermissionExist = $this->roleModel->checkRoleSystemActionPermissionExist($roleSystemActionPermissionID);
            $total = $checkRoleSystemActionPermissionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Role Permission Error',
                    'message' => 'The role permission does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->deleteRoleSystemActionPermission($roleSystemActionPermissionID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Role Permission Success',
                'message' => 'The role permission has been deleted successfully.',
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
    # Function: deleteRoleUserAccount
    # Description: 
    # Delete the role user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteRoleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_user_account_id']) && !empty($_POST['role_user_account_id'])) {
            $roleUserAccountID = htmlspecialchars($_POST['role_user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleUserAccountExist = $this->roleModel->checkRoleUserAccountExist($roleUserAccountID);
            $total = $checkRoleUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete User Account Error',
                    'message' => 'The role permission does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->deleteRoleUserAccount($roleUserAccountID);
                
            $response = [
                'success' => true,
                'title' => 'Delete User Account Success',
                'message' => 'The user account has been deleted successfully.',
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
    # Function: deleteUserAccountRole
    # Description: 
    # Delete the role user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteUserAccountRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_user_account_id']) && !empty($_POST['role_user_account_id'])) {
            $roleUserAccountID = htmlspecialchars($_POST['role_user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleUserAccountExist = $this->roleModel->checkRoleUserAccountExist($roleUserAccountID);
            $total = $checkRoleUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Role Error',
                    'message' => 'The role permission does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->deleteRoleUserAccount($roleUserAccountID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Role Success',
                'message' => 'The role has been deleted successfully.',
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
    # Function: deleteMultipleRole
    # Description: 
    # Delete the selected roles if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            $roleIDs = $_POST['role_id'];
    
            foreach($roleIDs as $roleID){
                $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
                $total = $checkRoleExist['total'] ?? 0;

                if($total > 0){
                    $this->roleModel->deleteRole($roleID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Role Success',
                'message' => 'The selected roles have been deleted successfully.',
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
    # Function: getRoleDetails
    # Description: 
    # Handles the retrieval of role details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getRoleDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            $userID = $_SESSION['user_account_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');

            $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
            $total = $checkRoleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Role Details Error',
                    'message' => 'The role does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $roleDetails = $this->roleModel->getRole($roleID);

            $response = [
                'success' => true,
                'roleName' => $roleDetails['role_name'] ?? null,
                'roleDescription' => $roleDetails['role_description'] ?? null
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
require_once '../../role/model/role-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../menu-item/model/menu-item-model.php';
require_once '../../system-action/model/system-action-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new RoleController(new RoleModel(new DatabaseModel), new UserAccountModel(new DatabaseModel), new MenuItemModel(new DatabaseModel), new SystemActionModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>