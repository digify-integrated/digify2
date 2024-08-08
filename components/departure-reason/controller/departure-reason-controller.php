<?php
session_start();

# -------------------------------------------------------------
#
# Function: DepartureReasonController
# Description: 
# The DepartureReasonController class handles departure reason related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class DepartureReasonController {
    private $departureReasonModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided DepartureReasonModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for departure reason related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param DepartureReasonModel $departureReasonModel     The DepartureReasonModel instance for departure reason related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(DepartureReasonModel $departureReasonModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->departureReasonModel = $departureReasonModel;
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
                case 'add departure reason':
                    $this->addDepartureReason();
                    break;
                case 'update departure reason':
                    $this->updateDepartureReason();
                    break;
                case 'get departure reason details':
                    $this->getDepartureReasonDetails();
                    break;
                case 'delete departure reason':
                    $this->deleteDepartureReason();
                    break;
                case 'delete multiple departure reason':
                    $this->deleteMultipleDepartureReason();
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
    # Function: addDepartureReason
    # Description: 
    # Inserts a departure reason.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addDepartureReason() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['departure_reason_name']) && !empty($_POST['departure_reason_name'])) {
            $userID = $_SESSION['user_account_id'];
            $departureReasonName = $_POST['departure_reason_name'];
        
            $departureReasonID = $this->departureReasonModel->insertDepartureReason($departureReasonName, $userID);
    
            $response = [
                'success' => true,
                'departureReasonID' => $this->securityModel->encryptData($departureReasonID),
                'title' => 'Insert Departure Reason Success',
                'message' => 'The departure reason has been inserted successfully.',
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
    # Function: updateDepartureReason
    # Description: 
    # Updates the departure reason if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateDepartureReason() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['departure_reason_id']) && !empty($_POST['departure_reason_id']) && isset($_POST['departure_reason_name']) && !empty($_POST['departure_reason_name'])) {
            $userID = $_SESSION['user_account_id'];
            $departureReasonID = htmlspecialchars($_POST['departure_reason_id'], ENT_QUOTES, 'UTF-8');
            $departureReasonName = $_POST['departure_reason_name'];
        
            $checkDepartureReasonExist = $this->departureReasonModel->checkDepartureReasonExist($departureReasonID);
            $total = $checkDepartureReasonExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Departure Reason Error',
                    'message' => 'The departure reason does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->departureReasonModel->updateDepartureReason($departureReasonID, $departureReasonName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Departure Reason Success',
                'message' => 'The departure reason has been updated successfully.',
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
    # Function: deleteDepartureReason
    # Description: 
    # Delete the departure reason if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteDepartureReason() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['departure_reason_id']) && !empty($_POST['departure_reason_id'])) {
            $departureReasonID = htmlspecialchars($_POST['departure_reason_id'], ENT_QUOTES, 'UTF-8');
        
            $checkDepartureReasonExist = $this->departureReasonModel->checkDepartureReasonExist($departureReasonID);
            $total = $checkDepartureReasonExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Departure Reason Error',
                    'message' => 'The departure reason does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->departureReasonModel->deleteDepartureReason($departureReasonID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Departure Reason Success',
                'message' => 'The departure reason has been deleted successfully.',
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
    # Function: deleteMultipleDepartureReason
    # Description: 
    # Delete the selected departure reason if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleDepartureReason() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['departure_reason_id']) && !empty($_POST['departure_reason_id'])) {
            $departureReasonIDs = $_POST['departure_reason_id'];
    
            foreach($departureReasonIDs as $departureReasonID){
                $checkDepartureReasonExist = $this->departureReasonModel->checkDepartureReasonExist($departureReasonID);
                $total = $checkDepartureReasonExist['total'] ?? 0;

                if($total > 0){                    
                    $this->departureReasonModel->deleteDepartureReason($departureReasonID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Departure Reason Success',
                'message' => 'The selected departure reason have been deleted successfully.',
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
    # Function: getDepartureReasonDetails
    # Description: 
    # Handles the retrieval of departure reason details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getDepartureReasonDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['departure_reason_id']) && !empty($_POST['departure_reason_id'])) {
            $userID = $_SESSION['user_account_id'];
            $departureReasonID = htmlspecialchars($_POST['departure_reason_id'], ENT_QUOTES, 'UTF-8');

            $checkDepartureReasonExist = $this->departureReasonModel->checkDepartureReasonExist($departureReasonID);
            $total = $checkDepartureReasonExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Departure Reason Details Error',
                    'message' => 'The departure reason does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $departureReasonDetails = $this->departureReasonModel->getDepartureReason($departureReasonID);

            $response = [
                'success' => true,
                'departureReasonName' => $departureReasonDetails['departure_reason_name'] ?? null,
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
require_once '../../departure-reason/model/departure-reason-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new DepartureReasonController(new DepartureReasonModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>