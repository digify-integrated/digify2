<?php
session_start();

# -------------------------------------------------------------
#
# Function: WorkLocationsController
# Description: 
# The WorkLocationsController class handles company related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class WorkLocationsController {
    private $workLocationsModel;
    private $cityModel;
    private $stateModel;
    private $countryModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided workLocationsModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for company related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param WorkLocationsModel $workLocationsModel     The workLocationsModel instance for company related operations.
    # - @param CityModel $cityModel     The cityModel instance for city related operations.
    # - @param StateModel $stateModel     The stateModel instance for state related operations.
    # - @param CountryModel $countryModel     The countryModel instance for country related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(WorkLocationsModel $workLocationsModel, CityModel $cityModel, StateModel $stateModel, CountryModel $countryModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->workLocationsModel = $workLocationsModel;
        $this->cityModel = $cityModel;
        $this->stateModel = $stateModel;
        $this->countryModel = $countryModel;
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
                case 'add work locations':
                    $this->addWorkLocations();
                    break;
                case 'update work locations':
                    $this->updateWorkLocations();
                    break;
                case 'get work locations details':
                    $this->getWorkLocationsDetails();
                    break;
                case 'delete work locations':
                    $this->deleteWorkLocations();
                    break;
                case 'delete multiple work locations':
                    $this->deleteMultipleWorkLocations();
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
    # Function: addWorkLocations
    # Description: 
    # Inserts a work locations.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addWorkLocations() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_locations_name']) && !empty($_POST['work_locations_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['phone']) && isset($_POST['mobile']) && isset($_POST['email'])) {
            $userID = $_SESSION['user_account_id'];
            $workLocationsName = $_POST['work_locations_name'];
            $address = $_POST['address'];
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $phone = htmlspecialchars($_POST['phone'], ENT_QUOTES, 'UTF-8');
            $mobile = htmlspecialchars($_POST['mobile'], ENT_QUOTES, 'UTF-8');
            $email = $_POST['email'];

            $cityDetails = $this->cityModel->getCity($cityID);
            $cityName = $cityDetails['city_name'] ?? null;
            $stateID = $cityDetails['state_id'] ?? null;
            $countryID = $cityDetails['country_id'] ?? null;

            $stateDetails = $this->stateModel->getState($stateID);
            $stateName = $stateDetails['state_name'] ?? null;

            $countryDetails = $this->countryModel->getCountry($countryID);
            $countryName = $countryDetails['country_name'] ?? null;
        
            $workLocationsID = $this->workLocationsModel->insertWorkLocations($workLocationsName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $phone, $mobile, $email, $userID);
    
            $response = [
                'success' => true,
                'workLocationsID' => $this->securityModel->encryptData($workLocationsID),
                'title' => 'Insert Work Locations Success',
                'message' => 'The company has been inserted successfully.',
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
    # Function: updateWorkLocations
    # Description: 
    # Updates the work locations if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateWorkLocations() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['work_locations_id']) && !empty($_POST['work_locations_id']) && isset($_POST['work_locations_name']) && !empty($_POST['work_locations_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['phone']) && isset($_POST['mobile']) && isset($_POST['email']) ) {
            $userID = $_SESSION['user_account_id'];
            $workLocationsID = htmlspecialchars($_POST['work_locations_id'], ENT_QUOTES, 'UTF-8');
            $workLocationsName = $_POST['work_locations_name'];
            $address = $_POST['address'];
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $phone = htmlspecialchars($_POST['phone'], ENT_QUOTES, 'UTF-8');
            $mobile = htmlspecialchars($_POST['mobile'], ENT_QUOTES, 'UTF-8');
            $email = $_POST['email'];
        
            $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($workLocationsID);
            $total = $checkWorkLocationsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Work Locations Error',
                    'message' => 'The company does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $cityDetails = $this->cityModel->getCity($cityID);
            $cityName = $cityDetails['city_name'] ?? null;
            $stateID = $cityDetails['state_id'] ?? null;
            $countryID = $cityDetails['country_id'] ?? null;

            $stateDetails = $this->stateModel->getState($stateID);
            $stateName = $stateDetails['state_name'] ?? null;

            $countryDetails = $this->countryModel->getCountry($countryID);
            $countryName = $countryDetails['country_name'] ?? null;

            $this->workLocationsModel->updateWorkLocations($workLocationsID, $workLocationsName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $phone, $mobile, $email, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Work Locations Success',
                'message' => 'The company has been updated successfully.',
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
    # Function: deleteWorkLocations
    # Description: 
    # Delete the company if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteWorkLocations() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_locations_id']) && !empty($_POST['work_locations_id'])) {
            $workLocationsID = htmlspecialchars($_POST['work_locations_id'], ENT_QUOTES, 'UTF-8');
        
            $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($workLocationsID);
            $total = $checkWorkLocationsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Work Location Error',
                    'message' => 'The work location does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->workLocationsModel->deleteWorkLocations($workLocationsID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Work Location Success',
                'message' => 'The work location has been deleted successfully.',
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
    # Function: deleteMultipleWorkLocations
    # Description: 
    # Delete the selected companies if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleWorkLocations() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_locations_id']) && !empty($_POST['work_locations_id'])) {
            $workLocationsIDs = $_POST['work_locations_id'];
    
            foreach($workLocationsIDs as $workLocationsID){
                $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($workLocationsID);
                $total = $checkWorkLocationsExist['total'] ?? 0;

                if($total > 0){
                    $this->workLocationsModel->deleteWorkLocations($workLocationsID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Work Locations Success',
                'message' => 'The selected work locations have been deleted successfully.',
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
    # Function: getWorkLocationsDetails
    # Description: 
    # Handles the retrieval of company details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getWorkLocationsDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['work_locations_id']) && !empty($_POST['work_locations_id'])) {
            $userID = $_SESSION['user_account_id'];
            $workLocationsID = htmlspecialchars($_POST['work_locations_id'], ENT_QUOTES, 'UTF-8');

            $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($workLocationsID);
            $total = $checkWorkLocationsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Work Locations Details Error',
                    'message' => 'The work location does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $companyDetails = $this->workLocationsModel->getWorkLocations($workLocationsID);
            $companyLogo = $this->systemModel->checkImage($companyDetails['work_locations_logo'] ?? null, 'company logo');

            $response = [
                'success' => true,
                'workLocationsName' => $companyDetails['work_locations_name'] ?? null,
                'address' => $companyDetails['address'] ?? null,
                'cityID' => $companyDetails['city_id'] ?? null,
                'cityName' => $companyDetails['city_name'] . ', ' . $companyDetails['state_name'] . ', ' . $companyDetails['country_name'],
                'phone' => $companyDetails['phone'] ?? null,
                'mobile' => $companyDetails['mobile'] ?? null,
                'email' => $companyDetails['email'] ?? null
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
require_once '../../work-locations/model/work-locations-model.php';
require_once '../../city/model/city-model.php';
require_once '../../state/model/state-model.php';
require_once '../../country/model/country-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new WorkLocationsController(new WorkLocationsModel(new DatabaseModel), new CityModel(new DatabaseModel), new StateModel(new DatabaseModel), new CountryModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>