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
    private $genderModel;
    private $religionModel;
    private $bloodTypeModel;
    private $civilStatusModel;
    private $companyModel;
    private $employmentTypeModel;
    private $departmentModel;
    private $jobPositionModel;
    private $workLocationModel;
    private $workScheduleModel;
    private $uploadSettingModel;
    private $userAccountModel;
    private $employmentLocationTypeModel;
    private $addressTypeModel;
    private $cityModel;
    private $stateModel;
    private $countryModel;
    private $bankModel;
    private $bankAccountTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided employeeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for employee related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param EmployeeModel $employeeModel     The employeeModel instance for employee related operations.
    # - @param GenderModel $genderModel     The GenderModel instance for gender operations.
    # - @param ReligionModel $religionModel     The ReligionModel instance for religion operations.
    # - @param BloodTypeModel $bloodTypeModel     The BloodTypeModel instance for blood type operations.
    # - @param CivilStatusModel $civilStatusModel     The CivilStatusModel instance for civil status operations.
    # - @param CompanyModel $companyModel     The CompanyModel instance for company operations.
    # - @param EmploymentTypeModel $employmentTypeModel     The EmploymentTypeModel instance for employment type operations.
    # - @param DepartmentModel $departmentModel     The DepartmentModel instance for department operations.
    # - @param JobPositionModel $jobPositionModel     The JobPositionModel instance for job position operations.
    # - @param WorkLocationModel $workLocationModel     The WorkLocationModel instance for work location operations.
    # - @param WorkScheduleModel $workScheduleModel     The WorkScheduleModel instance for work schedule operations.
    # - @param UserAccountModel $userAccountModel     The UserAccountModel instance for user account operations.
    # - @param EmploymentLocationTypeModel $employmentLocationTypeModel     The EmploymentLocationTypeModel instance for employment location type operations.
    # - @param AddressTypeModel $addressTypeModel     The addressTypeModel instance for address type related operations.
    # - @param CityModel $cityModel     The cityModel instance for city related operations.
    # - @param StateModel $stateModel     The stateModel instance for state related operations.
    # - @param CountryModel $countryModel     The countryModel instance for country related operations.
    # - @param BankModel $bankModel     The bankModel instance for bank related operations.
    # - @param BankAccountTypeModel $bankAccountTypeModel     The bankAccountTypeModel instance for bank account type related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(EmployeeModel $employeeModel, GenderModel $genderModel, ReligionModel $religionModel, BloodTypeModel $bloodTypeModel, CivilStatusModel $civilStatusModel, CompanyModel $companyModel, EmploymentTypeModel $employmentTypeModel, DepartmentModel $departmentModel, JobPositionModel $jobPositionModel, WorkLocationModel $workLocationModel, WorkScheduleModel $workScheduleModel, UserAccountModel $userAccountModel, EmploymentLocationTypeModel $employmentLocationTypeModel, AddressTypeModel $addressTypeModel, CityModel $cityModel, StateModel $stateModel, CountryModel $countryModel, BankModel $bankModel, BankAccountTypeModel $bankAccountTypeModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->employeeModel = $employeeModel;
        $this->genderModel = $genderModel;
        $this->religionModel = $religionModel;
        $this->bloodTypeModel = $bloodTypeModel;
        $this->civilStatusModel = $civilStatusModel;
        $this->companyModel = $companyModel;
        $this->employmentTypeModel = $employmentTypeModel;
        $this->departmentModel = $departmentModel;
        $this->jobPositionModel = $jobPositionModel;
        $this->workLocationModel = $workLocationModel;
        $this->workScheduleModel = $workScheduleModel;
        $this->userAccountModel = $userAccountModel;
        $this->employmentLocationTypeModel = $employmentLocationTypeModel;
        $this->addressTypeModel = $addressTypeModel;
        $this->cityModel = $cityModel;
        $this->stateModel = $stateModel;
        $this->countryModel = $countryModel;
        $this->bankModel = $bankModel;
        $this->bankAccountTypeModel = $bankAccountTypeModel;
        $this->uploadSettingModel = $uploadSettingModel;
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
                case 'add employee':
                    $this->addEmployee();
                    break;
                case 'update employee about':
                    $this->updateEmployeeAbout();
                    break;
                case 'update employee private information':
                    $this->updateEmployeePrivateInformation();
                    break;
                case 'update employee work information':
                    $this->updateEmployeeWorkInformation();
                    break;
                case 'update employee hr settings':
                    $this->updateEmployeeHRSettings();
                    break;
                case 'update employee work permit':
                    $this->updateEmployeeWorkPermit();
                    break;
                case 'save employee experience':
                    $this->saveEmployeeExperience();
                    break;
                case 'save employee education':
                    $this->saveEmployeeEducation();
                    break;
                case 'save employee address':
                    $this->saveEmployeeAddress();
                    break;
                case 'save employee bank account':
                    $this->saveEmployeeBankAccount();
                    break;
                case 'get about details':
                    $this->getAboutDetails();
                    break;
                case 'get private information details':
                    $this->getPrivateInformationDetails();
                    break;
                case 'get work information details':
                    $this->getWorkInformationDetails();
                    break;
                case 'get hr settings details':
                    $this->getHRSettingsDetails();
                    break;
                case 'get work permit details':
                    $this->getWorkPermitDetails();
                    break;
                case 'get employee experience details':
                    $this->getEmployeeExperienceDetails();
                    break;
                case 'get employee education details':
                    $this->getEmployeeEducationDetails();
                    break;
                case 'get employee address details':
                    $this->getEmployeeAddressDetails();
                    break;
                case 'get employee bank account details':
                    $this->getEmployeeBankAccountDetails();
                    break;
                case 'delete employee':
                    $this->deleteEmployee();
                    break;
                case 'delete multiple employee':
                    $this->deleteMultipleEmployee();
                    break;
                case 'delete employee experience':
                    $this->deleteEmployeeExperience();
                    break;
                case 'delete employee education':
                    $this->deleteEmployeeEducation();
                    break;
                case 'delete employee address':
                    $this->deleteEmployeeAddress();
                    break;
                case 'delete employee bank account':
                    $this->deleteEmployeeBankAccount();
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

            $fullNameParts = array_filter([$firstName, $middleName, $lastName]);
            $fullName = implode(' ', $fullNameParts);

            if (!empty($suffix)) {
                $fullName .= ', ' . $suffix;
            }

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
            $managerName = $managerDetails['full_name'] ?? '';

            $workScheduleDetails = $this->workScheduleModel->getWorkSchedule($workScheduleID);
            $workScheduleName = $workScheduleDetails['work_schedule_name'] ?? '';

            $workLocationDetails = $this->workLocationModel->getWorkLocation($workLocationID);
            $workLocationName = $workLocationDetails['work_location_name'] ?? '';

            $timeOffapproverDetails = $this->userAccountModel->getUserAccount($timeOffApproverID, null);
            $timeOffApproverName = $timeOffapproverDetails['file_as'] ?? '';

            $employeeID = $this->employeeModel->insertEmployee($fullName, $firstName, $middleName, $lastName, $suffix, $nickname, $civilStatusID, $civilStatusName, $genderID, $genderName, $religionID, $religionName, $bloodTypeID, $bloodTypeName, $birthday, $birthPlace, $height, $weight, $badgeID, $companyID, $companyName, $employmentTypeID, $employmentTypeName, $departmentID, $departmentName, $jobPositionID, $jobPositionName, $workLocationID, $workLocationName, $managerID, $managerName, $workScheduleID, $workScheduleName, $pinCode, $homeWorkDistance, $visaNumber, $workPermitNumber, $visaExpirationDate, $workPermitExpirationDate, $onboardDate, $timeOffApproverID, $timeOffApproverName, $userID);
            
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
    # Function: updateEmployeeAbout
    # Description: 
    # Updates the employee about if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmployeeAbout() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['about']) && !empty($_POST['about'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $about = $_POST['about'];
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update About Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employeeModel->updateEmployeeAbout($employeeID, $about, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update About Success',
                'message' => 'The employee has been updated successfully.',
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
    # Function: updateEmployeePrivateInformation
    # Description: 
    # Updates the employee private information if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmployeePrivateInformation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['first_name']) && !empty($_POST['first_name']) && isset($_POST['last_name']) && !empty($_POST['last_name']) && isset($_POST['middle_name']) && isset($_POST['nickname']) && isset($_POST['gender_id']) && !empty($_POST['gender_id']) && isset($_POST['civil_status_id']) && !empty($_POST['civil_status_id']) && isset($_POST['birthday']) && !empty($_POST['birthday']) && isset($_POST['birth_place']) && !empty($_POST['birth_place']) && isset($_POST['suffix']) && isset($_POST['blood_type_id']) && isset($_POST['religion_id']) && isset($_POST['height']) && isset($_POST['weight'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $firstName = $_POST['first_name'];
            $lastName = $_POST['last_name'];
            $middleName = $_POST['middle_name'];
            $suffix = $_POST['suffix'];
            $nickname = $_POST['nickname'];
            $genderID = htmlspecialchars($_POST['gender_id'], ENT_QUOTES, 'UTF-8');
            $civilStatusID = htmlspecialchars($_POST['civil_status_id'], ENT_QUOTES, 'UTF-8');
            $bloodTypeID = htmlspecialchars($_POST['blood_type_id'], ENT_QUOTES, 'UTF-8');
            $religionID = htmlspecialchars($_POST['religion_id'], ENT_QUOTES, 'UTF-8');
            $birthday = $this->systemModel->checkDate('empty', $_POST['birthday'], '', 'Y-m-d', '');
            $birthPlace = $_POST['birth_place'];
            $height = $_POST['height'];
            $weight = $_POST['weight'];
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Private Information Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $fullNameParts = array_filter([$firstName, $middleName, $lastName]);
            $fullName = implode(' ', $fullNameParts);

            if (!empty($suffix)) {
                $fullName .= ', ' . $suffix;
            }

            $civilStatusDetails = $this->civilStatusModel->getCivilStatus($civilStatusID);
            $civilStatusName = $civilStatusDetails['civil_status_name'] ?? '';

            $genderDetails = $this->genderModel->getGender($genderID);
            $genderName = $genderDetails['gender_name'] ?? '';

            $religionDetails = $this->religionModel->getReligion($religionID);
            $religionName = $religionDetails['religion_name'] ?? '';

            $bloodTypeDetails = $this->bloodTypeModel->getBloodType($bloodTypeID);
            $bloodTypeName = $bloodTypeDetails['blood_type_name'] ?? '';

            $this->employeeModel->updateEmployeePrivateInformation($employeeID, $fullName, $firstName, $middleName, $lastName, $suffix, $nickname, $civilStatusID, $civilStatusName, $genderID, $genderName, $religionID, $religionName, $bloodTypeID, $bloodTypeName, $birthday, $birthPlace, $height, $weight, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Private Information Success',
                'message' => 'The private information has been updated successfully.',
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
    # Function: updateEmployeeWorkInformation
    # Description: 
    # Updates the employee work information if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmployeeWorkInformation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['department_id']) && !empty($_POST['department_id']) && isset($_POST['manager_id']) && isset($_POST['company_id']) && !empty($_POST['company_id']) && isset($_POST['work_location_id']) && isset($_POST['home_work_distance']) && isset($_POST['work_schedule_id']) && isset($_POST['job_position_id']) && !empty($_POST['job_position_id']) && isset($_POST['time_off_approver_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $departmentID = htmlspecialchars($_POST['department_id'], ENT_QUOTES, 'UTF-8');
            $managerID = htmlspecialchars($_POST['manager_id'], ENT_QUOTES, 'UTF-8');
            $companyID = htmlspecialchars($_POST['company_id'], ENT_QUOTES, 'UTF-8');
            $workLocationID = htmlspecialchars($_POST['work_location_id'], ENT_QUOTES, 'UTF-8');
            $homeWorkDistance = $_POST['home_work_distance'];
            $workScheduleID = htmlspecialchars($_POST['work_schedule_id'], ENT_QUOTES, 'UTF-8');
            $jobPositionID = htmlspecialchars($_POST['job_position_id'], ENT_QUOTES, 'UTF-8');
            $timeOffApproverID = htmlspecialchars($_POST['time_off_approver_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Work Information Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $companyDetails = $this->companyModel->getCompany($companyID);
            $companyName = $companyDetails['company_name'] ?? '';

            $departmentDetails = $this->departmentModel->getDepartment($departmentID);
            $departmentName = $departmentDetails['department_name'] ?? '';

            $jobPositionDetails = $this->jobPositionModel->getJobPosition($jobPositionID);
            $jobPositionName = $jobPositionDetails['job_position_name'] ?? '';

            $managerDetails = $this->employeeModel->getEmployee($managerID);
            $managerName = $managerDetails['full_name'] ?? '';

            $workScheduleDetails = $this->workScheduleModel->getWorkSchedule($workScheduleID);
            $workScheduleName = $workScheduleDetails['work_schedule_name'] ?? '';

            $workLocationDetails = $this->workLocationModel->getWorkLocation($workLocationID);
            $workLocationName = $workLocationDetails['work_location_name'] ?? '';

            $timeOffapproverDetails = $this->userAccountModel->getUserAccount($timeOffApproverID, null);
            $timeOffApproverName = $timeOffapproverDetails['file_as'] ?? '';

            $this->employeeModel->updateEmployeeWorkInformation($employeeID, $companyID, $companyName, $departmentID, $departmentName, $jobPositionID, $jobPositionName, $workLocationID, $workLocationName, $managerID, $managerName, $workScheduleID, $workScheduleName, $homeWorkDistance, $timeOffApproverID, $timeOffApproverName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Work Information Success',
                'message' => 'The work information has been updated successfully.',
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
    # Function: updateEmployeeHRSettings
    # Description: 
    # Updates the employee HR settings if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmployeeHRSettings() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['pin_code']) && isset($_POST['badge_id']) && isset($_POST['employment_type_id']) && isset($_POST['onboard_date']) && !empty($_POST['onboard_date'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $pinCode = $_POST['pin_code'];
            $badgeID = $_POST['badge_id'];
            $employmentTypeID = htmlspecialchars($_POST['employment_type_id'], ENT_QUOTES, 'UTF-8');
            $onboardDate = $this->systemModel->checkDate('empty', $_POST['onboard_date'], '', 'Y-m-d', '');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update HR Settings Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $employmentTypeDetails = $this->employmentTypeModel->getEmploymentType($employmentTypeID);
            $employmentTypeName = $employmentTypeDetails['employment_type_name'] ?? '';

            $this->employeeModel->updateEmployeeHRSettings($employeeID, $badgeID, $employmentTypeID, $employmentTypeName, $pinCode, $onboardDate, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update HR Settings Success',
                'message' => 'The employee has been updated successfully.',
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
    # Function: updateEmployeeWorkPermit
    # Description: 
    # Updates the employee work permit if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateEmployeeWorkPermit() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['visa_number']) && isset($_POST['visa_expiration_date']) && isset($_POST['work_permit_number']) && isset($_POST['work_permit_expiration_date'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $visaNumber = $_POST['visa_number'];
            $workPermitNumber = $_POST['work_permit_number'];
            $visaExpirationDate = $this->systemModel->checkDate('empty', $_POST['visa_expiration_date'], '', 'Y-m-d', '');
            $workPermitExpirationDate = $this->systemModel->checkDate('empty', $_POST['work_permit_expiration_date'], '', 'Y-m-d', '');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update HR Settings Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employeeModel->updateEmployeeWorkPermit($employeeID, $visaNumber, $workPermitNumber, $visaExpirationDate, $workPermitExpirationDate, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update HR Settings Success',
                'message' => 'The employee has been updated successfully.',
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
    # Function: saveEmployeeExperience
    # Description: 
    # Saves the employee experience if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveEmployeeExperience() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['employee_experience_id']) && isset($_POST['job_title']) && !empty($_POST['job_title']) && isset($_POST['experience_employment_type_id']) && isset($_POST['company_name']) && !empty($_POST['company_name']) && isset($_POST['location']) && isset($_POST['employment_location_type_id']) && isset($_POST['start_experience_date_month']) && !empty($_POST['start_experience_date_month']) && isset($_POST['start_experience_date_year']) && !empty($_POST['start_experience_date_year']) && isset($_POST['end_experience_date_month']) && isset($_POST['end_experience_date_year']) && isset($_POST['job_description']) && !empty($_POST['job_description'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeExperienceID = htmlspecialchars($_POST['employee_experience_id'], ENT_QUOTES, 'UTF-8');
            $jobTitle = $_POST['job_title'];
            $employmentTypeID = htmlspecialchars($_POST['experience_employment_type_id'], ENT_QUOTES, 'UTF-8');
            $companyName = $_POST['company_name'];
            $location = $_POST['location'];
            $employmentLocationTypeID = htmlspecialchars($_POST['employment_location_type_id'], ENT_QUOTES, 'UTF-8');
            $startExperienceDateMonth = $_POST['start_experience_date_month'];
            $startExperienceDateYear = $_POST['start_experience_date_year'];
            $endExperienceDateMonth = $_POST['end_experience_date_month'];
            $endExperienceDateYear = $_POST['end_experience_date_year'];
            $jobDescription = $_POST['job_description'];

            $employmentTypeDetails = $this->employmentTypeModel->getEmploymentType($employmentTypeID);
            $employmentTypeName = $employmentTypeDetails['employment_type_name'] ?? '';

            $employmentLocationTypeDetails = $this->employmentLocationTypeModel->getEmploymentLocationType($employmentLocationTypeID);
            $employmentLocationTypeName = $employmentLocationTypeDetails['employment_location_type_name'] ?? '';
        
            $checkEmployeeExperienceExist = $this->employeeModel->checkEmployeeExperienceExist($employeeExperienceID);
            $total = $checkEmployeeExperienceExist['total'] ?? 0;

            if($total > 0){
                $this->employeeModel->updateEmployeeExperience($employeeExperienceID, $employeeID, $jobTitle, $employmentTypeID, $employmentTypeName, $companyName, $location, $employmentLocationTypeID, $employmentLocationTypeName, $startExperienceDateMonth, $startExperienceDateYear, $endExperienceDateMonth, $endExperienceDateYear, $jobDescription, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update Experience Success',
                    'message' => 'The experience has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->employeeModel->insertEmployeeExperience($employeeID, $jobTitle, $employmentTypeID, $employmentTypeName, $companyName, $location, $employmentLocationTypeID, $employmentLocationTypeName, $startExperienceDateMonth, $startExperienceDateYear, $endExperienceDateMonth, $endExperienceDateYear, $jobDescription, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Experience Success',
                    'message' => 'The experience has been inserted successfully.',
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
    #
    # Function: saveEmployeeEducation
    # Description: 
    # Saves the employee education if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveEmployeeEducation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['employee_education_id']) && isset($_POST['school']) && !empty($_POST['school']) && isset($_POST['degree']) && isset($_POST['field_of_study']) && isset($_POST['start_education_date_month']) && !empty($_POST['start_education_date_month']) && isset($_POST['start_education_date_year']) && !empty($_POST['start_education_date_year']) && isset($_POST['end_education_date_month']) && isset($_POST['end_education_date_year']) && isset($_POST['activities_societies']) && isset($_POST['education_description'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeEducationID = htmlspecialchars($_POST['employee_education_id'], ENT_QUOTES, 'UTF-8');
            $school = $_POST['school'];
            $degree = $_POST['degree'];
            $fieldOfStudy = $_POST['field_of_study'];
            $startEducationDateMonth = $_POST['start_education_date_month'];
            $startEducationDateYear = $_POST['start_education_date_year'];
            $endEducationDateMonth = $_POST['end_education_date_month'];
            $endEducationDateYear = $_POST['end_education_date_year'];
            $activitiesSocieties = $_POST['activities_societies'];
            $educationDescription = $_POST['education_description'];
        
            $checkEmployeeEducationExist = $this->employeeModel->checkEmployeeEducationExist($employeeEducationID);
            $total = $checkEmployeeEducationExist['total'] ?? 0;

            if($total > 0){
                $this->employeeModel->updateEmployeeEducation($employeeEducationID, $employeeID, $school, $degree, $fieldOfStudy, $startEducationDateMonth, $startEducationDateYear, $endEducationDateMonth, $endEducationDateYear, $activitiesSocieties, $educationDescription, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update Education Success',
                    'message' => 'The education has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->employeeModel->insertEmployeeEducation($employeeID, $school, $degree, $fieldOfStudy, $startEducationDateMonth, $startEducationDateYear, $endEducationDateMonth, $endEducationDateYear, $activitiesSocieties, $educationDescription, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Education Success',
                    'message' => 'The education has been inserted successfully.',
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
    #
    # Function: saveEmployeeAddress
    # Description: 
    # Saves the employee address if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveEmployeeAddress() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['employee_address_id']) && isset($_POST['address_type_id']) && !empty($_POST['address_type_id']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['address']) && !empty($_POST['address']) ) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeAddressID = htmlspecialchars($_POST['employee_address_id'], ENT_QUOTES, 'UTF-8');
            $addressTypeID = htmlspecialchars($_POST['address_type_id'], ENT_QUOTES, 'UTF-8');
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $address = $_POST['address'];

            $addressTypeDetails = $this->addressTypeModel->getAddressType($addressTypeID);
            $addressTypeName = $addressTypeDetails['address_type_name'];

            $cityDetails = $this->cityModel->getCity($cityID);
            $cityName = $cityDetails['city_name'] ?? null;
            $stateID = $cityDetails['state_id'] ?? null;
            $countryID = $cityDetails['country_id'] ?? null;

            $stateDetails = $this->stateModel->getState($stateID);
            $stateName = $stateDetails['state_name'] ?? null;

            $countryDetails = $this->countryModel->getCountry($countryID);
            $countryName = $countryDetails['country_name'] ?? null;
        
            $checkEmployeeAddressExist = $this->employeeModel->checkEmployeeAddressExist($employeeAddressID);
            $total = $checkEmployeeAddressExist['total'] ?? 0;

            if($total > 0){
                $this->employeeModel->updateEmployeeAddress($employeeAddressID, $employeeID, $addressTypeID, $addressTypeName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update Address Success',
                    'message' => 'The address has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->employeeModel->insertEmployeeAddress($employeeID, $addressTypeID, $addressTypeName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Address Success',
                    'message' => 'The address has been inserted successfully.',
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
    #
    # Function: saveEmployeeBankAccount
    # Description: 
    # Saves the employee bank account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveEmployeeBankAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['employee_id']) && !empty($_POST['employee_id']) && isset($_POST['employee_bank_account_id']) && isset($_POST['bank_id']) && !empty($_POST['bank_id']) && isset($_POST['bank_account_type_id']) && !empty($_POST['bank_account_type_id']) && isset($_POST['account_number']) && !empty($_POST['account_number']) ) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeBankAccountID = htmlspecialchars($_POST['employee_bank_account_id'], ENT_QUOTES, 'UTF-8');
            $bankID = htmlspecialchars($_POST['bank_id'], ENT_QUOTES, 'UTF-8');
            $bankAccountTypeID = htmlspecialchars($_POST['bank_account_type_id'], ENT_QUOTES, 'UTF-8');
            $accountNumber = $_POST['account_number'];

            $bankDetails = $this->bankModel->getBank($bankID);
            $bankName = $bankDetails['bank_name'];

            $bankAccountTypeDetails = $this->bankAccountTypeModel->getBankAccountType($bankAccountTypeID);
            $bankAccountTypeName = $bankAccountTypeDetails['bank_account_type_name'];
        
            $checkEmployeeBankAccountExist = $this->employeeModel->checkEmployeeBankAccountExist($employeeBankAccountID);
            $total = $checkEmployeeBankAccountExist['total'] ?? 0;

            if($total > 0){
                $this->employeeModel->updateEmployeeBankAccount($employeeBankAccountID, $employeeID, $bankID, $bankName, $bankAccountTypeID, $bankAccountTypeName, $accountNumber, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update Bank Account Success',
                    'message' => 'The bank account has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->employeeModel->insertEmployeeBankAccount($employeeID, $bankID, $bankName, $bankAccountTypeID, $bankAccountTypeName, $accountNumber, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Bank Account Success',
                    'message' => 'The bank account has been inserted successfully.',
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
    # Function: deleteEmployeeExperience
    # Description: 
    # Delete the employee experience if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteEmployeeExperience() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeExperienceID = htmlspecialchars($_POST['employee_experience_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Experience Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkEmployeeExperienceExist = $this->employeeModel->checkEmployeeExperienceExist($employeeExperienceID);
            $total = $checkEmployeeExperienceExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Experience Error',
                    'message' => 'The experience does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employeeModel->deleteEmployeeExperience($employeeExperienceID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Experience Success',
                'message' => 'The experience has been deleted successfully.',
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
    # Function: deleteEmployeeEducation
    # Description: 
    # Delete the employee education if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteEmployeeEducation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeEducationID = htmlspecialchars($_POST['employee_education_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Education Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkEmployeeEducationExist = $this->employeeModel->checkEmployeeEducationExist($employeeEducationID);
            $total = $checkEmployeeEducationExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Education Error',
                    'message' => 'The education does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employeeModel->deleteEmployeeEducation($employeeEducationID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Education Success',
                'message' => 'The education has been deleted successfully.',
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
    # Function: deleteEmployeeAddress
    # Description: 
    # Delete the employee address if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteEmployeeAddress() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeAddressID = htmlspecialchars($_POST['employee_address_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Address Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkEmployeeAddressExist = $this->employeeModel->checkEmployeeAddressExist($employeeAddressID);
            $total = $checkEmployeeAddressExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Address Error',
                    'message' => 'The address does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employeeModel->deleteEmployeeAddress($employeeAddressID, $employeeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Address Success',
                'message' => 'The address has been deleted successfully.',
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
    # Function: deleteEmployeeBankAccount
    # Description: 
    # Delete the employee bank account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteEmployeeBankAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeBankAccountID = htmlspecialchars($_POST['employee_bank_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Bank Account Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkEmployeeBankAccountExist = $this->employeeModel->checkEmployeeBankAccountExist($employeeBankAccountID);
            $total = $checkEmployeeBankAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Bank Account Error',
                    'message' => 'The bank account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->employeeModel->deleteEmployeeBankAccount($employeeBankAccountID, $employeeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Bank Account Success',
                'message' => 'The bank account has been deleted successfully.',
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
    # Function: getAboutDetails
    # Description: 
    # Handles the retrieval of employee about details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getAboutDetails() {
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
                    'title' => 'Get About Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeDetails = $this->employeeModel->getEmployee($employeeID);

            $response = [
                'success' => true,
                'about' => $employeeDetails['about'] ?? null
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
    # Function: getPrivateInformationDetails
    # Description: 
    # Handles the retrieval of employee private information details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getPrivateInformationDetails() {
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
                    'title' => 'Get Private Information Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeDetails = $this->employeeModel->getEmployee($employeeID);

            $response = [
                'success' => true,
                'fullName' => $employeeDetails['full_name'] ?? null,
                'firstName' => $employeeDetails['first_name'] ?? null,
                'middleName' => $employeeDetails['middle_name'] ?? null,
                'lastName' => $employeeDetails['last_name'] ?? null,
                'suffix' => $employeeDetails['suffix'] ?? null,
                'nickname' => $employeeDetails['nickname'] ?? null,
                'civilStatusID' => $employeeDetails['civil_status_id'] ?? null,
                'civilStatusName' => $employeeDetails['civil_status_name'] ?? null,
                'genderID' => $employeeDetails['gender_id'] ?? null,
                'genderName' => $employeeDetails['gender_name'] ?? null,
                'religionID' => $employeeDetails['religion_id'] ?? null,
                'religionName' => $employeeDetails['religion_name'] ?? null,
                'bloodTypeID' => $employeeDetails['blood_type_id'] ?? null,
                'bloodTypeName' => $employeeDetails['blood_type_name'] ?? null,
                'birthday' => $this->systemModel->checkDate('empty', $employeeDetails['birthday'], '', 'm/d/Y', ''),
                'birthPlace' => $employeeDetails['birth_place'] ?? null,
                'height' => $employeeDetails['height'] ?? null,
                'weight' => $employeeDetails['weight'] ?? null
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
    # Function: getWorkInformationDetails
    # Description: 
    # Handles the retrieval of employee work information details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getWorkInformationDetails() {
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
                    'title' => 'Get Work Information Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeDetails = $this->employeeModel->getEmployee($employeeID);

            $response = [
                'success' => true,
                'companyID' => $employeeDetails['company_id'] ?? null,
                'companyName' => $employeeDetails['company_name'] ?? null,
                'departmentID' => $employeeDetails['department_id'] ?? null,
                'departmentName' => $employeeDetails['department_name'] ?? null,
                'jobPositionID' => $employeeDetails['job_position_id'] ?? null,
                'jobPositionName' => $employeeDetails['job_position_name'] ?? null,
                'workLocationID' => $employeeDetails['work_location_id'] ?? null,
                'workLocationName' => $employeeDetails['work_location_name'] ?? null,
                'managerID' => $employeeDetails['manager_id'] ?? null,
                'managerName' => $employeeDetails['manager_name'] ?? null,
                'workScheduleID' => $employeeDetails['work_schedule_id'] ?? null,
                'workScheduleName' => $employeeDetails['work_schedule_name'] ?? null,
                'homeWorkDistance' => $employeeDetails['home_work_distance'] ?? null,
                'timeOffApproverID' => $employeeDetails['time_off_approver_id'] ?? null,
                'timeOffApproverName' => $employeeDetails['time_off_approver_name'] ?? null
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
    # Function: getHRSettingsDetails
    # Description: 
    # Handles the retrieval of employee HR settings details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getHRSettingsDetails() {
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
                    'title' => 'Get HR Settings Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeDetails = $this->employeeModel->getEmployee($employeeID);

            $response = [
                'success' => true,
                'badgeID' => $employeeDetails['badge_id'] ?? null,
                'employmentTypeID' => $employeeDetails['employment_type_id'] ?? null,
                'employmentTypeName' => $employeeDetails['employment_type_name'] ?? null,
                'pinCode' => $employeeDetails['pin_code'] ?? null,
                'onboardDate' => $this->systemModel->checkDate('empty', $employeeDetails['onboard_date'], '', 'm/d/Y', '')
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
    # Function: getWorkPermitDetails
    # Description: 
    # Handles the retrieval of employee work permit details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getWorkPermitDetails() {
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
                    'title' => 'Get HR Settings Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeDetails = $this->employeeModel->getEmployee($employeeID);

            $response = [
                'success' => true,
                'visaNumber' => $employeeDetails['visa_number'] ?? null,
                'workPermitNumber' => $employeeDetails['work_permit_number'] ?? null,
                'visaExpirationDate' => $this->systemModel->checkDate('empty', $employeeDetails['visa_expiration_date'], '', 'm/d/Y', ''),
                'workPermitExpirationDate' => $this->systemModel->checkDate('empty', $employeeDetails['work_permit_expiration_date'], '', 'm/d/Y', '')
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
    # Function: getEmployeeExperienceDetails
    # Description: 
    # Handles the retrieval of employee experience details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getEmployeeExperienceDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['employee_experience_id']) && !empty($_POST['employee_experience_id']) && isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeExperienceID = htmlspecialchars($_POST['employee_experience_id'], ENT_QUOTES, 'UTF-8');

            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Experience Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeExperienceDetails = $this->employeeModel->getEmployeeExperience($employeeExperienceID);

            $response = [
                'success' => true,
                'jobTitle' => $employeeExperienceDetails['job_title'] ?? null,
                'employmentTypeID' => $employeeExperienceDetails['employment_type_id'] ?? null,
                'companyName' => $employeeExperienceDetails['company_name'] ?? null,
                'location' => $employeeExperienceDetails['location'] ?? null,
                'employmentLocationTypeID' => $employeeExperienceDetails['employment_location_type_id'] ?? null,
                'startMonth' => $employeeExperienceDetails['start_month'] ?? null,
                'startYear' => $employeeExperienceDetails['start_year'] ?? null,
                'endMonth' => $employeeExperienceDetails['end_month'] ?? null,
                'endYear' => $employeeExperienceDetails['end_year'] ?? null,
                'jobDescription' => $employeeExperienceDetails['job_description'] ?? null
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
    # Function: getEmployeeEducationDetails
    # Description: 
    # Handles the retrieval of employee education details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getEmployeeEducationDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['employee_education_id']) && !empty($_POST['employee_education_id']) && isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeEducationID = htmlspecialchars($_POST['employee_education_id'], ENT_QUOTES, 'UTF-8');

            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Education Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeEducationDetails = $this->employeeModel->getEmployeeEducation($employeeEducationID);

            $response = [
                'success' => true,
                'school' => $employeeEducationDetails['school'] ?? null,
                'degree' => $employeeEducationDetails['degree'] ?? null,
                'fieldOfStudy' => $employeeEducationDetails['field_of_study'] ?? null,
                'startMonth' => $employeeEducationDetails['start_month'] ?? null,
                'startYear' => $employeeEducationDetails['start_year'] ?? null,
                'endMonth' => $employeeEducationDetails['end_month'] ?? null,
                'endYear' => $employeeEducationDetails['end_year'] ?? null,
                'activitiesSocieties' => $employeeEducationDetails['activities_societies'] ?? null,
                'educationDescription' => $employeeEducationDetails['education_description'] ?? null
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
    # Function: getEmployeeAddressDetails
    # Description: 
    # Handles the retrieval of employee address details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getEmployeeAddressDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['employee_address_id']) && !empty($_POST['employee_address_id']) && isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeAddressID = htmlspecialchars($_POST['employee_address_id'], ENT_QUOTES, 'UTF-8');

            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Address Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeAddressDetails = $this->employeeModel->getEmployeeAddress($employeeAddressID);

            $response = [
                'success' => true,
                'address' => $employeeAddressDetails['address'] ?? null,
                'addressTypeID' => $employeeAddressDetails['address_type_id'] ?? null,
                'address' => $employeeAddressDetails['address'] ?? null,
                'cityID' => $employeeAddressDetails['city_id'] ?? null
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
    # Function: getEmployeeBankAccountDetails
    # Description: 
    # Handles the retrieval of employee bank account details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getEmployeeBankAccountDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['employee_bank_account_id']) && !empty($_POST['employee_bank_account_id']) && isset($_POST['employee_id']) && !empty($_POST['employee_id'])) {
            $userID = $_SESSION['user_account_id'];
            $employeeID = htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8');
            $employeeBankAccountID = htmlspecialchars($_POST['employee_bank_account_id'], ENT_QUOTES, 'UTF-8');

            $checkEmployeeExist = $this->employeeModel->checkEmployeeExist($employeeID);
            $total = $checkEmployeeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Bank Account Details Error',
                    'message' => 'The employee does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $employeeBankAccountDetails = $this->employeeModel->getEmployeeBankAccount($employeeBankAccountID);

            $response = [
                'success' => true,
                'bankID' => $employeeBankAccountDetails['bank_id'] ?? null,
                'bankAccountTypeID' => $employeeBankAccountDetails['bank_account_type_id'] ?? null,
                'accountNumber' => $employeeBankAccountDetails['account_number'] ?? null
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
require_once '../../employee/model/employee-model.php';
require_once '../../gender/model/gender-model.php';
require_once '../../religion/model/religion-model.php';
require_once '../../blood-type/model/blood-type-model.php';
require_once '../../civil-status/model/civil-status-model.php';
require_once '../../company/model/company-model.php';
require_once '../../employment-type/model/employment-type-model.php';
require_once '../../department/model/department-model.php';
require_once '../../job-position/model/job-position-model.php';
require_once '../../work-location/model/work-location-model.php';
require_once '../../work-schedule/model/work-schedule-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../employment-location-type/model/employment-location-type-model.php';
require_once '../../address-type/model/address-type-model.php';
require_once '../../city/model/city-model.php';
require_once '../../state/model/state-model.php';
require_once '../../country/model/country-model.php';
require_once '../../bank/model/bank-model.php';
require_once '../../bank-account-type/model/bank-account-type-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new EmployeeController(new EmployeeModel(new DatabaseModel), new GenderModel(new DatabaseModel), new ReligionModel(new DatabaseModel), new BloodTypeModel(new DatabaseModel), new CivilStatusModel(new DatabaseModel), new CompanyModel(new DatabaseModel), new EmploymentTypeModel(new DatabaseModel), new DepartmentModel(new DatabaseModel), new JobPositionModel(new DatabaseModel), new WorkLocationModel(new DatabaseModel), new WorkScheduleModel(new DatabaseModel), new UserAccountModel(new DatabaseModel), new EmploymentLocationTypeModel(new DatabaseModel), new AddressTypeModel(new DatabaseModel), new CityModel(new DatabaseModel), new StateModel(new DatabaseModel), new CountryModel(new DatabaseModel), new BankModel(new DatabaseModel), new BankAccountTypeModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>