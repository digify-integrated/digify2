<?php
session_start();

# -------------------------------------------------------------
#
# Function: AddressTypeController
# Description: 
# The AddressTypeController class handles address type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class AddressTypeController {
    private $addressTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided AddressTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for address type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param AddressTypeModel $addressTypeModel     The AddressTypeModel instance for address type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(AddressTypeModel $addressTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->addressTypeModel = $addressTypeModel;
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
                case 'add address type':
                    $this->addAddressType();
                    break;
                case 'update address type':
                    $this->updateAddressType();
                    break;
                case 'get address type details':
                    $this->getAddressTypeDetails();
                    break;
                case 'delete address type':
                    $this->deleteAddressType();
                    break;
                case 'delete multiple address type':
                    $this->deleteMultipleAddressType();
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
    # Function: addAddressType
    # Description: 
    # Inserts a address type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addAddressType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['address_type_name']) && !empty($_POST['address_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $addressTypeName = $_POST['address_type_name'];
        
            $addressTypeID = $this->addressTypeModel->insertAddressType($addressTypeName, $userID);
    
            $response = [
                'success' => true,
                'addressTypeID' => $this->securityModel->encryptData($addressTypeID),
                'title' => 'Insert Address Type Success',
                'message' => 'The address type has been inserted successfully.',
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
    # Function: updateAddressType
    # Description: 
    # Updates the address type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateAddressType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['address_type_id']) && !empty($_POST['address_type_id']) && isset($_POST['address_type_name']) && !empty($_POST['address_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $addressTypeID = htmlspecialchars($_POST['address_type_id'], ENT_QUOTES, 'UTF-8');
            $addressTypeName = $_POST['address_type_name'];
        
            $checkAddressTypeExist = $this->addressTypeModel->checkAddressTypeExist($addressTypeID);
            $total = $checkAddressTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Address Type Error',
                    'message' => 'The address type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->addressTypeModel->updateAddressType($addressTypeID, $addressTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Address Type Success',
                'message' => 'The address type has been updated successfully.',
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
    # Function: deleteAddressType
    # Description: 
    # Delete the address type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteAddressType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['address_type_id']) && !empty($_POST['address_type_id'])) {
            $addressTypeID = htmlspecialchars($_POST['address_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkAddressTypeExist = $this->addressTypeModel->checkAddressTypeExist($addressTypeID);
            $total = $checkAddressTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Address Type Error',
                    'message' => 'The address type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->addressTypeModel->deleteAddressType($addressTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Address Type Success',
                'message' => 'The address type has been deleted successfully.',
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
    # Function: deleteMultipleAddressType
    # Description: 
    # Delete the selected address type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleAddressType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['address_type_id']) && !empty($_POST['address_type_id'])) {
            $addressTypeIDs = $_POST['address_type_id'];
    
            foreach($addressTypeIDs as $addressTypeID){
                $checkAddressTypeExist = $this->addressTypeModel->checkAddressTypeExist($addressTypeID);
                $total = $checkAddressTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->addressTypeModel->deleteAddressType($addressTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Address Types Success',
                'message' => 'The selected address types have been deleted successfully.',
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
    # Function: getAddressTypeDetails
    # Description: 
    # Handles the retrieval of address type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getAddressTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['address_type_id']) && !empty($_POST['address_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $addressTypeID = htmlspecialchars($_POST['address_type_id'], ENT_QUOTES, 'UTF-8');

            $checkAddressTypeExist = $this->addressTypeModel->checkAddressTypeExist($addressTypeID);
            $total = $checkAddressTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Address Type Details Error',
                    'message' => 'The address type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $addressTypeDetails = $this->addressTypeModel->getAddressType($addressTypeID);

            $response = [
                'success' => true,
                'addressTypeName' => $addressTypeDetails['address_type_name'] ?? null,
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
require_once '../../address-type/model/address-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new AddressTypeController(new AddressTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>