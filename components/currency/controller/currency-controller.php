<?php
session_start();

# -------------------------------------------------------------
#
# Function: CurrencyController
# Description: 
# The CurrencyController class handles currency related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class CurrencyController {
    private $currencyModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided currencyModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for currency related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param CurrencyModel $currencyModel     The currencyModel instance for currency related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(CurrencyModel $currencyModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->currencyModel = $currencyModel;
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
                case 'add currency':
                    $this->addCurrency();
                    break;
                case 'update currency':
                    $this->updateCurrency();
                    break;
                case 'get currency details':
                    $this->getCurrencyDetails();
                    break;
                case 'delete currency':
                    $this->deleteCurrency();
                    break;
                case 'delete multiple currency':
                    $this->deleteMultipleCurrency();
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
    # Function: addCurrency
    # Description: 
    # Inserts a currency.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCurrency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['currency_name']) && !empty($_POST['currency_name']) && isset($_POST['currency_symbol']) && !empty($_POST['currency_symbol'])) {
            $userID = $_SESSION['user_account_id'];
            $currencyName = $_POST['currency_name'];
            $currencySymbol = $_POST['currency_symbol'];
        
            $currencyID = $this->currencyModel->insertCurrency($currencyName, $currencySymbol, $userID);
    
            $response = [
                'success' => true,
                'currencyID' => $this->securityModel->encryptData($currencyID),
                'title' => 'Insert Currency Success',
                'message' => 'The currency has been inserted successfully.',
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
    # Function: updateCurrency
    # Description: 
    # Updates the currency if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCurrency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['currency_id']) && !empty($_POST['currency_id']) && isset($_POST['currency_name']) && !empty($_POST['currency_name']) && isset($_POST['currency_symbol']) && !empty($_POST['currency_symbol'])) {
            $userID = $_SESSION['user_account_id'];
            $currencyID = htmlspecialchars($_POST['currency_id'], ENT_QUOTES, 'UTF-8');
            $currencyName = $_POST['currency_name'];
            $currencySymbol = $_POST['currency_symbol'];
        
            $checkCurrencyExist = $this->currencyModel->checkCurrencyExist($currencyID);
            $total = $checkCurrencyExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Currency Error',
                    'message' => 'The currency does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->currencyModel->updateCurrency($currencyID, $currencyName, $currencySymbol, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Currency Success',
                'message' => 'The currency has been updated successfully.',
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
    # Function: deleteCurrency
    # Description: 
    # Delete the currency if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCurrency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['currency_id']) && !empty($_POST['currency_id'])) {
            $currencyID = htmlspecialchars($_POST['currency_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCurrencyExist = $this->currencyModel->checkCurrencyExist($currencyID);
            $total = $checkCurrencyExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Currency Error',
                    'message' => 'The currency does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->currencyModel->deleteCurrency($currencyID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Currency Success',
                'message' => 'The currency has been deleted successfully.',
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
    # Function: deleteMultipleCurrency
    # Description: 
    # Delete the selected currencys if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleCurrency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['currency_id']) && !empty($_POST['currency_id'])) {
            $currencyIDs = $_POST['currency_id'];
    
            foreach($currencyIDs as $currencyID){
                $checkCurrencyExist = $this->currencyModel->checkCurrencyExist($currencyID);
                $total = $checkCurrencyExist['total'] ?? 0;

                if($total > 0){
                    $this->currencyModel->deleteCurrency($currencyID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Currency Success',
                'message' => 'The selected currencys have been deleted successfully.',
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
    # Function: getCurrencyDetails
    # Description: 
    # Handles the retrieval of currency details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCurrencyDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['currency_id']) && !empty($_POST['currency_id'])) {
            $userID = $_SESSION['user_account_id'];
            $currencyID = htmlspecialchars($_POST['currency_id'], ENT_QUOTES, 'UTF-8');

            $checkCurrencyExist = $this->currencyModel->checkCurrencyExist($currencyID);
            $total = $checkCurrencyExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Currency Details Error',
                    'message' => 'The currency does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $currencyDetails = $this->currencyModel->getCurrency($currencyID);

            $response = [
                'success' => true,
                'currencyName' => $currencyDetails['currency_name'] ?? null,
                'currencySymbol' => $currencyDetails['currency_symbol'] ?? null,
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
require_once '../../currency/model/currency-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new CurrencyController(new CurrencyModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>