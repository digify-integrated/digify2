<?php
session_start();

# -------------------------------------------------------------
#
# Function: DepartmentController
# Description: 
# The DepartmentController class handles department related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class DepartmentController {
    private $departmentModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided departmentModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for department related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param DepartmentModel $departmentModel     The departmentModel instance for department related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(DepartmentModel $departmentModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->departmentModel = $departmentModel;
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
                case 'add department':
                    $this->addDepartment();
                    break;
                case 'update department':
                    $this->updateDepartment();
                    break;
                case 'get department details':
                    $this->getDepartmentDetails();
                    break;
                case 'delete department':
                    $this->deleteDepartment();
                    break;
                case 'delete multiple department':
                    $this->deleteMultipleDepartment();
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
    # Function: addDepartment
    # Description: 
    # Inserts a department.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addDepartment() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['department_name']) && !empty($_POST['department_name']) && isset($_POST['parent_department_id']) && isset($_POST['manager_id'])) {
            $userID = $_SESSION['user_account_id'];
            $departmentName = $_POST['department_name'];
            $parentDepartmentID = htmlspecialchars($_POST['parent_department_id'], ENT_QUOTES, 'UTF-8');
            $managerID = htmlspecialchars($_POST['manager_id'], ENT_QUOTES, 'UTF-8');

            $parentDepartmentDetails = $this->departmentModel->getDepartment($parentDepartmentID);
            $parentDepartmentName = $parentDepartmentDetails['department_name'] ?? '';
        
            $departmentID = $this->departmentModel->insertDepartment($departmentName, $parentDepartmentID, $parentDepartmentName, '', '', $userID);
    
            $response = [
                'success' => true,
                'departmentID' => $this->securityModel->encryptData($departmentID),
                'title' => 'Insert Department Success',
                'message' => 'The department has been inserted successfully.',
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
    # Function: updateDepartment
    # Description: 
    # Updates the department if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateDepartment() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['department_name']) && !empty($_POST['department_name']) && isset($_POST['parent_department_id']) && isset($_POST['manager_id'])) {
            $userID = $_SESSION['user_account_id'];
            $departmentID = htmlspecialchars($_POST['department_id'], ENT_QUOTES, 'UTF-8');
            $departmentName = $_POST['department_name'];
            $parentDepartmentID = htmlspecialchars($_POST['parent_department_id'], ENT_QUOTES, 'UTF-8');
            $managerID = htmlspecialchars($_POST['manager_id'], ENT_QUOTES, 'UTF-8');
        
            $checkDepartmentExist = $this->departmentModel->checkDepartmentExist($departmentID);
            $total = $checkDepartmentExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Department Error',
                    'message' => 'The department does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $parentDepartmentDetails = $this->departmentModel->getDepartment($parentDepartmentID);
            $parentDepartmentName = $parentDepartmentDetails['department_name'] ?? '';

            $this->departmentModel->updateDepartment($departmentID, $departmentName, $parentDepartmentID, $parentDepartmentName, '', '', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Department Success',
                'message' => 'The department has been updated successfully.',
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
    # Function: deleteDepartment
    # Description: 
    # Delete the department if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteDepartment() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['department_id']) && !empty($_POST['department_id'])) {
            $departmentID = htmlspecialchars($_POST['department_id'], ENT_QUOTES, 'UTF-8');
        
            $checkDepartmentExist = $this->departmentModel->checkDepartmentExist($departmentID);
            $total = $checkDepartmentExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Department Error',
                    'message' => 'The department does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->departmentModel->deleteDepartment($departmentID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Department Success',
                'message' => 'The department has been deleted successfully.',
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
    # Function: deleteMultipleDepartment
    # Description: 
    # Delete the selected departments if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleDepartment() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['department_id']) && !empty($_POST['department_id'])) {
            $departmentIDs = $_POST['department_id'];
    
            foreach($departmentIDs as $departmentID){
                $checkDepartmentExist = $this->departmentModel->checkDepartmentExist($departmentID);
                $total = $checkDepartmentExist['total'] ?? 0;

                if($total > 0){
                    $this->departmentModel->deleteDepartment($departmentID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Departments Success',
                'message' => 'The selected departments have been deleted successfully.',
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
    # Function: getDepartmentDetails
    # Description: 
    # Handles the retrieval of department details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getDepartmentDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['department_id']) && !empty($_POST['department_id'])) {
            $userID = $_SESSION['user_account_id'];
            $departmentID = htmlspecialchars($_POST['department_id'], ENT_QUOTES, 'UTF-8');

            $checkDepartmentExist = $this->departmentModel->checkDepartmentExist($departmentID);
            $total = $checkDepartmentExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Department Details Error',
                    'message' => 'The department does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $departmentDetails = $this->departmentModel->getDepartment($departmentID);

            $response = [
                'success' => true,
                'departmentName' => $departmentDetails['department_name'] ?? null,
                'parentDepartmentID' => !empty($departmentDetails['parent_department_id']) ? $departmentDetails['parent_department_id'] : '',
                'parentDepartmentName' => $departmentDetails['parent_department_name'] ?? null,
                'managerID' => $departmentDetails['manager_id'] ?? '',
                'managerName' => $departmentDetails['manager_name'] ?? null
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
require_once '../../department/model/department-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new DepartmentController(new DepartmentModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>