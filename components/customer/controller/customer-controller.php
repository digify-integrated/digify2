<?php
session_start();

# -------------------------------------------------------------
#
# Function: CustomerController
# Description: 
# The CustomerController class handles customer related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class CustomerController {
    private $customerModel;
    private $genderModel;
    private $civilStatusModel;
    private $uploadSettingModel;
    private $userAccountModel;
    private $addressTypeModel;
    private $cityModel;
    private $stateModel;
    private $countryModel;
    private $idTypeModel;
    private $bankModel;
    private $bankAccountTypeModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided customerModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for customer related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param CustomerModel $customerModel     The customerModel instance for customer related operations.
    # - @param GenderModel $genderModel     The GenderModel instance for gender operations.
    # - @param CivilStatusModel $civilStatusModel     The CivilStatusModel instance for civil status operations.
    # - @param UserAccountModel $userAccountModel     The UserAccountModel instance for user account operations.
    # - @param AddressTypeModel $addressTypeModel     The addressTypeModel instance for address type related operations.
    # - @param CityModel $cityModel     The cityModel instance for city related operations.
    # - @param StateModel $stateModel     The stateModel instance for state related operations.
    # - @param CountryModel $countryModel     The countryModel instance for country related operations.
    # - @param IDTypeModel $idTypeModel     The idTypeModel instance for ID type related operations.
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
    public function __construct(CustomerModel $customerModel, GenderModel $genderModel, CivilStatusModel $civilStatusModel, UserAccountModel $userAccountModel, AddressTypeModel $addressTypeModel, CityModel $cityModel, StateModel $stateModel, CountryModel $countryModel, IDTypeModel $idTypeModel, BankModel $bankModel, BankAccountTypeModel $bankAccountTypeModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->customerModel = $customerModel;
        $this->genderModel = $genderModel;
        $this->civilStatusModel = $civilStatusModel;
        $this->userAccountModel = $userAccountModel;
        $this->addressTypeModel = $addressTypeModel;
        $this->cityModel = $cityModel;
        $this->stateModel = $stateModel;
        $this->countryModel = $countryModel;
        $this->idTypeModel = $idTypeModel;
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
                case 'add customer':
                    $this->addCustomer();
                    break;
                case 'update customer about':
                    $this->updateCustomerAbout();
                    break;
                case 'update customer private information':
                    $this->updateCustomerPrivateInformation();
                    break;
                case 'set customer address as default':
                    $this->updateCustomerAddressDefault();
                    break;
                case 'set customer bank card as default':
                    $this->updateCustomerBankCardDefault();
                    break;
                case 'update customer image':
                    $this->updateCustomerImage();
                    break;
                case 'update customer id record image':
                    $this->updateCustomerIDRecordImage();
                    break;
                case 'save customer address':
                    $this->saveCustomerAddress();
                    break;
                case 'save customer bank account':
                    $this->saveCustomerBankAccount();
                    break;
                case 'save customer bank card':
                    $this->saveCustomerBankCard();
                    break;
                case 'save customer id record':
                    $this->saveCustomerIDRecord();
                    break;
                case 'get about details':
                    $this->getAboutDetails();
                    break;
                case 'get customer image details':
                    $this->getCustomerImageDetails();
                    break;
                case 'get private information details':
                    $this->getPrivateInformationDetails();
                    break;
                case 'get customer address details':
                    $this->getCustomerAddressDetails();
                    break;
                case 'get customer bank account details':
                    $this->getCustomerBankAccountDetails();
                    break;
                case 'get customer bank card details':
                    $this->getCustomerBankCardDetails();
                    break;
                case 'get customer id record details':
                    $this->getCustomerIDRecordDetails();
                    break;
                case 'delete customer':
                    $this->deleteCustomer();
                    break;
                case 'delete multiple customer':
                    $this->deleteMultipleCustomer();
                    break;
                case 'delete customer address':
                    $this->deleteCustomerAddress();
                    break;
                case 'delete customer bank account':
                    $this->deleteCustomerBankAccount();
                    break;
                case 'delete customer bank card':
                    $this->deleteCustomerBankCard();
                    break;
                case 'delete customer id record':
                    $this->deleteCustomerIDRecord();
                    break;
                case 'archive customer':
                    $this->archiveCustomer();
                    break;
                case 'unarchive customer':
                    $this->unarchiveCustomer();
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
    # Function: addCustomer
    # Description: 
    # Inserts a customer.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCustomer() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['first_name']) && !empty($_POST['first_name']) && isset($_POST['middle_name']) && isset($_POST['last_name']) && !empty($_POST['last_name']) && isset($_POST['suffix']) && isset($_POST['nickname']) && isset($_POST['gender_id']) && isset($_POST['civil_status_id']) && isset($_POST['birthday']) && isset($_POST['birth_place'])) {
            $userID = $_SESSION['user_account_id'];
            $firstName = $_POST['first_name'];
            $middleName = $_POST['middle_name'];
            $lastName = $_POST['last_name'];
            $suffix = $_POST['suffix'];
            $nickname = $_POST['nickname'];
            $birthPlace = $_POST['birth_place'];
            $genderID = htmlspecialchars($_POST['gender_id'], ENT_QUOTES, 'UTF-8');
            $civilStatusID = htmlspecialchars($_POST['civil_status_id'], ENT_QUOTES, 'UTF-8');
            $birthday = $this->systemModel->checkDate('empty', $_POST['birthday'], '', 'Y-m-d', '');

            $fullNameParts = array_filter([$firstName, $middleName, $lastName]);
            $fullName = implode(' ', $fullNameParts);

            if (!empty($suffix)) {
                $fullName .= ', ' . $suffix;
            }

            $civilStatusDetails = $this->civilStatusModel->getCivilStatus($civilStatusID);
            $civilStatusName = $civilStatusDetails['civil_status_name'] ?? '';

            $genderDetails = $this->genderModel->getGender($genderID);
            $genderName = $genderDetails['gender_name'] ?? '';

            $customerID = $this->customerModel->insertCustomer($fullName, $firstName, $middleName, $lastName, $suffix, $nickname, $civilStatusID, $civilStatusName, $genderID, $genderName, $birthday, $birthPlace, $userID);
            
            $response = [
                'success' => true,
                'customerID' => $this->securityModel->encryptData($customerID),
                'title' => 'Insert Customer Success',
                'message' => 'The customer has been inserted successfully.',
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
    # Function: updateCustomerAbout
    # Description: 
    # Updates the customer about if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCustomerAbout() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['about']) && !empty($_POST['about'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $about = $_POST['about'];
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update About Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerModel->updateCustomerAbout($customerID, $about, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update About Success',
                'message' => 'The customer has been updated successfully.',
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
    # Function: updateCustomerPrivateInformation
    # Description: 
    # Updates the customer private information if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCustomerPrivateInformation() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['first_name']) && !empty($_POST['first_name']) && isset($_POST['last_name']) && !empty($_POST['last_name']) && isset($_POST['middle_name']) && isset($_POST['suffix']) && isset($_POST['nickname']) && isset($_POST['gender_id']) && !empty($_POST['gender_id']) && isset($_POST['civil_status_id']) && !empty($_POST['civil_status_id']) && isset($_POST['birthday']) && !empty($_POST['birthday']) && isset($_POST['birth_place']) && !empty($_POST['birth_place'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $firstName = $_POST['first_name'];
            $lastName = $_POST['last_name'];
            $middleName = $_POST['middle_name'];
            $suffix = $_POST['suffix'];
            $nickname = $_POST['nickname'];
            $genderID = htmlspecialchars($_POST['gender_id'], ENT_QUOTES, 'UTF-8');
            $civilStatusID = htmlspecialchars($_POST['civil_status_id'], ENT_QUOTES, 'UTF-8');
            $birthday = $this->systemModel->checkDate('empty', $_POST['birthday'], '', 'Y-m-d', '');
            $birthPlace = $_POST['birth_place'];
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Private Information Error',
                    'message' => 'The customer does not exist.',
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

            $this->customerModel->updateCustomerPrivateInformation($customerID, $fullName, $firstName, $middleName, $lastName, $suffix, $nickname, $civilStatusID, $civilStatusName, $genderID, $genderName, $birthday, $birthPlace, $userID);
                
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
    # Function: updateCustomerAddressDefault
    # Description: 
    # Updates the customer address default if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCustomerAddressDefault() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerAddressID = htmlspecialchars($_POST['customer_address_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tagging Address As Default Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkCustomerAddressExist = $this->customerModel->checkCustomerAddressExist($customerAddressID);
            $total = $checkCustomerAddressExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tagging Address As Default Error',
                    'message' => 'The address does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerModel->updateCustomerAddressDefault($customerAddressID, $customerID, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tagging Address To Default Success',
                'message' => 'The address has been tagged as default successfully.',
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
    # Function: updateCustomerBankCardDefault
    # Description: 
    # Updates the customer bank card default if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCustomerBankCardDefault() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerBankCardID = htmlspecialchars($_POST['customer_bank_card_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tagging Bank Card As Default Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkCustomerBankCardExist = $this->customerModel->checkCustomerBankCardExist($customerBankCardID);
            $total = $checkCustomerBankCardExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Tagging Bank Card As Default Error',
                    'message' => 'The bank card does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerModel->updateCustomerBankCardDefault($customerBankCardID, $customerID, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Tagging Bank Card To Default Success',
                'message' => 'The bank card has been tagged as default successfully.',
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
    # Function: updateCustomerIDRecordImage
    # Description: 
    # Saves the customer ID record image if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCustomerIDRecordImage() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_id_record_id']) && !empty($_POST['customer_id_record_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerIDRecordID = htmlspecialchars($_POST['customer_id_record_id'], ENT_QUOTES, 'UTF-8');
           
            $checkCustomerIDRecordExist = $this->customerModel->checkCustomerIDRecordExist($customerIDRecordID);
            $total = $checkCustomerIDRecordExist['total'] ?? 0;

            if($total > 0){
                $idRecordFileName = $_FILES['id_image']['name'];
                $idRecordFileSize = $_FILES['id_image']['size'];
                $idRecordFileError = $_FILES['id_image']['error'];
                $idRecordTempName = $_FILES['id_image']['tmp_name'];
                $idRecordFileExtension = explode('.', $idRecordFileName);
                $idRecordActualFileExtension = strtolower(end($idRecordFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(4);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(4);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($idRecordActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Upload ID Record Image Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($idRecordTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Upload ID Record Image Error',
                        'message' => 'Please choose the ID record image.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($idRecordFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Upload ID Record Image Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($idRecordFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Upload ID Record Image Error',
                        'message' => 'The ID record image exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $idRecordActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('ID_RECORD_DIR', 'id-record/');
    
                $directory = PROJECT_BASE_DIR . '/image/' .  $customerID . '/'. ID_RECORD_DIR. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/customer/image/'. $customerID . '/id-record/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Upload ID Record Image Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $customerIDRecordDetails = $this->customerModel->getCustomerIDRecord($customerIDRecordID);
                $idRecordPath = !empty($customerIDRecordDetails['id_image']) ? str_replace('./components/', '../../', $customerIDRecordDetails['id_image']) : null;
    
                if(file_exists($idRecordPath)){
                    if (!unlink($idRecordPath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Upload ID Record Image Error',
                            'message' => 'The ID record image cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
    
                if(!move_uploaded_file($idRecordTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Upload ID Record Image Error',
                        'message' => 'The ID record image cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                $this->customerModel->updateCustomerIDRecordImage($customerIDRecordID, $filePath, $userID);

                $response = [
                    'success' => true,
                    'title' => 'Upload ID Record Image Success',
                    'message' => 'The ID record has been uploaded successfully.',
                    'messageType' => 'success'
                ];
    
                echo json_encode($response);
                exit;
            }
            else{
                $response = [
                    'success' => false,
                    'title' => 'Upload ID Record Image Error',
                    'message' => 'The ID record does not exist.',
                    'messageType' => 'error'
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
    # Function: updateCustomerImage
    # Description: 
    # Saves the customer image if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCustomerImage() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
           
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total > 0){
                $customerImageFileName = $_FILES['customer_image']['name'];
                $customerImageFileSize = $_FILES['customer_image']['size'];
                $customerImageFileError = $_FILES['customer_image']['error'];
                $customerImageTempName = $_FILES['customer_image']['tmp_name'];
                $customerImageFileExtension = explode('.', $customerImageFileName);
                $customerImageActualFileExtension = strtolower(end($customerImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(3);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(3);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($customerImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Upload Customer Image Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($customerImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Upload Customer Image Error',
                        'message' => 'Please choose the customer image.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($customerImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Upload Customer Image Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($customerImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Upload Customer Image Error',
                        'message' => 'The customer image exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $customerImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('ID_RECORD_DIR', 'profile/');
    
                $directory = PROJECT_BASE_DIR . '/image/' .  $customerID . '/'. ID_RECORD_DIR. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/customer/image/'. $customerID . '/profile/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Upload Customer Image Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $customerDetails = $this->customerModel->getCustomer($customerID);
                $customerImagePath = !empty($customerDetails['customer_image']) ? str_replace('./components/', '../../', $customerDetails['customer_image']) : null;
    
                if(file_exists($customerImagePath)){
                    if (!unlink($customerImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Upload Customer Image Error',
                            'message' => 'The customer image cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
    
                if(!move_uploaded_file($customerImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Upload Customer Image Error',
                        'message' => 'The customer image cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                $this->customerModel->updateCustomerImage($customerID, $filePath, $userID);

                $response = [
                    'success' => true,
                    'title' => 'Upload Customer Image Success',
                    'message' => 'The customer image has been uploaded successfully.',
                    'messageType' => 'success'
                ];
    
                echo json_encode($response);
                exit;
            }
            else{
                $response = [
                    'success' => false,
                    'title' => 'Upload Customer Image Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
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
    #   Save methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: saveCustomerAddress
    # Description: 
    # Saves the customer address if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveCustomerAddress() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_address_id']) && isset($_POST['address_type_id']) && !empty($_POST['address_type_id']) && isset($_POST['city_id']) && !empty($_POST['city_id']) && isset($_POST['address']) && !empty($_POST['address']) ) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerAddressID = htmlspecialchars($_POST['customer_address_id'], ENT_QUOTES, 'UTF-8');
            $addressTypeID = htmlspecialchars($_POST['address_type_id'], ENT_QUOTES, 'UTF-8');
            $cityID = htmlspecialchars($_POST['city_id'], ENT_QUOTES, 'UTF-8');
            $address = $_POST['address'];
            $telephone = $_POST['customer_address_telephone'];
            $mobile = $_POST['customer_address_mobile'];
            $email = $_POST['contact_information_email'];

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
        
            $checkCustomerAddressExist = $this->customerModel->checkCustomerAddressExist($customerAddressID);
            $total = $checkCustomerAddressExist['total'] ?? 0;

            if($total > 0){
                $this->customerModel->updateCustomerAddress($customerAddressID, $customerID, $addressTypeID, $addressTypeName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $telephone, $mobile, $email, $userID);
                
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
                $this->customerModel->insertCustomerAddress($customerID, $addressTypeID, $addressTypeName, $address, $cityID, $cityName, $stateID, $stateName, $countryID, $countryName, $telephone, $mobile, $email, $userID);
                
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
    # Function: saveCustomerBankAccount
    # Description: 
    # Saves the customer bank account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveCustomerBankAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_bank_account_id']) && isset($_POST['bank_id']) && !empty($_POST['bank_id']) && isset($_POST['bank_account_type_id']) && !empty($_POST['bank_account_type_id']) && isset($_POST['account_number']) && !empty($_POST['account_number']) ) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerBankAccountID = htmlspecialchars($_POST['customer_bank_account_id'], ENT_QUOTES, 'UTF-8');
            $bankID = htmlspecialchars($_POST['bank_id'], ENT_QUOTES, 'UTF-8');
            $bankAccountTypeID = htmlspecialchars($_POST['bank_account_type_id'], ENT_QUOTES, 'UTF-8');
            $accountNumber = $_POST['account_number'];

            $bankDetails = $this->bankModel->getBank($bankID);
            $bankName = $bankDetails['bank_name'];

            $bankAccountTypeDetails = $this->bankAccountTypeModel->getBankAccountType($bankAccountTypeID);
            $bankAccountTypeName = $bankAccountTypeDetails['bank_account_type_name'];
        
            $checkCustomerBankAccountExist = $this->customerModel->checkCustomerBankAccountExist($customerBankAccountID);
            $total = $checkCustomerBankAccountExist['total'] ?? 0;

            if($total > 0){
                $this->customerModel->updateCustomerBankAccount($customerBankAccountID, $customerID, $bankID, $bankName, $bankAccountTypeID, $bankAccountTypeName, $accountNumber, $userID);
                
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
                $this->customerModel->insertCustomerBankAccount($customerID, $bankID, $bankName, $bankAccountTypeID, $bankAccountTypeName, $accountNumber, $userID);
                
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
    #
    # Function: saveCustomerBankCard
    # Description: 
    # Saves the customer bank account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveCustomerBankCard() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_bank_card_id']) && isset($_POST['name_on_card']) && !empty($_POST['name_on_card']) && isset($_POST['card_number']) && !empty($_POST['card_number']) && isset($_POST['expiry_date']) && !empty($_POST['expiry_date']) && isset($_POST['cvv']) && !empty($_POST['cvv'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerBankCardID = htmlspecialchars($_POST['customer_bank_card_id'], ENT_QUOTES, 'UTF-8');
            $nameOnCard = $this->securityModel->encryptData($_POST['name_on_card']);
            $cardNumber = $this->securityModel->encryptData($_POST['card_number']);
            $expiryDate = $this->securityModel->encryptData($_POST['expiry_date']);
            $cvv = $this->securityModel->encryptData($_POST['cvv']);
        
            $checkCustomerBankCardExist = $this->customerModel->checkCustomerBankCardExist($customerBankCardID);
            $total = $checkCustomerBankCardExist['total'] ?? 0;

            if($total > 0){
                $this->customerModel->updateCustomerBankCard($customerBankCardID, $customerID, $nameOnCard, $cardNumber, $expiryDate, $cvv, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update Bank Card Success',
                    'message' => 'The bank card has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->customerModel->insertCustomerBankCard($customerID, $nameOnCard, $cardNumber, $expiryDate, $cvv, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Bank Card Success',
                    'message' => 'The bank card has been inserted successfully.',
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
    # Function: saveCustomerIDRecord
    # Description: 
    # Saves the customer ID record if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveCustomerIDRecord() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_id_record_id']) && isset($_POST['id_type_id']) && !empty($_POST['id_type_id']) && isset($_POST['id_number']) && !empty($_POST['id_number']) && isset($_POST['id_issue_date']) && !empty($_POST['id_issue_date']) && isset($_POST['id_expiration_date'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerIDRecordID = htmlspecialchars($_POST['customer_id_record_id'], ENT_QUOTES, 'UTF-8');
            $idTypeID = htmlspecialchars($_POST['id_type_id'], ENT_QUOTES, 'UTF-8');
            $issueDate = $this->systemModel->checkDate('empty', $_POST['id_issue_date'], '', 'Y-m-d', '');
            $expirationDate = $this->systemModel->checkDate('empty', $_POST['id_expiration_date'], '', 'Y-m-d', '');
            $idNumber = $_POST['id_number'];
            $issuingAuthority = $_POST['issuing_authority'];

            $idTypeDetails = $this->idTypeModel->getIDType($idTypeID);
            $idTypeName = $idTypeDetails['id_type_name'] ?? null;
        
            $checkCustomerIDRecordExist = $this->customerModel->checkCustomerIDRecordExist($customerIDRecordID);
            $total = $checkCustomerIDRecordExist['total'] ?? 0;

            if($total > 0){
                $this->customerModel->updateCustomerIDRecord($customerIDRecordID, $customerID, $idTypeID, $idTypeName, $idNumber, $issueDate, $expirationDate, $issuingAuthority, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update ID Record Success',
                    'message' => 'The ID record has been updated successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                $this->customerModel->insertCustomerIDRecord($customerID, $idTypeID, $idTypeName, $idNumber, $issueDate, $expirationDate, $issuingAuthority, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert ID Record Success',
                    'message' => 'The ID record has been inserted successfully.',
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
    # Function: deleteCustomer
    # Description: 
    # Delete the customer if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCustomer() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Customer Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerModel->deleteCustomer($customerID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Customer Success',
                'message' => 'The customer has been deleted successfully.',
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
    # Function: deleteCustomerAddress
    # Description: 
    # Delete the customer address if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCustomerAddress() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_address_id']) && !empty($_POST['customer_address_id'])) {
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerAddressID = htmlspecialchars($_POST['customer_address_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Address Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkCustomerAddressExist = $this->customerModel->checkCustomerAddressExist($customerAddressID);
            $total = $checkCustomerAddressExist['total'] ?? 0;

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

            $this->customerModel->deleteCustomerAddress($customerAddressID, $customerID);
                
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
    # Function: deleteCustomerBankAccount
    # Description: 
    # Delete the customer bank account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCustomerBankAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_bank_account_id']) && !empty($_POST['customer_bank_account_id'])) {
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerBankAccountID = htmlspecialchars($_POST['customer_bank_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Bank Account Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkCustomerBankAccountExist = $this->customerModel->checkCustomerBankAccountExist($customerBankAccountID);
            $total = $checkCustomerBankAccountExist['total'] ?? 0;

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

            $this->customerModel->deleteCustomerBankAccount($customerBankAccountID, $customerID);
                
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
    #
    # Function: deleteCustomerBankCard
    # Description: 
    # Delete the customer bank card if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCustomerBankCard() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_bank_card_id']) && !empty($_POST['customer_bank_card_id'])) {
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerBankCardID = htmlspecialchars($_POST['customer_bank_card_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Bank Account Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkCustomerBankCardExist = $this->customerModel->checkCustomerBankCardExist($customerBankCardID);
            $total = $checkCustomerBankCardExist['total'] ?? 0;

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

            $this->customerModel->deleteCustomerBankCard($customerBankCardID, $customerID);
                
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
    #
    # Function: deleteCustomerIDRecord
    # Description: 
    # Delete the customer ID record if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCustomerIDRecord() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id']) && isset($_POST['customer_id_record_id']) && !empty($_POST['customer_id_record_id'])) {
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerIDRecordID = htmlspecialchars($_POST['customer_id_record_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete ID Record Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkCustomerIDRecordExist = $this->customerModel->checkCustomerIDRecordExist($customerIDRecordID);
            $total = $checkCustomerIDRecordExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete ID Record Error',
                    'message' => 'The ID record does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $idRecordDetails = $this->customerModel->getCustomerIDRecord($customerIDRecordID);
            $idImagePath = !empty($idRecordDetails['id_image']) ? str_replace('./components/', '../../', $idRecordDetails['id_image']) : null;

            if(file_exists($idImagePath)){
                if (!unlink($idImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete ID Record Error',
                        'message' => 'The ID record cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->customerModel->deleteCustomerIDRecord($customerIDRecordID);
                
            $response = [
                'success' => true,
                'title' => 'Delete ID Record Success',
                'message' => 'The ID record has been deleted successfully.',
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
    # Function: archiveCustomer
    # Description: 
    # Archive the customer if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function archiveCustomer() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Archive Customer Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerModel->updateCustomerStatus($customerID, 'Archived', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Archive Customer Success',
                'message' => 'The emaployee has been archived successfully.',
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
    # Function: unarchiveCustomer
    # Description: 
    # Unarchive the customer if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unarchiveCustomer() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unarchive Customer Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->customerModel->updateCustomerStatus($customerID, 'Active', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unarchive Customer Success',
                'message' => 'The customer has been unarchived successfully.',
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
    # Handles the retrieval of customer about details.
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
    
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get About Details Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerDetails = $this->customerModel->getCustomer($customerID);

            $response = [
                'success' => true,
                'about' => $customerDetails['about'] ?? null
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
    # Function: getCustomerImageDetails
    # Description: 
    # Handles the retrieval of customer about details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCustomerImageDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Customer Image Details Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerDetails = $this->customerModel->getCustomer($customerID);
            $customerImage = $this->systemModel->checkImage($customerDetails['customer_image'] ?? null, 'upload placeholder');

            $response = [
                'success' => true,
                'customerImage' => $customerImage
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
    # Handles the retrieval of customer private information details.
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
    
        if (isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Private Information Details Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerDetails = $this->customerModel->getCustomer($customerID);

            $response = [
                'success' => true,
                'fullName' => $customerDetails['full_name'] ?? null,
                'firstName' => $customerDetails['first_name'] ?? null,
                'middleName' => $customerDetails['middle_name'] ?? null,
                'lastName' => $customerDetails['last_name'] ?? null,
                'suffix' => $customerDetails['suffix'] ?? null,
                'nickname' => $this->systemModel->displaySummary($customerDetails['nickname'] ?? null),
                'civilStatusID' => $customerDetails['civil_status_id'] ?? null,
                'civilStatusName' => $this->systemModel->displaySummary($customerDetails['civil_status_name'] ?? null),
                'genderID' => $customerDetails['gender_id'] ?? null,
                'genderName' => $this->systemModel->displaySummary($customerDetails['gender_name'] ?? null),
                'religionID' => $customerDetails['religion_id'] ?? null,
                'religionName' => $this->systemModel->displaySummary($customerDetails['religion_name'] ?? null),
                'bloodTypeID' => $customerDetails['blood_type_id'] ?? null,
                'bloodTypeName' => $this->systemModel->displaySummary($customerDetails['blood_type_name'] ?? null),
                'birthday' => $this->systemModel->checkDate('empty', $customerDetails['birthday'], '', 'm/d/Y', ''),
                'birthdaySummary' => $this->systemModel->checkDate('summary', $customerDetails['birthday'], '', 'M d, Y', ''),
                'birthPlace' => $customerDetails['birth_place'] ?? null,
                'height' => $this->systemModel->displaySummary($customerDetails['height'] ?? null),
                'weight' => $this->systemModel->displaySummary($customerDetails['weight'] ?? null)
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
    # Function: getCustomerAddressDetails
    # Description: 
    # Handles the retrieval of customer address details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCustomerAddressDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_address_id']) && !empty($_POST['customer_address_id']) && isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerAddressID = htmlspecialchars($_POST['customer_address_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Address Details Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkCustomerAddressExist = $this->customerModel->checkCustomerAddressExist($customerAddressID);
            $total = $checkCustomerAddressExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'detailsNotExist' => true,
                    'title' => 'Get Address Details Error',
                    'message' => 'The address does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerAddressDetails = $this->customerModel->getCustomerAddress($customerAddressID);

            $response = [
                'success' => true,
                'address' => $customerAddressDetails['address'] ?? null,
                'addressTypeID' => $customerAddressDetails['address_type_id'] ?? null,
                'address' => $customerAddressDetails['address'] ?? null,
                'cityID' => $customerAddressDetails['city_id'] ?? null,
                'telephone' => $customerAddressDetails['telephone'] ?? null,
                'mobile' => $customerAddressDetails['mobile'] ?? null,
                'email' => $customerAddressDetails['email'] ?? null
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
    # Function: getCustomerBankAccountDetails
    # Description: 
    # Handles the retrieval of customer bank account details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCustomerBankAccountDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_bank_account_id']) && !empty($_POST['customer_bank_account_id']) && isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerBankAccountID = htmlspecialchars($_POST['customer_bank_account_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Bank Account Details Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkCustomerBankAccountExist = $this->customerModel->checkCustomerBankAccountExist($customerBankAccountID);
            $total = $checkCustomerBankAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'detailsNotExist' => true,
                    'title' => 'Get Bank Account Details Error',
                    'message' => 'The bank account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerBankAccountDetails = $this->customerModel->getCustomerBankAccount($customerBankAccountID);

            $response = [
                'success' => true,
                'bankID' => $customerBankAccountDetails['bank_id'] ?? null,
                'bankAccountTypeID' => $customerBankAccountDetails['bank_account_type_id'] ?? null,
                'accountNumber' => $customerBankAccountDetails['account_number'] ?? null
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
    # Function: getCustomerBankCardDetails
    # Description: 
    # Handles the retrieval of customer bank account details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCustomerBankCardDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_bank_account_id']) && !empty($_POST['customer_bank_account_id']) && isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerBankCardID = htmlspecialchars($_POST['customer_bank_account_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Bank Account Details Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkCustomerBankCardExist = $this->customerModel->checkCustomerBankCardExist($customerBankCardID);
            $total = $checkCustomerBankCardExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'detailsNotExist' => true,
                    'title' => 'Get Bank Account Details Error',
                    'message' => 'The bank account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerBankCardDetails = $this->customerModel->getCustomerBankCard($customerBankCardID);

            $response = [
                'success' => true,
                'bankID' => $customerBankCardDetails['bank_id'] ?? null,
                'bankAccountTypeID' => $customerBankCardDetails['bank_account_type_id'] ?? null,
                'accountNumber' => $customerBankCardDetails['account_number'] ?? null
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
    # Function: getCustomerIDRecordDetails
    # Description: 
    # Handles the retrieval of customer ID record details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCustomerIDRecordDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_id_record_id']) && !empty($_POST['customer_id_record_id']) && isset($_POST['customer_id']) && !empty($_POST['customer_id'])) {
            $userID = $_SESSION['user_account_id'];
            $customerID = htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8');
            $customerIDRecordID = htmlspecialchars($_POST['customer_id_record_id'], ENT_QUOTES, 'UTF-8');

            $checkCustomerExist = $this->customerModel->checkCustomerExist($customerID);
            $total = $checkCustomerExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get ID Record Details Error',
                    'message' => 'The customer does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkCustomerIDRecordExist = $this->customerModel->checkCustomerIDRecordExist($customerIDRecordID);
            $total = $checkCustomerIDRecordExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'detailsNotExist' => true,
                    'title' => 'Get ID Record Details Error',
                    'message' => 'The ID record does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $customerIDRecordDetails = $this->customerModel->getCustomerIDRecord($customerIDRecordID);

            $response = [
                'success' => true,
                'idTypeID' => $customerIDRecordDetails['id_type_id'] ?? null,
                'idNumber' => $customerIDRecordDetails['id_number'] ?? null,
                'issueDate' => $this->systemModel->checkDate('empty', $customerIDRecordDetails['issue_date'], '', 'm/d/Y', ''),
                'expirationDate' => $this->systemModel->checkDate('empty', $customerIDRecordDetails['expiration_date'], '', 'm/d/Y', ''),
                'issuingAuthority' => $customerIDRecordDetails['issuing_authority'] ?? null
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
require_once '../../customer/model/customer-model.php';
require_once '../../gender/model/gender-model.php';
require_once '../../civil-status/model/civil-status-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../address-type/model/address-type-model.php';
require_once '../../city/model/city-model.php';
require_once '../../state/model/state-model.php';
require_once '../../country/model/country-model.php';
require_once '../../id-type/model/id-type-model.php';
require_once '../../bank/model/bank-model.php';
require_once '../../bank-account-type/model/bank-account-type-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new CustomerController(new CustomerModel(new DatabaseModel), new GenderModel(new DatabaseModel), new CivilStatusModel(new DatabaseModel), new UserAccountModel(new DatabaseModel), new AddressTypeModel(new DatabaseModel), new CityModel(new DatabaseModel), new StateModel(new DatabaseModel), new CountryModel(new DatabaseModel), new IDTypeModel(new DatabaseModel), new BankModel(new DatabaseModel), new BankAccountTypeModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>