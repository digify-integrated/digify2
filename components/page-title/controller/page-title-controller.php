<?php
session_start();

# -------------------------------------------------------------
#
# Function: Page TitleController
# Description: 
# The Page TitleController class handles carousel related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class PageTitleController {
    private $pageTitleModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $systemModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided pageTitleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for page title related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param Page TitleModel $pageTitleModel     The pageTitleModel instance for page title related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(PageTitleModel $pageTitleModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SystemModel $systemModel, SecurityModel $securityModel) {
        $this->pageTitleModel = $pageTitleModel;
        $this->blockStyleModel = $blockStyleModel;
        $this->uploadSettingModel = $uploadSettingModel;
        $this->authenticationModel = $authenticationModel;
        $this->systemModel = $systemModel;
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
                case 'add page title':
                    $this->addPageTitle();
                    break;
                case 'update page title':
                    $this->updatePageTitle();
                    break;
                case 'get page title details':
                    $this->getPageTitleDetails();
                    break;
                case 'publish page title':
                    $this->publishPageTitle();
                    break;
                case 'unpublish page title':
                    $this->unpublishPageTitle();
                    break;
                case 'delete page title':
                    $this->deletePageTitle();
                    break;
                case 'delete multiple page title':
                    $this->deleteMultiplePageTitle();
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
    # Function: addPageTitle
    # Description: 
    # Inserts a page title.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addPageTitle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['page_title_name']) && !empty($_POST['page_title_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description']) && isset($_POST['page_title']) && !empty($_POST['page_title']) && isset($_POST['page_heading']) && !empty($_POST['page_heading'])) {
            $userID = $_SESSION['user_account_id'];
            $pageTitleName = $_POST['page_title_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
            $pageTitle = $_POST['page_title'];
            $pageHeading = $_POST['page_heading'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';            

            $pageTitleImageFileName = $_FILES['page_title_image']['name'];
            $pageTitleImageFileSize = $_FILES['page_title_image']['size'];
            $pageTitleImageFileError = $_FILES['page_title_image']['error'];
            $pageTitleImageTempName = $_FILES['page_title_image']['tmp_name'];
            $pageTitleImageFileExtension = explode('.', $pageTitleImageFileName);
            $pageTitleImageActualFileExtension = strtolower(end($pageTitleImageFileExtension));
    
            $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
            $maxFileSize = $uploadSetting['max_file_size'];
    
            $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
            $allowedFileExtensions = [];
    
            foreach ($uploadSettingFileExtension as $row) {
                $allowedFileExtensions[] = $row['file_extension'];
            }
    
            if (!in_array($pageTitleImageActualFileExtension, $allowedFileExtensions)) {
                $response = [
                    'success' => false,
                    'title' => 'Insert Page Title Error',
                    'message' => 'The file uploaded is not supported.',
                    'messageType' => 'error'
                ];
                    
                echo json_encode($response);
                exit;
            }
                
            if(empty($pageTitleImageTempName)){
                $response = [
                    'success' => false,
                    'title' => 'Insert Page Title Error',
                    'message' => 'Please choose the page title item.',
                    'messageType' => 'error'
                ];
                    
                echo json_encode($response);
                exit;
            }
                
            if($pageTitleImageFileError){
                $response = [
                    'success' => false,
                    'title' => 'Insert Page Title Error',
                    'message' => 'An error occurred while uploading the file.',
                    'messageType' => 'error'
                ];
                    
                echo json_encode($response);
                exit;
            }
                
            if($pageTitleImageFileSize > ($maxFileSize * 1024)){
                $response = [
                    'success' => false,
                    'title' => 'Insert Page Title Error',
                    'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                    'messageType' => 'error'
                ];
                    
                echo json_encode($response);
                exit;
            }

            $pageTitleID = $this->pageTitleModel->insertPageTitle($pageTitleName, $description, $blockStyleID, $blockStyleName, $pageTitle, $pageHeading, $userID);
    
            $fileName = $this->securityModel->generateFileName();
            $fileNew = $fileName . '.' . $pageTitleImageActualFileExtension;
                
            define('PROJECT_BASE_DIR', dirname(__DIR__));
            define('CAROUSEL_IMAGE_DIR', 'image/');
    
            $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $pageTitleID. '/';
            $fileDestination = $directory. $fileNew;
            $filePath = './components/page-title/image/'. $pageTitleID . '/' . $fileNew;
    
            $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));

            if(!$directoryChecker){
                $response = [
                    'success' => false,
                    'title' => 'Insert Page Title Error',
                    'message' => $directoryChecker,
                    'messageType' => 'error'
                ];
                    
                echo json_encode($response);
                exit;
            }

            if(!move_uploaded_file($pageTitleImageTempName, $fileDestination)){
                $response = [
                    'success' => false,
                    'title' => 'Insert Page Title Error',
                    'message' => 'The page title cannot be uploaded due to an error.',
                    'messageType' => 'error'
                ];
                    
                echo json_encode($response);
                exit;           
            }

            $this->pageTitleModel->updatePageTitleImage($pageTitleID, $filePath, $userID);
    
            $response = [
                'success' => true,
                'pageTitleID' => $this->securityModel->encryptData($pageTitleID),
                'title' => 'Insert Page Title Success',
                'message' => 'The page title has been inserted successfully.',
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
    # Function: updatePageTitle
    # Description: 
    # Updates the page title if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updatePageTitle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['page_title_name']) && !empty($_POST['page_title_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description']) && isset($_POST['page_title']) && !empty($_POST['page_title']) && isset($_POST['page_heading']) && !empty($_POST['page_heading'])) {
            $userID = $_SESSION['user_account_id'];
            $pageTitleID = htmlspecialchars($_POST['page_title_id'], ENT_QUOTES, 'UTF-8');
            $pageTitleName = $_POST['page_title_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
            $pageTitle = $_POST['page_title'];
            $pageHeading = $_POST['page_heading'];
        
            $checkPageTitleExist = $this->pageTitleModel->checkPageTitleExist($pageTitleID);
            $total = $checkPageTitleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Page Title Error',
                    'message' => 'The page title does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $pageTitleImageFileName = $_FILES['page_title_image']['name'];
            $pageTitleImageFileSize = $_FILES['page_title_image']['size'];
            $pageTitleImageFileError = $_FILES['page_title_image']['error'];
            $pageTitleImageTempName = $_FILES['page_title_image']['tmp_name'];
            $pageTitleImageFileExtension = explode('.', $pageTitleImageFileName);
            $pageTitleImageActualFileExtension = strtolower(end($pageTitleImageFileExtension));

            if (!empty($pageTitleImageFileName) && $pageTitleImageFileSize > 0) {
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
        
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
        
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
        
                if (!in_array($pageTitleImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Update Page Title Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                        
                    echo json_encode($response);
                    exit;
                }
                    
                if(empty($pageTitleImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Update Page Title Error',
                        'message' => 'Please choose the page title item.',
                        'messageType' => 'error'
                    ];
                        
                    echo json_encode($response);
                    exit;
                }
                    
                if($pageTitleImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Update Page Title Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                        
                    echo json_encode($response);
                    exit;
                }
                    
                if($pageTitleImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Update Page Title Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                        
                    echo json_encode($response);
                    exit;
                }
        
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $pageTitleImageActualFileExtension;
                    
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CAROUSEL_IMAGE_DIR', 'image/');
        
                $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $pageTitleID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/page-title/image/'. $pageTitleID . '/' . $fileNew;
        
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Update Page Title Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                        
                    echo json_encode($response);
                    exit;
                }

                $pageTitleDetails = $this->pageTitleModel->getPageTitle($pageTitleID);
                $pageTitleImagePath = !empty($pageTitleDetails['page_title_image']) ? str_replace('./components/', '../../', $pageTitleDetails['page_title_image']) : null;

                if(file_exists($pageTitleImagePath)){
                    if (!unlink($pageTitleImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Page Title Error',
                            'message' => 'The page title cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                            
                        echo json_encode($response);
                        exit;
                    }
                }

                if(!move_uploaded_file($pageTitleImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Update Page Title Error',
                        'message' => 'The page title cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                        
                    echo json_encode($response);
                    exit;           
                }  

                $this->pageTitleModel->updatePageTitle($pageTitleID, $pageTitleName, $description, $blockStyleID, $blockStyleName, $pageTitle, $pageHeading, $filePath, $userID);
                    
                $response = [
                    'success' => true,
                    'title' => 'Update Page Title Success',
                    'message' => 'The page title has been updated successfully.',
                    'messageType' => 'success'
                ];
                    
                echo json_encode($response);
                exit;   
            } 
            else {
                $this->pageTitleModel->updatePageTitle($pageTitleID, $pageTitleName, $description, $blockStyleID, $blockStyleName, $pageTitle, $pageHeading, '', $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Update Page Title Success',
                    'message' => 'The page title has been updated successfully.',
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
    # Function: publishPageTitle
    # Description: 
    # Publish the page title if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishPageTitle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['page_title_id']) && !empty($_POST['page_title_id'])) {
            $userID = $_SESSION['user_account_id'];
            $pageTitleID = htmlspecialchars($_POST['page_title_id'], ENT_QUOTES, 'UTF-8');
        
            $checkPageTitleExist = $this->pageTitleModel->checkPageTitleExist($pageTitleID);
            $total = $checkPageTitleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Page Title Error',
                    'message' => 'The page title does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->pageTitleModel->updatePageTitlePublishStatus($pageTitleID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Page Title Success',
                'message' => 'The page title has been published successfully.',
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
    # Function: unpublishPageTitle
    # Description: 
    # Publish the page title if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishPageTitle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['page_title_id']) && !empty($_POST['page_title_id'])) {
            $userID = $_SESSION['user_account_id'];
            $pageTitleID = htmlspecialchars($_POST['page_title_id'], ENT_QUOTES, 'UTF-8');
        
            $checkPageTitleExist = $this->pageTitleModel->checkPageTitleExist($pageTitleID);
            $total = $checkPageTitleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Page Title Error',
                    'message' => 'The page title does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->pageTitleModel->updatePageTitlePublishStatus($pageTitleID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Page Title Success',
                'message' => 'The page title has been unpublished successfully.',
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
    # Function: deletePageTitle
    # Description: 
    # Delete the page title if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deletePageTitle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['page_title_id']) && !empty($_POST['page_title_id'])) {
            $pageTitleID = htmlspecialchars($_POST['page_title_id'], ENT_QUOTES, 'UTF-8');
        
            $checkPageTitleExist = $this->pageTitleModel->checkPageTitleExist($pageTitleID);
            $total = $checkPageTitleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Page Title Error',
                    'message' => 'The page title does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $pageTitleDetails = $this->pageTitleModel->getPageTitle($pageTitleID);

            $pageTitleImagePath = !empty($pageTitleDetails['page_title_image']) ? str_replace('./components/', '../../', $pageTitleDetails['page_title_image']) : null;

            if(file_exists($pageTitleImagePath)){
                if (!unlink($pageTitleImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Page Title Error',
                        'message' => 'The page title cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                        
                    echo json_encode($response);
                    exit;
                }
            }

            $this->pageTitleModel->deletePageTitle($pageTitleID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Page Title Success',
                'message' => 'The page title has been deleted successfully.',
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
    # Function: deleteMultiplePageTitle
    # Description: 
    # Delete the selected page titles if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultiplePageTitle() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['page_title_id']) && !empty($_POST['page_title_id'])) {
            $pageTitleIDs = $_POST['page_title_id'];
    
            foreach($pageTitleIDs as $pageTitleID){
                $checkPageTitleExist = $this->pageTitleModel->checkPageTitleExist($pageTitleID);
                $total = $checkPageTitleExist['total'] ?? 0;

                if($total > 0){
                    $pageTitleDetails = $this->pageTitleModel->getPageTitle($pageTitleID);

                    $pageTitleImagePath = !empty($pageTitleDetails['page_title_image']) ? str_replace('./components/', '../../', $pageTitleDetails['page_title_image']) : null;

                    if(file_exists($pageTitleImagePath)){
                        if (!unlink($pageTitleImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Delete Page Title Error',
                                'message' => 'The page title cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                                
                            echo json_encode($response);
                            exit;
                        }
                    }

                    $this->pageTitleModel->deletePageTitle($pageTitleID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Page Titles Success',
                'message' => 'The selected page titles have been deleted successfully.',
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
    # Function: getPageTitleDetails
    # Description: 
    # Handles the retrieval of page title details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getPageTitleDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['page_title_id']) && !empty($_POST['page_title_id'])) {
            $userID = $_SESSION['user_account_id'];
            $pageTitleID = htmlspecialchars($_POST['page_title_id'], ENT_QUOTES, 'UTF-8');

            $checkPageTitleExist = $this->pageTitleModel->checkPageTitleExist($pageTitleID);
            $total = $checkPageTitleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Page Title Details Error',
                    'message' => 'The page title does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $carouselDetails = $this->pageTitleModel->getPageTitle($pageTitleID);
            $pageTitleImage = $this->systemModel->checkImage($carouselDetails['page_title_image'] ?? null, 'upload placeholder');

            $response = [
                'success' => true,
                'pageTitleName' => $carouselDetails['page_title_name'] ?? null,
                'description' => $carouselDetails['description'] ?? null,
                'blockStyleID' => $carouselDetails['block_style_id'] ?? '',
                'blockStyleName' => $carouselDetails['block_style_name'] ?? '',
                'pageTitle' => $carouselDetails['page_title'] ?? '',
                'pageHeading' => $carouselDetails['page_heading'] ?? '',
                'pageTitleImage' => $pageTitleImage
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
require_once '../../page-title/model/page-title-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new PageTitleController(new PageTitleModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SystemModel(), new SecurityModel());
$controller->handleRequest();

?>