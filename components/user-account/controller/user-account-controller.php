<?php
session_start();

# -------------------------------------------------------------
#
# Function: UserAccountController
# Description: 
# The UserAccountController class handles user account related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class UserAccountController {
    private $userAccountModel;
    private $roleModel;
    private $authenticationModel;
    private $securitySettingModel;
    private $uploadSettingModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided RoleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for role related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param UserAccountModel $userAccountModel     The UserAccountModel instance for user account related operations.
    # - @param RoleModel $roleModel     The RoleModel instance for role related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecuritySettingModel $securitySettingModel     The securitySettingModel instance for security setting related operations.
    # - @param UploadSettingModel $uploadSettingModel     The uploadSettingModel instance for upload setting related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(UserAccountModel $userAccountModel, RoleModel $roleModel, AuthenticationModel $authenticationModel, SecuritySettingModel $securitySettingModel, UploadSettingModel $uploadSettingModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->userAccountModel = $userAccountModel;
        $this->roleModel = $roleModel;
        $this->authenticationModel = $authenticationModel;
        $this->securitySettingModel = $securitySettingModel;
        $this->uploadSettingModel = $uploadSettingModel;
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
                case 'add user account':
                    $this->addUserAccount();
                    break;
                case 'update user account':
                    $this->updateUserAccount();
                    break;
                case 'change password':
                    $this->updateUserAccountPassword();
                    break;
                case 'update user account profile picture':
                    $this->updateUserAccountProfilePicture();
                    break;
                case 'get user account details':
                    $this->getUserAccountDetails();
                    break;
                case 'activate user account':
                    $this->activateUserAccount();
                    break;
                case 'activate multiple user account':
                    $this->activateMultipleUserAccount();
                    break;
                case 'deactivate user account':
                    $this->deactivateUserAccount();
                    break;
                case 'deactivate multiple user account':
                    $this->deactivateMultipleUserAccount();
                    break;
                case 'lock user account':
                    $this->lockUserAccount();
                    break;
                case 'lock multiple user account':
                    $this->lockMultipleUserAccount();
                    break;
                case 'enable two factor authentication':
                    $this->enableTwoFactorAuthentication();
                    break;
                case 'disable two factor authentication':
                    $this->disableTwoFactorAuthentication();
                    break;
                case 'enable multiple login sessions':
                    $this->enableMultipleLoginSessions();
                    break;
                case 'disable multiple login sessions':
                    $this->disableMultipleLoginSessions();
                    break;
                case 'unlock user account':
                    $this->unlockUserAccount();
                    break;
                case 'unlock multiple user account':
                    $this->unlockMultipleUserAccount();
                    break;
                case 'delete user account':
                    $this->deleteUserAccount();
                    break;
                case 'delete multiple user account':
                    $this->deleteMultipleUserAccount();
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
    # Function: addUserAccount
    # Description: 
    # Inserts a user account.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_as']) && !empty($_POST['file_as']) && isset($_POST['email']) && !empty($_POST['email']) && isset($_POST['password']) && !empty($_POST['password'])) {
            $userID = $_SESSION['user_account_id'];
            $fileAs = htmlspecialchars($_POST['file_as'], ENT_QUOTES, 'UTF-8');
            $email = htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8');
            $password = $this->securityModel->encryptData($_POST['password']);

            $checkUserAccountEmailExist = $this->userAccountModel->checkUserAccountEmailExist($email);
            $total = $checkUserAccountEmailExist['total'] ?? 0;

            if($total > 0){
                $response = [
                    'success' => false,
                    'title' => 'Insert User Account Error',
                    'message' => 'The email address already exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(4);
            $defaultPasswordDuration = $securitySettingDetails['value'] ?? DEFAULT_PASSWORD_DURATION;
        
            $lastPasswordChange = date('Y-m-d H:i:s');
            $passwordExpiryDate = date('Y-m-d', strtotime('+'. $defaultPasswordDuration .' days'));
        
            $userAccountID = $this->userAccountModel->insertUserAccount($fileAs, $email, $password, $passwordExpiryDate, $lastPasswordChange, $userID);
            $this->authenticationModel->insertPasswordHistory($userAccountID, $email, $password, $lastPasswordChange);
    
            $response = [
                'success' => true,
                'userAccountID' => $this->securityModel->encryptData($userAccountID),
                'title' => 'Insert User Account Success',
                'message' => 'The user account has been inserted successfully.',
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
    # Function: updateUserAccount
    # Description: 
    # Updates the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id']) && isset($_POST['file_as']) && !empty($_POST['file_as']) && isset($_POST['email']) && !empty($_POST['email'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
            $fileAs = htmlspecialchars($_POST['file_as'], ENT_QUOTES, 'UTF-8');
            $email = htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update User Account Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            $checkUserAccountEmailUpdateExist = $this->userAccountModel->checkUserAccountEmailUpdateExist($userAccountID, $email);
            $total = $checkUserAccountEmailUpdateExist['total'] ?? 0;

            if($total > 0){
                $response = [
                    'success' => false,
                    'title' => 'Update User Account Error',
                    'message' => 'The email address already exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateUserAccount($userAccountID, $fileAs, $email, $userID);
            
            $response = [
                'success' => true,
                'title' => 'Update User Account Success',
                'message' => 'The user account has been updated successfully.',
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
    # Function: updateUserAccountProfilePicture
    # Description: 
    # Handles the update of the user account profile picture.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateUserAccountProfilePicture() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];

            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');

            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update User Account Profile Picture Error',
                    'message' => 'The user account profile picture does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $profilePictureFileName = $_FILES['profile_picture']['name'];
            $profilePictureFileSize = $_FILES['profile_picture']['size'];
            $profilePictureFileError = $_FILES['profile_picture']['error'];
            $profilePictureTempName = $_FILES['profile_picture']['tmp_name'];
            $profilePictureFileExtension = explode('.', $profilePictureFileName);
            $profilePictureActualFileExtension = strtolower(end($profilePictureFileExtension));

            $uploadSetting = $this->uploadSettingModel->getUploadSetting(1);
            $maxFileSize = $uploadSetting['max_file_size'];

            $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(1);
            $allowedFileExtensions = [];

            foreach ($uploadSettingFileExtension as $row) {
                $allowedFileExtensions[] = $row['file_extension'];
            }

            if (!in_array($profilePictureActualFileExtension, $allowedFileExtensions)) {
                $response = [
                    'success' => false,
                    'title' => 'Update User Account Profile Picture Error',
                    'message' => 'The file uploaded is not supported.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if(empty($profilePictureTempName)){
                $response = [
                    'success' => false,
                    'title' => 'Update User Account Profile Picture Error',
                    'message' => 'Please choose the profile picture.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if($profilePictureFileError){
                $response = [
                    'success' => false,
                    'title' => 'Update User Account Profile Picture Error',
                    'message' => 'An error occurred while uploading the file.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if($profilePictureFileSize > ($maxFileSize * 1024)){
                $response = [
                    'success' => false,
                    'title' => 'Update User Account Profile Picture Error',
                    'message' => 'The document file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $fileName = $this->securityModel->generateFileName();
            $fileNew = $fileName . '.' . $profilePictureActualFileExtension;
            
            define('PROJECT_BASE_DIR', dirname(__DIR__));
            define('USER_ACCOUNT_PROFILE_PICTURE_DIR', 'image/profile_image/');

            $directory = PROJECT_BASE_DIR. '/'. USER_ACCOUNT_PROFILE_PICTURE_DIR. $userAccountID. '/';
            $fileDestination = $directory. $fileNew;
            $filePath = './components/user-account/image/profile_image/'. $userAccountID . '/' . $fileNew;

            $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));

            if(!$directoryChecker){
                $response = [
                    'success' => false,
                    'title' => 'Update User Account Profile Picture Error',
                    'message' => $directoryChecker,
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);
            $userAccountProfilePiturePath = !empty($userAccountDetails['profile_picture']) ? str_replace('./components/', '../../', $userAccountDetails['profile_picture']) : null;

            if(file_exists($userAccountProfilePiturePath)){
                if (!unlink($userAccountProfilePiturePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Update User Account Profile Picture Error',
                        'message' => 'The user account profile picture cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;                    
                }
            }

            if(!move_uploaded_file($profilePictureTempName, $fileDestination)){
                $response = [
                    'success' => false,
                    'title' => 'Update User Account Profile Picture Error',
                    'message' => 'The user account profile picture cannot be uploaded due to an error.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;           
            }

            $this->userAccountModel->updateUserAccountProfilePicture($userAccountID, $filePath, $userID);

            $response = [
                'success' => true,
                'title' => 'Update User Account Profile Picture Success',
                'message' => 'The user account profile picture has been updated successfully.',
                'messageType' => 'success'
            ];

            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateUserAccountPassword
    # Description: 
    # Updates the user account password if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateUserAccountPassword() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id']) && isset($_POST['new_password']) && !empty($_POST['new_password'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
            $newPassword = htmlspecialchars($_POST['new_password'], ENT_QUOTES, 'UTF-8');
            $encryptedPassword = $this->securityModel->encryptData($newPassword);
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Change User Account Password Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkPasswordHistory = $this->checkPasswordHistory($userAccountID, null, $newPassword);
    
            if ($checkPasswordHistory > 0) {
                $response = [
                    'success' => false,
                    'passwordExist' => true,
                    'title' => 'Change User Account Password Error',
                    'message' => 'The new password cannot be identical to the previous one for security reasons. Please choose a different password to proceed.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);
            $email = $userAccountDetails['email'];

            $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(4);
            $defaultPasswordDuration = $securitySettingDetails['value'] ?? DEFAULT_PASSWORD_DURATION;
        
            $lastPasswordChange = date('Y-m-d H:i:s');
            $passwordExpiryDate = date('Y-m-d', strtotime('+'. $defaultPasswordDuration .' days'));

            $this->userAccountModel->updateUserAccountPassword($userAccountID, $encryptedPassword, $passwordExpiryDate, $userID);
            $this->authenticationModel->insertPasswordHistory($userAccountID, $email, $encryptedPassword, $lastPasswordChange);
            
            $response = [
                'success' => true,
                'title' => 'Update User Account Password Success',
                'message' => 'The user account has been updated successfully.',
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
    #   Activate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: activateUserAccount
    # Description: 
    # Activate the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function activateUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Activate User Account Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateUserAccountStatus($userAccountID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Activate User Account Success',
                'message' => 'The user account has been activated successfully.',
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
    # Function: activateMultipleUserAccount
    # Description: 
    # Activate the selected user accounts if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function activateMultipleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountIDs = $_POST['user_account_id'];
    
            foreach($userAccountIDs as $userAccountID){
                $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
                $total = $checkUserAccountExist['total'] ?? 0;

                if($total > 0){
                    $this->userAccountModel->updateUserAccountStatus($userAccountID, 'Yes', $userID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Activate Multiple User Account Success',
                'message' => 'The selected user accounts have been activated successfully.',
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
    #   Deactivate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deactivateUserAccount
    # Description: 
    # Deactivate the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deactivateUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($userAccountID == $userID){
                $response = [
                    'success' => false,
                    'title' => 'Deactivate User Account Error',
                    'message' => 'You cannot deactivate the user account you are currently logged in as.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Deactivate User Account Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateUserAccountStatus($userAccountID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Deactivate User Account Success',
                'message' => 'The user account has been deactivated successfully.',
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
    # Function: deactivateMultipleUserAccount
    # Description: 
    # Deactivate the selected user accounts if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deactivateMultipleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountIDs = $_POST['user_account_id'];
    
            foreach($userAccountIDs as $userAccountID){
                $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
                $total = $checkUserAccountExist['total'] ?? 0;

                if($total > 0){
                    if($userAccountID != $userID){
                        $this->userAccountModel->updateUserAccountStatus($userAccountID, 'No', $userID);
                    }
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Deactivate Multiple User Account Success',
                'message' => 'The selected user accounts have been deactivated successfully.',
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
    #   Lock methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: lockUserAccount
    # Description: 
    # Lock the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function lockUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Lock User Account Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            if($userAccountID == $userID){
                $response = [
                    'success' => false,
                    'title' => 'Lock User Account Error',
                    'message' => 'You cannot lock the user account you are currently logged in as.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateUserAccountLock($userAccountID, 'Yes', 9999999, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Lock User Account Success',
                'message' => 'The user account has been locked successfully.',
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
    # Function: lockMultipleUserAccount
    # Description: 
    # Lock the selected user accounts if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function lockMultipleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountIDs = $_POST['user_account_id'];
    
            foreach($userAccountIDs as $userAccountID){
                $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
                $total = $checkUserAccountExist['total'] ?? 0;

                if($total > 0){
                    if($userAccountID != $userID){
                        $this->userAccountModel->updateUserAccountLock($userAccountID, 'Yes', 9999999, $userID);
                    }
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Lock Multiple User Account Success',
                'message' => 'The selected user accounts have been locked successfully.',
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
    #   Unlock methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: unlockUserAccount
    # Description: 
    # Unlock the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unlockUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unlock User Account Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateUserAccountLock($userAccountID, 'No', 0, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unlock User Account Success',
                'message' => 'The user account has been unlocked successfully.',
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
    # Function: unlockMultipleUserAccount
    # Description: 
    # Unlock the selected user accounts if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unlockMultipleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountIDs = $_POST['user_account_id'];
    
            foreach($userAccountIDs as $userAccountID){
                $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
                $total = $checkUserAccountExist['total'] ?? 0;

                if($total > 0){
                    $this->userAccountModel->updateUserAccountLock($userAccountID, 'No', 0, $userID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Unlock Multiple User Account Success',
                'message' => 'The selected user accounts have been unlocked successfully.',
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
    #   Enable methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: enableTwoFactorAuthentication
    # Description: 
    # Enable the user account's two-factor authentication if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function enableTwoFactorAuthentication() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Enable Two-Factor Authentication Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateTwoFactorAuthenticationStatus($userAccountID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Enable Two-Factor Authentication Success',
                'message' => 'The two-factor authentication has been enabled successfully.',
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
    # Function: enableMultipleLoginSessions
    # Description: 
    # Enable the user account's multiple login sessions if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function enableMultipleLoginSessions() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Enable Multiple Login Sessions Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateMultipleLoginSessionsStatus($userAccountID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Enable Multiple Login Sessions Success',
                'message' => 'The multiple login sessions has been enabled successfully.',
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
    #   Disable methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: disableTwoFactorAuthentication
    # Description: 
    # Disable the user account's two-factor authentication if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function disableTwoFactorAuthentication() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Disable Two-Factor Authentication Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateTwoFactorAuthenticationStatus($userAccountID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Disable Two-Factor Authentication Success',
                'message' => 'The two-factor authentication has been disabled successfully.',
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
    # Function: disableMultipleLoginSessions
    # Description: 
    # Disable the user account's multiple login sessions if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function disableMultipleLoginSessions() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Disable Multiple Login Sessions Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateMultipleLoginSessionsStatus($userAccountID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Disable Multiple Login Sessions Success',
                'message' => 'The multiple login sessions has been disabled successfully.',
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
    # Function: deleteUserAccount
    # Description: 
    # Delete the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete User Account Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            if($userAccountID == $userID){
                $response = [
                    'success' => false,
                    'title' => 'Delete User Account Error',
                    'message' => 'You cannot delete the user account you are currently logged in as.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);
            $userAccountProfilePiturePath = !empty($userAccountDetails['profile_picture']) ? str_replace('./components/', '../../', $userAccountDetails['profile_picture']) : null;

            if(file_exists($userAccountProfilePiturePath)){
                if (!unlink($userAccountProfilePiturePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Update User Account Profile Picture Error',
                        'message' => 'The user account profile picture cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;                    
                }
            }

            $this->userAccountModel->deleteUserAccount($userAccountID);
                
            $response = [
                'success' => true,
                'title' => 'Delete User Account Success',
                'message' => 'The user account has been deleted successfully.',
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
    # Function: deleteMultipleUserAccount
    # Description: 
    # Delete the selected user accounts if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountIDs = $_POST['user_account_id'];
    
            foreach($userAccountIDs as $userAccountID){
                $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
                $total = $checkUserAccountExist['total'] ?? 0;

                if($total > 0){
                    if($userAccountID != $userID){
                        $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);
                        $userAccountProfilePiturePath = !empty($userAccountDetails['profile_picture']) ? str_replace('./components/', '../../', $userAccountDetails['profile_picture']) : null;
            
                        if(file_exists($userAccountProfilePiturePath)){
                            if (!unlink($userAccountProfilePiturePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Update User Account Profile Picture Error',
                                    'message' => 'The user account profile picture cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }

                        $this->userAccountModel->deleteUserAccount($userAccountID);
                    }
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple User Account Success',
                'message' => 'The selected user accounts have been deleted successfully.',
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
    #  Format methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: formatDuration
    # Description:
    # Updates the failed login attempts and, if the maximum attempts are reached, locks the account.
    #
    # Parameters: 
    # - $lockDuration (int): The duration in seconds that needs to be formatted. This value represents the total duration that you want to convert into a human-readable format.
    #
    # Returns: 
    #  Returns a formatted string representing the duration in a human-readable format. 
    #  The format includes years, months, days, hours, and minutes, as applicable. 
    #  The function constructs this string based on the provided $lockDuration parameter.
    #
    # -------------------------------------------------------------
    private function formatDuration($lockDuration) {
        $durationParts = [];

        $timeUnits = [
            ['year', 60 * 60 * 24 * 30 * 12],
            ['month', 60 * 60 * 24 * 30],
            ['day', 60 * 60 * 24],
            ['hour', 60 * 60],
            ['minute', 60]
        ];

        foreach ($timeUnits as list($unit, $seconds)) {
            $value = floor($lockDuration / $seconds);
            $lockDuration %= $seconds;

            if ($value > 0) {
                $durationParts[] = number_format($value) . ' ' . $unit . ($value > 1 ? 's' : '');
            }
        }

        return $durationParts;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkPasswordHistory
    # Description: 
    # Checks the password history for a given user ID and email to determine if the new password matches any previous passwords.
    #
    # Parameters: 
    # - $p_user_account_id (array): The user ID.
    # - $p_email (string): The email address of the user.
    # - $p_password (string): The password of the user.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function checkPasswordHistory($p_user_account_id, $p_email, $p_password) {
        $total = 0;
        $passwordHistory = $this->authenticationModel->getPasswordHistory($p_user_account_id, $p_email);
    
        foreach ($passwordHistory as $history) {
            $password = $this->securityModel->decryptData($history['password']);
    
            if ($password === $p_password) {
                $total++;
            }
        }
    
        return $total;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get details methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getUserAccountDetails
    # Description: 
    # Handles the retrieval of user account details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getUserAccountDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_account_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');

            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get User Account Details Error',
                    'message' => 'The user account does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);
            $active = $userAccountDetails['active'] ?? null;
            $locked = $userAccountDetails['locked'] ?? null;
            $accountLockDuration = $userAccountDetails['account_lock_duration'] ?? 0;
            $twoFactorAuthentication = $userAccountDetails['two_factor_auth'] ?? 'Yes';
            $multipleSession = $userAccountDetails['multiple_session'] ?? 'No';
            $profilePicture = $this->systemModel->checkImage($userAccountDetails['profile_picture'] ?? null, 'profile');
            $passwordExpiryDate = date('F d, Y', strtotime($userAccountDetails['password_expiry_date']));
            $lastPasswordReset = (!empty($userAccountDetails['last_password_reset'])) ? date('F d, Y h:i:s a', strtotime($userAccountDetails['last_password_reset'])) : 'Never Reset';
            $lastConnectionDate = (!empty($userAccountDetails['last_connection_date'])) ? date('F d, Y h:i:s a', strtotime($userAccountDetails['last_connection_date'])) : 'Never Connected';
            $lastFailedLoginAttempt = (!empty($userAccountDetails['last_failed_login_attempt'])) ? date('F d, Y h:i:s a', strtotime($userAccountDetails['last_failed_login_attempt'])) : '--';

            $activeBadge = $active == 'Yes' ? '<span class="badge bg-success">Active</span>' : '<span class="badge bg-danger">Inactive</span>';
            $lockedBadge = $locked == 'Yes' ? '<span class="badge bg-danger">Yes</span>' : '<span class="badge bg-success">No</span>';

            $accountLockDuration = ($accountLockDuration > 0) ? 'Locked for ' . implode(", ", $this->formatDuration($accountLockDuration)) : '--';

            $response = [
                'success' => true,
                'fileAs' => $userAccountDetails['file_as'] ?? null,
                'email' => $userAccountDetails['email'] ?? null,
                'profilePicture' => $profilePicture,
                'passwordExpiryDate' => $passwordExpiryDate,
                'lastPasswordReset' => $lastPasswordReset,
                'lastConnectionDate' => $lastConnectionDate,
                'lastFailedLoginAttempt' => $lastFailedLoginAttempt,
                'accountLockDuration' => $accountLockDuration,
                'twoFactorAuthentication' => $twoFactorAuthentication,
                'multipleSession' => $multipleSession,
                'activeBadge' => $activeBadge,
                'lockedBadge' => $lockedBadge
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
require_once '../../user-account/model/user-account-model.php';
require_once '../../role/model/role-model.php';
require_once '../../authentication/model/authentication-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../security-setting/model/security-setting-model.php';

$controller = new UserAccountController(new UserAccountModel(new DatabaseModel), new RoleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecuritySettingModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>