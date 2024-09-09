<?php
session_start();

# -------------------------------------------------------------
#
# Function: CustomerInquiryController
# Description: 
# The CustomerInquiryController class handles customer inquiry related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class CustomerInquiryController {
    private $customerInquiryModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided customerInquiryModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for customer inquiry related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param CustomerInquiryModel $customerInquiryModel     The customerInquiryModel instance for customer inquiry related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(CustomerInquiryModel $customerInquiryModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->customerInquiryModel = $customerInquiryModel;
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
                case 'add customer inquiry form':
                    $this->addCustomerInquiryForm();
                    break;
                case 'add customer inquiry':
                    $this->addCustomerInquiry();
                    break;
                case 'update customer inquiry':
                    $this->updateCustomerInquiry();
                    break;
                case 'get customer inquiry details':
                    $this->getCustomerInquiryDetails();
                    break;
                case 'tag customer inquiry as in-progress':
                    $this->tagCustomerInquiryAsInProgress();
                    break;
                case 'tag customer inquiry as resolved':
                    $this->tagCustomerInquiryAsResolved();
                    break;
                case 'tag customer inquiry as closed':
                    $this->tagCustomerInquiryAsClosed();
                    break;
                case 'delete customer inquiry':
                    $this->deleteCustomerInquiry();
                    break;
                case 'delete multiple customer inquiry':
                    $this->deleteMultipleCustomerInquiry();
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
    # Function: addCustomerInquiryForm
    # Description: 
    # Inserts a customer inquiry.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCustomerInquiryForm() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_name']) && !empty($_POST['customer_name']) && isset($_POST['phone']) && !empty($_POST['phone']) && isset($_POST['email']) && !empty($_POST['email']) && isset($_POST['subject']) && !empty($_POST['subject']) && isset($_POST['message']) && !empty($_POST['message'])) {
            $userID = $_SESSION['user_account_id'];
            $customerName = $_POST['customer_name'];
            $phone = $_POST['phone'];
            $email = $_POST['email'];
            $subject = $_POST['subject'];
            $message = $_POST['message'];
        
            $this->customerInquiryModel->insertCustomerInquiry($customerName, $email, $phone, $subject, $message, $userID);
    
            $response = [
                'success' => false,
                'title' => 'Customer Inquiry Submission Success',
                'message' => 'The customer inquiry has been submission successfully.'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again or contact our support team for assistance.'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: addCustomerInquiry
    # Description: 
    # Inserts a customer inquiry.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCustomerInquiry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_name']) && !empty($_POST['customer_name']) && isset($_POST['phone']) && !empty($_POST['phone']) && isset($_POST['email']) && !empty($_POST['email']) && isset($_POST['subject']) && !empty($_POST['subject']) && isset($_POST['message']) && !empty($_POST['message'])) {
            $userID = $_SESSION['user_account_id'];
            $customerName = $_POST['customer_name'];
            $phone = $_POST['phone'];
            $email = $_POST['email'];
            $subject = $_POST['subject'];
            $message = $_POST['message'];
        
            $customerInquiryID = $this->customerInquiryModel->insertCustomerInquiry($customerName, $email, $phone, $subject, $message, $userID);
    
            $response = [
                'success' => true,
                'customerInquiryID' => $this->securityModel->encryptData($customerInquiryID),
                'title' => 'Insert Customer Inquiry Success',
                'message' => 'The customer inquiry has been inserted successfully.',
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
    # Function: updateCustomerInquiry
    # Description: 
    # Updates the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCustomerInquiry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_name']) && !empty($_POST['customer_name']) && isset($_POST['phone']) && !empty($_POST['phone']) && isset($_POST['email']) && !empty($_POST['email']) && isset($_POST['subject']) && !empty($_POST['subject']) && isset($_POST['message']) && !empty($_POST['message'])) {
            $userID = $_SESSION['user_account_id'];
            $customerInquiryID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
            $customerName = $_POST['customer_name'];
            $phone = $_POST['phone'];
            $email = $_POST['email'];
            $subject = $_POST['subject'];
            $message = $_POST['message'];
        
            $checkCustomerInquiryExist = $this->customerInquiryModel->checkCustomerInquiryExist($customerInquiryID);
            $total = $checkCustomerInquiryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Customer Inquiry Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerInquiryModel->updateCustomerInquiry($customerInquiryID, $customerName, $email, $phone, $subject, $message, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Customer Inquiry Success',
                'message' => 'The customer inquiry has been updated successfully.',
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
    #   Tag methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagCustomerInquiryAsInProgress
    # Description: 
    # Tag the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagCustomerInquiryAsInProgress() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerInquiryID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerInquiryExist = $this->customerInquiryModel->checkCustomerInquiryExist($customerInquiryID);
            $total = $checkCustomerInquiryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Customer Inquiry As In-Progress Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerInquiryModel->updateCustomerInquiryStatus($customerInquiryID, 'In-Progress', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Customer Inquiry As In-Progress Success',
                'message' => 'The customer inquiry has been tagged as in-progress successfully.',
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
    # Function: tagCustomerInquiryAsResolved
    # Description: 
    # Tag the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagCustomerInquiryAsResolved() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerInquiryID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerInquiryExist = $this->customerInquiryModel->checkCustomerInquiryExist($customerInquiryID);
            $total = $checkCustomerInquiryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Customer Inquiry As Resolved Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerInquiryModel->updateCustomerInquiryStatus($customerInquiryID, 'Resolved', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Customer Inquiry As Resolved Success',
                'message' => 'The customer inquiry has been tagged as resolved successfully.',
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
    # Function: tagCustomerInquiryAsClosed
    # Description: 
    # Tag the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagCustomerInquiryAsClosed() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerInquiryID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerInquiryExist = $this->customerInquiryModel->checkCustomerInquiryExist($customerInquiryID);
            $total = $checkCustomerInquiryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Customer Inquiry As Closed Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerInquiryModel->updateCustomerInquiryStatus($customerInquiryID, 'Closed', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Customer Inquiry As Closed Success',
                'message' => 'The customer inquiry has been tagged as closed successfully.',
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
    # Function: deleteCustomerInquiry
    # Description: 
    # Delete the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCustomerInquiry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $customerInquiryID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerInquiryExist = $this->customerInquiryModel->checkCustomerInquiryExist($customerInquiryID);
            $total = $checkCustomerInquiryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Customer Inquiry Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerInquiryModel->deleteCustomerInquiry($customerInquiryID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Customer Inquiry Success',
                'message' => 'The customer inquiry has been deleted successfully.',
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
    # Function: deleteMultipleCustomerInquiry
    # Description: 
    # Delete the selected customer inquiries if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleCustomerInquiry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $customerInquiryIDs = $_POST['customer_inquiry_id'];
    
            foreach($customerInquiryIDs as $customerInquiryID){
                $checkCustomerInquiryExist = $this->customerInquiryModel->checkCustomerInquiryExist($customerInquiryID);
                $total = $checkCustomerInquiryExist['total'] ?? 0;

                if($total > 0){
                    $this->customerInquiryModel->deleteCustomerInquiry($customerInquiryID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Customer Inquiries Success',
                'message' => 'The selected customer inquiries have been deleted successfully.',
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
    # Function: getCustomerInquiryDetails
    # Description: 
    # Handles the retrieval of customer inquiry details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCustomerInquiryDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerInquiryID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerInquiryExist = $this->customerInquiryModel->checkCustomerInquiryExist($customerInquiryID);
            $total = $checkCustomerInquiryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Customer Inquiry Details Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerInquiryDetails = $this->customerInquiryModel->getCustomerInquiry($customerInquiryID);
            $inquiryStatus = $customerInquiryDetails['inquiry_status'];

            $badgeClasses = [
                'Pending' => 'text-bg-info',
                'In-Progress' => 'text-bg-warning',
                'Resolved' => 'text-bg-success',
            ];
                
            $inquiryStatusBadge = '<span class="badge rounded-pill ' . ($badgeClasses[$inquiryStatus] ?? 'text-bg-dark') . '">' . $inquiryStatus . '</span>';

            $response = [
                'success' => true,
                'customerName' => $customerInquiryDetails['customer_name'] ?? null,
                'email' => $customerInquiryDetails['email'] ?? null,
                'phone' => $customerInquiryDetails['phone'] ?? null,
                'subject' => $customerInquiryDetails['subject'] ?? null,
                'message' => $customerInquiryDetails['message'] ?? null,
                'inquiryStatusBadge' => $inquiryStatusBadge
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
require_once '../../customer-inquiry/model/customer-inquiry-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new CustomerInquiryController(new CustomerInquiryModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>