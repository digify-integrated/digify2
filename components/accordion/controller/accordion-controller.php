<?php
session_start();

# -------------------------------------------------------------
#
# Function: AccordionController
# Description: 
# The AccordionController class handles accordion related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class AccordionController {
    private $accordionModel;
    private $blockStyleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided accordionModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for accordion related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param AccordionModel $accordionModel     The accordionModel instance for accordion related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(AccordionModel $accordionModel, BlockStyleModel $blockStyleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->accordionModel = $accordionModel;
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
                case 'add accordion':
                    $this->addAccordion();
                    break;
                case 'update accordion':
                    $this->updateAccordion();
                    break;
                case 'save accordion item':
                    $this->saveAccordionItem();
                    break;
                case 'get accordion details':
                    $this->getAccordionDetails();
                    break;
                case 'get accordion item details':
                    $this->getAccordionItemDetails();
                    break;
                case 'publish accordion':
                    $this->publishAccordion();
                    break;
                case 'unpublish accordion':
                    $this->unpublishAccordion();
                    break;
                case 'delete accordion':
                    $this->deleteAccordion();
                    break;
                case 'delete accordion item':
                    $this->deleteAccordionItem();
                    break;
                case 'delete multiple accordion':
                    $this->deleteMultipleAccordion();
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
    # Function: addAccordion
    # Description: 
    # Inserts a accordion.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addAccordion() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['accordion_name']) && !empty($_POST['accordion_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $accordionName = $_POST['accordion_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $accordionID = $this->accordionModel->insertAccordion($accordionName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'accordionID' => $this->securityModel->encryptData($accordionID),
                'title' => 'Insert Accordion Success',
                'message' => 'The accordion has been inserted successfully.',
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
    # Function: updateAccordion
    # Description: 
    # Updates the accordion if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateAccordion() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['accordion_name']) && !empty($_POST['accordion_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $accordionID = htmlspecialchars($_POST['accordion_id'], ENT_QUOTES, 'UTF-8');
            $accordionName = $_POST['accordion_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkAccordionExist = $this->accordionModel->checkAccordionExist($accordionID);
            $total = $checkAccordionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Accordion Error',
                    'message' => 'The accordion does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->accordionModel->updateAccordion($accordionID, $accordionName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Accordion Success',
                'message' => 'The accordion has been updated successfully.',
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
    #   Save methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: saveAccordionItem
    # Description: 
    # Updates the accordion if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveAccordionItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['accordion_item_id']) && isset($_POST['accordion_id']) && !empty($_POST['accordion_id']) && isset($_POST['accordion_header']) && !empty($_POST['accordion_header']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence']) && isset($_POST['accordion_body']) && !empty($_POST['accordion_body'])) {
            $userID = $_SESSION['user_account_id'];
            $accordionItemID = htmlspecialchars($_POST['accordion_item_id'], ENT_QUOTES, 'UTF-8');
            $accordionID = htmlspecialchars($_POST['accordion_id'], ENT_QUOTES, 'UTF-8');
            $accordionHeader = $_POST['accordion_header'];
            $orderSequence = $_POST['order_sequence'];
            $accordionBody = $_POST['accordion_body'];
        
            $checkAccordionExist = $this->accordionModel->checkAccordionExist($accordionID);
            $total = $checkAccordionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Accordion Item Error',
                    'message' => 'The accordion does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkAccordionItemExist = $this->accordionModel->checkAccordionItemExist($accordionItemID);
            $total = $checkAccordionItemExist['total'] ?? 0;

            if($total > 0){
                $this->accordionModel->updateAccordionItem($accordionItemID, $accordionID, $accordionHeader, $accordionBody, $orderSequence, $userID);

                $response = [
                    'success' => true,
                    'title' => 'Update Accordion Item Success',
                    'message' => 'The accordion item has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->accordionModel->insertAccordionItem($accordionID, $accordionHeader, $accordionBody, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Accordion Item Success',
                    'message' => 'The accordion item has been inserted successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
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
    # Function: publishAccordion
    # Description: 
    # Publish the accordion if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishAccordion() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['accordion_id']) && !empty($_POST['accordion_id'])) {
            $userID = $_SESSION['user_account_id'];
            $accordionID = htmlspecialchars($_POST['accordion_id'], ENT_QUOTES, 'UTF-8');
        
            $checkAccordionExist = $this->accordionModel->checkAccordionExist($accordionID);
            $total = $checkAccordionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Accordion Error',
                    'message' => 'The accordion does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->accordionModel->updateAccordionPublishStatus($accordionID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Accordion Success',
                'message' => 'The accordion has been published successfully.',
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
    # Function: unpublishAccordion
    # Description: 
    # Publish the accordion if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishAccordion() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['accordion_id']) && !empty($_POST['accordion_id'])) {
            $userID = $_SESSION['user_account_id'];
            $accordionID = htmlspecialchars($_POST['accordion_id'], ENT_QUOTES, 'UTF-8');
        
            $checkAccordionExist = $this->accordionModel->checkAccordionExist($accordionID);
            $total = $checkAccordionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Accordion Error',
                    'message' => 'The accordion does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->accordionModel->updateAccordionPublishStatus($accordionID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Accordion Success',
                'message' => 'The accordion has been unpublished successfully.',
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
    # Function: deleteAccordion
    # Description: 
    # Delete the accordion if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteAccordion() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['accordion_id']) && !empty($_POST['accordion_id'])) {
            $accordionID = htmlspecialchars($_POST['accordion_id'], ENT_QUOTES, 'UTF-8');
        
            $checkAccordionExist = $this->accordionModel->checkAccordionExist($accordionID);
            $total = $checkAccordionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Accordion Error',
                    'message' => 'The accordion does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->accordionModel->deleteAccordion($accordionID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Accordion Success',
                'message' => 'The accordion has been deleted successfully.',
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
    # Function: deleteAccordionItem
    # Description: 
    # Delete the accordion if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteAccordionItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['accordion_item_id']) && !empty($_POST['accordion_item_id'])) {
            $accordionItemID = htmlspecialchars($_POST['accordion_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkAccordionItemExist = $this->accordionModel->checkAccordionItemExist($accordionItemID);
            $total = $checkAccordionItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Accordion Item Error',
                    'message' => 'The accordion item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->accordionModel->deleteAccordionItem($accordionItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Accordion Item Success',
                'message' => 'The accordion item has been deleted successfully.',
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
    # Function: deleteMultipleAccordion
    # Description: 
    # Delete the selected accordions if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleAccordion() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['accordion_id']) && !empty($_POST['accordion_id'])) {
            $accordionIDs = $_POST['accordion_id'];
    
            foreach($accordionIDs as $accordionID){
                $checkAccordionExist = $this->accordionModel->checkAccordionExist($accordionID);
                $total = $checkAccordionExist['total'] ?? 0;

                if($total > 0){
                    $this->accordionModel->deleteAccordion($accordionID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Accordions Success',
                'message' => 'The selected accordions have been deleted successfully.',
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
    # Function: getAccordionDetails
    # Description: 
    # Handles the retrieval of accordion details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getAccordionDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['accordion_id']) && !empty($_POST['accordion_id'])) {
            $userID = $_SESSION['user_account_id'];
            $accordionID = htmlspecialchars($_POST['accordion_id'], ENT_QUOTES, 'UTF-8');

            $checkAccordionExist = $this->accordionModel->checkAccordionExist($accordionID);
            $total = $checkAccordionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Accordion Details Error',
                    'message' => 'The accordion does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $accordionDetails = $this->accordionModel->getAccordion($accordionID);

            $response = [
                'success' => true,
                'accordionName' => $accordionDetails['accordion_name'] ?? null,
                'description' => $accordionDetails['description'] ?? null,
                'blockStyleID' => $accordionDetails['block_style_id'] ?? '',
                'blockStyleName' => $accordionDetails['block_style_name'] ?? ''
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
    # Function: getAccordionItemDetails
    # Description: 
    # Handles the retrieval of accordion item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getAccordionItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['accordion_item_id']) && !empty($_POST['accordion_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $accordionItemID = htmlspecialchars($_POST['accordion_item_id'], ENT_QUOTES, 'UTF-8');

            $checkAccordionItemExist = $this->accordionModel->checkAccordionItemExist($accordionItemID);
            $total = $checkAccordionItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Accordion Item Details Error',
                    'message' => 'The accordion item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $accordionItemDetails = $this->accordionModel->getAccordionItem($accordionItemID);

            $response = [
                'success' => true,
                'accordionHeader' => $accordionItemDetails['accordion_header'] ?? null,
                'accordionBody' => $accordionItemDetails['accordion_body'] ?? null,
                'orderSequence' => $accordionItemDetails['order_sequence'] ?? null
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
require_once '../../accordion/model/accordion-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new AccordionController(new AccordionModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>