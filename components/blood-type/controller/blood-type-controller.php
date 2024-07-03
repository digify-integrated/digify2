<?php
session_start();

# -------------------------------------------------------------
#
# Function: BloodTypeController
# Description: 
# The BloodTypeController class handles blood type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class BloodTypeController {
    private $bloodTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided BloodTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for blood type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param BloodTypeModel $bloodTypeModel     The BloodTypeModel instance for blood type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BloodTypeModel $bloodTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->bloodTypeModel = $bloodTypeModel;
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
                case 'add blood type':
                    $this->addBloodType();
                    break;
                case 'update blood type':
                    $this->updateBloodType();
                    break;
                case 'get blood type details':
                    $this->getBloodTypeDetails();
                    break;
                case 'delete blood type':
                    $this->deleteBloodType();
                    break;
                case 'delete multiple blood type':
                    $this->deleteMultipleBloodType();
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
    # Function: addBloodType
    # Description: 
    # Inserts a blood type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addBloodType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['blood_type_name']) && !empty($_POST['blood_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $bloodTypeName = $_POST['blood_type_name'];
        
            $bloodTypeID = $this->bloodTypeModel->insertBloodType($bloodTypeName, $userID);
    
            $response = [
                'success' => true,
                'bloodTypeID' => $this->securityModel->encryptData($bloodTypeID),
                'title' => 'Insert Blood Type Success',
                'message' => 'The blood type has been inserted successfully.',
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
    # Function: updateBloodType
    # Description: 
    # Updates the blood type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBloodType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['blood_type_id']) && !empty($_POST['blood_type_id']) && isset($_POST['blood_type_name']) && !empty($_POST['blood_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $bloodTypeID = htmlspecialchars($_POST['blood_type_id'], ENT_QUOTES, 'UTF-8');
            $bloodTypeName = $_POST['blood_type_name'];
        
            $checkBloodTypeExist = $this->bloodTypeModel->checkBloodTypeExist($bloodTypeID);
            $total = $checkBloodTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Blood Type Error',
                    'message' => 'The blood type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bloodTypeModel->updateBloodType($bloodTypeID, $bloodTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Blood Type Success',
                'message' => 'The blood type has been updated successfully.',
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
    # Function: deleteBloodType
    # Description: 
    # Delete the blood type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteBloodType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['blood_type_id']) && !empty($_POST['blood_type_id'])) {
            $bloodTypeID = htmlspecialchars($_POST['blood_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBloodTypeExist = $this->bloodTypeModel->checkBloodTypeExist($bloodTypeID);
            $total = $checkBloodTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Blood Type Error',
                    'message' => 'The blood type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bloodTypeModel->deleteBloodType($bloodTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Blood Type Success',
                'message' => 'The blood type has been deleted successfully.',
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
    # Function: deleteMultipleBloodType
    # Description: 
    # Delete the selected blood type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleBloodType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['blood_type_id']) && !empty($_POST['blood_type_id'])) {
            $bloodTypeIDs = $_POST['blood_type_id'];
    
            foreach($bloodTypeIDs as $bloodTypeID){
                $checkBloodTypeExist = $this->bloodTypeModel->checkBloodTypeExist($bloodTypeID);
                $total = $checkBloodTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->bloodTypeModel->deleteBloodType($bloodTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Blood Types Success',
                'message' => 'The selected blood types have been deleted successfully.',
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
    # Function: getBloodTypeDetails
    # Description: 
    # Handles the retrieval of blood type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBloodTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['blood_type_id']) && !empty($_POST['blood_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bloodTypeID = htmlspecialchars($_POST['blood_type_id'], ENT_QUOTES, 'UTF-8');

            $checkBloodTypeExist = $this->bloodTypeModel->checkBloodTypeExist($bloodTypeID);
            $total = $checkBloodTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Blood Type Details Error',
                    'message' => 'The blood type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $bloodTypeDetails = $this->bloodTypeModel->getBloodType($bloodTypeID);

            $response = [
                'success' => true,
                'bloodTypeName' => $bloodTypeDetails['blood_type_name'] ?? null,
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
require_once '../../blood-type/model/blood-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new BloodTypeController(new BloodTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>