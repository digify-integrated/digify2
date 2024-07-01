<?php
session_start();

# -------------------------------------------------------------
#
# Function: EmploymentTypeController
# Description: 
# The EmploymentTypeController class handles employment type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class EmploymentTypeController {
    private $employmentTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided EmploymentTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for employment type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param EmploymentTypeModel $employmentTypeModel     The EmploymentTypeModel instance for employment type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(EmploymentTypeModel $employmentTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->employmentTypeModel = $employmentTypeModel;
        $this->authenticationModel = $authenticationModel;
        $this->securityModel = $securityModel;
        $this->systemModel = $systemModel;
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
                case 'add employment type':
                    $this->addEmploymentType();
                    break;
                case 'update employment type':
                    $this->updateEmploymentType();
                    break;
                case 'update app logo':
                    $this->updateAppLogo();
                    break;
                case 'get employment type details':
                    $this->getEmploymentTypeDetails();
                    break;
                case 'delete employment type':
                    $this->deleteEmploymentType();
                    break;
                case 'delete multiple employment type':
                    $this->deleteMultipleEmploymentType();
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
    # Function: addEmploymentType
    # Description: 
    # Inserts a employment type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addEmploymentType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employment_type_name']) && !empty($_POST['employment_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $employmentTypeName = $_POST['employment_type_name'];
        
            $employmentTypeID = $this->employmentTypeModel->insertEmploymentType($employmentTypeName, $userID);
    
            $response = [
                'success' => true,
                'employmentTypeID' => $this->securityModel->encryptData($employmentTypeID),
                'title' => 'Insert Employment Type Success',
                'message' => 'The employment type has been inserted successfully.',
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
    # Function: updateEmploymentType
    # Description: 
    # Updates the employment type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmploymentType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employment_type_id']) && !empty($_POST['employment_type_id']) && isset($_POST['employment_type_name']) && !empty($_POST['employment_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $employmentTypeID = htmlspecialchars($_POST['employment_type_id'], ENT_QUOTES, 'UTF-8');
            $employmentTypeName = $_POST['employment_type_name'];
        
            $checkEmploymentTypeExist = $this->employmentTypeModel->checkEmploymentTypeExist($employmentTypeID);
            $total = $checkEmploymentTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Employment Type Error',
                    'message' => 'The employment type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employmentTypeModel->updateEmploymentType($employmentTypeID, $employmentTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Employment Type Success',
                'message' => 'The employment type has been updated successfully.',
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
    # Function: deleteEmploymentType
    # Description: 
    # Delete the employment type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteEmploymentType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employment_type_id']) && !empty($_POST['employment_type_id'])) {
            $employmentTypeID = htmlspecialchars($_POST['employment_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmploymentTypeExist = $this->employmentTypeModel->checkEmploymentTypeExist($employmentTypeID);
            $total = $checkEmploymentTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Employment Type Error',
                    'message' => 'The employment type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employmentTypeModel->deleteEmploymentType($employmentTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Employment Type Success',
                'message' => 'The employment type has been deleted successfully.',
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
    # Function: deleteMultipleEmploymentType
    # Description: 
    # Delete the selected employment type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleEmploymentType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employment_type_id']) && !empty($_POST['employment_type_id'])) {
            $employmentTypeIDs = $_POST['employment_type_id'];
    
            foreach($employmentTypeIDs as $employmentTypeID){
                $checkEmploymentTypeExist = $this->employmentTypeModel->checkEmploymentTypeExist($employmentTypeID);
                $total = $checkEmploymentTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->employmentTypeModel->deleteEmploymentType($employmentTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Employment Type Success',
                'message' => 'The selected employment type have been deleted successfully.',
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
    # Function: getEmploymentTypeDetails
    # Description: 
    # Handles the retrieval of employment type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getEmploymentTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['employment_type_id']) && !empty($_POST['employment_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employmentTypeID = htmlspecialchars($_POST['employment_type_id'], ENT_QUOTES, 'UTF-8');

            $checkEmploymentTypeExist = $this->employmentTypeModel->checkEmploymentTypeExist($employmentTypeID);
            $total = $checkEmploymentTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Employment Type Details Error',
                    'message' => 'The employment type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employmentTypeDetails = $this->employmentTypeModel->getEmploymentType($employmentTypeID);
            $appLogo = $this->systemModel->checkImage($employmentTypeDetails['app_logo'] ?? null, 'employment type logo');

            $response = [
                'success' => true,
                'employmentTypeName' => $employmentTypeDetails['employment_type_name'] ?? null,
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
require_once '../../employment-type/model/employment-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new EmploymentTypeController(new EmploymentTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>