<?php
session_start();

# -------------------------------------------------------------
#
# Function: AppModuleController
# Description: 
# The AppModuleController class handles app module related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class AppModuleController {
    private $appModuleModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided AppModuleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for app module related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param AppModuleModel $appModuleModel     The AppModuleModel instance for app module related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(AppModuleModel $appModuleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->appModuleModel = $appModuleModel;
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
                case 'add app module':
                    $this->addAppModule();
                    break;
                case 'update app module':
                    $this->updateAppModule();
                    break;
                case 'update app logo':
                    $this->updateAppLogo();
                    break;
                case 'get app module details':
                    $this->getAppModuleDetails();
                    break;
                case 'delete app module':
                    $this->deleteAppModule();
                    break;
                case 'delete multiple app module':
                    $this->deleteMultipleAppModule();
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
    # Function: addAppModule
    # Description: 
    # Inserts a app module.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['app_module_name']) && !empty($_POST['app_module_name']) && isset($_POST['app_module_description']) && !empty($_POST['app_module_description']) && isset($_POST['redirect_link']) && !empty($_POST['redirect_link']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $appModuleName = $_POST['app_module_name'];
            $appModuleDescription = $_POST['app_module_description'];
            $redirectLink = $_POST['redirect_link'];
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');
        
            $appModuleID = $this->appModuleModel->insertAppModule($appModuleName, $appModuleDescription, $redirectLink, $orderSequence, $userID);
    
            $response = [
                'success' => true,
                'appModuleID' => $this->securityModel->encryptData($appModuleID),
                'title' => 'Insert App Module Success',
                'message' => 'The app module has been inserted successfully.',
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
    # Function: updateAppModule
    # Description: 
    # Updates the app module if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id']) && isset($_POST['app_module_name']) && !empty($_POST['app_module_name']) && isset($_POST['app_module_description']) && !empty($_POST['app_module_description']) && isset($_POST['redirect_link']) && !empty($_POST['redirect_link']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');
            $appModuleName = $_POST['app_module_name'];
            $appModuleDescription = $_POST['app_module_description'];
            $redirectLink = $_POST['redirect_link'];
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');
        
            $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
            $total = $checkAppModuleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update App Module Error',
                    'message' => 'The app module does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->appModuleModel->updateAppModule($appModuleID, $appModuleName, $appModuleDescription, $redirectLink, $orderSequence, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update App Module Success',
                'message' => 'The app module has been updated successfully.',
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
    # Function: updateAppLogo
    # Description: 
    # Handles the update of the app logo.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateAppLogo() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id'])) {
            $userID = $_SESSION['user_account_id'];

            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');

            $checkAppExist = $this->appModel->checkAppExist($appModuleID);
            $total = $checkAppExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update App Logo Error',
                    'message' => 'The app logo does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $appLogoFileName = $_FILES['app_logo']['name'];
            $appLogoFileSize = $_FILES['app_logo']['size'];
            $appLogoFileError = $_FILES['app_logo']['error'];
            $appLogoTempName = $_FILES['app_logo']['tmp_name'];
            $appLogoFileExtension = explode('.', $appLogoFileName);
            $appLogoActualFileExtension = strtolower(end($appLogoFileExtension));

            $uploadSetting = $this->uploadSettingModel->getUploadSetting(4);
            $maxFileSize = $uploadSetting['max_file_size'];

            $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(4);
            $allowedFileExtensions = [];

            foreach ($uploadSettingFileExtension as $row) {
                $allowedFileExtensions[] = $row['file_extension'];
            }

            if (!in_array($appLogoActualFileExtension, $allowedFileExtensions)) {
                $response = [
                    'success' => false,
                    'title' => 'Update App Logo Error',
                    'message' => 'The file uploaded is not supported.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if(empty($appLogoTempName)){
                $response = [
                    'success' => false,
                    'title' => 'Update App Logo Error',
                    'message' => 'Please choose the app logo.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if($appLogoFileError){
                $response = [
                    'success' => false,
                    'title' => 'Update App Logo Error',
                    'message' => 'An error occurred while uploading the file.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if($appLogoFileSize > ($maxFileSize * 1024)){
                $response = [
                    'success' => false,
                    'title' => 'Update App Logo Error',
                    'message' => 'The app logo exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $fileName = $this->securityModel->generateFileName();
            $fileNew = $fileName . '.' . $appLogoActualFileExtension;
            
            define('PROJECT_BASE_DIR', dirname(__DIR__));
            define('APP_LOGO_DIR', 'image/logo/');

            $directory = PROJECT_BASE_DIR. '/'. APP_LOGO_DIR. $appModuleID. '/';
            $fileDestination = $directory. $fileNew;
            $filePath = './components/app-module/image/logo/'. $appModuleID . '/' . $fileNew;

            $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));

            if(!$directoryChecker){
                $response = [
                    'success' => false,
                    'title' => 'Update App Logo Error',
                    'message' => $directoryChecker,
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $appDetails = $this->appModuleModel->getAppModule($appModuleID);
            $appLogoPath = !empty($appDetails['app_logo']) ? str_replace('./components/', '../../', $appDetails['app_logo']) : null;

            if(file_exists($appLogoPath)){
                if (!unlink($appLogoPath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Update App Logo Error',
                        'message' => 'The app logo cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            if(!move_uploaded_file($appLogoTempName, $fileDestination)){
                $response = [
                    'success' => false,
                    'title' => 'Update App Logo Error',
                    'message' => 'The app logo cannot be uploaded due to an error.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;           
            }

            $this->appModel->updateAppLogo($appModuleID, $filePath, $userID);

            $response = [
                'success' => true,
                'title' => 'Update App Logo Success',
                'message' => 'The app logo has been updated successfully.',
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
    # Function: deleteAppModule
    # Description: 
    # Delete the app module if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id'])) {
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');
        
            $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
            $total = $checkAppModuleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete App Module Error',
                    'message' => 'The app module does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $appDetails = $this->appModuleModel->getAppModule($appModuleID);
            $appLogoPath = !empty($appDetails['app_logo']) ? str_replace('./components/', '../../', $appDetails['app_logo']) : null;

            if(file_exists($appLogoPath)){
                if (!unlink($appLogoPath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete App Logo Error',
                        'message' => 'The app logo cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->appModuleModel->deleteAppModule($appModuleID);
                
            $response = [
                'success' => true,
                'title' => 'Delete App Module Success',
                'message' => 'The app module has been deleted successfully.',
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
    # Function: deleteMultipleAppModule
    # Description: 
    # Delete the selected app modules if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id'])) {
            $appModuleIDs = $_POST['app_module_id'];
    
            foreach($appModuleIDs as $appModuleID){
                $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
                $total = $checkAppModuleExist['total'] ?? 0;

                if($total > 0){
                    $appDetails = $this->appModuleModel->getAppModule($appModuleID);
                    $appLogoPath = !empty($appDetails['app_logo']) ? str_replace('./components/', '../../', $appDetails['app_logo']) : null;

                    if(file_exists($appLogoPath)){
                        if (!unlink($appLogoPath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Delete App Logo Error',
                                'message' => 'The app logo cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }
                    
                    $this->appModuleModel->deleteAppModule($appModuleID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple App Module Success',
                'message' => 'The selected app modules have been deleted successfully.',
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
    # Function: getAppModuleDetails
    # Description: 
    # Handles the retrieval of app module details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getAppModuleDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id'])) {
            $userID = $_SESSION['user_account_id'];
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');

            $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
            $total = $checkAppModuleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get App Module Details Error',
                    'message' => 'The app module does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $appModuleDetails = $this->appModuleModel->getAppModule($appModuleID);
            $appLogo = $this->systemModel->checkImage($appModuleDetails['app_logo'] ?? null, 'app module logo');

            $response = [
                'success' => true,
                'appModuleName' => $appModuleDetails['app_module_name'] ?? null,
                'appModuleDescription' => $appModuleDetails['app_module_description'] ?? null,
                'redirectLink' => $appModuleDetails['redirect_link'] ?? null,
                'orderSequence' => $appModuleDetails['order_sequence'] ?? null,
                'appLogo' => $appLogo
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
require_once '../../app-module/model/app-module-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new AppModuleController(new AppModuleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>