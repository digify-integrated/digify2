<?php
session_start();

# -------------------------------------------------------------
#
# Function: DepartureReasonsController
# Description: 
# The DepartureReasonsController class handles departure reasons related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class DepartureReasonsController {
    private $departureReasonsModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided DepartureReasonsModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for departure reasons related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param DepartureReasonsModel $departureReasonsModel     The DepartureReasonsModel instance for departure reasons related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(DepartureReasonsModel $departureReasonsModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->departureReasonsModel = $departureReasonsModel;
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
                case 'add departure reasons':
                    $this->addDepartureReasons();
                    break;
                case 'update departure reasons':
                    $this->updateDepartureReasons();
                    break;
                case 'update app logo':
                    $this->updateAppLogo();
                    break;
                case 'get departure reasons details':
                    $this->getDepartureReasonsDetails();
                    break;
                case 'delete departure reasons':
                    $this->deleteDepartureReasons();
                    break;
                case 'delete multiple departure reasons':
                    $this->deleteMultipleDepartureReasons();
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
    # Function: addDepartureReasons
    # Description: 
    # Inserts a departure reasons.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addDepartureReasons() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['departure_reasons_name']) && !empty($_POST['departure_reasons_name'])) {
            $userID = $_SESSION['user_account_id'];
            $departureReasonsName = $_POST['departure_reasons_name'];
        
            $departureReasonsID = $this->departureReasonsModel->insertDepartureReasons($departureReasonsName, $userID);
    
            $response = [
                'success' => true,
                'departureReasonsID' => $this->securityModel->encryptData($departureReasonsID),
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
    # Function: updateDepartureReasons
    # Description: 
    # Updates the departure reasons if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateDepartureReasons() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['departure_reasons_id']) && !empty($_POST['departure_reasons_id']) && isset($_POST['departure_reasons_name']) && !empty($_POST['departure_reasons_name'])) {
            $userID = $_SESSION['user_account_id'];
            $departureReasonsID = htmlspecialchars($_POST['departure_reasons_id'], ENT_QUOTES, 'UTF-8');
            $departureReasonsName = $_POST['departure_reasons_name'];
        
            $checkDepartureReasonsExist = $this->departureReasonsModel->checkDepartureReasonsExist($departureReasonsID);
            $total = $checkDepartureReasonsExist['total'] ?? 0;

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

            $this->departureReasonsModel->updateDepartureReasons($departureReasonsID, $departureReasonsName, $userID);
                
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
    # Function: deleteDepartureReasons
    # Description: 
    # Delete the departure reasons if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteDepartureReasons() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['departure_reasons_id']) && !empty($_POST['departure_reasons_id'])) {
            $departureReasonsID = htmlspecialchars($_POST['departure_reasons_id'], ENT_QUOTES, 'UTF-8');
        
            $checkDepartureReasonsExist = $this->departureReasonsModel->checkDepartureReasonsExist($departureReasonsID);
            $total = $checkDepartureReasonsExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Departure Reason Error',
                    'message' => 'The departure reasons does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->departureReasonsModel->deleteDepartureReasons($departureReasonsID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Departure Reason Success',
                'message' => 'The departure reasons has been deleted successfully.',
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
    # Function: deleteMultipleDepartureReasons
    # Description: 
    # Delete the selected departure reasons if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleDepartureReasons() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['departure_reasons_id']) && !empty($_POST['departure_reasons_id'])) {
            $departureReasonsIDs = $_POST['departure_reasons_id'];
    
            foreach($departureReasonsIDs as $departureReasonsID){
                $checkDepartureReasonsExist = $this->departureReasonsModel->checkDepartureReasonsExist($departureReasonsID);
                $total = $checkDepartureReasonsExist['total'] ?? 0;

                if($total > 0){                    
                    $this->departureReasonsModel->deleteDepartureReasons($departureReasonsID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Departure Reasons Success',
                'message' => 'The selected departure reasons have been deleted successfully.',
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
    # Function: getDepartureReasonsDetails
    # Description: 
    # Handles the retrieval of departure reasons details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getDepartureReasonsDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['departure_reasons_id']) && !empty($_POST['departure_reasons_id'])) {
            $userID = $_SESSION['user_account_id'];
            $departureReasonsID = htmlspecialchars($_POST['departure_reasons_id'], ENT_QUOTES, 'UTF-8');

            $checkDepartureReasonsExist = $this->departureReasonsModel->checkDepartureReasonsExist($departureReasonsID);
            $total = $checkDepartureReasonsExist['total'] ?? 0;

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
    
            $departureReasonsDetails = $this->departureReasonsModel->getDepartureReasons($departureReasonsID);
            $appLogo = $this->systemModel->checkImage($departureReasonsDetails['app_logo'] ?? null, 'departure reasons logo');

            $response = [
                'success' => true,
                'departureReasonsName' => $departureReasonsDetails['departure_reasons_name'] ?? null,
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
require_once '../../departure-reasons/model/departure-reasons-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new DepartureReasonsController(new DepartureReasonsModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>