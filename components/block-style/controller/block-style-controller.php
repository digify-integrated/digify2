<?php
session_start();

# -------------------------------------------------------------
#
# Function: BlockStyleController
# Description: 
# The BlockStyleController class handles block style related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class BlockStyleController {
    private $blockStyleModel;
    private $blockTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided BlockStyleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for block style related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param BlockStyleModel $blockStyleModel     The BlockStyleModel instance for block style related operations.
    # - @param BlockTypeModel $blockTypeModel     The BlockTypeModel instance for block type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BlockStyleModel $blockStyleModel, BlockTypeModel $blockTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->blockStyleModel = $blockStyleModel;
        $this->blockTypeModel = $blockTypeModel;
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
                case 'add block style':
                    $this->addBlockStyle();
                    break;
                case 'update block style':
                    $this->updateBlockStyle();
                    break;
                case 'update block container':
                    $this->updateBlockContainer();
                    break;
                case 'update block item':
                    $this->updateBlockItem();
                    break;
                case 'get block style details':
                    $this->getBlockStyleDetails();
                    break;
                case 'get block container details':
                    $this->getBlockContainerDetails();
                    break;
                case 'get block item details':
                    $this->getBlockItemDetails();
                    break;
                case 'delete block style':
                    $this->deleteBlockStyle();
                    break;
                case 'delete multiple block style':
                    $this->deleteMultipleBlockStyle();
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
    # Function: addBlockStyle
    # Description: 
    # Inserts a block style.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addBlockStyle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['block_style_name']) && !empty($_POST['block_style_name']) && isset($_POST['description']) && isset($_POST['block_type_id']) && !empty($_POST['block_type_id']) ) {
            $userID = $_SESSION['user_account_id'];
            $blockStyleName = $_POST['block_style_name'];
            $description = $_POST['description'];
            $blockTypeID = $_POST['block_type_id'];

            $blockTypeDetails = $this->blockTypeModel->getBlockType($blockTypeID);
            $blockTypeName = $blockTypeDetails['block_type_name'] ?? null;
        
            $blockStyleID = $this->blockStyleModel->insertBlockStyle($blockStyleName, $description, $blockTypeID, $blockTypeName, $userID);
    
            $response = [
                'success' => true,
                'blockStyleID' => $this->securityModel->encryptData($blockStyleID),
                'title' => 'Insert Block Style Success',
                'message' => 'The block style has been inserted successfully.',
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
    # Function: updateBlockStyle
    # Description: 
    # Updates the block style if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBlockStyle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['block_style_name']) && !empty($_POST['block_style_name']) && isset($_POST['description']) && isset($_POST['block_type_id']) && !empty($_POST['block_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $blockStyleName = $_POST['block_style_name'];
            $description = $_POST['description'];
            $blockTypeID = $_POST['block_type_id'];
        
            $checkBlockStyleExist = $this->blockStyleModel->checkBlockStyleExist($blockStyleID);
            $total = $checkBlockStyleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Block Style Error',
                    'message' => 'The block style does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockTypeDetails = $this->blockTypeModel->getBlockType($blockTypeID);
            $blockTypeName = $blockTypeDetails['block_type_name'] ?? null;

            $this->blockStyleModel->updateBlockStyle($blockStyleID, $blockStyleName, $description, $blockTypeID, $blockTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Block Style Success',
                'message' => 'The block style has been updated successfully.',
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
    # Function: updateBlockContainer
    # Description: 
    # Updates the block container if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBlockContainer() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['block_container']) && !empty($_POST['block_container'])) {
            $userID = $_SESSION['user_account_id'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $blockContainer = $_POST['block_container'];
        
            $checkBlockContainerExist = $this->blockStyleModel->checkBlockContainerExist($blockStyleID);
            $total = $checkBlockContainerExist['total'] ?? 0;

            if($total > 0){
                $this->blockStyleModel->updateBlockContainer($blockStyleID, $blockContainer, $userID);
            }
            else{
                $this->blockStyleModel->insertBlockContainer($blockStyleID, $blockContainer, $userID);
            }

            $response = [
                'success' => true,
                'title' => 'Update Block Container Success',
                'message' => 'The block container has been updated successfully.',
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
    # Function: updateBlockItem
    # Description: 
    # Updates the block item if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBlockItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['block_item']) && !empty($_POST['block_item'])) {
            $userID = $_SESSION['user_account_id'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $blockItem = $_POST['block_item'];
        
            $checkBlockItemExist = $this->blockStyleModel->checkBlockItemExist($blockStyleID);
            $total = $checkBlockItemExist['total'] ?? 0;

            if($total > 0){
                $this->blockStyleModel->updateBlockItem($blockStyleID, $blockItem, $userID);
            }
            else{
                $this->blockStyleModel->insertBlockitem($blockStyleID, $blockItem, $userID);
            }

            $response = [
                'success' => true,
                'title' => 'Update Block Item Success',
                'message' => 'The block item has been updated successfully.',
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
    # Function: deleteBlockStyle
    # Description: 
    # Delete the block style if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteBlockStyle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id'])) {
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBlockStyleExist = $this->blockStyleModel->checkBlockStyleExist($blockStyleID);
            $total = $checkBlockStyleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Block Style Error',
                    'message' => 'The block style does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->blockStyleModel->deleteBlockStyle($blockStyleID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Block Style Success',
                'message' => 'The block style has been deleted successfully.',
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
    # Function: deleteMultipleBlockStyle
    # Description: 
    # Delete the selected block style if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleBlockStyle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id'])) {
            $blockStyleIDs = $_POST['block_style_id'];
    
            foreach($blockStyleIDs as $blockStyleID){
                $checkBlockStyleExist = $this->blockStyleModel->checkBlockStyleExist($blockStyleID);
                $total = $checkBlockStyleExist['total'] ?? 0;

                if($total > 0){                    
                    $this->blockStyleModel->deleteBlockStyle($blockStyleID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Block Styles Success',
                'message' => 'The selected block styles have been deleted successfully.',
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
    # Function: getBlockStyleDetails
    # Description: 
    # Handles the retrieval of block style details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBlockStyleDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id'])) {
            $userID = $_SESSION['user_account_id'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');

            $checkBlockStyleExist = $this->blockStyleModel->checkBlockStyleExist($blockStyleID);
            $total = $checkBlockStyleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Block Style Details Error',
                    'message' => 'The block style does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);

            $response = [
                'success' => true,
                'blockStyleName' => $blockStyleDetails['block_style_name'] ?? null,
                'description' => $blockStyleDetails['description'] ?? null,
                'blockTypeID' => $blockStyleDetails['block_type_id'] ?? null,
                'blockTypeName' => $blockStyleDetails['block_type_name'] ?? null
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
    # Function: getBlockContainerDetails
    # Description: 
    # Handles the retrieval of block container details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBlockContainerDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id'])) {
            $userID = $_SESSION['user_account_id'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');

            $checkBlockStyleExist = $this->blockStyleModel->checkBlockStyleExist($blockStyleID);
            $total = $checkBlockStyleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Block Container Details Error',
                    'message' => 'The block container does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $blockContainerDetails = $this->blockStyleModel->getBlockContainer($blockStyleID);

            $response = [
                'success' => true,
                'blockContainer' => $blockContainerDetails['block_container'] ?? null
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
    # Function: getBlockItemDetails
    # Description: 
    # Handles the retrieval of block container details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBlockItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['block_style_id']) && !empty($_POST['block_style_id'])) {
            $userID = $_SESSION['user_account_id'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');

            $checkBlockStyleExist = $this->blockStyleModel->checkBlockStyleExist($blockStyleID);
            $total = $checkBlockStyleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Block Item Details Error',
                    'message' => 'The block item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $blockItemDetails = $this->blockStyleModel->getBlockItem($blockStyleID);

            $response = [
                'success' => true,
                'blockItem' => $blockItemDetails['block_item'] ?? null
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
require_once '../../block-style/model/block-style-model.php';
require_once '../../block-type/model/block-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new BlockStyleController(new BlockStyleModel(new DatabaseModel), new BlockTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>