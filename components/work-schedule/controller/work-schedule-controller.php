<?php
session_start();

# -------------------------------------------------------------
#
# Function: WorkScheduleController
# Description: 
# The WorkScheduleController class handles work schedule related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class WorkScheduleController {
    private $workScheduleModel;
    private $scheduleTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided workScheduleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for work schedule related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param WorkScheduleModel $workScheduleModel     The workScheduleModel instance for work schedule related operations.
    # - @param ScheduleTypeModel $scheduleTypeModel     The scheduleTypeModel instance for schedule type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(WorkScheduleModel $workScheduleModel, ScheduleTypeModel $scheduleTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->workScheduleModel = $workScheduleModel;
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
                case 'add work schedule':
                    $this->addWorkSchedule();
                    break;
                case 'update work schedule':
                    $this->updateWorkSchedule();
                    break;
                case 'save work hours':
                    $this->saveWorkHours();
                    break;
                case 'get work schedule details':
                    $this->getWorkScheduleDetails();
                    break;
                case 'get work hours details':
                    $this->getWorkHoursDetails();
                    break;
                case 'delete work schedule':
                    $this->deleteWorkSchedule();
                    break;
                case 'delete work hours':
                    $this->deleteWorkHours();
                    break;
                case 'delete multiple work schedule':
                    $this->deleteMultipleWorkSchedule();
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
    # Function: addWorkSchedule
    # Description: 
    # Inserts a work schedule.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addWorkSchedule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_schedule_name']) && !empty($_POST['work_schedule_name']) && isset($_POST['schedule_type_id']) && !empty($_POST['schedule_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $workScheduleName = $_POST['work_schedule_name'];
            $scheduleTypeID = htmlspecialchars($_POST['schedule_type_id'], ENT_QUOTES, 'UTF-8');

            $scheduleTypeDetails = $this->scheduleTypeModel->getScheduleType($scheduleTypeID);
            $scheduleTypeName = $scheduleTypeDetails['schedule_type_name'] ?? null;
        
            $workScheduleID = $this->workScheduleModel->insertWorkSchedule($workScheduleName, $scheduleTypeID, $scheduleTypeName, $userID);
    
            $response = [
                'success' => true,
                'workScheduleID' => $this->securityModel->encryptData($workScheduleID),
                'title' => 'Insert Work Schedule Success',
                'message' => 'The work schedule has been inserted successfully.',
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
    # Function: updateWorkSchedule
    # Description: 
    # Updates the work schedule if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateWorkSchedule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['work_schedule_id']) && !empty($_POST['work_schedule_id']) && isset($_POST['work_schedule_name']) && !empty($_POST['work_schedule_name']) && isset($_POST['schedule_type_id']) && !empty($_POST['schedule_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $workScheduleID = htmlspecialchars($_POST['work_schedule_id'], ENT_QUOTES, 'UTF-8');
            $workScheduleName = $_POST['work_schedule_name'];
            $scheduleTypeID = htmlspecialchars($_POST['schedule_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkWorkScheduleExist = $this->workScheduleModel->checkWorkScheduleExist($workScheduleID);
            $total = $checkWorkScheduleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Work Schedule Error',
                    'message' => 'The work schedule does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $scheduleTypeDetails = $this->scheduleTypeModel->getScheduleType($scheduleTypeID);
            $scheduleTypeName = $scheduleTypeDetails['schedule_type_name'] ?? null;

            $this->workScheduleModel->updateWorkSchedule($workScheduleID, $workScheduleName, $scheduleTypeID, $scheduleTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Work Schedule Success',
                'message' => 'The work schedule has been updated successfully.',
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
    # Function: saveWorkHours
    # Description: 
    # Saves the work hours if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveWorkHours() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['work_schedule_id']) && !empty($_POST['work_schedule_id']) && isset($_POST['work_hours_id']) && isset($_POST['day_of_week']) && !empty($_POST['day_of_week']) && isset($_POST['day_period']) && !empty($_POST['day_period']) && isset($_POST['work_from']) && !empty($_POST['work_from']) && isset($_POST['work_to']) && !empty($_POST['work_to']) && isset($_POST['notes'])) {
            $userID = $_SESSION['user_account_id'];
            $workScheduleID = htmlspecialchars($_POST['work_schedule_id'], ENT_QUOTES, 'UTF-8');
            $workHoursID = htmlspecialchars($_POST['work_hours_id'], ENT_QUOTES, 'UTF-8');
            $dayOfWeek = htmlspecialchars($_POST['day_of_week'], ENT_QUOTES, 'UTF-8');
            $dayPeriod = htmlspecialchars($_POST['day_period'], ENT_QUOTES, 'UTF-8');
            $workFrom = $this->systemModel->checkDate('empty', $_POST['work_from'], '', 'H:i:s', '');
            $workTo = $this->systemModel->checkDate('empty', $_POST['work_to'], '', 'H:i:s', '');
            $notes = $_POST['notes'];

            $checkWorkHoursOverlap = $this->workScheduleModel->checkWorkHoursOverlap($workHoursID, $workScheduleID, $dayOfWeek, $dayPeriod, $workFrom, $workTo);
            $total = $checkWorkHoursOverlap['total'] ?? 0;
        
            if ($total > 0) {
                $response = [
                    'success' => false,
                    'title' => 'Save Work Hour Error',
                    'message' => 'The work hour entered overlaps with the other work hours.',
                    'messageType' => 'error'
                ];

                echo json_encode($response);
                exit;
            } 
        
            $checkWorkHoursExist = $this->workScheduleModel->checkWorkHoursExist($workScheduleID);
            $total = $checkWorkHoursExist['total'] ?? 0;

            if($total > 0){
                $this->workScheduleModel->updateWorkHours($workHoursID, $workScheduleID, $dayOfWeek, $dayPeriod, $workFrom, $workTo, $notes, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update Work Hour Success',
                    'message' => 'The work hour has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->workScheduleModel->insertWorkHours($workScheduleID, $dayOfWeek, $dayPeriod, $workFrom, $workTo, $notes, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Work Hour Success',
                    'message' => 'The work hour has been inserted successfully.',
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
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteWorkSchedule
    # Description: 
    # Delete the work schedule if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteWorkSchedule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_schedule_id']) && !empty($_POST['work_schedule_id'])) {
            $workScheduleID = htmlspecialchars($_POST['work_schedule_id'], ENT_QUOTES, 'UTF-8');
        
            $checkWorkScheduleExist = $this->workScheduleModel->checkWorkScheduleExist($workScheduleID);
            $total = $checkWorkScheduleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Work Schedule Error',
                    'message' => 'The work schedule does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->workScheduleModel->deleteWorkSchedule($workScheduleID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Work Schedule Success',
                'message' => 'The work schedule has been deleted successfully.',
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
    # Function: deleteWorkHours
    # Description: 
    # Delete the work hours if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteWorkHours() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_hours_id']) && !empty($_POST['work_hours_id'])) {
            $workHoursID = htmlspecialchars($_POST['work_hours_id'], ENT_QUOTES, 'UTF-8');
        
            $checkWorkHoursExist = $this->workScheduleModel->checkWorkHoursExist($workHoursID);
            $total = $checkWorkHoursExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Work Hour Error',
                    'message' => 'The work hour does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->workScheduleModel->deleteWorkHours($workHoursID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Work Hour Success',
                'message' => 'The work hour has been deleted successfully.',
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
    # Function: deleteMultipleWorkSchedule
    # Description: 
    # Delete the selected companies if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleWorkSchedule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['work_schedule_id']) && !empty($_POST['work_schedule_id'])) {
            $workScheduleIDs = $_POST['work_schedule_id'];
    
            foreach($workScheduleIDs as $workScheduleID){
                $checkWorkScheduleExist = $this->workScheduleModel->checkWorkScheduleExist($workScheduleID);
                $total = $checkWorkScheduleExist['total'] ?? 0;

                if($total > 0){
                    $this->workScheduleModel->deleteWorkSchedule($workScheduleID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Work Schedules Success',
                'message' => 'The selected work schedules have been deleted successfully.',
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
    # Function: getWorkScheduleDetails
    # Description: 
    # Handles the retrieval of work location details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getWorkScheduleDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['work_schedule_id']) && !empty($_POST['work_schedule_id'])) {
            $userID = $_SESSION['user_account_id'];
            $workScheduleID = htmlspecialchars($_POST['work_schedule_id'], ENT_QUOTES, 'UTF-8');

            $checkWorkScheduleExist = $this->workScheduleModel->checkWorkScheduleExist($workScheduleID);
            $total = $checkWorkScheduleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Work Schedule Details Error',
                    'message' => 'The work schedule does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $workScheduleDetails = $this->workScheduleModel->getWorkSchedule($workScheduleID);

            $response = [
                'success' => true,
                'workScheduleName' => $workScheduleDetails['work_schedule_name'] ?? null,
                'scheduleTypeID' => $workScheduleDetails['schedule_type_id'] ?? null,
                'scheduleTypeName' => $workScheduleDetails['schedule_type_name'] ?? null
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
    # Function: getWorkHoursDetails
    # Description: 
    # Handles the retrieval of work hour details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getWorkHoursDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['work_hours_id']) && !empty($_POST['work_hours_id'])) {
            $userID = $_SESSION['user_account_id'];
            $workHoursID = htmlspecialchars($_POST['work_hours_id'], ENT_QUOTES, 'UTF-8');

            $checkWorkScheduleExist = $this->workScheduleModel->checkWorkScheduleExist($workHoursID);
            $total = $checkWorkScheduleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Work Hour Details Error',
                    'message' => 'The work hour does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $workHoursDetails = $this->workScheduleModel->getWorkHours($workHoursID);

            $response = [
                'success' => true,
                'workHoursID' => $workHoursDetails['work_hours_id'],
                'dayOfWeek' => $workHoursDetails['day_of_week'],
                'dayPeriod' => $workHoursDetails['day_period'],
                'startTime' => $this->systemModel->checkDate('empty', $workHoursDetails['start_time'], '', 'H:i', ''),
                'endTime' => $this->systemModel->checkDate('empty', $workHoursDetails['end_time'], '', 'H:i', ''),
                'notes' => $workHoursDetails['notes']
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
require_once '../../work-schedule/model/work-schedule-model.php';
require_once '../../schedule-type/model/schedule-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new WorkScheduleController(new WorkScheduleModel(new DatabaseModel), new ScheduleTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>