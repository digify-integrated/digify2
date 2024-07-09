<?php
session_start();

# -------------------------------------------------------------
#
# Function: EmployeeController
# Description: 
# The EmployeeController class handles employee related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class EmployeeController {
    private $employeeModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided employeeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for employee related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param EmployeeModel $employeeModel     The employeeModel instance for employee related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(EmployeeModel $employeeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->employeeModel = $employeeModel;
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
                case 'add employee':
                    $this->addEmployee();
                    break;
                case 'update employee':
                    $this->updateEmployee();
                    break;
                case 'get employee details':
                    $this->getEmployeeDetails();
                    break;
                case 'delete employee':
                    $this->deleteEmployee();
                    break;
                case 'delete multiple employee':
                    $this->deleteMultipleEmployee();
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
    # Function: addEmployee
    # Description: 
    # Inserts a employee.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addEmployee() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['first_name']) && !empty($_POST['first_name']) && isset($_POST['middle_name']) && isset($_POST['last_name']) && !empty($_POST['last_name']) && isset($_POST['suffix']) && isset($_POST['department_id']) && isset($_POST['manager_id']) && isset($_POST['job_position_id']) && isset($_POST['company_id']) && !empty($_POST['company_id']) && isset($_POST['work_location_id']) && isset($_POST['home_work_distance']) && isset($_POST['work_schedule_id']) && isset($_POST['time_off_approver_id']) && isset($_POST['nickname']) && isset($_POST['blood_type_id']) && isset($_POST['religion_id']) && isset($_POST['height']) && isset($_POST['weight']) && isset($_POST['visa_number']) && isset($_POST['visa_expiration_date']) && isset($_POST['work_permit_number']) && isset($_POST['work_permit_expiration_date']) && isset($_POST['pin_code']) && isset($_POST['badge_id']) && isset($_POST['employment_type_id']) && isset($_POST['onboard_date']) && isset($_POST['gender_id']) && !empty($_POST['gender_id']) && isset($_POST['civil_status_id']) && !empty($_POST['civil_status_id']) && isset($_POST['birthday']) && !empty($_POST['birthday'])) {
            $userID = $_SESSION['user_account_id'];
            $firstName = $_POST['first_name'];
            $middleName = $_POST['middle_name'];
            $lastName = $_POST['last_name'];
            $suffix = $_POST['suffix'];
            $nickname = $_POST['nickname'];
            $birthPlace = $_POST['birth_place'];
            $departmentID = htmlspecialchars($_POST['department_id'], ENT_QUOTES, 'UTF-8');
            $managerID = htmlspecialchars($_POST['manager_id'], ENT_QUOTES, 'UTF-8');
            $jobPositionID = htmlspecialchars($_POST['job_position_id'], ENT_QUOTES, 'UTF-8');
            $companyID = htmlspecialchars($_POST['company_id'], ENT_QUOTES, 'UTF-8');
            $workLocationID = htmlspecialchars($_POST['work_location_id'], ENT_QUOTES, 'UTF-8');
            $homeWorkDistance = htmlspecialchars($_POST['home_work_distance'], ENT_QUOTES, 'UTF-8');
            $workScheduleID = htmlspecialchars($_POST['work_schedule_id'], ENT_QUOTES, 'UTF-8');
            $timeOffApproverID = htmlspecialchars($_POST['time_off_approver_id'], ENT_QUOTES, 'UTF-8');
            $genderID = htmlspecialchars($_POST['gender_id'], ENT_QUOTES, 'UTF-8');
            $civilStatusID = htmlspecialchars($_POST['civil_status_id'], ENT_QUOTES, 'UTF-8');
            $birthday = $this->systemModel->checkDate('empty', $_POST['birthday'], '', 'Y-m-d', '');
            $visaExpirationDate = $this->systemModel->checkDate('empty', $_POST['visa_expiration_date'], '', 'Y-m-d', '');
            $workPermitExpirationDate = $this->systemModel->checkDate('empty', $_POST['work_permit_expiration_date'], '', 'Y-m-d', '');
            $onboardDate = $this->systemModel->checkDate('empty', $_POST['onboard_date'], '', 'Y-m-d', '');
            $bloodTypeID = htmlspecialchars($_POST['blood_type_id'], ENT_QUOTES, 'UTF-8');
            $religionID = htmlspecialchars($_POST['religion_id'], ENT_QUOTES, 'UTF-8');
            $height = htmlspecialchars($_POST['height'], ENT_QUOTES, 'UTF-8');
            $weight = htmlspecialchars($_POST['weight'], ENT_QUOTES, 'UTF-8');
            $visaNumber = htmlspecialchars($_POST['visa_number'], ENT_QUOTES, 'UTF-8');
            $workPermitNumber = htmlspecialchars($_POST['work_permit_number'], ENT_QUOTES, 'UTF-8');
            $pinCode = htmlspecialchars($_POST['pin_code'], ENT_QUOTES, 'UTF-8');
            $badgeID = htmlspecialchars($_POST['badge_id'], ENT_QUOTES, 'UTF-8');
            $employmentTypeID = htmlspecialchars($_POST['employment_type_id'], ENT_QUOTES, 'UTF-8');

            $civilStatusDetails = $this->civilStatusModel->getCivilStatus($civilStatusID);
            $civilStatusName = $civilStatusDetails['civil_status_name'] ?? '';

            $genderDetails = $this->genderModel->getGender($genderID);
            $genderName = $genderDetails['gender_name'] ?? '';

            $religionDetails = $this->religionModel->getReligion($religionID);
            $religionName = $religionDetails['religion_name'] ?? '';

            $bloodTypeDetails = $this->bloodTypeModel->getBloodType($bloodTypeID);
            $bloodTypeName = $bloodTypeDetails['blood_type_name'] ?? '';

            $companyDetails = $this->companyModel->getCompany($companyID);
            $companyName = $companyDetails['company_name'] ?? '';

            $employmentTypeDetails = $this->employmentTypeModel->getEmploymentType($employmentTypeID);
            $employmentTypeName = $employmentTypeDetails['employment_type_name'] ?? '';

            $departmentDetails = $this->departmentModel->getDepartment($departmentID);
            $departmentName = $departmentDetails['department_name'] ?? '';

            $jobPositionDetails = $this->jobPositionModel->getJobPosition($jobPositionID);
            $jobPositionName = $jobPositionDetails['job_position_name'] ?? '';

            $managerDetails = $this->employeeModel->getEmployee($managerID);
            $managerName = $managerDetails['file_as'] ?? '';

            $workScheduleDetails = $this->workScheduleModel->getWorkSchedule($workScheduleID);
            $workScheduleName = $workScheduleDetails['work_schedule_name'] ?? '';

            $timeOffapproverDetails = $this->employeeModel->getEmployee($timeOffApproverID);
            $timeOffApproverName = $timeOffapproverDetails['file_as'] ?? '';

            $employeeID = $this->employeeModel->insertEmployee($firstName, $middleName, $lastName, $suffix, $nickname, $civilStatusID, $civilStatusName, $genderID, $genderName, $religionID, $religionName, $bloodTypeID, $bloodTypeName, $birthday, $birthPlace, $height, $weight, $userID);

            $this->employeeModel->insertWorkInformation($employeeID, $badgeID, $companyID, $companyName, $employmentTypeID, $employmentTypeName, $departmentID, $departmentName, $jobPositionID, $jobPositionName, $managerID, $managerName, $workScheduleID, $workScheduleName, $pinCode, $homeWorkDistance, $visaNumber, $workPermitNumber, $visaExpirationDate, $workPermitExpirationDate, $onboardDate, $timeOffApproverID, $timeOffApproverName, $userID);

            $employeeImageFileName = $_FILES['employee_image']['name'];
            $employeeImageFileSize = $_FILES['employee_image']['size'];
            $employeeImageFileError = $_FILES['employee_image']['error'];
            $employeeImageTempName = $_FILES['employee_image']['tmp_name'];
            $employeeImageFileExtension = explode('.', $employeeImageFileName);
            $employeeImageActualFileExtension = strtolower(end($employeeImageFileExtension));

            if ($employeeImageFileError === 0 && $employeeImageFileSize > 0) {
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(1);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(1);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($employeeImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Update Employee Image Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($employeeImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Update Employee Image Error',
                        'message' => 'Please choose the employee image.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($employeeImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Update Employee Image Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($employeeImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Update Employee Image Error',
                        'message' => 'The employee image exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $employeeImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('EMPLOYEE_IMAGE_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. EMPLOYEE_IMAGE_DIR. $employeeID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/employee/image/'. $employeeID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Update Employee Image Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                if(!move_uploaded_file($employeeImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Update Employee Image Error',
                        'message' => 'The employee image cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $this->employeeModel->updateEmployeeImage($employeeID, $filePath, $userID);
    
                $response = [
                    'success' => true,
                    'title' => 'Update Employee Image Success',
                    'message' => 'The employee image has been updated successfully.',
                    'messageType' => 'success'
                ];
            }

            $workPermitFileName = $_FILES['work_permit']['name'];
            $workPermitFileSize = $_FILES['work_permit']['size'];
            $workPermitFileError = $_FILES['work_permit']['error'];
            $workPermitTempName = $_FILES['work_permit']['tmp_name'];
            $workPermitFileExtension = explode('.', $workPermitFileName);
            $workPermitActualFileExtension = strtolower(end($workPermitFileExtension));

            if ($workPermitFileError === 0 && $workPermitFileSize > 0) {

            }
    
            $response = [
                'success' => true,
                'employeeID' => $this->securityModel->encryptData($employeeID),
                'title' => 'Insert Employee Success',
                'message' => 'The employee has been inserted successfully.',
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
    # Function: updateEmployee
    # Description: 
    # Updates the employee if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmployee() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_name']) && !empty($_POST['employee_name']) && isset($_POST['parent_employee_id']) && isset($_POST['manager_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeName = $_POST['employee_name'];
            $parentEmployeeID = htmlspecialchars($_POST['parent_employee_id'], ENT_QUOTES, 'UTF-8');
            $managerID = htmlspecialchars($_POST['manager_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Employee Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $parentEmployeeDetails = $this->employeeModel->getEmployee($parentEmployeeID);
            $parentEmployeeName = $parentEmployeeDetails['employee_name'] ?? '';

            $this->employeeModel->updateEmployee($employeeID, $employeeName, $parentEmployeeID, $parentEmployeeName, '', '', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Employee Success',
                'message' => 'The employee has been updated successfully.',
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
    # Function: deleteEmployee
    # Description: 
    # Delete the employee if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteEmployee() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Employee Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employeeModel->deleteEmployee($employeeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Employee Success',
                'message' => 'The employee has been deleted successfully.',
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
    # Function: deleteMultipleEmployee
    # Description: 
    # Delete the selected employees if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleEmployee() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $employeeIDs = $_POST['employee_id'];
    
            foreach($employeeIDs as $employeeID){
                $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
                $total = $checkEmployeeExist['total'] ?? 0;

                if($total > 0){
                    $this->employeeModel->deleteEmployee($employeeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Employees Success',
                'message' => 'The selected employees have been deleted successfully.',
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
    # Function: getEmployeeDetails
    # Description: 
    # Handles the retrieval of employee details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getEmployeeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');

            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Employee Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeDetails = $this->employeeModel->getEmployee($employeeID);

            $response = [
                'success' => true,
                'employeeName' => $employeeDetails['employee_name'] ?? null,
                'parentEmployeeID' => $employeeDetails['parent_employee_id'] ?? '',
                'parentEmployeeName' => $employeeDetails['parent_employee_name'] ?? null,
                'managerID' => $employeeDetails['manager_id'] ?? '',
                'managerName' => $employeeDetails['manager_name'] ?? null
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
require_once '../../employee/model/employee-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new EmployeeController(new EmployeeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>