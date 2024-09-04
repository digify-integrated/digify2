<?php
session_start();

# -------------------------------------------------------------
#
# Function: VoucherController
# Description: 
# The VoucherController class handles voucher related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class VoucherController {
    private $voucherModel;
    private $authenticationModel;
    private $systemModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided voucherModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for voucher related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param VoucherModel $voucherModel     The voucherModel instance for voucher related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SystemModel $securityModel   The SystemModel instance for system related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(VoucherModel $voucherModel, AuthenticationModel $authenticationModel, SystemModel $systemModel, SecurityModel $securityModel) {
        $this->voucherModel = $voucherModel;
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
                case 'add voucher':
                    $this->addVoucher();
                    break;
                case 'update voucher':
                    $this->updateVoucher();
                    break;
                case 'get voucher details':
                    $this->getVoucherDetails();
                    break;
                case 'delete voucher':
                    $this->deleteVoucher();
                    break;
                case 'delete multiple voucher':
                    $this->deleteMultipleVoucher();
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
    # Function: addVoucher
    # Description: 
    # Inserts a voucher.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addVoucher() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['voucher_name']) && !empty($_POST['voucher_name']) && isset($_POST['voucher_code']) && !empty($_POST['voucher_code']) && isset($_POST['voucher_usage_start_date']) && !empty($_POST['voucher_usage_start_date']) && isset($_POST['voucher_usage_end_date']) && !empty($_POST['voucher_usage_end_date']) && isset($_POST['discount_type']) && !empty($_POST['discount_type']) && isset($_POST['discount_amount']) && !empty($_POST['discount_amount']) && isset($_POST['minimum_booking_amount']) && isset($_POST['voucher_quantity']) && !empty($_POST['voucher_quantity'])) {
            $userID = $_SESSION['user_account_id'];
            $voucherName = $_POST['voucher_name'];
            $voucherCode = $_POST['voucher_code'];
            $voucheUsageStartDate = $this->systemModel->checkDate('empty', $_POST['voucher_usage_start_date'], '', 'Y-m-d', '');
            $voucheUsageEndDate = $this->systemModel->checkDate('empty', $_POST['voucher_usage_end_date'], '', 'Y-m-d', '');
            $discountType = $_POST['discount_type'];
            $discountAmount = $_POST['discount_amount'];
            $minimumBookingAmount = $_POST['minimum_booking_amount'];
            $voucherQuantity = $_POST['voucher_quantity'];
        
            $voucherID = $this->voucherModel->insertVoucher($voucherName, $voucherCode, $voucheUsageStartDate, $voucheUsageEndDate, $discountType, $discountAmount, $minimumBookingAmount, $voucherQuantity , $voucherQuantity, $userID);
    
            $response = [
                'success' => true,
                'voucherID' => $this->securityModel->encryptData($voucherID),
                'title' => 'Insert Voucher Success',
                'message' => 'The voucher has been inserted successfully.',
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
    # Function: updateVoucher
    # Description: 
    # Updates the voucher if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateVoucher() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['voucher_name']) && !empty($_POST['voucher_name']) && isset($_POST['voucher_code']) && !empty($_POST['voucher_code']) && isset($_POST['voucher_usage_start_date']) && !empty($_POST['voucher_usage_start_date']) && isset($_POST['voucher_usage_end_date']) && !empty($_POST['voucher_usage_end_date']) && isset($_POST['discount_type']) && !empty($_POST['discount_type']) && isset($_POST['discount_amount']) && !empty($_POST['discount_amount']) && isset($_POST['minimum_booking_amount']) && isset($_POST['voucher_quantity']) && !empty($_POST['voucher_quantity']) && isset($_POST['available_voucher'])) {
            $userID = $_SESSION['user_account_id'];
            $voucherID = htmlspecialchars($_POST['voucher_id'], ENT_QUOTES, 'UTF-8');
            $voucherName = $_POST['voucher_name'];
            $voucherCode = $_POST['voucher_code'];
            $voucheUsageStartDate = $this->systemModel->checkDate('empty', $_POST['voucher_usage_start_date'], '', 'Y-m-d', '');
            $voucheUsageEndDate = $this->systemModel->checkDate('empty', $_POST['voucher_usage_end_date'], '', 'Y-m-d', '');
            $discountType = $_POST['discount_type'];
            $discountAmount = $_POST['discount_amount'];
            $minimumBookingAmount = $_POST['minimum_booking_amount'];
            $voucherQuantity = $_POST['voucher_quantity'];
            $availableVoucher = $_POST['available_voucher'];
        
            $checkVoucherExist = $this->voucherModel->checkVoucherExist($voucherID);
            $total = $checkVoucherExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Voucher Error',
                    'message' => 'The voucher does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            if($availableVoucher > $voucherQuantity){
                $response = [
                    'success' => false,
                    'title' => 'Update Voucher Error',
                    'message' => 'The available voucher cannot be greater than the voucher quantity.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->voucherModel->updateVoucher($voucherID, $voucherName, $voucherCode, $voucheUsageStartDate, $voucheUsageEndDate, $discountType, $discountAmount, $minimumBookingAmount, $voucherQuantity , $availableVoucher, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Voucher Success',
                'message' => 'The voucher has been updated successfully.',
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
    # Function: deleteVoucher
    # Description: 
    # Delete the voucher if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteVoucher() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['voucher_id']) && !empty($_POST['voucher_id'])) {
            $voucherID = htmlspecialchars($_POST['voucher_id'], ENT_QUOTES, 'UTF-8');
        
            $checkVoucherExist = $this->voucherModel->checkVoucherExist($voucherID);
            $total = $checkVoucherExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Voucher Error',
                    'message' => 'The voucher does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->voucherModel->deleteVoucher($voucherID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Voucher Success',
                'message' => 'The voucher has been deleted successfully.',
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
    # Function: deleteMultipleVoucher
    # Description: 
    # Delete the selected vouchers if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleVoucher() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['voucher_id']) && !empty($_POST['voucher_id'])) {
            $voucherIDs = $_POST['voucher_id'];
    
            foreach($voucherIDs as $voucherID){
                $checkVoucherExist = $this->voucherModel->checkVoucherExist($voucherID);
                $total = $checkVoucherExist['total'] ?? 0;

                if($total > 0){
                    $this->voucherModel->deleteVoucher($voucherID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Vouchers Success',
                'message' => 'The selected vouchers have been deleted successfully.',
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
    # Function: getVoucherDetails
    # Description: 
    # Handles the retrieval of voucher details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getVoucherDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['voucher_id']) && !empty($_POST['voucher_id'])) {
            $userID = $_SESSION['user_account_id'];
            $voucherID = htmlspecialchars($_POST['voucher_id'], ENT_QUOTES, 'UTF-8');

            $checkVoucherExist = $this->voucherModel->checkVoucherExist($voucherID);
            $total = $checkVoucherExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Voucher Details Error',
                    'message' => 'The voucher does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $voucherDetails = $this->voucherModel->getVoucher($voucherID);

            $response = [
                'success' => true,
                'voucherName' => $voucherDetails['voucher_name'] ?? null,
                'voucherCode' => $voucherDetails['voucher_code'] ?? null,
                'voucherUsageStartDate' => $this->systemModel->checkDate('empty', $voucherDetails['voucher_usage_start_date'], '', 'm/d/Y', ''),
                'voucherUsageStartDateSummary' => $this->systemModel->checkDate('summary', $voucherDetails['voucher_usage_start_date'], '', 'M d, Y', ''),
                'voucherUsageEndDate' => $this->systemModel->checkDate('empty', $voucherDetails['voucher_usage_end_date'], '', 'm/d/Y', ''),
                'voucherUsageEndDateSummary' => $this->systemModel->checkDate('summary', $voucherDetails['voucher_usage_end_date'], '', 'M d, Y', ''),
                'discountType' => $voucherDetails['discount_type'] ?? null,
                'discountAmount' => $voucherDetails['discount_amount'] ?? null,
                'discountAmountSummary' => number_format($voucherDetails['discount_amount'] ?? 0, 2),
                'minimumBookingAmount' => $voucherDetails['minimum_booking_amount'] ?? null,
                'minimumBookingAmountSummary' => number_format($voucherDetails['minimum_booking_amount'] ?? 0, 2),
                'voucherQuantity' => $voucherDetails['voucher_quantity'] ?? null,
                'voucherQuantitySummary' => number_format($voucherDetails['voucher_quantity'] ?? 0),
                'availableVoucher' => $voucherDetails['available_voucher'] ?? null,
                'availableVoucherSummary' => number_format($voucherDetails['available_voucher'] ?? 0),
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
require_once '../../voucher/model/voucher-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new VoucherController(new VoucherModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SystemModel(), new SecurityModel());
$controller->handleRequest();

?>