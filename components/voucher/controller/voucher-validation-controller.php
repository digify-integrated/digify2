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
            $transaction = isset($_POST['transaction']) ? $_POST['transaction'] : null;

            switch ($transaction) {
                case 'validate voucher':
                    $this->validateVoucher();
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
    #   Validate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: validateVoucher
    # Description: 
    # Validate the voucher if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function validateVoucher() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['voucher_code']) && !empty($_POST['voucher_code']) && isset($_POST['booking_subtotal'])) {
            $voucherCode = $_POST['voucher_code'];
            $bookingSubtotal = $_POST['booking_subtotal'];
        
            $checkVoucherCodeValidy = $this->voucherModel->checkVoucherCodeValidy($voucherCode);
            $total = $checkVoucherCodeValidy['total'] ?? 0;

            if($total === 0){
                $response = [
                    'valid' => false,
                    'title' => 'Voucher Application Error',
                    'message' => 'The voucher code is invalid or expired.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            $voucherCodeDetails = $this->voucherModel->getVoucherCode($voucherCode);
            $minimumBookingAmount = $voucherCodeDetails['minimum_booking_amount'] ?? 0;
            $discountType = $voucherCodeDetails['discount_type'];
            $discountAmount = $voucherCodeDetails['discount_amount'];

            if ($bookingSubtotal >= $minimumBookingAmount) {
                if($discountType === 'Fix Amount'){
                    $discountAmountTotal = $discountAmount;
                }
                else{
                    $discountAmountTotal = ($discountAmount/100);
                }

                $response = [
                    'valid' => true,
                    'discount_type' => $discountType,
                    'discount_amount' => $discountAmountTotal,
                    'title' => 'Voucher Application Success',
                    'message' => 'The voucher has been applied.',
                    'messageType' => 'success'
                ];
            } else {
                $additionalBookingAmount = $minimumBookingAmount - $bookingSubtotal;

                $response = [
                    'valid' => false,
                    'title' => 'Voucher Application Error',
                    'message' => 'To use this voucher, please add AED ' . $additionalBookingAmount . ' more to your booking amount. The current booking amount does not meet the minimum required.',
                    'messageType' => 'error'
                ];
            }
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'valid' => false,
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