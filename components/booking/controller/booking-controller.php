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
    private $systemModel;
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
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BookingModel $bookingModel, AuthenticationModel $authenticationModel, SystemModel $systemModel, SecurityModel $securityModel) {
        $this->bookingModel = $bookingModel;
        $this->authenticationModel = $authenticationModel;
        $this->systemModel = $systemModel;
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
                    'message' => 'Your account is currently locked. Kindly reach out to the administrator for assistance $unlocking it.',
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
                    'message' => 'Your session has expired. Please log $aga$to continue',
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
                case 'tag booking as completed':
                    $this->tagBookingAsCompleted();
                    break;
                case 'tag booking as cancelled':
                    $this->tagBookingAsCancelled();
                    break;
                case 'tag booking for cancellation':
                    $this->tagBookingForCancellation();
                    break;
                case 'tag booking for cancellation as rejected':
                    $this->tagBookingForCancellationAsRejected();
                    break;
                case 'tag booking payment as paid':
                    $this->tagBookingPaymentAsPaid();
                    break;
                case 'tag booking payment for refund':
                    $this->tagBookingPaymentForRefund();
                    break;
                case 'tag booking payment for refund as rejected':
                    $this->tagBookingPaymentForRefundAsRejected();
                    break;
                case 'tag booking payment as refunded':
                    $this->tagBookingPaymentAsRefunded();
                    break;
                case 'assign booking personnel':
                    $this->assignBookingPersonnel();
                    break;
                case 'unassign booking personnel':
                    $this->unassignBookingPersonnel();
                    break;
                case 'start job':
                    $this->startJob();
                    break;
                case 'end job':
                    $this->endJob();
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
                        'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
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

        if (isset($_POST['first_name']) && !empty($_POST['first_name']) && isset($_POST['last_name']) && !empty($_POST['last_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['phone']) && !empty($_POST['phone']) && isset($_POST['email_address']) && !empty($_POST['email_address']) && isset($_POST['source_of_booking']) && !empty($_POST['source_of_booking']) && isset($_POST['service']) && !empty($_POST['service']) && isset($_POST['frequency']) && isset($_POST['duration']) && isset($_POST['number_of_seats']) && isset($_POST['meters']) && isset($_POST['cleaning_materials']) && isset($_POST['booking_date']) && !empty($_POST['booking_date']) && isset($_POST['booking_time']) && !empty($_POST['booking_time']) && isset($_POST['number_of_professionals']) && !empty($_POST['number_of_professionals']) && isset($_POST['number_of_hours']) && !empty($_POST['number_of_hours']) && isset($_POST['nationality']) && !empty($_POST['nationality']) && isset($_POST['special_instructions']) && isset($_POST['mode_of_payment']) && !empty($_POST['mode_of_payment']) && isset($_POST['discount_type']) && isset($_POST['discount_amount']) && isset($_POST['booking_subtotal']) && !empty($_POST['booking_subtotal']) && isset($_POST['total_discount_amount']) && isset($_POST['booking_total'])) {
            $userID = $_SESSION['user_account_id'];
            $firstName = $_POST['first_name'];
            $lastName = $_POST['last_name'];
            $address = $_POST['address'];
            $phone = $_POST['phone'];
            $emailAddress = $_POST['email_address'];
            $sourceOfBooking = $_POST['source_of_booking'];
            $service = $_POST['service'];
            $frequency = $_POST['frequency'];
            $duration = $_POST['duration'];
            $numberOfSeats = $_POST['number_of_seats'];
            $meters = $_POST['meters'];
            $cleaningMaterials = $_POST['cleaning_materials'];
            $bookingDate = $this->systemModel->checkDate('empty', $_POST['booking_date'], '', 'Y-m-d', '');
            $bookingTime = $_POST['booking_time'];
            $numberOfProfessionals = $_POST['number_of_professionals'];
            $numberOfHours = $_POST['number_of_hours'];
            $nationality = $_POST['nationality'];
            $specialInstructions = $_POST['special_instructions'];
            $modeOfPayment = $_POST['mode_of_payment'];
            $discountType = $_POST['discount_type'];
            $discountAmount = $_POST['discount_amount'];
            $bookingSubtotal = $_POST['booking_subtotal'];
            $totalDiscountAmount = $_POST['total_discount_amount'];
            $bookingTotal = $_POST['booking_total'];

            $bookingReferenceNumber = $this->generateBookingReferenceNumber();
            $cancellationWindow = $this->calculateCancellationWindow(date('Y-m-d H:i:s'), $bookingDate, $bookingTime);
        
            $bookingID = $this->bookingModel->insertBooking($bookingReferenceNumber, $sourceOfBooking, $service, $frequency, $duration, $numberOfSeats, $meters, $cleaningMaterials, $bookingDate, $bookingTime, $numberOfProfessionals, $numberOfHours, $nationality, $firstName, $lastName, $address, $phone, $emailAddress, $specialInstructions, $modeOfPayment, '', $discountType, $discountAmount, $totalDiscountAmount, $bookingSubtotal, $bookingTotal, $cancellationWindow, $userID);
    
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
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
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
        
        if (isset($_POST['first_name']) && !empty($_POST['first_name']) && isset($_POST['last_name']) && !empty($_POST['last_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['phone']) && !empty($_POST['phone']) && isset($_POST['email_address']) && !empty($_POST['email_address']) && isset($_POST['source_of_booking']) && !empty($_POST['source_of_booking']) && isset($_POST['service']) && !empty($_POST['service']) && isset($_POST['frequency']) && isset($_POST['duration']) && isset($_POST['number_of_seats']) && isset($_POST['meters']) && isset($_POST['cleaning_materials']) && isset($_POST['booking_date']) && !empty($_POST['booking_date']) && isset($_POST['booking_time']) && !empty($_POST['booking_time']) && isset($_POST['number_of_professionals']) && !empty($_POST['number_of_professionals']) && isset($_POST['number_of_hours']) && !empty($_POST['number_of_hours']) && isset($_POST['nationality']) && !empty($_POST['nationality']) && isset($_POST['special_instructions']) && isset($_POST['mode_of_payment']) && !empty($_POST['mode_of_payment']) && isset($_POST['discount_type']) && isset($_POST['discount_amount']) && isset($_POST['booking_subtotal']) && !empty($_POST['mode_of_payment']) && isset($_POST['total_discount_amount']) && isset($_POST['booking_total'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $firstName = $_POST['first_name'];
            $lastName = $_POST['last_name'];
            $address = $_POST['address'];
            $phone = $_POST['phone'];
            $emailAddress = $_POST['email_address'];
            $sourceOfBooking = $_POST['source_of_booking'];
            $service = $_POST['service'];
            $frequency = $_POST['frequency'];
            $duration = $_POST['duration'];
            $numberOfSeats = $_POST['number_of_seats'];
            $meters = $_POST['meters'];
            $cleaningMaterials = $_POST['cleaning_materials'];
            $bookingDate = $this->systemModel->checkDate('empty', $_POST['booking_date'], '', 'Y-m-d', '');
            $bookingTime = $_POST['booking_time'];
            $numberOfProfessionals = $_POST['number_of_professionals'];
            $numberOfHours = $_POST['number_of_hours'];
            $nationality = $_POST['nationality'];
            $specialInstructions = $_POST['special_instructions'];
            $modeOfPayment = $_POST['mode_of_payment'];
            $discountType = $_POST['discount_type'];
            $discountAmount = $_POST['discount_amount'];
            $bookingSubtotal = $_POST['booking_subtotal'];
            $totalDiscountAmount = $_POST['total_discount_amount'];
            $bookingTotal = $_POST['booking_total'];
        
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

            $this->bookingModel->updateBooking($bookingID, $sourceOfBooking, $service, $frequency, $duration, $numberOfSeats, $meters, $cleaningMaterials, $bookingDate, $bookingTime, $numberOfProfessionals, $numberOfHours, $nationality, $firstName, $lastName, $address, $phone, $emailAddress, $specialInstructions, $modeOfPayment, '', $discountType, $discountAmount, $totalDiscountAmount, $bookingSubtotal, $bookingTotal, $userID);
                
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
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Assign methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: assignBookingPersonnel
    # Description: 
    # Assigns a booking personnel.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignBookingPersonnel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            if(!isset($_POST['employee_id']) || empty($_POST['employee_id'])){
                $response = [
                    'success' => false,
                    'title' => 'Booking Personnel Selection Required',
                    'message' => 'Please select the employee(s) you wish to assign to the booking.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $employeeIDs = $_POST['employee_id'];

            foreach ($employeeIDs as $employeeID) {
                $this->bookingModel->insertBookingPersonnel($bookingID, $employeeID, $userID);
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign Booking Personnel Success',
                'message' => 'The booking personnel has been assigned successfully.',
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
    # Tag the booking as in-progress if it exists; otherwise, return an error message.
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

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
        
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

            $this->bookingModel->updateBookingStatus($bookingID, 'In-Progress', '', $userID);
                
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
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingAsCompleted
    # Description: 
    # Tag the booking as completed if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingAsCompleted() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking As Completed Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingStatus($bookingID, 'Completed', '', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking As Completed Success',
                'message' => 'The booking has been tagged as completed successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingAsCancelled
    # Description: 
    # Tag the booking as cancelled if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingAsCancelled() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking As Cancelled Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingStatus($bookingID, 'Cancelled', '', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking As Cancelled Success',
                'message' => 'The booking has been tagged as cancelled successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingForCancellation
    # Description: 
    # Tag the booking for cancellation if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingForCancellation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $cancellationReason = $_POST['cancellation_reason'];
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking For Cancellation Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingStatus($bookingID, 'For Cancellation', $cancellationReason, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking For Cancellation Success',
                'message' => 'The booking has been tagged for cancellation successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingForCancellationAsRejected
    # Description: 
    # Tag the booking for cancellation as rejected if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingForCancellationAsRejected() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $bookingForCancellationRejectionReason = $_POST['booking_for_cancellation_rejection_reason'];
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking For Cancellation As Rejected Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingStatus($bookingID, 'Rejected', $bookingForCancellationRejectionReason, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking For Cancellation As Rejected Success',
                'message' => 'The booking has been tagged for cancellation successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingPaymentAsPaid
    # Description: 
    # Tag the booking payment as paid if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingPaymentAsPaid() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $paymentDate = $this->systemModel->checkDate('empty', $_POST['payment_date'], '', 'Y-m-d H:i:s', '');
            $paymentReferenceNumber = $_POST['payment_reference_number'];
            $paymentAmount = $_POST['payment_amount'];
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking Payment As Paid Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingPaymentStatus($bookingID, 'Paid', $paymentAmount, $paymentDate, $paymentReferenceNumber, '', '', $userID);

            $response = [
                'success' => true,
                'title' => 'Tag Booking Payment As Paid Success',
                'message' => 'The booking payment has been tagged as paid successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingPaymentForRefund
    # Description: 
    # Tag the booking payment for refund if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingPaymentForRefund() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $refundAmount = $_POST['refund_amount'];
            $forRefundReason = $_POST['for_refund_reason'];
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking Payment For Refund Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $bookingDetails = $this->bookingModel->getBooking($bookingID);
            $paymentAmount = $bookingDetails['payment_amount'] ?? 0;

            if($refundAmount > $paymentAmount){
                $response = [
                    'success' => false,
                    'title' => 'Tag Booking Payment For Refund Error',
                    'message' => 'The refund amount cannot be greater than the payment amount.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingPaymentStatus($bookingID, 'For Refund', '', '', '', $refundAmount, $forRefundReason, $userID);

            $response = [
                'success' => true,
                'title' => 'Tag Booking Payment For Refund Success',
                'message' => 'The booking payment has been tagged as for refund successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingPaymentForRefundAsRejected
    # Description: 
    # Tag the booking payment for refund as rejected if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingPaymentForRefundAsRejected() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $forRefundRejectionReason = $_POST['for_refund_rejection_reason'];
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking For Cancellation As Rejected Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingPaymentStatus($bookingID, 'Rejected', '', '', '', '', $forRefundRejectionReason, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking For Cancellation As Rejected Success',
                'message' => 'The booking has been tagged for cancellation successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: tagBookingPaymentAsRefunded
    # Description: 
    # Tag the booking payment as refunded if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function tagBookingPaymentAsRefunded() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tag Booking Payment As Refunded Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $bookingDetails = $this->bookingModel->getBooking($bookingID);
            $modeOfPayment = $bookingDetails['mode_of_payment'] ?? null;
            $refundAmount = $bookingDetails['refund_amount'] ?? 0;
            $paymentReferenceNumber = $bookingDetails['payment_reference_number'] ?? null;

            if($modeOfPayment == 'Stripe'){
                \Stripe\Stripe::setApiKey(STRIPE_API_KEY);

                if(!empty($paymentReferenceNumber)){
                    // Create the refund
                    $refund = \Stripe\Refund::create([
                        'payment_intent' => $paymentReferenceNumber,
                        'amount' => $refundAmount * 100, // Convert to cents or the smallest currency unit
                    ]);

                    if ($refund->status != 'succeeded') {
                        $response = [
                            'success' => false,
                            'title' => 'Tag Booking Payment As Refunded Error',
                            'message' => 'The refund could not be processed. Please try again later.',
                            'messageType' => 'error'
                        ];

                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->bookingModel->updateBookingPaymentStatus($bookingID, 'Refunded', '', '', '', '', '', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tag Booking Payment As Refunded Success',
                'message' => 'The booking payment has been tagged as refunded successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
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

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
        
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
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
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

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $bookingIDs = $_POST['booking_id'];
    
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
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Unassign methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: unassignBookingPersonnel
    # Description: 
    # Unassign the booking personnel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unassignBookingPersonnel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id']) && isset($_POST['booking_personnel_id']) && !empty($_POST['booking_personnel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $bookingPersonnelID = htmlspecialchars($_POST['booking_personnel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unassign Booking Personnel Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->deleteBookingPersonnel($bookingPersonnelID, 'Start', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unassign Booking Personnel Success',
                'message' => 'The booking personnel has been unassigned successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Start methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: startJob
    # Description: 
    # Starts the booking personnel job time if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function startJob() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id']) && isset($_POST['booking_personnel_id']) && !empty($_POST['booking_personnel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $bookingPersonnelID = htmlspecialchars($_POST['booking_personnel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Start Booking Personnel Job Time Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingPersonnelJobTime($bookingPersonnelID, 'Start', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Start Booking Personnel Job Time Success',
                'message' => 'The job has been started successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   End methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: endJob
    # Description: 
    # Starts the booking personnel job time if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function endJob() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['booking_id']) && !empty($_POST['booking_id']) && isset($_POST['booking_personnel_id']) && !empty($_POST['booking_personnel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');
            $bookingPersonnelID = htmlspecialchars($_POST['booking_personnel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBookingExist = $this->bookingModel->checkBookingExist($bookingID);
            $total = $checkBookingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'End Booking Personnel Job Time Error',
                    'message' => 'The booking does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bookingModel->updateBookingPersonnelJobTime($bookingPersonnelID, 'End', $userID);
                
            $response = [
                'success' => true,
                'title' => 'End Booking Personnel Job Time Success',
                'message' => 'The job has been ended successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Custom methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: calculateCancellationWindow
    # Description: 
    # Handles the calculation of cancellation window.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function calculateCancellationWindow($transactionDateTime, $bookingDate, $bookingTime) {
        // Convert the booking date and time to a DateTime object
        $bookingDateTime = new DateTime($bookingDate . ' ' . $bookingTime);
    
        // Convert the transaction date and time to a DateTime object
        $transactionDateTime = new DateTime($transactionDateTime);
    
        // Calculate the difference in hours between the transaction time and the booking time
        $interval = $transactionDateTime->diff($bookingDateTime);
        $hoursDifference = ($interval->days * 24) + $interval->h;
    
        // Determine the cancellation window datetime
        if ($hoursDifference > 24) {
            // Cancellation window is 24 hours before the booking datetime
            $cancellationWindow = clone $bookingDateTime;
            $cancellationWindow->modify('-24 hours');
        } elseif ($hoursDifference >= 2) {
            // Cancellation window is 2 hours before the booking datetime for same-day bookings
            $cancellationWindow = clone $bookingDateTime;
            $cancellationWindow->modify('-2 hours');
        } else {
            // No cancellation allowed if less than 2 hours remain
            return "No cancellation allowed";
        }
    
        return $cancellationWindow->format('Y-m-d H:i:s');
    }    
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateBookingReferenceNumber
    # Description: 
    # Handles the generation of booking reference number.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function generateBookingReferenceNumber($length = 8) {
        // Define the prefix for the booking reference number
        $prefix = 'ALTH';
        
        // Define the characters to use in the booking reference
        $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        $charactersLength = strlen($characters);
        $bookingReferenceNumber = '';
        
        // Generate a random part of the booking reference
        for ($i = 0; $i < $length; $i++) {
            $bookingReferenceNumber .= $characters[rand(0, $charactersLength - 1)];
        }
        
        // Combine the prefix with the reference number
        $finalReference = $prefix . $bookingReferenceNumber;
        
        return $finalReference;
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
    
        if (isset($_POST['booking_id']) && !empty($_POST['booking_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bookingID = htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8');

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
            $bookingStatus = $bookingDetails['booking_status'];
            $paymentStatus = $bookingDetails['payment_status'];

            $bookingStatusBadgeClasses = [
                'Pending' => 'text-bg-info',
                'In-Progress' => 'text-bg-warning',
                'Completed' => 'text-bg-success',
                'For Cancellation' => 'text-bg-warning',
                'Rejected' => 'text-bg-danger',
                'Cancelled' => 'text-bg-danger'
            ];

            $paymentStatusBadgeClasses = [
                'Pending' => 'text-bg-info',
                'Paid' => 'text-bg-success',
                'For Refund' => 'text-bg-warning',
                'Rejected' => 'text-bg-danger',
                'Refunded' => 'text-bg-danger'
            ];
                
            $bookingStatusBadge = '<span class="badge rounded-pill ' . ($bookingStatusBadgeClasses[$bookingStatus] ?? 'text-bg-dark') . '">' . $bookingStatus . '</span>';
            $paymentStatusBadge = '<span class="badge rounded-pill ' . ($paymentStatusBadgeClasses[$paymentStatus] ?? 'text-bg-dark') . '">' . $paymentStatus . '</span>';

            $response = [
                'success' => true,
                'sourceOfBooking' => $bookingDetails['source_of_booking'] ?? null,
                'service' => $bookingDetails['service'] ?? null,
                'frequency' => $bookingDetails['frequency'] ?? null,
                'duration' => $bookingDetails['duration'] ?? null,
                'numberOfSeats' => $bookingDetails['number_of_seats'] ?? null,
                'meters' => $bookingDetails['meters'] ?? null,
                'cleaningMaterials' => $bookingDetails['cleaning_materials'] ?? null,
                'bookingTime' => $bookingDetails['booking_time'] ?? null,
                'numberOfProfessionals' => $bookingDetails['number_of_professionals'] ?? null,
                'numberOfHours' => $bookingDetails['number_of_hours'] ?? null,
                'nationality' => $bookingDetails['nationality'] ?? null,
                'firstName' => $bookingDetails['first_name'] ?? null,
                'lastName' => $bookingDetails['last_name'] ?? null,
                'address' => $bookingDetails['address'] ?? null,
                'phone' => $bookingDetails['phone'] ?? null,
                'emailAddress' => $bookingDetails['email_address'] ?? null,
                'specialInstructions' => $bookingDetails['special_instructions'] ?? null,
                'modeOfPayment' => $bookingDetails['mode_of_payment'] ?? null,
                'discountType' => $bookingDetails['discount_type'] ?? null,
                'discountAmount' => $bookingDetails['discount_amount'] ?? null,
                'bookingDate' => $this->systemModel->checkDate('empty', $bookingDetails['booking_date'], '', 'm/d/Y', ''),
                'bookingReferenceNumber' => $bookingDetails['booking_reference_number'] ?? '--',
                'bookingStatusBadge' => $bookingStatusBadge,
                'paymentStatusBadge' => $paymentStatusBadge,
                'discountCode' => !empty($bookingDetails['discount_code']) ? $bookingDetails['discount_code'] : '--',
                'refundAmount' => number_format($bookingDetails['refund_amount'] ?? '0', 2),
                'cancellationRequestDate' => $this->systemModel->checkDate('summary', $bookingDetails['cancellation_request_date'], '', 'M d, Y h:i:s a', ''),
                'cancellationWindow' => $this->systemModel->checkDate('summary', $bookingDetails['cancellation_window'], '', 'M d, Y h:i:s a', ''),
                'paymentDate' => $this->systemModel->checkDate('summary', $bookingDetails['payment_date'], '', 'M d, Y h:i:s a', ''),
                'refundDate' => $this->systemModel->checkDate('summary', $bookingDetails['refund_date'], '', 'M d, Y h:i:s a', ''),
                'inProgressDate' => $this->systemModel->checkDate('summary', $bookingDetails['in_progress_date'], '', 'M d, Y h:i:s a', ''),
                'completedDate' => $this->systemModel->checkDate('summary', $bookingDetails['completed_date'], '', 'M d, Y h:i:s a', ''),
                'cancellationDate' => $this->systemModel->checkDate('summary', $bookingDetails['cancellation_date'], '', 'M d, Y h:i:s a', ''),
                'transactionDate' => $this->systemModel->checkDate('summary', $bookingDetails['transaction_date'], '', 'M d, Y h:i:s a', ''),
                'cancellationReason' => $bookingDetails['cancellation_reason'] ?? '--',
                'paymentReferenceNumber' => $bookingDetails['payment_reference_number'] ?? '--',
                'forRefundReason' => $bookingDetails['for_refund_reason'] ?? '--',
                'forRefundRejectionReason' => $bookingDetails['for_refund_rejection_reason'] ?? '--',
                'paymentAmount' => number_format($bookingDetails['payment_amount'] ?? '0', 2),
                'forRefundDate' => $this->systemModel->checkDate('summary', $bookingDetails['for_refund_date'], '', 'M d, Y h:i:s a', ''),
                'forRefundRejectionDate' => $this->systemModel->checkDate('summary', $bookingDetails['for_refund_rejection_date'], '', 'M d, Y h:i:s a', ''),
            ];

            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
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
require_once '../../booking/model/booking-model.php';
require_once '../../authentication/model/authentication-model.php';
require_once '../../../assets/libs/stripe-php-master/init.php';

$controller = new BookingController(new BookingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SystemModel(), new SecurityModel());
$controller->handleRequest();

?>