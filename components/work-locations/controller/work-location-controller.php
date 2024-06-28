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

        if (isset($_POST['work_locations_name']) && !empty($_POST['work_locations_name']) && isset($_POST['legal_name']) && !empty($_POST['legal_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['currency_id']) && !empty($_POST['currency_id']) && isset($_POST['tax_id']) && isset($_POST['phone']) && isset($_POST['mobile']) && isset($_POST['email']) && isset($_POST['website'])) {
            $userID = $_SESSION['user_account_id'];
            $companyName = $_POST['work_locations_name'];
            $legalName = $_POST['legal_name'];
            $address = $_POST['address'];
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $currencyID = htmlspecialchars($_POST['currency_id'], ENT_QUOTES, 'UTF-8');
            $taxID = htmlspecialchars($_POST['tax_id'], ENT_QUOTES, 'UTF-8');
            $phone = htmlspecialchars($_POST['phone'], ENT_QUOTES, 'UTF-8');
            $mobile = htmlspecialchars($_POST['mobile'], ENT_QUOTES, 'UTF-8');
            $email = $_POST['email'];
            $website = $_POST['website'];

            $currencyDetails = $this->currencyModel->getCurrency($currencyID);
            $currencyName = $currencyDetails['currency_name'] ?? null;
            $currencySymbol = $currencyDetails['currency_symbol'] ?? null;

            $cityDetails = $this->cityModel->getCity($cityID);
            $cityName = $cityDetails['city_name'] ?? null;
            $stateID = $cityDetails['state_id'] ?? null;
            $countryID = $cityDetails['country_id'] ?? null;

            $stateDetails = $this->stateModel->getState($stateID);
            $stateName = $stateDetails['state_name'] ?? null;

            $countryDetails = $this->countryModel->getCountry($countryID);
            $countryName = $countryDetails['country_name'] ?? null;
        
            $companyID = $this->workLocationsModel->insertWorkLocations($companyName, $legalName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $currencyID, $currencyName, $currencySymbol, $taxID, $phone, $mobile, $email, $website, $userID);
    
            $response = [
                'success' => true,
                'companyID' => $this->securityModel->encryptData($companyID),
                'title' => 'Insert WorkLocations Success',
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
    # Updates the company if it exists; otherwise, return an error message.
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
        
        if (isset($_POST['work_locations_id']) && !empty($_POST['work_locations_id']) && isset($_POST['work_locations_name']) && !empty($_POST['work_locations_name']) && isset($_POST['legal_name']) && !empty($_POST['legal_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['currency_id']) && !empty($_POST['currency_id']) && isset($_POST['tax_id']) && isset($_POST['phone']) && isset($_POST['mobile']) && isset($_POST['email']) && isset($_POST['website'])) {
            $userID = $_SESSION['user_account_id'];
            $companyID = htmlspecialchars($_POST['work_locations_id'], ENT_QUOTES, 'UTF-8');
            $companyName = $_POST['work_locations_name'];
            $legalName = $_POST['legal_name'];
            $address = $_POST['address'];
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $currencyID = htmlspecialchars($_POST['currency_id'], ENT_QUOTES, 'UTF-8');
            $taxID = htmlspecialchars($_POST['tax_id'], ENT_QUOTES, 'UTF-8');
            $phone = htmlspecialchars($_POST['phone'], ENT_QUOTES, 'UTF-8');
            $mobile = htmlspecialchars($_POST['mobile'], ENT_QUOTES, 'UTF-8');
            $email = $_POST['email'];
            $website = $_POST['website'];
        
            $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($companyID);
            $total = $checkWorkLocationsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update WorkLocations Error',
                    'message' => 'The company does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $currencyDetails = $this->currencyModel->getCurrency($currencyID);
            $currencyName = $currencyDetails['currency_name'] ?? null;
            $currencySymbol = $currencyDetails['currency_symbol'] ?? null;

            $cityDetails = $this->cityModel->getCity($cityID);
            $cityName = $cityDetails['city_name'] ?? null;
            $stateID = $cityDetails['state_id'] ?? null;
            $countryID = $cityDetails['country_id'] ?? null;

            $stateDetails = $this->stateModel->getState($stateID);
            $stateName = $stateDetails['state_name'] ?? null;

            $countryDetails = $this->countryModel->getCountry($countryID);
            $countryName = $countryDetails['country_name'] ?? null;

            $this->workLocationsModel->updateWorkLocations($companyID, $companyName, $legalName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $currencyID, $currencyName, $currencySymbol, $taxID, $phone, $mobile, $email, $website, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update WorkLocations Success',
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
    #
    # Function: updateWorkLocationsLogo
    # Description: 
    # Handles the update of the company logo.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateWorkLocationsLogo() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_locations_id']) && !empty($_POST['work_locations_id'])) {
            $userID = $_SESSION['user_account_id'];

            $companyID = htmlspecialchars($_POST['work_locations_id'], ENT_QUOTES, 'UTF-8');

            $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($companyID);
            $total = $checkWorkLocationsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update WorkLocations Logo Error',
                    'message' => 'The company logo does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $companyLogoFileName = $_FILES['work_locations_logo']['name'];
            $companyLogoFileSize = $_FILES['work_locations_logo']['size'];
            $companyLogoFileError = $_FILES['work_locations_logo']['error'];
            $companyLogoTempName = $_FILES['work_locations_logo']['tmp_name'];
            $companyLogoFileExtension = explode('.', $companyLogoFileName);
            $companyLogoActualFileExtension = strtolower(end($companyLogoFileExtension));

            $uploadSetting = $this->uploadSettingModel->getUploadSetting(3);
            $maxFileSize = $uploadSetting['max_file_size'];

            $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(3);
            $allowedFileExtensions = [];

            foreach ($uploadSettingFileExtension as $row) {
                $allowedFileExtensions[] = $row['file_extension'];
            }

            if (!in_array($companyLogoActualFileExtension, $allowedFileExtensions)) {
                $response = [
                    'success' => false,
                    'title' => 'Update WorkLocations Logo Error',
                    'message' => 'The file uploaded is not supported.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if(empty($companyLogoTempName)){
                $response = [
                    'success' => false,
                    'title' => 'Update WorkLocations Logo Error',
                    'message' => 'Please choose the company logo.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if($companyLogoFileError){
                $response = [
                    'success' => false,
                    'title' => 'Update WorkLocations Logo Error',
                    'message' => 'An error occurred while uploading the file.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if($companyLogoFileSize > ($maxFileSize * 1024)){
                $response = [
                    'success' => false,
                    'title' => 'Update WorkLocations Logo Error',
                    'message' => 'The company logo exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $fileName = $this->securityModel->generateFileName();
            $fileNew = $fileName . '.' . $companyLogoActualFileExtension;
            
            define('PROJECT_BASE_DIR', dirname(__DIR__));
            define('COMPANY_LOGO_DIR', 'image/logo/');

            $directory = PROJECT_BASE_DIR. '/'. COMPANY_LOGO_DIR. $companyID. '/';
            $fileDestination = $directory. $fileNew;
            $filePath = './components/company/image/logo/'. $companyID . '/' . $fileNew;

            $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));

            if(!$directoryChecker){
                $response = [
                    'success' => false,
                    'title' => 'Update WorkLocations Logo Error',
                    'message' => $directoryChecker,
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $companyDetails = $this->workLocationsModel->getWorkLocations($companyID);
            $companyLogoPath = !empty($companyDetails['work_locations_logo']) ? str_replace('./components/', '../../', $companyDetails['work_locations_logo']) : null;

            if(file_exists($companyLogoPath)){
                if (!unlink($companyLogoPath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Update WorkLocations Logo Error',
                        'message' => 'The company logo cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            if(!move_uploaded_file($companyLogoTempName, $fileDestination)){
                $response = [
                    'success' => false,
                    'title' => 'Update WorkLocations Logo Error',
                    'message' => 'The company logo cannot be uploaded due to an error.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;           
            }

            $this->workLocationsModel->updateWorkLocationsLogo($companyID, $filePath, $userID);

            $response = [
                'success' => true,
                'title' => 'Update WorkLocations Logo Success',
                'message' => 'The company logo has been updated successfully.',
                'messageType' => 'success'
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
            $companyID = htmlspecialchars($_POST['work_locations_id'], ENT_QUOTES, 'UTF-8');
        
            $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($companyID);
            $total = $checkWorkLocationsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete WorkLocations Error',
                    'message' => 'The company does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $companyDetails = $this->workLocationsModel->getWorkLocations($companyID);
            $companyLogoPath = !empty($companyDetails['work_locations_logo']) ? str_replace('./components/', '../../', $companyDetails['work_locations_logo']) : null;

            if(file_exists($companyLogoPath)){
                if (!unlink($companyLogoPath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete WorkLocations Logo Error',
                        'message' => 'The company logo cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->workLocationsModel->deleteWorkLocations($companyID);
                
            $response = [
                'success' => true,
                'title' => 'Delete WorkLocations Success',
                'message' => 'The company has been deleted successfully.',
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
            $companyIDs = $_POST['work_locations_id'];
    
            foreach($companyIDs as $companyID){
                $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($companyID);
                $total = $checkWorkLocationsExist['total'] ?? 0;

                if($total > 0){
                    $companyDetails = $this->workLocationsModel->getWorkLocations($companyID);
                    $companyLogoPath = !empty($companyDetails['work_locations_logo']) ? str_replace('./components/', '../../', $companyDetails['work_locations_logo']) : null;
        
                    if(file_exists($companyLogoPath)){
                        if (!unlink($companyLogoPath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Delete WorkLocations Logo Error',
                                'message' => 'The company logo cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }
                    
                    $this->workLocationsModel->deleteWorkLocations($companyID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple WorkLocations Success',
                'message' => 'The selected companies have been deleted successfully.',
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
            $companyID = htmlspecialchars($_POST['work_locations_id'], ENT_QUOTES, 'UTF-8');

            $checkWorkLocationsExist = $this->workLocationsModel->checkWorkLocationsExist($companyID);
            $total = $checkWorkLocationsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get WorkLocations Details Error',
                    'message' => 'The company does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $companyDetails = $this->workLocationsModel->getWorkLocations($companyID);
            $companyLogo = $this->systemModel->checkImage($companyDetails['work_locations_logo'] ?? null, 'company logo');

            $response = [
                'success' => true,
                'companyName' => $companyDetails['work_locations_name'] ?? null,
                'legalName' => $companyDetails['legal_name'] ?? null,
                'address' => $companyDetails['address'] ?? null,
                'cityID' => $companyDetails['city_id'] ?? null,
                'cityName' => $companyDetails['city_name'] . ', ' . $companyDetails['state_name'] . ', ' . $companyDetails['country_name'],
                'currencyID' => $companyDetails['currency_id'] ?? null,
                'currencyName' => $companyDetails['currency_name'] ?? null,
                'currencySymbol' => $companyDetails['currency_symbol'] ?? null,
                'taxID' => $companyDetails['tax_id'] ?? null,
                'phone' => $companyDetails['phone'] ?? null,
                'mobile' => $companyDetails['mobile'] ?? null,
                'email' => $companyDetails['email'] ?? null,
                'website' => $companyDetails['website'] ?? null,
                'companyLogo' => $companyLogo
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
require_once '../../company/model/company-model.php';
require_once '../../city/model/city-model.php';
require_once '../../state/model/state-model.php';
require_once '../../country/model/country-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new WorkLocationsController(new WorkLocationsModel(new DatabaseModel), new CityModel(new DatabaseModel), new StateModel(new DatabaseModel), new CountryModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>