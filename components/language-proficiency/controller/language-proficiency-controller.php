<?php
session_start();

# -------------------------------------------------------------
#
# Function: LanguageProficiencyController
# Description: 
# The LanguageProficiencyController class handles language proficiency related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class LanguageProficiencyController {
    private $languageProficiencyModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided LanguageProficiencyModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for language proficiency related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param LanguageProficiencyModel $languageProficiencyModel     The LanguageProficiencyModel instance for language proficiency related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(LanguageProficiencyModel $languageProficiencyModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->languageProficiencyModel = $languageProficiencyModel;
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
                case 'add language proficiency':
                    $this->addLanguageProficiency();
                    break;
                case 'update language proficiency':
                    $this->updateLanguageProficiency();
                    break;
                case 'get language proficiency details':
                    $this->getLanguageProficiencyDetails();
                    break;
                case 'delete language proficiency':
                    $this->deleteLanguageProficiency();
                    break;
                case 'delete multiple language proficiency':
                    $this->deleteMultipleLanguageProficiency();
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
    # Function: addLanguageProficiency
    # Description: 
    # Inserts a language proficiency.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addLanguageProficiency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['language_proficiency_name']) && !empty($_POST['language_proficiency_name']) && isset($_POST['language_proficiency_description']) && !empty($_POST['language_proficiency_description'])) {
            $userID = $_SESSION['user_account_id'];
            $languageProficiencyName = $_POST['language_proficiency_name'];
            $languageProficiencyDescription = $_POST['language_proficiency_description'];
        
            $languageProficiencyID = $this->languageProficiencyModel->insertLanguageProficiency($languageProficiencyName, $languageProficiencyDescription, $userID);
    
            $response = [
                'success' => true,
                'languageProficiencyID' => $this->securityModel->encryptData($languageProficiencyID),
                'title' => 'Insert Language Proficiency Success',
                'message' => 'The language proficiency has been inserted successfully.',
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
    # Function: updateLanguageProficiency
    # Description: 
    # Updates the language proficiency if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateLanguageProficiency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['language_proficiency_id']) && !empty($_POST['language_proficiency_id']) && isset($_POST['language_proficiency_name']) && !empty($_POST['language_proficiency_name']) && isset($_POST['language_proficiency_description']) && !empty($_POST['language_proficiency_description'])) {
            $userID = $_SESSION['user_account_id'];
            $languageProficiencyID = htmlspecialchars($_POST['language_proficiency_id'], ENT_QUOTES, 'UTF-8');
            $languageProficiencyName = $_POST['language_proficiency_name'];
            $languageProficiencyDescription = $_POST['language_proficiency_description'];
        
            $checkLanguageProficiencyExist = $this->languageProficiencyModel->checkLanguageProficiencyExist($languageProficiencyID);
            $total = $checkLanguageProficiencyExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Language Proficiency Error',
                    'message' => 'The language proficiency does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->languageProficiencyModel->updateLanguageProficiency($languageProficiencyID, $languageProficiencyName, $languageProficiencyDescription, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Language Proficiency Success',
                'message' => 'The language proficiency has been updated successfully.',
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
    # Function: deleteLanguageProficiency
    # Description: 
    # Delete the language proficiency if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteLanguageProficiency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['language_proficiency_id']) && !empty($_POST['language_proficiency_id'])) {
            $languageProficiencyID = htmlspecialchars($_POST['language_proficiency_id'], ENT_QUOTES, 'UTF-8');
        
            $checkLanguageProficiencyExist = $this->languageProficiencyModel->checkLanguageProficiencyExist($languageProficiencyID);
            $total = $checkLanguageProficiencyExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Language Proficiency Error',
                    'message' => 'The language proficiency does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->languageProficiencyModel->deleteLanguageProficiency($languageProficiencyID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Language Proficiency Success',
                'message' => 'The language proficiency has been deleted successfully.',
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
    # Function: deleteMultipleLanguageProficiency
    # Description: 
    # Delete the selected language proficiency if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleLanguageProficiency() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['language_proficiency_id']) && !empty($_POST['language_proficiency_id'])) {
            $languageProficiencyIDs = $_POST['language_proficiency_id'];
    
            foreach($languageProficiencyIDs as $languageProficiencyID){
                $checkLanguageProficiencyExist = $this->languageProficiencyModel->checkLanguageProficiencyExist($languageProficiencyID);
                $total = $checkLanguageProficiencyExist['total'] ?? 0;

                if($total > 0){                    
                    $this->languageProficiencyModel->deleteLanguageProficiency($languageProficiencyID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Language Proficiency Success',
                'message' => 'The selected language proficiency have been deleted successfully.',
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
    # Function: getLanguageProficiencyDetails
    # Description: 
    # Handles the retrieval of language proficiency details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getLanguageProficiencyDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['language_proficiency_id']) && !empty($_POST['language_proficiency_id'])) {
            $userID = $_SESSION['user_account_id'];
            $languageProficiencyID = htmlspecialchars($_POST['language_proficiency_id'], ENT_QUOTES, 'UTF-8');

            $checkLanguageProficiencyExist = $this->languageProficiencyModel->checkLanguageProficiencyExist($languageProficiencyID);
            $total = $checkLanguageProficiencyExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Language Proficiency Details Error',
                    'message' => 'The language proficiency does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $languageProficiencyDetails = $this->languageProficiencyModel->getLanguageProficiency($languageProficiencyID);

            $response = [
                'success' => true,
                'languageProficiencyName' => $languageProficiencyDetails['language_proficiency_name'] ?? null,
                'languageProficiencyDescription' => $languageProficiencyDetails['language_proficiency_description'] ?? null,
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
require_once '../../language-proficiency/model/language-proficiency-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new LanguageProficiencyController(new LanguageProficiencyModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>