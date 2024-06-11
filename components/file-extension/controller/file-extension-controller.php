<?php
session_start();

# -------------------------------------------------------------
#
# Function: FileExtensionController
# Description: 
# The FileExtensionController class handles file extension related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class FileExtensionController {
    private $fileExtensionModel;
    private $fileTypeModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided fileExtensionModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for file extension related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param FileExtensionModel $fileExtensionModel     The fileExtensionModel instance for file extension related operations.
    # - @param FileTypeModel $fileTypeModel     The fileTypeModel instance for file type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(FileExtensionModel $fileExtensionModel, FileTypeModel $fileTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->fileExtensionModel = $fileExtensionModel;
        $this->fileTypeModel = $fileTypeModel;
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
                case 'add file extension':
                    $this->addFileExtension();
                    break;
                case 'update file extension':
                    $this->updateFileExtension();
                    break;
                case 'get file extension details':
                    $this->getFileExtensionDetails();
                    break;
                case 'delete file extension':
                    $this->deleteFileExtension();
                    break;
                case 'delete multiple file extension':
                    $this->deleteMultipleFileExtension();
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
    # Function: addFileExtension
    # Description: 
    # Inserts a file extension.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addFileExtension() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_extension_name']) && !empty($_POST['file_extension_name']) && isset($_POST['file_type']) && !empty($_POST['file_type']) && isset($_POST['file_extension']) && !empty($_POST['file_extension'])) {
            $userID = $_SESSION['user_account_id'];
            $fileExtensionName = $_POST['file_extension_name'];
            $fileExtension = htmlspecialchars($_POST['file_extension'], ENT_QUOTES, 'UTF-8');
            $fileType = htmlspecialchars($_POST['file_type'], ENT_QUOTES, 'UTF-8');

            $fileTypeDetails = $this->fileTypeModel->getFileType($fileType);
            $fileTypeName = $fileTypeDetails['file_type_name'] ?? null;
        
            $fileExtensionID = $this->fileExtensionModel->insertFileExtension($fileExtensionName, $fileExtension, $fileType, $fileTypeName, $userID);
    
            $response = [
                'success' => true,
                'fileExtensionID' => $this->securityModel->encryptData($fileExtensionID),
                'title' => 'Insert File Extension Success',
                'message' => 'The file extension has been inserted successfully.',
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
    # Function: updateFileExtension
    # Description: 
    # Updates the file extension if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateFileExtension() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['file_extension_id']) && !empty($_POST['file_extension_id']) && isset($_POST['file_extension_name']) && !empty($_POST['file_extension_name']) && isset($_POST['file_type']) && !empty($_POST['file_type']) && isset($_POST['file_extension']) && !empty($_POST['file_extension'])) {
            $userID = $_SESSION['user_account_id'];
            $fileExtensionID = htmlspecialchars($_POST['file_extension_id'], ENT_QUOTES, 'UTF-8');
            $fileExtensionName = $_POST['file_extension_name'];
            $fileExtension = htmlspecialchars($_POST['file_extension'], ENT_QUOTES, 'UTF-8');
            $fileType = htmlspecialchars($_POST['file_type'], ENT_QUOTES, 'UTF-8');
        
            $checkFileExtensionExist = $this->fileExtensionModel->checkFileExtensionExist($fileExtensionID);
            $total = $checkFileExtensionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update File Extension Error',
                    'message' => 'The file extension does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $fileTypeDetails = $this->fileTypeModel->getFileType($fileType);
            $fileTypeName = $fileTypeDetails['file_type_name'] ?? null;

            $this->fileExtensionModel->updateFileExtension($fileExtensionID, $fileExtensionName, $fileExtension, $fileType, $fileTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update File Extension Success',
                'message' => 'The file extension has been updated successfully.',
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
    # Function: deleteFileExtension
    # Description: 
    # Delete the file extension if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteFileExtension() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_extension_id']) && !empty($_POST['file_extension_id'])) {
            $fileExtensionID = htmlspecialchars($_POST['file_extension_id'], ENT_QUOTES, 'UTF-8');
        
            $checkFileExtensionExist = $this->fileExtensionModel->checkFileExtensionExist($fileExtensionID);
            $total = $checkFileExtensionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete File Extension Error',
                    'message' => 'The file extension does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->fileExtensionModel->deleteFileExtension($fileExtensionID);
                
            $response = [
                'success' => true,
                'title' => 'Delete File Extension Success',
                'message' => 'The file extension has been deleted successfully.',
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
    # Function: deleteMultipleFileExtension
    # Description: 
    # Delete the selected file extensions if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleFileExtension() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_extension_id']) && !empty($_POST['file_extension_id'])) {
            $fileExtensionIDs = $_POST['file_extension_id'];
    
            foreach($fileExtensionIDs as $fileExtensionID){
                $checkFileExtensionExist = $this->fileExtensionModel->checkFileExtensionExist($fileExtensionID);
                $total = $checkFileExtensionExist['total'] ?? 0;

                if($total > 0){
                    $this->fileExtensionModel->deleteFileExtension($fileExtensionID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple File Extension Success',
                'message' => 'The selected file extensions have been deleted successfully.',
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
    # Function: getFileExtensionDetails
    # Description: 
    # Handles the retrieval of file extension details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getFileExtensionDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['file_extension_id']) && !empty($_POST['file_extension_id'])) {
            $userID = $_SESSION['user_account_id'];
            $fileExtensionID = htmlspecialchars($_POST['file_extension_id'], ENT_QUOTES, 'UTF-8');

            $checkFileExtensionExist = $this->fileExtensionModel->checkFileExtensionExist($fileExtensionID);
            $total = $checkFileExtensionExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get File Extension Details Error',
                    'message' => 'The file extension does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $fileExtensionDetails = $this->fileExtensionModel->getFileExtension($fileExtensionID);

            $response = [
                'success' => true,
                'fileExtensionName' => $fileExtensionDetails['file_extension_name'] ?? null,
                'fileExtension' => $fileExtensionDetails['file_extension'] ?? null,
                'fileTypeID' => $fileExtensionDetails['file_type_id'] ?? null,
                'fileTypeName' => $fileExtensionDetails['file_type_name'] ?? null
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
require_once '../../file-extension/model/file-extension-model.php';
require_once '../../file-type/model/file-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new FileExtensionController(new FileExtensionModel(new DatabaseModel), new FileTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>