<?php
session_start();

# -------------------------------------------------------------
#
# Function: BankAccountTypeController
# Description: 
# The BankAccountTypeController class handles bank account type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class BankAccountTypeController {
    private $bankAccountTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided BankAccountTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for bank account type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param BankAccountTypeModel $bankAccountTypeModel     The BankAccountTypeModel instance for bank account type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BankAccountTypeModel $bankAccountTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->bankAccountTypeModel = $bankAccountTypeModel;
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
                case 'add bank account type':
                    $this->addBankAccountType();
                    break;
                case 'update bank account type':
                    $this->updateBankAccountType();
                    break;
                case 'get bank account type details':
                    $this->getBankAccountTypeDetails();
                    break;
                case 'delete bank account type':
                    $this->deleteBankAccountType();
                    break;
                case 'delete multiple bank account type':
                    $this->deleteMultipleBankAccountType();
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
    # Function: addBankAccountType
    # Description: 
    # Inserts a bank account type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addBankAccountType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['bank_account_type_name']) && !empty($_POST['bank_account_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $bankAccountTypeName = $_POST['bank_account_type_name'];
        
            $bankAccountTypeID = $this->bankAccountTypeModel->insertBankAccountType($bankAccountTypeName, $userID);
    
            $response = [
                'success' => true,
                'bankAccountTypeID' => $this->securityModel->encryptData($bankAccountTypeID),
                'title' => 'Insert Bank Account Type Success',
                'message' => 'The bank account type has been inserted successfully.',
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
    # Function: updateBankAccountType
    # Description: 
    # Updates the bank account type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBankAccountType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['bank_account_type_id']) && !empty($_POST['bank_account_type_id']) && isset($_POST['bank_account_type_name']) && !empty($_POST['bank_account_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $bankAccountTypeID = htmlspecialchars($_POST['bank_account_type_id'], ENT_QUOTES, 'UTF-8');
            $bankAccountTypeName = $_POST['bank_account_type_name'];
        
            $checkBankAccountTypeExist = $this->bankAccountTypeModel->checkBankAccountTypeExist($bankAccountTypeID);
            $total = $checkBankAccountTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Bank Account Type Error',
                    'message' => 'The bank account type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bankAccountTypeModel->updateBankAccountType($bankAccountTypeID, $bankAccountTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Bank Account Type Success',
                'message' => 'The bank account type has been updated successfully.',
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
    # Function: deleteBankAccountType
    # Description: 
    # Delete the bank account type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteBankAccountType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['bank_account_type_id']) && !empty($_POST['bank_account_type_id'])) {
            $bankAccountTypeID = htmlspecialchars($_POST['bank_account_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBankAccountTypeExist = $this->bankAccountTypeModel->checkBankAccountTypeExist($bankAccountTypeID);
            $total = $checkBankAccountTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Bank Account Type Error',
                    'message' => 'The bank account type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->bankAccountTypeModel->deleteBankAccountType($bankAccountTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Bank Account Type Success',
                'message' => 'The bank account type has been deleted successfully.',
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
    # Function: deleteMultipleBankAccountType
    # Description: 
    # Delete the selected bank account type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleBankAccountType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['bank_account_type_id']) && !empty($_POST['bank_account_type_id'])) {
            $bankAccountTypeIDs = $_POST['bank_account_type_id'];
    
            foreach($bankAccountTypeIDs as $bankAccountTypeID){
                $checkBankAccountTypeExist = $this->bankAccountTypeModel->checkBankAccountTypeExist($bankAccountTypeID);
                $total = $checkBankAccountTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->bankAccountTypeModel->deleteBankAccountType($bankAccountTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Bank Account Types Success',
                'message' => 'The selected bank account types have been deleted successfully.',
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
    # Function: getBankAccountTypeDetails
    # Description: 
    # Handles the retrieval of bank account type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBankAccountTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['bank_account_type_id']) && !empty($_POST['bank_account_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $bankAccountTypeID = htmlspecialchars($_POST['bank_account_type_id'], ENT_QUOTES, 'UTF-8');

            $checkBankAccountTypeExist = $this->bankAccountTypeModel->checkBankAccountTypeExist($bankAccountTypeID);
            $total = $checkBankAccountTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Bank Account Type Details Error',
                    'message' => 'The bank account type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $bankAccountTypeDetails = $this->bankAccountTypeModel->getBankAccountType($bankAccountTypeID);

            $response = [
                'success' => true,
                'bankAccountTypeName' => $bankAccountTypeDetails['bank_account_type_name'] ?? null,
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
require_once '../../bank-account-type/model/bank-account-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new BankAccountTypeController(new BankAccountTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>