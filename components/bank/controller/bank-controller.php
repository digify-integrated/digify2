<?php
session_start();

# -------------------------------------------------------------
#
# Function: BankController
# Description: 
# The BankController class handles bank related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class BankController {
    private $bankModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided BankModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for bank related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param BankModel $bankModel     The BankModel instance for bank related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BankModel $bankModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->bankModel = $bankModel;
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
                case 'add bank':
                    $this->addBank();
                    break;
                case 'update bank':
                    $this->updateBank();
                    break;
                case 'get bank details':
                    $this->getBankDetails();
                    break;
                case 'delete bank':
                    $this->deleteBank();
                    break;
                case 'delete multiple bank':
                    $this->deleteMultipleBank();
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
    # Function: addBank
    # Description: 
    # Inserts a bank.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addBank() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['bank_name']) && !empty($_POST['bank_name']) && isset($_POST['bank_identifier_code']) && !empty($_POST['bank_identifier_code'])) {
            $userID = $_SESSION['user_account_id'];
            $bankName = $_POST['bank_name'];
            $bankIdentifierCode = $_POST['bank_identifier_code'];
        
            $bankID = $this->bankModel->insertBank($bankName, $bankIdentifierCode, $userID);
    
            $response = [
                'success' => true,
                'bankID' => $this->securityModel->encryptData($bankID),
                'title' => 'Insert Bank Success',
                'message' => 'The bank has been inserted successfully.',
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
    # Function: updateBank
    # Description: 
    # Updates the bank if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBank() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['bank_id']) && !empty($_POST['bank_id']) && isset($_POST['bank_name']) && !empty($_POST['bank_name']) && isset($_POST['bank_identifier_code']) && !empty($_POST['bank_identifier_code'])) {
            $userID = $_SESSION['user_account_id'];
            $bankID = htmlspecialchars($_POST['bank_id'], ENT_QUOTES, 'UTF-8');
            $bankName = $_POST['bank_name'];
            $bankIdentifierCode = $_POST['bank_identifier_code'];
        
            $checkBankExist = $this->bankModel->checkBankExist($bankID);
            $total = $checkBankExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Bank Error',
                    'message' => 'The bank does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bankModel->updateBank($bankID, $bankName, $bankIdentifierCode, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Bank Success',
                'message' => 'The bank has been updated successfully.',
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
    # Function: deleteBank
    # Description: 
    # Delete the bank if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteBank() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['bank_id']) && !empty($_POST['bank_id'])) {
            $bankID = htmlspecialchars($_POST['bank_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBankExist = $this->bankModel->checkBankExist($bankID);
            $total = $checkBankExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Bank Error',
                    'message' => 'The bank does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bankModel->deleteBank($bankID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Bank Success',
                'message' => 'The bank has been deleted successfully.',
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
    # Function: deleteMultipleBank
    # Description: 
    # Delete the selected bank if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleBank() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['bank_id']) && !empty($_POST['bank_id'])) {
            $bankIDs = $_POST['bank_id'];
    
            foreach($bankIDs as $bankID){
                $checkBankExist = $this->bankModel->checkBankExist($bankID);
                $total = $checkBankExist['total'] ?? 0;

                if($total > 0){                    
                    $this->bankModel->deleteBank($bankID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Bank Success',
                'message' => 'The selected bank have been deleted successfully.',
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
    # Function: getBankDetails
    # Description: 
    # Handles the retrieval of bank details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBankDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['bank_id']) && !empty($_POST['bank_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bankID = htmlspecialchars($_POST['bank_id'], ENT_QUOTES, 'UTF-8');

            $checkBankExist = $this->bankModel->checkBankExist($bankID);
            $total = $checkBankExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Bank Details Error',
                    'message' => 'The bank does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $bankDetails = $this->bankModel->getBank($bankID);

            $response = [
                'success' => true,
                'bankName' => $bankDetails['bank_name'] ?? null,
                'bankIdentifierCode' => $bankDetails['bank_identifier_code'] ?? null,
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
require_once '../../bank/model/bank-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new BankController(new BankModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>