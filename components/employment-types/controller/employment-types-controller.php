<?php
session_start();

# -------------------------------------------------------------
#
# Function: EmploymentTypesController
# Description: 
# The EmploymentTypesController class handles employment types related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class EmploymentTypesController {
    private $employmentTypesModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided EmploymentTypesModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for employment types related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param EmploymentTypesModel $employmentTypesModel     The EmploymentTypesModel instance for employment types related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(EmploymentTypesModel $employmentTypesModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->employmentTypesModel = $employmentTypesModel;
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
                case 'add employment types':
                    $this->addEmploymentTypes();
                    break;
                case 'update employment types':
                    $this->updateEmploymentTypes();
                    break;
                case 'update app logo':
                    $this->updateAppLogo();
                    break;
                case 'get employment types details':
                    $this->getEmploymentTypesDetails();
                    break;
                case 'delete employment types':
                    $this->deleteEmploymentTypes();
                    break;
                case 'delete multiple employment types':
                    $this->deleteMultipleEmploymentTypes();
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
    # Function: addEmploymentTypes
    # Description: 
    # Inserts a employment types.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addEmploymentTypes() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employment_types_name']) && !empty($_POST['employment_types_name'])) {
            $userID = $_SESSION['user_account_id'];
            $employmentTypesName = $_POST['employment_types_name'];
        
            $employmentTypesID = $this->employmentTypesModel->insertEmploymentTypes($employmentTypesName, $userID);
    
            $response = [
                'success' => true,
                'employmentTypesID' => $this->securityModel->encryptData($employmentTypesID),
                'title' => 'Insert Employment Types Success',
                'message' => 'The employment types has been inserted successfully.',
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
    # Function: updateEmploymentTypes
    # Description: 
    # Updates the employment types if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmploymentTypes() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employment_types_id']) && !empty($_POST['employment_types_id']) && isset($_POST['employment_types_name']) && !empty($_POST['employment_types_name'])) {
            $userID = $_SESSION['user_account_id'];
            $employmentTypesID = htmlspecialchars($_POST['employment_types_id'], ENT_QUOTES, 'UTF-8');
            $employmentTypesName = $_POST['employment_types_name'];
        
            $checkEmploymentTypesExist = $this->employmentTypesModel->checkEmploymentTypesExist($employmentTypesID);
            $total = $checkEmploymentTypesExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Employment Types Error',
                    'message' => 'The employment types does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employmentTypesModel->updateEmploymentTypes($employmentTypesID, $employmentTypesName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Employment Types Success',
                'message' => 'The employment types has been updated successfully.',
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
    # Function: deleteEmploymentTypes
    # Description: 
    # Delete the employment types if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteEmploymentTypes() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employment_types_id']) && !empty($_POST['employment_types_id'])) {
            $employmentTypesID = htmlspecialchars($_POST['employment_types_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmploymentTypesExist = $this->employmentTypesModel->checkEmploymentTypesExist($employmentTypesID);
            $total = $checkEmploymentTypesExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Employment Types Error',
                    'message' => 'The employment types does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employmentTypesModel->deleteEmploymentTypes($employmentTypesID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Employment Types Success',
                'message' => 'The employment types has been deleted successfully.',
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
    # Function: deleteMultipleEmploymentTypes
    # Description: 
    # Delete the selected employment types if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleEmploymentTypes() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employment_types_id']) && !empty($_POST['employment_types_id'])) {
            $employmentTypesIDs = $_POST['employment_types_id'];
    
            foreach($employmentTypesIDs as $employmentTypesID){
                $checkEmploymentTypesExist = $this->employmentTypesModel->checkEmploymentTypesExist($employmentTypesID);
                $total = $checkEmploymentTypesExist['total'] ?? 0;

                if($total > 0){                    
                    $this->employmentTypesModel->deleteEmploymentTypes($employmentTypesID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Employment Types Success',
                'message' => 'The selected employment types have been deleted successfully.',
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
    # Function: getEmploymentTypesDetails
    # Description: 
    # Handles the retrieval of employment types details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getEmploymentTypesDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['employment_types_id']) && !empty($_POST['employment_types_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employmentTypesID = htmlspecialchars($_POST['employment_types_id'], ENT_QUOTES, 'UTF-8');

            $checkEmploymentTypesExist = $this->employmentTypesModel->checkEmploymentTypesExist($employmentTypesID);
            $total = $checkEmploymentTypesExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Employment Types Details Error',
                    'message' => 'The employment types does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employmentTypesDetails = $this->employmentTypesModel->getEmploymentTypes($employmentTypesID);
            $appLogo = $this->systemModel->checkImage($employmentTypesDetails['app_logo'] ?? null, 'employment types logo');

            $response = [
                'success' => true,
                'employmentTypesName' => $employmentTypesDetails['employment_types_name'] ?? null,
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
require_once '../../employment-types/model/employment-types-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new EmploymentTypesController(new EmploymentTypesModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>