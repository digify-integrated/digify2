<?php
session_start();

# -------------------------------------------------------------
#
# Function: ColumnsController
# Description: 
# The ColumnsController class handles columns related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ColumnsController {
    private $columnsModel;
    private $blockStyleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided columnsModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for columns related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ColumnsModel $columnsModel     The columnsModel instance for columns related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ColumnsModel $columnsModel, BlockStyleModel $blockStyleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->columnsModel = $columnsModel;
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
                case 'add columns':
                    $this->addColumns();
                    break;
                case 'update columns':
                    $this->updateColumns();
                    break;
                case 'get columns details':
                    $this->getColumnsDetails();
                    break;
                case 'publish columns':
                    $this->publishColumns();
                    break;
                case 'unpublish columns':
                    $this->unpublishColumns();
                    break;
                case 'delete columns':
                    $this->deleteColumns();
                    break;
                case 'delete multiple columns':
                    $this->deleteMultipleColumns();
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
    # Function: addColumns
    # Description: 
    # Inserts a columns.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addColumns() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['columns_name']) && !empty($_POST['columns_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $columnsName = $_POST['columns_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $columnsID = $this->columnsModel->insertColumns($columnsName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'columnsID' => $this->securityModel->encryptData($columnsID),
                'title' => 'Insert Columns Success',
                'message' => 'The columns has been inserted successfully.',
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
    # Function: updateColumns
    # Description: 
    # Updates the columns if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateColumns() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['columns_name']) && !empty($_POST['columns_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $columnsID = htmlspecialchars($_POST['columns_id'], ENT_QUOTES, 'UTF-8');
            $columnsName = $_POST['columns_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkColumnsExist = $this->columnsModel->checkColumnsExist($columnsID);
            $total = $checkColumnsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Columns Error',
                    'message' => 'The columns does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->columnsModel->updateColumns($columnsID, $columnsName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Columns Success',
                'message' => 'The columns has been updated successfully.',
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
    # Function: publishColumns
    # Description: 
    # Publish the columns if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishColumns() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['columns_id']) && !empty($_POST['columns_id'])) {
            $userID = $_SESSION['user_account_id'];
            $columnsID = htmlspecialchars($_POST['columns_id'], ENT_QUOTES, 'UTF-8');
        
            $checkColumnsExist = $this->columnsModel->checkColumnsExist($columnsID);
            $total = $checkColumnsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Columns Error',
                    'message' => 'The columns does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->columnsModel->updateColumnsPublishStatus($columnsID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Columns Success',
                'message' => 'The columns has been published successfully.',
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
    # Function: unpublishColumns
    # Description: 
    # Publish the columns if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishColumns() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['columns_id']) && !empty($_POST['columns_id'])) {
            $userID = $_SESSION['user_account_id'];
            $columnsID = htmlspecialchars($_POST['columns_id'], ENT_QUOTES, 'UTF-8');
        
            $checkColumnsExist = $this->columnsModel->checkColumnsExist($columnsID);
            $total = $checkColumnsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Columns Error',
                    'message' => 'The columns does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->columnsModel->updateColumnsPublishStatus($columnsID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Columns Success',
                'message' => 'The columns has been unpublished successfully.',
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
    # Function: deleteColumns
    # Description: 
    # Delete the columns if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteColumns() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['columns_id']) && !empty($_POST['columns_id'])) {
            $columnsID = htmlspecialchars($_POST['columns_id'], ENT_QUOTES, 'UTF-8');
        
            $checkColumnsExist = $this->columnsModel->checkColumnsExist($columnsID);
            $total = $checkColumnsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Columns Error',
                    'message' => 'The columns does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->columnsModel->deleteColumns($columnsID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Columns Success',
                'message' => 'The columns has been deleted successfully.',
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
    # Function: deleteMultipleColumns
    # Description: 
    # Delete the selected columnss if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleColumns() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['columns_id']) && !empty($_POST['columns_id'])) {
            $columnsIDs = $_POST['columns_id'];
    
            foreach($columnsIDs as $columnsID){
                $checkColumnsExist = $this->columnsModel->checkColumnsExist($columnsID);
                $total = $checkColumnsExist['total'] ?? 0;

                if($total > 0){
                    $this->columnsModel->deleteColumns($columnsID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Columnss Success',
                'message' => 'The selected columnss have been deleted successfully.',
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
    # Function: getColumnsDetails
    # Description: 
    # Handles the retrieval of columns details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getColumnsDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['columns_id']) && !empty($_POST['columns_id'])) {
            $userID = $_SESSION['user_account_id'];
            $columnsID = htmlspecialchars($_POST['columns_id'], ENT_QUOTES, 'UTF-8');

            $checkColumnsExist = $this->columnsModel->checkColumnsExist($columnsID);
            $total = $checkColumnsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Columns Details Error',
                    'message' => 'The columns does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $columnsDetails = $this->columnsModel->getColumns($columnsID);

            $response = [
                'success' => true,
                'columnsName' => $columnsDetails['columns_name'] ?? null,
                'description' => $columnsDetails['description'] ?? null,
                'blockStyleID' => $columnsDetails['block_style_id'] ?? '',
                'blockStyleName' => $columnsDetails['block_style_name'] ?? ''
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
require_once '../../columns/model/columns-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ColumnsController(new ColumnsModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>