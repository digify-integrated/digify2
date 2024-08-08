<?php
session_start();

# -------------------------------------------------------------
#
# Function: WorkLocationController
# Description: 
# The WorkLocationController class handles work location related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class WorkLocationController {
    private $workLocationModel;
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
    # The constructor initializes the object with the provided workLocationModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for work location related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param WorkLocationModel $workLocationModel     The workLocationModel instance for work location related operations.
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
    public function __construct(WorkLocationModel $workLocationModel, CityModel $cityModel, StateModel $stateModel, CountryModel $countryModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->workLocationModel = $workLocationModel;
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
                case 'add work location':
                    $this->addWorkLocation();
                    break;
                case 'update work location':
                    $this->updateWorkLocation();
                    break;
                case 'get work location details':
                    $this->getWorkLocationDetails();
                    break;
                case 'delete work location':
                    $this->deleteWorkLocation();
                    break;
                case 'delete multiple work location':
                    $this->deleteMultipleWorkLocation();
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
    # Function: addWorkLocation
    # Description: 
    # Inserts a work location.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addWorkLocation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_location_name']) && !empty($_POST['work_location_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['phone']) && isset($_POST['mobile']) && isset($_POST['email'])) {
            $userID = $_SESSION['user_account_id'];
            $workLocationName = $_POST['work_location_name'];
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
        
            $workLocationID = $this->workLocationModel->insertWorkLocation($workLocationName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $phone, $mobile, $email, $userID);
    
            $response = [
                'success' => true,
                'workLocationID' => $this->securityModel->encryptData($workLocationID),
                'title' => 'Insert Work Location Success',
                'message' => 'The work location has been inserted successfully.',
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
    # Function: updateWorkLocation
    # Description: 
    # Updates the work location if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateWorkLocation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['work_location_id']) && !empty($_POST['work_location_id']) && isset($_POST['work_location_name']) && !empty($_POST['work_location_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['phone']) && isset($_POST['mobile']) && isset($_POST['email']) ) {
            $userID = $_SESSION['user_account_id'];
            $workLocationID = htmlspecialchars($_POST['work_location_id'], ENT_QUOTES, 'UTF-8');
            $workLocationName = $_POST['work_location_name'];
            $address = $_POST['address'];
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $phone = htmlspecialchars($_POST['phone'], ENT_QUOTES, 'UTF-8');
            $mobile = htmlspecialchars($_POST['mobile'], ENT_QUOTES, 'UTF-8');
            $email = $_POST['email'];
        
            $checkWorkLocationExist = $this->workLocationModel->checkWorkLocationExist($workLocationID);
            $total = $checkWorkLocationExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Work Location Error',
                    'message' => 'The work location does not exist.',
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

            $this->workLocationModel->updateWorkLocation($workLocationID, $workLocationName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $phone, $mobile, $email, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Work Location Success',
                'message' => 'The work location has been updated successfully.',
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
    # Function: deleteWorkLocation
    # Description: 
    # Delete the work location if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteWorkLocation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_location_id']) && !empty($_POST['work_location_id'])) {
            $workLocationID = htmlspecialchars($_POST['work_location_id'], ENT_QUOTES, 'UTF-8');
        
            $checkWorkLocationExist = $this->workLocationModel->checkWorkLocationExist($workLocationID);
            $total = $checkWorkLocationExist['total'] ?? 0;

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

            $this->workLocationModel->deleteWorkLocation($workLocationID);
                
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
    # Function: deleteMultipleWorkLocation
    # Description: 
    # Delete the selected companies if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleWorkLocation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_location_id']) && !empty($_POST['work_location_id'])) {
            $workLocationIDs = $_POST['work_location_id'];
    
            foreach($workLocationIDs as $workLocationID){
                $checkWorkLocationExist = $this->workLocationModel->checkWorkLocationExist($workLocationID);
                $total = $checkWorkLocationExist['total'] ?? 0;

                if($total > 0){
                    $this->workLocationModel->deleteWorkLocation($workLocationID);
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
    # Function: getWorkLocationDetails
    # Description: 
    # Handles the retrieval of work location details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getWorkLocationDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['work_location_id']) && !empty($_POST['work_location_id'])) {
            $userID = $_SESSION['user_account_id'];
            $workLocationID = htmlspecialchars($_POST['work_location_id'], ENT_QUOTES, 'UTF-8');

            $checkWorkLocationExist = $this->workLocationModel->checkWorkLocationExist($workLocationID);
            $total = $checkWorkLocationExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Work Location Details Error',
                    'message' => 'The work location does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $workLocationDetails = $this->workLocationModel->getWorkLocation($workLocationID);
            $companyLogo = $this->systemModel->checkImage($workLocationDetails['work_location_logo'] ?? null, 'company logo');

            $response = [
                'success' => true,
                'workLocationName' => $workLocationDetails['work_location_name'] ?? null,
                'address' => $workLocationDetails['address'] ?? null,
                'cityID' => $workLocationDetails['city_id'] ?? null,
                'cityName' => $workLocationDetails['city_name'] . ', ' . $workLocationDetails['state_name'] . ', ' . $workLocationDetails['country_name'],
                'phone' => $workLocationDetails['phone'] ?? null,
                'mobile' => $workLocationDetails['mobile'] ?? null,
                'email' => $workLocationDetails['email'] ?? null
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
require_once '../../work-location/model/work-location-model.php';
require_once '../../city/model/city-model.php';
require_once '../../state/model/state-model.php';
require_once '../../country/model/country-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new WorkLocationController(new WorkLocationModel(new DatabaseModel), new CityModel(new DatabaseModel), new StateModel(new DatabaseModel), new CountryModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>