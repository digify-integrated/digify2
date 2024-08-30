<?php
session_start();

# -------------------------------------------------------------
#
# Function: ContactFormController
# Description: 
# The ContactFormController class handles contact form related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ContactFormController {
    private $contactFormModel;
    private $blockStyleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided contactFormModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for contact form related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ContactFormModel $contactFormModel     The contactFormModel instance for contact form related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ContactFormModel $contactFormModel, BlockStyleModel $blockStyleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->contactFormModel = $contactFormModel;
        $this->blockStyleModel = $blockStyleModel;
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
                case 'add contact form':
                    $this->addContactForm();
                    break;
                case 'update contact form':
                    $this->updateContactForm();
                    break;
                case 'get contact form details':
                    $this->getContactFormDetails();
                    break;
                case 'publish contact form':
                    $this->publishContactForm();
                    break;
                case 'unpublish contact form':
                    $this->unpublishContactForm();
                    break;
                case 'delete contact form':
                    $this->deleteContactForm();
                    break;
                case 'delete multiple contact form':
                    $this->deleteMultipleContactForm();
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
    # Function: addContactForm
    # Description: 
    # Inserts a contact form.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addContactForm() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_form_name']) && !empty($_POST['contact_form_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $contactFormName = $_POST['contact_form_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $contactFormID = $this->contactFormModel->insertContactForm($contactFormName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'contactFormID' => $this->securityModel->encryptData($contactFormID),
                'title' => 'Insert Contact Form Success',
                'message' => 'The contact form has been inserted successfully.',
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
    # Function: updateContactForm
    # Description: 
    # Updates the contact form if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateContactForm() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['contact_form_name']) && !empty($_POST['contact_form_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $contactFormID = htmlspecialchars($_POST['contact_form_id'], ENT_QUOTES, 'UTF-8');
            $contactFormName = $_POST['contact_form_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkContactFormExist = $this->contactFormModel->checkContactFormExist($contactFormID);
            $total = $checkContactFormExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Contact Form Error',
                    'message' => 'The contact form does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->contactFormModel->updateContactForm($contactFormID, $contactFormName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Contact Form Success',
                'message' => 'The contact form has been updated successfully.',
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
    #   Publish methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: publishContactForm
    # Description: 
    # Publish the contact form if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishContactForm() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_form_id']) && !empty($_POST['contact_form_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contactFormID = htmlspecialchars($_POST['contact_form_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContactFormExist = $this->contactFormModel->checkContactFormExist($contactFormID);
            $total = $checkContactFormExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Contact Form Error',
                    'message' => 'The contact form does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contactFormModel->updateContactFormPublishStatus($contactFormID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Contact Form Success',
                'message' => 'The contact form has been published successfully.',
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
    #   Publish methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: unpublishContactForm
    # Description: 
    # Publish the contact form if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishContactForm() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_form_id']) && !empty($_POST['contact_form_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contactFormID = htmlspecialchars($_POST['contact_form_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContactFormExist = $this->contactFormModel->checkContactFormExist($contactFormID);
            $total = $checkContactFormExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Contact Form Error',
                    'message' => 'The contact form does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contactFormModel->updateContactFormPublishStatus($contactFormID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Contact Form Success',
                'message' => 'The contact form has been unpublished successfully.',
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
    # Function: deleteContactForm
    # Description: 
    # Delete the contact form if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteContactForm() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_form_id']) && !empty($_POST['contact_form_id'])) {
            $contactFormID = htmlspecialchars($_POST['contact_form_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContactFormExist = $this->contactFormModel->checkContactFormExist($contactFormID);
            $total = $checkContactFormExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Contact Form Error',
                    'message' => 'The contact form does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contactFormModel->deleteContactForm($contactFormID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Contact Form Success',
                'message' => 'The contact form has been deleted successfully.',
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
    # Function: deleteMultipleContactForm
    # Description: 
    # Delete the selected contact forms if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleContactForm() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['contact_form_id']) && !empty($_POST['contact_form_id'])) {
            $contactFormIDs = $_POST['contact_form_id'];
    
            foreach($contactFormIDs as $contactFormID){
                $checkContactFormExist = $this->contactFormModel->checkContactFormExist($contactFormID);
                $total = $checkContactFormExist['total'] ?? 0;

                if($total > 0){
                    $this->contactFormModel->deleteContactForm($contactFormID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Contact Forms Success',
                'message' => 'The selected contact forms have been deleted successfully.',
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
    # Function: getContactFormDetails
    # Description: 
    # Handles the retrieval of contact form details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getContactFormDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['contact_form_id']) && !empty($_POST['contact_form_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contactFormID = htmlspecialchars($_POST['contact_form_id'], ENT_QUOTES, 'UTF-8');

            $checkContactFormExist = $this->contactFormModel->checkContactFormExist($contactFormID);
            $total = $checkContactFormExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Contact Form Details Error',
                    'message' => 'The contact form does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $contactFormDetails = $this->contactFormModel->getContactForm($contactFormID);

            $response = [
                'success' => true,
                'contactFormName' => $contactFormDetails['contact_form_name'] ?? null,
                'description' => $contactFormDetails['description'] ?? null,
                'blockStyleID' => $contactFormDetails['block_style_id'] ?? '',
                'blockStyleName' => $contactFormDetails['block_style_name'] ?? ''
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
require_once '../../contact-form/model/contact-form-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ContactFormController(new ContactFormModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>