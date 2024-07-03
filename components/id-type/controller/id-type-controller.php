<?php
session_start();

# -------------------------------------------------------------
#
# Function: IDTypeController
# Description: 
# The IDTypeController class handles id type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class IDTypeController {
    private $idTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided IDTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for id type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param IDTypeModel $idTypeModel     The IDTypeModel instance for id type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(IDTypeModel $idTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->idTypeModel = $idTypeModel;
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
                case 'add id type':
                    $this->addIDType();
                    break;
                case 'update id type':
                    $this->updateIDType();
                    break;
                case 'get id type details':
                    $this->getIDTypeDetails();
                    break;
                case 'delete id type':
                    $this->deleteIDType();
                    break;
                case 'delete multiple id type':
                    $this->deleteMultipleIDType();
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
    # Function: addIDType
    # Description: 
    # Inserts a id type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addIDType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['id_type_name']) && !empty($_POST['id_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $idTypeName = $_POST['id_type_name'];
        
            $idTypeID = $this->idTypeModel->insertIDType($idTypeName, $userID);
    
            $response = [
                'success' => true,
                'idTypeID' => $this->securityModel->encryptData($idTypeID),
                'title' => 'Insert ID Type Success',
                'message' => 'The id type has been inserted successfully.',
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
    # Function: updateIDType
    # Description: 
    # Updates the id type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateIDType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['id_type_id']) && !empty($_POST['id_type_id']) && isset($_POST['id_type_name']) && !empty($_POST['id_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $idTypeID = htmlspecialchars($_POST['id_type_id'], ENT_QUOTES, 'UTF-8');
            $idTypeName = $_POST['id_type_name'];
        
            $checkIDTypeExist = $this->idTypeModel->checkIDTypeExist($idTypeID);
            $total = $checkIDTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update ID Type Error',
                    'message' => 'The id type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->idTypeModel->updateIDType($idTypeID, $idTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update ID Type Success',
                'message' => 'The id type has been updated successfully.',
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
    # Function: deleteIDType
    # Description: 
    # Delete the id type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteIDType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['id_type_id']) && !empty($_POST['id_type_id'])) {
            $idTypeID = htmlspecialchars($_POST['id_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkIDTypeExist = $this->idTypeModel->checkIDTypeExist($idTypeID);
            $total = $checkIDTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete ID Type Error',
                    'message' => 'The id type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->idTypeModel->deleteIDType($idTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete ID Type Success',
                'message' => 'The id type has been deleted successfully.',
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
    # Function: deleteMultipleIDType
    # Description: 
    # Delete the selected id type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleIDType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['id_type_id']) && !empty($_POST['id_type_id'])) {
            $idTypeIDs = $_POST['id_type_id'];
    
            foreach($idTypeIDs as $idTypeID){
                $checkIDTypeExist = $this->idTypeModel->checkIDTypeExist($idTypeID);
                $total = $checkIDTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->idTypeModel->deleteIDType($idTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple ID Types Success',
                'message' => 'The selected id types have been deleted successfully.',
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
    # Function: getIDTypeDetails
    # Description: 
    # Handles the retrieval of id type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getIDTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['id_type_id']) && !empty($_POST['id_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $idTypeID = htmlspecialchars($_POST['id_type_id'], ENT_QUOTES, 'UTF-8');

            $checkIDTypeExist = $this->idTypeModel->checkIDTypeExist($idTypeID);
            $total = $checkIDTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get ID Type Details Error',
                    'message' => 'The id type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $idTypeDetails = $this->idTypeModel->getIDType($idTypeID);

            $response = [
                'success' => true,
                'idTypeName' => $idTypeDetails['id_type_name'] ?? null,
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
require_once '../../id-type/model/id-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new IDTypeController(new IDTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>