<?php
session_start();

# -------------------------------------------------------------
#
# Function: ProcessStepController
# Description: 
# The ProcessStepController class handles process step related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ProcesStepController {
    private $processStepModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided processStepModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for process step related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ProcessStepModel $processStepModel     The processStepModel instance for process step related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ProcesStepModel $processStepModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->processStepModel = $processStepModel;
        $this->blockStyleModel = $blockStyleModel;
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
                case 'add process step':
                    $this->addProcesStep();
                    break;
                case 'update process step':
                    $this->updateProcesStep();
                    break;
                case 'save process step item':
                    $this->saveProcesStepItem();
                    break;
                case 'get process step details':
                    $this->getProcesStepDetails();
                    break;
                case 'get process step item details':
                    $this->getProcesStepItemDetails();
                    break;
                case 'publish process step':
                    $this->publishProcesStep();
                    break;
                case 'unpublish process step':
                    $this->unpublishProcesStep();
                    break;
                case 'delete process step':
                    $this->deleteProcesStep();
                    break;
                case 'delete process step item':
                    $this->deleteProcesStepItem();
                    break;
                case 'delete multiple process step':
                    $this->deleteMultipleProcesStep();
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
    # Function: addProcesStep
    # Description: 
    # Inserts a process step.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addProcesStep() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['process_step_name']) && !empty($_POST['process_step_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $procesStepName = $_POST['process_step_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $procesStepID = $this->processStepModel->insertProcesStep($procesStepName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'procesStepID' => $this->securityModel->encryptData($procesStepID),
                'title' => 'Insert Process Step Success',
                'message' => 'The process step has been inserted successfully.',
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
    # Function: updateProcesStep
    # Description: 
    # Updates the process step if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateProcesStep() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['process_step_name']) && !empty($_POST['process_step_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $procesStepID = htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8');
            $procesStepName = $_POST['process_step_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkProcesStepExist = $this->processStepModel->checkProcesStepExist($procesStepID);
            $total = $checkProcesStepExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Process Step Error',
                    'message' => 'The process step does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->processStepModel->updateProcesStep($procesStepID, $procesStepName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Process Step Success',
                'message' => 'The process step has been updated successfully.',
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
    # Function: saveProcesStepItem
    # Description: 
    # Updates the process step if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveProcesStepItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['process_step_item_id']) && isset($_POST['process_step_id']) && !empty($_POST['process_step_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $procesStepItemID = htmlspecialchars($_POST['process_step_item_id'], ENT_QUOTES, 'UTF-8');
            $procesStepID = htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8');
            $procesStepTitle = $_POST['process_step_title'];
            $procesStepHeading = $_POST['process_step_heading'];
            $procesStepLink = $_POST['process_step_link'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkProcesStepExist = $this->processStepModel->checkProcesStepExist($procesStepID);
            $total = $checkProcesStepExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Process Step Item Error',
                    'message' => 'The process step does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkProcesStepItemExist = $this->processStepModel->checkProcesStepItemExist($procesStepItemID);
            $total = $checkProcesStepItemExist['total'] ?? 0;

            if($total > 0){
                $procesStepImageFileName = $_FILES['process_step_image']['name'];
                $procesStepImageFileSize = $_FILES['process_step_image']['size'];
                $procesStepImageFileError = $_FILES['process_step_image']['error'];
                $procesStepImageTempName = $_FILES['process_step_image']['tmp_name'];
                $procesStepImageFileExtension = explode('.', $procesStepImageFileName);
                $procesStepImageActualFileExtension = strtolower(end($procesStepImageFileExtension));

                if (!empty($procesStepImageFileName) && $procesStepImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($procesStepImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Process Step Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($procesStepImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Process Step Item Error',
                            'message' => 'Please choose the process step item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($procesStepImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Process Step Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($procesStepImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Process Step Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $procesStepImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('CAROUSEL_IMAGE_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $procesStepID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/process-step/image/'. $procesStepID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Process Step Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $procesStepItemDetails = $this->processStepModel->getProcesStepItem($procesStepItemID);
                    $procesStepImagePath = !empty($procesStepItemDetails['process_step_image']) ? str_replace('./components/', '../../', $procesStepItemDetails['process_step_image']) : null;

                    if(file_exists($procesStepImagePath)){
                        if (!unlink($procesStepImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Process Step Item Error',
                                'message' => 'The process step item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($procesStepImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Process Step Item Error',
                            'message' => 'The process step item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->processStepModel->updateProcesStepItem($procesStepItemID, $procesStepID, $procesStepTitle, $procesStepHeading, $procesStepLink, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Process Step Item Success',
                        'message' => 'The process step item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->processStepModel->updateProcesStepItem($procesStepItemID, $procesStepID, $procesStepTitle, $procesStepHeading, $procesStepLink, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Process Step Item Success',
                        'message' => 'The process step item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $procesStepImageFileName = $_FILES['process_step_image']['name'];
                $procesStepImageFileSize = $_FILES['process_step_image']['size'];
                $procesStepImageFileError = $_FILES['process_step_image']['error'];
                $procesStepImageTempName = $_FILES['process_step_image']['tmp_name'];
                $procesStepImageFileExtension = explode('.', $procesStepImageFileName);
                $procesStepImageActualFileExtension = strtolower(end($procesStepImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($procesStepImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Process Step Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($procesStepImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Process Step Item Error',
                        'message' => 'Please choose the process step item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($procesStepImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Process Step Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($procesStepImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Process Step Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $procesStepImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CAROUSEL_IMAGE_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $procesStepID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/process-step/image/'. $procesStepID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Process Step Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($procesStepImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Process Step Item Error',
                        'message' => 'The process step item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->processStepModel->insertProcesStepItem($procesStepID, $procesStepTitle, $procesStepHeading, $procesStepLink, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Process Step Item Success',
                    'message' => 'The process step item has been inserted successfully.',
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
    #   Publish methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: publishProcesStep
    # Description: 
    # Publish the process step if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishProcesStep() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['process_step_id']) && !empty($_POST['process_step_id'])) {
            $userID = $_SESSION['user_account_id'];
            $procesStepID = htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8');
        
            $checkProcesStepExist = $this->processStepModel->checkProcesStepExist($procesStepID);
            $total = $checkProcesStepExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Process Step Error',
                    'message' => 'The process step does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->processStepModel->updateProcesStepPublishStatus($procesStepID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Process Step Success',
                'message' => 'The process step has been published successfully.',
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
    #   Publish methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: unpublishProcesStep
    # Description: 
    # Publish the process step if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishProcesStep() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['process_step_id']) && !empty($_POST['process_step_id'])) {
            $userID = $_SESSION['user_account_id'];
            $procesStepID = htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8');
        
            $checkProcesStepExist = $this->processStepModel->checkProcesStepExist($procesStepID);
            $total = $checkProcesStepExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Process Step Error',
                    'message' => 'The process step does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->processStepModel->updateProcesStepPublishStatus($procesStepID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Process Step Success',
                'message' => 'The process step has been unpublished successfully.',
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
    # Function: deleteProcesStep
    # Description: 
    # Delete the process step if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteProcesStep() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['process_step_id']) && !empty($_POST['process_step_id'])) {
            $procesStepID = htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8');
        
            $checkProcesStepExist = $this->processStepModel->checkProcesStepExist($procesStepID);
            $total = $checkProcesStepExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Process Step Error',
                    'message' => 'The process step does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $procesStepItemByCourselDetails = $this->processStepModel->getProcesStepItemByProcesStepID($procesStepID);

            foreach ($procesStepItemByCourselDetails as $row) {
                $procesStepImagePath = !empty($row['process_step_image']) ? str_replace('./components/', '../../', $row['process_step_image']) : null;

                if(file_exists($procesStepImagePath)){
                    if (!unlink($procesStepImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Process Step Item Error',
                            'message' => 'The process step item cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->processStepModel->deleteProcesStep($procesStepID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Process Step Success',
                'message' => 'The process step has been deleted successfully.',
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
    # Function: deleteProcesStepItem
    # Description: 
    # Delete the process step if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteProcesStepItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['process_step_item_id']) && !empty($_POST['process_step_item_id'])) {
            $procesStepItemID = htmlspecialchars($_POST['process_step_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkProcesStepItemExist = $this->processStepModel->checkProcesStepItemExist($procesStepItemID);
            $total = $checkProcesStepItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Process Step Item Error',
                    'message' => 'The process step item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $procesStepItemDetails = $this->processStepModel->getProcesStepItem($procesStepItemID);
            $procesStepImagePath = !empty($procesStepItemDetails['process_step_image']) ? str_replace('./components/', '../../', $procesStepItemDetails['process_step_image']) : null;


            if(file_exists($procesStepImagePath)){
                if (!unlink($procesStepImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Process Step Item Error',
                        'message' => 'The process step item cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->processStepModel->deleteProcesStepItem($procesStepItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Process Step Item Success',
                'message' => 'The process step item has been deleted successfully.',
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
    # Function: deleteMultipleProcesStep
    # Description: 
    # Delete the selected process steps if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleProcesStep() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['process_step_id']) && !empty($_POST['process_step_id'])) {
            $procesStepIDs = $_POST['process_step_id'];
    
            foreach($procesStepIDs as $procesStepID){
                $checkProcesStepExist = $this->processStepModel->checkProcesStepExist($procesStepID);
                $total = $checkProcesStepExist['total'] ?? 0;

                if($total > 0){
                    $procesStepItemByCourselDetails = $this->processStepModel->getProcesStepItemByProcesStepID($procesStepID);

                    foreach ($procesStepItemByCourselDetails as $row) {
                        $procesStepImagePath = !empty($row['process_step_image']) ? str_replace('./components/', '../../', $row['process_step_image']) : null;

                        if(file_exists($procesStepImagePath)){
                            if (!unlink($procesStepImagePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Process Step Item Error',
                                    'message' => 'The process step item cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->processStepModel->deleteProcesStep($procesStepID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Process Steps Success',
                'message' => 'The selected process steps have been deleted successfully.',
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
    # Function: getProcesStepDetails
    # Description: 
    # Handles the retrieval of process step details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getProcesStepDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['process_step_id']) && !empty($_POST['process_step_id'])) {
            $userID = $_SESSION['user_account_id'];
            $procesStepID = htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8');

            $checkProcesStepExist = $this->processStepModel->checkProcesStepExist($procesStepID);
            $total = $checkProcesStepExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Process Step Details Error',
                    'message' => 'The process step does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $processStepDetails = $this->processStepModel->getProcesStep($procesStepID);

            $response = [
                'success' => true,
                'procesStepName' => $processStepDetails['process_step_name'] ?? null,
                'description' => $processStepDetails['description'] ?? null,
                'blockStyleID' => $processStepDetails['block_style_id'] ?? '',
                'blockStyleName' => $processStepDetails['block_style_name'] ?? ''
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
    # Function: getProcesStepItemDetails
    # Description: 
    # Handles the retrieval of process step item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getProcesStepItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['process_step_item_id']) && !empty($_POST['process_step_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $procesStepItemID = htmlspecialchars($_POST['process_step_item_id'], ENT_QUOTES, 'UTF-8');

            $checkProcesStepItemExist = $this->processStepModel->checkProcesStepItemExist($procesStepItemID);
            $total = $checkProcesStepItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Process Step Item Details Error',
                    'message' => 'The process step item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $procesStepItemDetails = $this->processStepModel->getProcesStepItem($procesStepItemID);

            $response = [
                'success' => true,
                'procesStepTitle' => $procesStepItemDetails['process_step_title'] ?? null,
                'procesStepHeading' => $procesStepItemDetails['process_step_heading'] ?? null,
                'procesStepLink' => $procesStepItemDetails['process_step_link'] ?? null,
                'orderSequence' => $procesStepItemDetails['order_sequence'] ?? null,
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
require_once '../../process-step/model/process-step-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ProcesStepController(new ProcesStepModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>