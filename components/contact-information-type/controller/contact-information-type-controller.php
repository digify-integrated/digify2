<?php
session_start();

# -------------------------------------------------------------
#
# Function: ContactInformationTypeController
# Description: 
# The ContactInformationTypeController class handles contact information type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ContactInformationTypeController {
    private $contactInformationTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided ContactInformationTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for contact information type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ContactInformationTypeModel $contactInformationTypeModel     The ContactInformationTypeModel instance for contact information type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ContactInformationTypeModel $contactInformationTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->contactInformationTypeModel = $contactInformationTypeModel;
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
                case 'add contact information type':
                    $this->addContactInformationType();
                    break;
                case 'update contact information type':
                    $this->updateContactInformationType();
                    break;
                case 'get contact information type details':
                    $this->getContactInformationTypeDetails();
                    break;
                case 'delete contact information type':
                    $this->deleteContactInformationType();
                    break;
                case 'delete multiple contact information type':
                    $this->deleteMultipleContactInformationType();
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
    # Function: addContactInformationType
    # Description: 
    # Inserts a contact information type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addContactInformationType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_information_type_name']) && !empty($_POST['contact_information_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $contactInformationTypeName = $_POST['contact_information_type_name'];
        
            $contactInformationTypeID = $this->contactInformationTypeModel->insertContactInformationType($contactInformationTypeName, $userID);
    
            $response = [
                'success' => true,
                'contactInformationTypeID' => $this->securityModel->encryptData($contactInformationTypeID),
                'title' => 'Insert Contact Information Type Success',
                'message' => 'The contact information type has been inserted successfully.',
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
    # Function: updateContactInformationType
    # Description: 
    # Updates the contact information type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateContactInformationType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['contact_information_type_id']) && !empty($_POST['contact_information_type_id']) && isset($_POST['contact_information_type_name']) && !empty($_POST['contact_information_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $contactInformationTypeID = htmlspecialchars($_POST['contact_information_type_id'], ENT_QUOTES, 'UTF-8');
            $contactInformationTypeName = $_POST['contact_information_type_name'];
        
            $checkContactInformationTypeExist = $this->contactInformationTypeModel->checkContactInformationTypeExist($contactInformationTypeID);
            $total = $checkContactInformationTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Contact Information Type Error',
                    'message' => 'The contact information type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contactInformationTypeModel->updateContactInformationType($contactInformationTypeID, $contactInformationTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Contact Information Type Success',
                'message' => 'The contact information type has been updated successfully.',
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
    # Function: deleteContactInformationType
    # Description: 
    # Delete the contact information type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteContactInformationType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_information_type_id']) && !empty($_POST['contact_information_type_id'])) {
            $contactInformationTypeID = htmlspecialchars($_POST['contact_information_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContactInformationTypeExist = $this->contactInformationTypeModel->checkContactInformationTypeExist($contactInformationTypeID);
            $total = $checkContactInformationTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Contact Information Type Error',
                    'message' => 'The contact information type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contactInformationTypeModel->deleteContactInformationType($contactInformationTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Contact Information Type Success',
                'message' => 'The contact information type has been deleted successfully.',
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
    # Function: deleteMultipleContactInformationType
    # Description: 
    # Delete the selected contact information type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleContactInformationType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_information_type_id']) && !empty($_POST['contact_information_type_id'])) {
            $contactInformationTypeIDs = $_POST['contact_information_type_id'];
    
            foreach($contactInformationTypeIDs as $contactInformationTypeID){
                $checkContactInformationTypeExist = $this->contactInformationTypeModel->checkContactInformationTypeExist($contactInformationTypeID);
                $total = $checkContactInformationTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->contactInformationTypeModel->deleteContactInformationType($contactInformationTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Contact Information Types Success',
                'message' => 'The selected contact information types have been deleted successfully.',
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
    # Function: getContactInformationTypeDetails
    # Description: 
    # Handles the retrieval of contact information type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getContactInformationTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['contact_information_type_id']) && !empty($_POST['contact_information_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contactInformationTypeID = htmlspecialchars($_POST['contact_information_type_id'], ENT_QUOTES, 'UTF-8');

            $checkContactInformationTypeExist = $this->contactInformationTypeModel->checkContactInformationTypeExist($contactInformationTypeID);
            $total = $checkContactInformationTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Contact Information Type Details Error',
                    'message' => 'The contact information type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $contactInformationTypeDetails = $this->contactInformationTypeModel->getContactInformationType($contactInformationTypeID);

            $response = [
                'success' => true,
                'contactInformationTypeName' => $contactInformationTypeDetails['contact_information_type_name'] ?? null,
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
require_once '../../contact-information-type/model/contact-information-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ContactInformationTypeController(new ContactInformationTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>