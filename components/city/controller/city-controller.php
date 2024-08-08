<?php
session_start();

# -------------------------------------------------------------
#
# Function: CityController
# Description: 
# The CityController class handles city related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class CityController {
    private $cityModel;
    private $stateModel;
    private $countryModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided cityModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for city related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param CityModel $cityModel     The cityModel instance for city related operations.
    # - @param StateModel $stateModel     The stateModel instance for state related operations.
    # - @param CountryModel $stateModel     The countryModel instance for country related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(CityModel $cityModel, StateModel $stateModel, CountryModel $countryModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->cityModel = $cityModel;
        $this->stateModel = $stateModel;
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
                case 'add city':
                    $this->addCity();
                    break;
                case 'update city':
                    $this->updateCity();
                    break;
                case 'get city details':
                    $this->getCityDetails();
                    break;
                case 'delete city':
                    $this->deleteCity();
                    break;
                case 'delete multiple city':
                    $this->deleteMultipleCity();
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
    # Function: addCity
    # Description: 
    # Inserts a city.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCity() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['city_name']) && !empty($_POST['city_name']) && isset($_POST['state_id']) && !empty($_POST['state_id'])) {
            $userID = $_SESSION['user_account_id'];
            $cityName = $_POST['city_name'];
            $stateID = htmlspecialchars($_POST['state_id'], ENT_QUOTES, 'UTF-8');

            $stateDetails = $this->stateModel->getState($stateID);
            $stateName = $stateDetails['state_name'] ?? null;
            $countryID = $stateDetails['country_id'] ?? null;

            $countryDetails = $this->countryModel->getCountry($countryID);
            $countryName = $countryDetails['country_name'] ?? null;
        
            $cityID = $this->cityModel->insertCity($cityName, $stateID, $stateName, $countryID, $countryName, $userID);
    
            $response = [
                'success' => true,
                'cityID' => $this->securityModel->encryptData($cityID),
                'title' => 'Insert City Success',
                'message' => 'The city has been inserted successfully.',
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
    # Function: updateCity
    # Description: 
    # Updates the city if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCity() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['city_name']) && !empty($_POST['city_name']) && isset($_POST['state_id']) && !empty($_POST['state_id'])) {
            $userID = $_SESSION['user_account_id'];
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $cityName = $_POST['city_name'];
            $stateID = htmlspecialchars($_POST['state_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCityExist = $this->cityModel->checkCityExist($cityID);
            $total = $checkCityExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update City Error',
                    'message' => 'The city does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $stateDetails = $this->stateModel->getState($stateID);
            $stateName = $stateDetails['state_name'] ?? null;
            $countryID = $stateDetails['country_id'] ?? null;

            $countryDetails = $this->countryModel->getCountry($countryID);
            $countryName = $countryDetails['country_name'] ?? null;

            $this->cityModel->updateCity($cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update City Success',
                'message' => 'The city has been updated successfully.',
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
    # Function: deleteCity
    # Description: 
    # Delete the city if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCity() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['city_id']) && !empty($_POST['city_id'])) {
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCityExist = $this->cityModel->checkCityExist($cityID);
            $total = $checkCityExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete City Error',
                    'message' => 'The city does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->cityModel->deleteCity($cityID);
                
            $response = [
                'success' => true,
                'title' => 'Delete City Success',
                'message' => 'The city has been deleted successfully.',
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
    # Function: deleteMultipleCity
    # Description: 
    # Delete the selected cities if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleCity() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['city_id']) && !empty($_POST['city_id'])) {
            $cityIDs = $_POST['city_id'];
    
            foreach($cityIDs as $cityID){
                $checkCityExist = $this->cityModel->checkCityExist($cityID);
                $total = $checkCityExist['total'] ?? 0;

                if($total > 0){
                    $this->cityModel->deleteCity($cityID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple City Success',
                'message' => 'The selected cities have been deleted successfully.',
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
    # Function: getCityDetails
    # Description: 
    # Handles the retrieval of city details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCityDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['city_id']) && !empty($_POST['city_id'])) {
            $userID = $_SESSION['user_account_id'];
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');

            $checkCityExist = $this->cityModel->checkCityExist($cityID);
            $total = $checkCityExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get City Details Error',
                    'message' => 'The city does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $cityDetails = $this->cityModel->getCity($cityID);

            $response = [
                'success' => true,
                'cityName' => $cityDetails['city_name'] ?? null,
                'city' => $cityDetails['city'] ?? null,
                'stateID' => $cityDetails['state_id'] ?? null,
                'stateName' => $cityDetails['state_name'] . ', ' . $cityDetails['country_name']
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
require_once '../../city/model/city-model.php';
require_once '../../state/model/state-model.php';
require_once '../../country/model/country-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new CityController(new CityModel(new DatabaseModel), new StateModel(new DatabaseModel), new CountryModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>