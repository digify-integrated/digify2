<?php
session_start();

# -------------------------------------------------------------
#
# Function: CountryController
# Description: 
# The CountryController class handles country related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class CountryController {
    private $countryModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided CountryModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for country related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param CountryModel $countryModel     The CountryModel instance for country related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(CountryModel $countryModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->countryModel = $countryModel;
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
                case 'add country':
                    $this->addCountry();
                    break;
                case 'update country':
                    $this->updateCountry();
                    break;
                case 'get country details':
                    $this->getCountryDetails();
                    break;
                case 'delete country':
                    $this->deleteCountry();
                    break;
                case 'delete multiple country':
                    $this->deleteMultipleCountry();
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
    # Function: addCountry
    # Description: 
    # Inserts a country.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCountry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['country_name']) && !empty($_POST['country_name'])) {
            $userID = $_SESSION['user_account_id'];
            $countryName = htmlspecialchars($_POST['country_name'], ENT_QUOTES, 'UTF-8');

            $countryID = $this->countryModel->insertCountry($countryName, $userID);
    
            $response = [
                'success' => true,
                'countryID' => $this->securityModel->encryptData($countryID),
                'title' => 'Insert Country Success',
                'message' => 'The country has been inserted successfully.',
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
    # Function: updateCountry
    # Description: 
    # Updates the country if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCountry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['country_id']) && !empty($_POST['country_id']) && isset($_POST['country_name']) && !empty($_POST['country_name'])) {
            $userID = $_SESSION['user_account_id'];
            $countryID = htmlspecialchars($_POST['country_id'], ENT_QUOTES, 'UTF-8');
            $countryName = htmlspecialchars($_POST['country_name'], ENT_QUOTES, 'UTF-8');
        
            $checkCountryExist = $this->countryModel->checkCountryExist($countryID);
            $total = $checkCountryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Country Error',
                    'message' => 'The country does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->countryModel->updateCountry($countryID, $countryName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Country Success',
                'message' => 'The country has been updated successfully.',
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
    # Function: deleteCountry
    # Description: 
    # Delete the country if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCountry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['country_id']) && !empty($_POST['country_id'])) {
            $countryID = htmlspecialchars($_POST['country_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCountryExist = $this->countryModel->checkCountryExist($countryID);
            $total = $checkCountryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Country Error',
                    'message' => 'The country does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->countryModel->deleteCountry($countryID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Country Success',
                'message' => 'The country has been deleted successfully.',
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
    # Function: deleteMultipleCountry
    # Description: 
    # Delete the selected countries if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleCountry() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['country_id']) && !empty($_POST['country_id'])) {
            $countryIDs = $_POST['country_id'];
    
            foreach($countryIDs as $countryID){
                $checkCountryExist = $this->countryModel->checkCountryExist($countryID);
                $total = $checkCountryExist['total'] ?? 0;

                if($total > 0){
                    $this->countryModel->deleteCountry($countryID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Country Success',
                'message' => 'The selected countries have been deleted successfully.',
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
    # Function: getCountryDetails
    # Description: 
    # Handles the retrieval of country details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCountryDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['country_id']) && !empty($_POST['country_id'])) {
            $userID = $_SESSION['user_account_id'];
            $countryID = htmlspecialchars($_POST['country_id'], ENT_QUOTES, 'UTF-8');

            $checkCountryExist = $this->countryModel->checkCountryExist($countryID);
            $total = $checkCountryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Country Details Error',
                    'message' => 'The country does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $countryDetails = $this->countryModel->getCountry($countryID);

            $response = [
                'success' => true,
                'countryName' => $countryDetails['country_name'] ?? null
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
require_once '../../country/model/country-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new CountryController(new CountryModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>