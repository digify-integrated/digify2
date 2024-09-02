<?php
session_start();

# -------------------------------------------------------------
#
# Function: SectionsController
# Description: 
# The SectionsController class handles sections related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class SectionsController {
    private $sectionsModel;
    private $blockStyleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided sectionsModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for sections related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param SectionsModel $sectionsModel     The sectionsModel instance for sections related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(SectionsModel $sectionsModel, BlockStyleModel $blockStyleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->sectionsModel = $sectionsModel;
        $this->blockStyleModel = $blockStyleModel;
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
                case 'add sections':
                    $this->addSections();
                    break;
                case 'update sections':
                    $this->updateSections();
                    break;
                case 'get sections details':
                    $this->getSectionsDetails();
                    break;
                case 'publish sections':
                    $this->publishSections();
                    break;
                case 'unpublish sections':
                    $this->unpublishSections();
                    break;
                case 'delete sections':
                    $this->deleteSections();
                    break;
                case 'delete multiple sections':
                    $this->deleteMultipleSections();
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
    # Function: addSections
    # Description: 
    # Inserts a sections.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addSections() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['sections_name']) && !empty($_POST['sections_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $sectionsName = $_POST['sections_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $sectionsID = $this->sectionsModel->insertSections($sectionsName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'sectionsID' => $this->securityModel->encryptData($sectionsID),
                'title' => 'Insert Sections Success',
                'message' => 'The sections has been inserted successfully.',
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
    # Function: updateSections
    # Description: 
    # Updates the sections if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateSections() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['sections_name']) && !empty($_POST['sections_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $sectionsID = htmlspecialchars($_POST['sections_id'], ENT_QUOTES, 'UTF-8');
            $sectionsName = $_POST['sections_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkSectionsExist = $this->sectionsModel->checkSectionsExist($sectionsID);
            $total = $checkSectionsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Sections Error',
                    'message' => 'The sections does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->sectionsModel->updateSections($sectionsID, $sectionsName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Sections Success',
                'message' => 'The sections has been updated successfully.',
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
    #   Publish methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: publishSections
    # Description: 
    # Publish the sections if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishSections() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['sections_id']) && !empty($_POST['sections_id'])) {
            $userID = $_SESSION['user_account_id'];
            $sectionsID = htmlspecialchars($_POST['sections_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSectionsExist = $this->sectionsModel->checkSectionsExist($sectionsID);
            $total = $checkSectionsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Sections Error',
                    'message' => 'The sections does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->sectionsModel->updateSectionsPublishStatus($sectionsID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Sections Success',
                'message' => 'The sections has been published successfully.',
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
    #   Publish methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: unpublishSections
    # Description: 
    # Publish the sections if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishSections() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['sections_id']) && !empty($_POST['sections_id'])) {
            $userID = $_SESSION['user_account_id'];
            $sectionsID = htmlspecialchars($_POST['sections_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSectionsExist = $this->sectionsModel->checkSectionsExist($sectionsID);
            $total = $checkSectionsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Sections Error',
                    'message' => 'The sections does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->sectionsModel->updateSectionsPublishStatus($sectionsID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Sections Success',
                'message' => 'The sections has been unpublished successfully.',
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
    # Function: deleteSections
    # Description: 
    # Delete the sections if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteSections() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['sections_id']) && !empty($_POST['sections_id'])) {
            $sectionsID = htmlspecialchars($_POST['sections_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSectionsExist = $this->sectionsModel->checkSectionsExist($sectionsID);
            $total = $checkSectionsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Sections Error',
                    'message' => 'The sections does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->sectionsModel->deleteSections($sectionsID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Sections Success',
                'message' => 'The sections has been deleted successfully.',
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
    # Function: deleteMultipleSections
    # Description: 
    # Delete the selected sectionss if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleSections() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['sections_id']) && !empty($_POST['sections_id'])) {
            $sectionsIDs = $_POST['sections_id'];
    
            foreach($sectionsIDs as $sectionsID){
                $checkSectionsExist = $this->sectionsModel->checkSectionsExist($sectionsID);
                $total = $checkSectionsExist['total'] ?? 0;

                if($total > 0){
                    $this->sectionsModel->deleteSections($sectionsID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Sectionss Success',
                'message' => 'The selected sectionss have been deleted successfully.',
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
    # Function: getSectionsDetails
    # Description: 
    # Handles the retrieval of sections details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getSectionsDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['sections_id']) && !empty($_POST['sections_id'])) {
            $userID = $_SESSION['user_account_id'];
            $sectionsID = htmlspecialchars($_POST['sections_id'], ENT_QUOTES, 'UTF-8');

            $checkSectionsExist = $this->sectionsModel->checkSectionsExist($sectionsID);
            $total = $checkSectionsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Sections Details Error',
                    'message' => 'The sections does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $sectionsDetails = $this->sectionsModel->getSections($sectionsID);

            $response = [
                'success' => true,
                'sectionsName' => $sectionsDetails['sections_name'] ?? null,
                'description' => $sectionsDetails['description'] ?? null,
                'blockStyleID' => $sectionsDetails['block_style_id'] ?? '',
                'blockStyleName' => $sectionsDetails['block_style_name'] ?? ''
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
require_once '../../sections/model/sections-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new SectionsController(new SectionsModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>