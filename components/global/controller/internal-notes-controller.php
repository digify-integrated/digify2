<?php
session_start();

# -------------------------------------------------------------
#
# Function: InternalNotesController
# Description: 
# The InternalNotesController class handles global related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class InternalNotesController {
    private $globalModel;
    private $authenticationModel;
    private $securityModel;
    private $uploadSettingModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided globalModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for global related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param GlobalModel $globalModel     The GlobalModel instance for global related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(GlobalModel $globalModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->globalModel = $globalModel;
        $this->uploadSettingModel = $uploadSettingModel;
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
                case 'add internal notes':
                    $this->addInternalNotes();
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
    # Function: addInternalNotes
    # Description: 
    # Inserts a global.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addInternalNotes() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['database_table']) && !empty($_POST['database_table']) && isset($_POST['reference_id']) && !empty($_POST['reference_id']) && isset($_POST['internal_note']) && !empty($_POST['internal_note'])) {
            $userID = $_SESSION['user_account_id'];
            $databaseTable = htmlspecialchars($_POST['database_table'], ENT_QUOTES, 'UTF-8');
            $referenceID = htmlspecialchars($_POST['reference_id'], ENT_QUOTES, 'UTF-8');
            $internalNote = $_POST['internal_note'];
        
            $internalNoteID = $this->globalModel->insertInternalNotes($databaseTable, $referenceID, $internalNote, $userID);

            if(isset($_FILES['internal_notes_files']) && !empty($_FILES['internal_notes_files']['name'])){
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('INTERNAL_NOTES_DIR', 'files/internal_notes/');
    
                $directory = PROJECT_BASE_DIR. '/'. INTERNAL_NOTES_DIR . $internalNoteID . '/';
                
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Internal Note Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                $uploadSetting = $this->uploadSettingModel->getUploadSetting(2);
                $maxFileSize = $uploadSetting['max_file_size'];

                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(2);
                $allowedFileExtensions = [];

                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }

                for ($i = 0; $i < count($_FILES['internal_notes_files']['name']); $i++) {
                    $error = 0;
                    $internalNotesFileName = $_FILES['internal_notes_files']['name'][$i];
                    $internalNotesFileSize = $_FILES['internal_notes_files']['size'][$i];
                    $internalNotesFileError = $_FILES['internal_notes_files']['error'][$i];
                    $internalNotesFileTempName = $_FILES['internal_notes_files']['tmp_name'][$i];
                    $internalNotesFileExtension = explode('.', $internalNotesFileName);
                    $internalNotesActualFileName = reset($internalNotesFileExtension);
                    $internalNotesActualFileExtension = strtolower(end($internalNotesFileExtension));

                    if (!in_array($internalNotesActualFileExtension, $allowedFileExtensions)) {
                       $error = $error + 1;
                    }
                    
                    if($internalNotesFileError){
                        $error = $error + 1;
                    }
                    
                    if($internalNotesFileSize > ($maxFileSize * 1024)){
                        $error = $error + 1;
                    }

                    $fileNew = $internalNotesActualFileName . '.' . $internalNotesActualFileExtension;
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/global/files/internal_notes/' . $internalNoteID . '/'  . $fileNew;

                    if(!move_uploaded_file($internalNotesFileTempName, $fileDestination)){
                        $error = $error + 1;
                    }
                    
                    if($error == 0){
                        $this->globalModel->insertInternalNotesAttachment($internalNoteID, $internalNotesActualFileName, $internalNotesFileSize, $filePath);
                    }
                }
            }
    
            $response = [
                'success' => true,
                'title' => 'Insert Internal Note Success',
                'message' => 'The internal note has been inserted successfully.',
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
}
# -------------------------------------------------------------

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../global/model/global-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new InternalNotesController(new GlobalModel(new DatabaseModel, new SecurityModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>