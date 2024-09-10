<?php
session_start();

# -------------------------------------------------------------
#
# Function: BookingController
# Description: 
# The BookingController class handles booking related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class BookingController {
    private $bookingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided bookingModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for booking related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param BookingModel $bookingModel     The bookingModel instance for booking related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BookingModel $bookingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->bookingModel = $bookingModel;
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
                case 'add booking':
                    $this->addBooking();
                    break;
                case 'update booking':
                    $this->updateBooking();
                    break;
                case 'get booking details':
                    $this->getBookingDetails();
                    break;
                case 'tag booking as in-progress':
                    $this->tagBookingAsInProgress();
                    break;
                case 'tag booking as resolved':
                    $this->tagBookingAsResolved();
                    break;
                case 'tag booking as closed':
                    $this->tagBookingAsClosed();
                    break;
                case 'delete booking':
                    $this->deleteBooking();
                    break;
                case 'delete multiple booking':
                    $this->deleteMultipleBooking();
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
    # Function: addBooking
    # Description: 
    # Inserts a booking.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addBooking() {
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
        
            $bookingID = $this->bookingModel->insertBooking($customerName, $email, $phone, $subject, $message, $userID);
    
            $response = [
                'success' => true,
                'bookingID' => $this->securityModel->encryptData($bookingID),
                'title' => 'Insert Booking Success',
                'message' => 'The booking has been inserted successfully.',
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
    # Function: updateBooking
    # Description: 
    # Updates the booking if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBooking() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_name']) && !empty($_POST['customer_name']) && isset($_POST['phone']) && !empty($_POST['phone']) && isset($_POST['email']) && !empty($_POST['email']) && isset($_POST['subject']) && !empty($_POST['subject']) && isset($_POST['message']) && !empty($_POST['message'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
            $customerName = $_POST['customer_name'];
            $phone = $_POST['phone'];
            $email = $_POST['email'];
            $subject = $_POST['subject'];
            $message = $_POST['message'];
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Booking Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBooking($bookingID, $customerName, $email, $phone, $subject, $message, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Booking Success',
                'message' => 'The booking has been updated successfully.',
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
    # Function: tagBookingAsInProgress
    # Description: 
    # Tag the booking if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingAsInProgress() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking As In-Progress Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingStatus($bookingID, 'In-Progress', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking As In-Progress Success',
                'message' => 'The booking has been tagged as in-progress successfully.',
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
    # Function: tagBookingAsResolved
    # Description: 
    # Tag the booking if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingAsResolved() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking As Resolved Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingStatus($bookingID, 'Resolved', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking As Resolved Success',
                'message' => 'The booking has been tagged as resolved successfully.',
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
    # Function: tagBookingAsClosed
    # Description: 
    # Tag the booking if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingAsClosed() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking As Closed Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingStatus($bookingID, 'Closed', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking As Closed Success',
                'message' => 'The booking has been tagged as closed successfully.',
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
    # Function: deleteBooking
    # Description: 
    # Delete the booking if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteBooking() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $bookingID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Booking Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->deleteBooking($bookingID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Booking Success',
                'message' => 'The booking has been deleted successfully.',
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
    # Function: deleteMultipleBooking
    # Description: 
    # Delete the selected customer inquiries if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleBooking() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $bookingIDs = $_POST['customer_inquiry_id'];
    
            foreach($bookingIDs as $bookingID){
                $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
                $total = $checkBookingExist['total'] ?? 0;

                if($total > 0){
                    $this->bookingModel->deleteBooking($bookingID);
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
    # Function: getBookingDetails
    # Description: 
    # Handles the retrieval of booking details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBookingDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');

            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Booking Details Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $bookingDetails = $this->bookingModel->getBooking($bookingID);
            $inquiryStatus = $bookingDetails['inquiry_status'];

            $badgeClasses = [
                'Pending' => 'text-bg-info',
                'In-Progress' => 'text-bg-warning',
                'Resolved' => 'text-bg-success',
            ];
                
            $inquiryStatusBadge = '<span class="badge rounded-pill ' . ($badgeClasses[$inquiryStatus] ?? 'text-bg-dark') . '">' . $inquiryStatus . '</span>';

            $response = [
                'success' => true,
                'customerName' => $bookingDetails['customer_name'] ?? null,
                'email' => $bookingDetails['email'] ?? null,
                'phone' => $bookingDetails['phone'] ?? null,
                'subject' => $bookingDetails['subject'] ?? null,
                'message' => $bookingDetails['message'] ?? null,
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
require_once '../../my-bookings/model/my-bookings-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new BookingController(new BookingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>