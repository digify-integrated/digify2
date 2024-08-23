<?php
session_start();

# -------------------------------------------------------------
#
# Function: WebsiteController
# Description: 
# The WebsiteController class handles website related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class WebsiteController {
    private $websiteModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided WebsiteModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for website related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param WebsiteModel $websiteModel     The WebsiteModel instance for website related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(WebsiteModel $websiteModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->websiteModel = $websiteModel;
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
                case 'add website':
                    $this->addWebsite();
                    break;
                case 'update website':
                    $this->updateWebsite();
                    break;
                case 'get website details':
                    $this->getWebsiteDetails();
                    break;
                case 'delete website':
                    $this->deleteWebsite();
                    break;
                case 'delete multiple website':
                    $this->deleteMultipleWebsite();
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
    # Function: addWebsite
    # Description: 
    # Inserts a website.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addWebsite() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['website_name']) && !empty($_POST['website_name']) && isset($_POST['url']) && !empty($_POST['url']) && isset($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $websiteName = $_POST['website_name'];
            $url = $_POST['url'];
            $description = $_POST['description'];
        
            $websiteID = $this->websiteModel->insertWebsite($websiteName, $description, $url, $userID);
    
            $response = [
                'success' => true,
                'websiteID' => $this->securityModel->encryptData($websiteID),
                'title' => 'Insert Website Success',
                'message' => 'The website has been inserted successfully.',
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
    # Function: updateWebsite
    # Description: 
    # Updates the website if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateWebsite() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['website_id']) && !empty($_POST['website_id']) && isset($_POST['website_name']) && !empty($_POST['website_name']) && isset($_POST['url']) && !empty($_POST['url']) && isset($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $websiteID = htmlspecialchars($_POST['website_id'], ENT_QUOTES, 'UTF-8');
            $websiteName = $_POST['website_name'];
            $url = $_POST['url'];
            $description = $_POST['description'];
        
            $checkWebsiteExist = $this->websiteModel->checkWebsiteExist($websiteID);
            $total = $checkWebsiteExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Website Error',
                    'message' => 'The website does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->websiteModel->updateWebsite($websiteID, $websiteName, $description, $url, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Website Success',
                'message' => 'The website has been updated successfully.',
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
    # Function: deleteWebsite
    # Description: 
    # Delete the website if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteWebsite() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['website_id']) && !empty($_POST['website_id'])) {
            $websiteID = htmlspecialchars($_POST['website_id'], ENT_QUOTES, 'UTF-8');
        
            $checkWebsiteExist = $this->websiteModel->checkWebsiteExist($websiteID);
            $total = $checkWebsiteExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Website Error',
                    'message' => 'The website does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->websiteModel->deleteWebsite($websiteID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Website Success',
                'message' => 'The website has been deleted successfully.',
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
    # Function: deleteMultipleWebsite
    # Description: 
    # Delete the selected website if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleWebsite() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['website_id']) && !empty($_POST['website_id'])) {
            $websiteIDs = $_POST['website_id'];
    
            foreach($websiteIDs as $websiteID){
                $checkWebsiteExist = $this->websiteModel->checkWebsiteExist($websiteID);
                $total = $checkWebsiteExist['total'] ?? 0;

                if($total > 0){                    
                    $this->websiteModel->deleteWebsite($websiteID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Websites Success',
                'message' => 'The selected websites have been deleted successfully.',
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
    # Function: getWebsiteDetails
    # Description: 
    # Handles the retrieval of website details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getWebsiteDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['website_id']) && !empty($_POST['website_id'])) {
            $userID = $_SESSION['user_account_id'];
            $websiteID = htmlspecialchars($_POST['website_id'], ENT_QUOTES, 'UTF-8');

            $checkWebsiteExist = $this->websiteModel->checkWebsiteExist($websiteID);
            $total = $checkWebsiteExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Website Details Error',
                    'message' => 'The website does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $websiteDetails = $this->websiteModel->getWebsite($websiteID);

            $response = [
                'success' => true,
                'websiteName' => $websiteDetails['website_name'] ?? null,
                'url' => $websiteDetails['url'] ?? null,
                'description' => $websiteDetails['description'] ?? null
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
require_once '../../website/model/website-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new WebsiteController(new WebsiteModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>