<?php
session_start();

# -------------------------------------------------------------
#
# Function: CallToActionController
# Description: 
# The CallToActionController class handles call to action related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class CallToActionController {
    private $callToActionModel;
    private $blockStyleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided callToActionModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for call to action related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param CallToActionModel $callToActionModel     The callToActionModel instance for call to action related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(CallToActionModel $callToActionModel, BlockStyleModel $blockStyleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->callToActionModel = $callToActionModel;
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
                case 'add call to action':
                    $this->addCallToAction();
                    break;
                case 'update call to action':
                    $this->updateCallToAction();
                    break;
                case 'get call to action details':
                    $this->getCallToActionDetails();
                    break;
                case 'publish call to action':
                    $this->publishCallToAction();
                    break;
                case 'unpublish call to action':
                    $this->unpublishCallToAction();
                    break;
                case 'delete call to action':
                    $this->deleteCallToAction();
                    break;
                case 'delete multiple call to action':
                    $this->deleteMultipleCallToAction();
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
    # Function: addCallToAction
    # Description: 
    # Inserts a call to action.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCallToAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['call_to_action_name']) && !empty($_POST['call_to_action_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description']) && isset($_POST['call_to_action_header']) && !empty($_POST['call_to_action_header']) && isset($_POST['call_to_action_body']) && !empty($_POST['call_to_action_body'])) {
            $userID = $_SESSION['user_account_id'];
            $callToActionName = $_POST['call_to_action_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
            $callToActionHeader = $_POST['call_to_action_header'];
            $callToActionBody = $_POST['call_to_action_body'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $callToAction = $this->callToActionModel->insertCallToAction($callToActionName, $description, $blockStyleID, $blockStyleName, $callToActionHeader, $callToActionBody, $userID);
    
            $response = [
                'success' => true,
                'callToActionID' => $this->securityModel->encryptData($callToAction),
                'title' => 'Insert Call To Action Success',
                'message' => 'The call to action has been inserted successfully.',
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
    # Function: updateCallToAction
    # Description: 
    # Updates the call to action if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCallToAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['call_to_action_name']) && !empty($_POST['call_to_action_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description']) && isset($_POST['call_to_action_header']) && !empty($_POST['call_to_action_header']) && isset($_POST['call_to_action_body']) && !empty($_POST['call_to_action_body'])) {
            $userID = $_SESSION['user_account_id'];
            $callToActionID = htmlspecialchars($_POST['call_to_action_id'], ENT_QUOTES, 'UTF-8');
            $callToActionName = $_POST['call_to_action_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
            $callToActionHeader = $_POST['call_to_action_header'];
            $callToActionBody = $_POST['call_to_action_body'];
        
            $checkCallToActionExist = $this->callToActionModel->checkCallToActionExist($callToActionID);
            $total = $checkCallToActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Call To Action Error',
                    'message' => 'The call to action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->callToActionModel->updateCallToAction($callToActionID, $callToActionName, $description, $blockStyleID, $blockStyleName, $callToActionHeader, $callToActionBody, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Call To Action Success',
                'message' => 'The call to action has been updated successfully.',
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
    # Function: publishCallToAction
    # Description: 
    # Publish the call to action if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishCallToAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['call_to_action_id']) && !empty($_POST['call_to_action_id'])) {
            $userID = $_SESSION['user_account_id'];
            $callToAction = htmlspecialchars($_POST['call_to_action_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCallToActionExist = $this->callToActionModel->checkCallToActionExist($callToAction);
            $total = $checkCallToActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Call To Action Error',
                    'message' => 'The call to action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->callToActionModel->updateCallToActionPublishStatus($callToAction, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Call To Action Success',
                'message' => 'The call to action has been published successfully.',
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
    # Function: unpublishCallToAction
    # Description: 
    # Publish the call to action if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishCallToAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['call_to_action_id']) && !empty($_POST['call_to_action_id'])) {
            $userID = $_SESSION['user_account_id'];
            $callToAction = htmlspecialchars($_POST['call_to_action_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCallToActionExist = $this->callToActionModel->checkCallToActionExist($callToAction);
            $total = $checkCallToActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Call To Action Error',
                    'message' => 'The call to action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->callToActionModel->updateCallToActionPublishStatus($callToAction, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Call To Action Success',
                'message' => 'The call to action has been unpublished successfully.',
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
    # Function: deleteCallToAction
    # Description: 
    # Delete the call to action if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCallToAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['call_to_action_id']) && !empty($_POST['call_to_action_id'])) {
            $callToAction = htmlspecialchars($_POST['call_to_action_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCallToActionExist = $this->callToActionModel->checkCallToActionExist($callToAction);
            $total = $checkCallToActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Call To Action Error',
                    'message' => 'The call to action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->callToActionModel->deleteCallToAction($callToAction);
                
            $response = [
                'success' => true,
                'title' => 'Delete Call To Action Success',
                'message' => 'The call to action has been deleted successfully.',
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
    # Function: deleteMultipleCallToAction
    # Description: 
    # Delete the selected call to actions if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleCallToAction() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['call_to_action_id']) && !empty($_POST['call_to_action_id'])) {
            $callToActions = $_POST['call_to_action_id'];
    
            foreach($callToActions as $callToAction){
                $checkCallToActionExist = $this->callToActionModel->checkCallToActionExist($callToAction);
                $total = $checkCallToActionExist['total'] ?? 0;

                if($total > 0){
                    $this->callToActionModel->deleteCallToAction($callToAction);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Call To Actions Success',
                'message' => 'The selected call to actions have been deleted successfully.',
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
    # Function: getCallToActionDetails
    # Description: 
    # Handles the retrieval of call to action details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCallToActionDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['call_to_action_id']) && !empty($_POST['call_to_action_id'])) {
            $userID = $_SESSION['user_account_id'];
            $callToAction = htmlspecialchars($_POST['call_to_action_id'], ENT_QUOTES, 'UTF-8');

            $checkCallToActionExist = $this->callToActionModel->checkCallToActionExist($callToAction);
            $total = $checkCallToActionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Call To Action Details Error',
                    'message' => 'The call to action does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $callToActionDetails = $this->callToActionModel->getCallToAction($callToAction);

            $response = [
                'success' => true,
                'callToActionName' => $callToActionDetails['call_to_action_name'] ?? null,
                'description' => $callToActionDetails['description'] ?? null,
                'blockStyleID' => $callToActionDetails['block_style_id'] ?? '',
                'blockStyleName' => $callToActionDetails['block_style_name'] ?? '',
                'callToActionHeader' => $callToActionDetails['call_to_action_header'] ?? '',
                'callToActionBody' => $callToActionDetails['call_to_action_body'] ?? ''
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
require_once '../../call-to-action/model/call-to-action-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new CallToActionController(new CallToActionModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>