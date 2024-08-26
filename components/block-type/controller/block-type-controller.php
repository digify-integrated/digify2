<?php
session_start();

# -------------------------------------------------------------
#
# Function: BlockTypeController
# Description: 
# The BlockTypeController class handles block type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class BlockTypeController {
    private $blockTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided BlockTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for block type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param BlockTypeModel $blockTypeModel     The BlockTypeModel instance for block type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BlockTypeModel $blockTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
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
                case 'add block type':
                    $this->addBlockType();
                    break;
                case 'update block type':
                    $this->updateBlockType();
                    break;
                case 'get block type details':
                    $this->getBlockTypeDetails();
                    break;
                case 'delete block type':
                    $this->deleteBlockType();
                    break;
                case 'delete multiple block type':
                    $this->deleteMultipleBlockType();
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
    # Function: addBlockType
    # Description: 
    # Inserts a block type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addBlockType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['block_type_name']) && !empty($_POST['block_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $blockTypeName = $_POST['block_type_name'];
        
            $blockTypeID = $this->blockTypeModel->insertBlockType($blockTypeName, $userID);
    
            $response = [
                'success' => true,
                'blockTypeID' => $this->securityModel->encryptData($blockTypeID),
                'title' => 'Insert Block Type Success',
                'message' => 'The block type has been inserted successfully.',
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
    # Function: updateBlockType
    # Description: 
    # Updates the block type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateBlockType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['block_type_id']) && !empty($_POST['block_type_id']) && isset($_POST['block_type_name']) && !empty($_POST['block_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $blockTypeID = htmlspecialchars($_POST['block_type_id'], ENT_QUOTES, 'UTF-8');
            $blockTypeName = $_POST['block_type_name'];
        
            $checkBlockTypeExist = $this->blockTypeModel->checkBlockTypeExist($blockTypeID);
            $total = $checkBlockTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Block Type Error',
                    'message' => 'The block type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->blockTypeModel->updateBlockType($blockTypeID, $blockTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Block Type Success',
                'message' => 'The block type has been updated successfully.',
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
    # Function: deleteBlockType
    # Description: 
    # Delete the block type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteBlockType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['block_type_id']) && !empty($_POST['block_type_id'])) {
            $blockTypeID = htmlspecialchars($_POST['block_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkBlockTypeExist = $this->blockTypeModel->checkBlockTypeExist($blockTypeID);
            $total = $checkBlockTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Block Type Error',
                    'message' => 'The block type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->blockTypeModel->deleteBlockType($blockTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Block Type Success',
                'message' => 'The block type has been deleted successfully.',
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
    # Function: deleteMultipleBlockType
    # Description: 
    # Delete the selected block type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleBlockType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['block_type_id']) && !empty($_POST['block_type_id'])) {
            $blockTypeIDs = $_POST['block_type_id'];
    
            foreach($blockTypeIDs as $blockTypeID){
                $checkBlockTypeExist = $this->blockTypeModel->checkBlockTypeExist($blockTypeID);
                $total = $checkBlockTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->blockTypeModel->deleteBlockType($blockTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Block Type Success',
                'message' => 'The selected block type have been deleted successfully.',
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
    # Function: getBlockTypeDetails
    # Description: 
    # Handles the retrieval of block type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getBlockTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['block_type_id']) && !empty($_POST['block_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $blockTypeID = htmlspecialchars($_POST['block_type_id'], ENT_QUOTES, 'UTF-8');

            $checkBlockTypeExist = $this->blockTypeModel->checkBlockTypeExist($blockTypeID);
            $total = $checkBlockTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Block Type Details Error',
                    'message' => 'The block type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $blockTypeDetails = $this->blockTypeModel->getBlockType($blockTypeID);

            $response = [
                'success' => true,
                'blockTypeName' => $blockTypeDetails['block_type_name'] ?? null,
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
require_once '../../block-type/model/block-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new BlockTypeController(new BlockTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>