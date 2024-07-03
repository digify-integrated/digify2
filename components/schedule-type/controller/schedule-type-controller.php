<?php
session_start();

# -------------------------------------------------------------
#
# Function: ScheduleTypeController
# Description: 
# The ScheduleTypeController class handles schedule type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ScheduleTypeController {
    private $scheduleTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided ScheduleTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for schedule type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ScheduleTypeModel $scheduleTypeModel     The ScheduleTypeModel instance for schedule type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ScheduleTypeModel $scheduleTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->scheduleTypeModel = $scheduleTypeModel;
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
                case 'add schedule type':
                    $this->addScheduleType();
                    break;
                case 'update schedule type':
                    $this->updateScheduleType();
                    break;
                case 'get schedule type details':
                    $this->getScheduleTypeDetails();
                    break;
                case 'delete schedule type':
                    $this->deleteScheduleType();
                    break;
                case 'delete multiple schedule type':
                    $this->deleteMultipleScheduleType();
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
    # Function: addScheduleType
    # Description: 
    # Inserts a schedule type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addScheduleType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['schedule_type_name']) && !empty($_POST['schedule_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $scheduleTypeName = $_POST['schedule_type_name'];
        
            $scheduleTypeID = $this->scheduleTypeModel->insertScheduleType($scheduleTypeName, $userID);
    
            $response = [
                'success' => true,
                'scheduleTypeID' => $this->securityModel->encryptData($scheduleTypeID),
                'title' => 'Insert Schedule Type Success',
                'message' => 'The schedule type has been inserted successfully.',
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
    # Function: updateScheduleType
    # Description: 
    # Updates the schedule type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateScheduleType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['schedule_type_id']) && !empty($_POST['schedule_type_id']) && isset($_POST['schedule_type_name']) && !empty($_POST['schedule_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $scheduleTypeID = htmlspecialchars($_POST['schedule_type_id'], ENT_QUOTES, 'UTF-8');
            $scheduleTypeName = $_POST['schedule_type_name'];
        
            $checkScheduleTypeExist = $this->scheduleTypeModel->checkScheduleTypeExist($scheduleTypeID);
            $total = $checkScheduleTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Schedule Type Error',
                    'message' => 'The schedule type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->scheduleTypeModel->updateScheduleType($scheduleTypeID, $scheduleTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Schedule Type Success',
                'message' => 'The schedule type has been updated successfully.',
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
    # Function: deleteScheduleType
    # Description: 
    # Delete the schedule type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteScheduleType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['schedule_type_id']) && !empty($_POST['schedule_type_id'])) {
            $scheduleTypeID = htmlspecialchars($_POST['schedule_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkScheduleTypeExist = $this->scheduleTypeModel->checkScheduleTypeExist($scheduleTypeID);
            $total = $checkScheduleTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Schedule Type Error',
                    'message' => 'The schedule type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->scheduleTypeModel->deleteScheduleType($scheduleTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Schedule Type Success',
                'message' => 'The schedule type has been deleted successfully.',
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
    # Function: deleteMultipleScheduleType
    # Description: 
    # Delete the selected schedule type if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleScheduleType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['schedule_type_id']) && !empty($_POST['schedule_type_id'])) {
            $scheduleTypeIDs = $_POST['schedule_type_id'];
    
            foreach($scheduleTypeIDs as $scheduleTypeID){
                $checkScheduleTypeExist = $this->scheduleTypeModel->checkScheduleTypeExist($scheduleTypeID);
                $total = $checkScheduleTypeExist['total'] ?? 0;

                if($total > 0){                    
                    $this->scheduleTypeModel->deleteScheduleType($scheduleTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Schedule Type Success',
                'message' => 'The selected schedule type have been deleted successfully.',
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
    # Function: getScheduleTypeDetails
    # Description: 
    # Handles the retrieval of schedule type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getScheduleTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['schedule_type_id']) && !empty($_POST['schedule_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $scheduleTypeID = htmlspecialchars($_POST['schedule_type_id'], ENT_QUOTES, 'UTF-8');

            $checkScheduleTypeExist = $this->scheduleTypeModel->checkScheduleTypeExist($scheduleTypeID);
            $total = $checkScheduleTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Schedule Type Details Error',
                    'message' => 'The schedule type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $scheduleTypeDetails = $this->scheduleTypeModel->getScheduleType($scheduleTypeID);

            $response = [
                'success' => true,
                'scheduleTypeName' => $scheduleTypeDetails['schedule_type_name'] ?? null,
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
require_once '../../schedule-type/model/schedule-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ScheduleTypeController(new ScheduleTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>