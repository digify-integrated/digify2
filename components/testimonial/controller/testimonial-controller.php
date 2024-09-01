<?php
session_start();

# -------------------------------------------------------------
#
# Function: TestimonialController
# Description: 
# The TestimonialController class handles testimonial related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class TestimonialController {
    private $testimonialModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided testimonialModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for testimonial related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param TestimonialModel $testimonialModel     The testimonialModel instance for testimonial related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(TestimonialModel $testimonialModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->testimonialModel = $testimonialModel;
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
                case 'add testimonial':
                    $this->addTestimonial();
                    break;
                case 'update testimonial':
                    $this->updateTestimonial();
                    break;
                case 'save testimonial item':
                    $this->saveTestimonialItem();
                    break;
                case 'get testimonial details':
                    $this->getTestimonialDetails();
                    break;
                case 'get testimonial item details':
                    $this->getTestimonialItemDetails();
                    break;
                case 'publish testimonial':
                    $this->publishTestimonial();
                    break;
                case 'unpublish testimonial':
                    $this->unpublishTestimonial();
                    break;
                case 'delete testimonial':
                    $this->deleteTestimonial();
                    break;
                case 'delete testimonial item':
                    $this->deleteTestimonialItem();
                    break;
                case 'delete multiple testimonial':
                    $this->deleteMultipleTestimonial();
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
    # Function: addTestimonial
    # Description: 
    # Inserts a testimonial.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addTestimonial() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['testimonial_name']) && !empty($_POST['testimonial_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $testimonialName = $_POST['testimonial_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $testimonialID = $this->testimonialModel->insertTestimonial($testimonialName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'testimonialID' => $this->securityModel->encryptData($testimonialID),
                'title' => 'Insert Testimonial Success',
                'message' => 'The testimonial has been inserted successfully.',
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
    # Function: updateTestimonial
    # Description: 
    # Updates the testimonial if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateTestimonial() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['testimonial_name']) && !empty($_POST['testimonial_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $testimonialID = htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8');
            $testimonialName = $_POST['testimonial_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkTestimonialExist = $this->testimonialModel->checkTestimonialExist($testimonialID);
            $total = $checkTestimonialExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Testimonial Error',
                    'message' => 'The testimonial does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->testimonialModel->updateTestimonial($testimonialID, $testimonialName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Testimonial Success',
                'message' => 'The testimonial has been updated successfully.',
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
    # Function: saveTestimonialItem
    # Description: 
    # Updates the testimonial if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveTestimonialItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['testimonial_item_id']) && isset($_POST['testimonial_id']) && !empty($_POST['testimonial_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $testimonialItemID = htmlspecialchars($_POST['testimonial_item_id'], ENT_QUOTES, 'UTF-8');
            $testimonialID = htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8');
            $testimonialTitle = $_POST['testimonial_title'];
            $testimonialClient = $_POST['testimonial_client'];
            $testimonialParagraph = $_POST['testimonial_paragraph'];
            $rating = $_POST['rating'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkTestimonialExist = $this->testimonialModel->checkTestimonialExist($testimonialID);
            $total = $checkTestimonialExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Testimonial Item Error',
                    'message' => 'The testimonial does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkTestimonialItemExist = $this->testimonialModel->checkTestimonialItemExist($testimonialItemID);
            $total = $checkTestimonialItemExist['total'] ?? 0;

            if($total > 0){
                $testimonialImageFileName = $_FILES['testimonial_image']['name'];
                $testimonialImageFileSize = $_FILES['testimonial_image']['size'];
                $testimonialImageFileError = $_FILES['testimonial_image']['error'];
                $testimonialImageTempName = $_FILES['testimonial_image']['tmp_name'];
                $testimonialImageFileExtension = explode('.', $testimonialImageFileName);
                $testimonialImageActualFileExtension = strtolower(end($testimonialImageFileExtension));

                if (!empty($testimonialImageFileName) && $testimonialImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($testimonialImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Testimonial Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($testimonialImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Testimonial Item Error',
                            'message' => 'Please choose the testimonial item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($testimonialImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Testimonial Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($testimonialImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Testimonial Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $testimonialImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('TESTIMONIAL_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. TESTIMONIAL_DIR. $testimonialID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/testimonial/image/'. $testimonialID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Testimonial Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $testimonialItemDetails = $this->testimonialModel->getTestimonialItem($testimonialItemID);
                    $testimonialImagePath = !empty($testimonialItemDetails['testimonial_image']) ? str_replace('./components/', '../../', $testimonialItemDetails['testimonial_image']) : null;

                    if(file_exists($testimonialImagePath)){
                        if (!unlink($testimonialImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Testimonial Item Error',
                                'message' => 'The testimonial item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($testimonialImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Testimonial Item Error',
                            'message' => 'The testimonial item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->testimonialModel->updateTestimonialItem($testimonialItemID, $testimonialID, $testimonialClient, $testimonialTitle, $testimonialParagraph, $rating, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Testimonial Item Success',
                        'message' => 'The testimonial item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->testimonialModel->updateTestimonialItem($testimonialItemID, $testimonialID, $testimonialClient, $testimonialTitle, $testimonialParagraph, $rating, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Testimonial Item Success',
                        'message' => 'The testimonial item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $testimonialImageFileName = $_FILES['testimonial_image']['name'];
                $testimonialImageFileSize = $_FILES['testimonial_image']['size'];
                $testimonialImageFileError = $_FILES['testimonial_image']['error'];
                $testimonialImageTempName = $_FILES['testimonial_image']['tmp_name'];
                $testimonialImageFileExtension = explode('.', $testimonialImageFileName);
                $testimonialImageActualFileExtension = strtolower(end($testimonialImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($testimonialImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Testimonial Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($testimonialImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Testimonial Item Error',
                        'message' => 'Please choose the testimonial item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($testimonialImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Testimonial Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($testimonialImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Testimonial Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $testimonialImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('TESTIMONIAL_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. TESTIMONIAL_DIR. $testimonialID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/testimonial/image/'. $testimonialID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Testimonial Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($testimonialImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Testimonial Item Error',
                        'message' => 'The testimonial item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->testimonialModel->insertTestimonialItem($testimonialID, $testimonialClient, $testimonialTitle, $testimonialParagraph, $rating, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Testimonial Item Success',
                    'message' => 'The testimonial item has been inserted successfully.',
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
    # Function: publishTestimonial
    # Description: 
    # Publish the testimonial if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishTestimonial() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['testimonial_id']) && !empty($_POST['testimonial_id'])) {
            $userID = $_SESSION['user_account_id'];
            $testimonialID = htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8');
        
            $checkTestimonialExist = $this->testimonialModel->checkTestimonialExist($testimonialID);
            $total = $checkTestimonialExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Testimonial Error',
                    'message' => 'The testimonial does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->testimonialModel->updateTestimonialPublishStatus($testimonialID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Testimonial Success',
                'message' => 'The testimonial has been published successfully.',
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
    # Function: unpublishTestimonial
    # Description: 
    # Publish the testimonial if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishTestimonial() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['testimonial_id']) && !empty($_POST['testimonial_id'])) {
            $userID = $_SESSION['user_account_id'];
            $testimonialID = htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8');
        
            $checkTestimonialExist = $this->testimonialModel->checkTestimonialExist($testimonialID);
            $total = $checkTestimonialExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Testimonial Error',
                    'message' => 'The testimonial does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->testimonialModel->updateTestimonialPublishStatus($testimonialID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Testimonial Success',
                'message' => 'The testimonial has been unpublished successfully.',
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
    # Function: deleteTestimonial
    # Description: 
    # Delete the testimonial if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteTestimonial() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['testimonial_id']) && !empty($_POST['testimonial_id'])) {
            $testimonialID = htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8');
        
            $checkTestimonialExist = $this->testimonialModel->checkTestimonialExist($testimonialID);
            $total = $checkTestimonialExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Testimonial Error',
                    'message' => 'The testimonial does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $testimonialItemByCourselDetails = $this->testimonialModel->getTestimonialItemByTestimonialID($testimonialID);

            foreach ($testimonialItemByCourselDetails as $row) {
                $testimonialImagePath = !empty($row['testimonial_image']) ? str_replace('./components/', '../../', $row['testimonial_image']) : null;

                if(file_exists($testimonialImagePath)){
                    if (!unlink($testimonialImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Testimonial Item Error',
                            'message' => 'The testimonial item cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->testimonialModel->deleteTestimonial($testimonialID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Testimonial Success',
                'message' => 'The testimonial has been deleted successfully.',
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
    # Function: deleteTestimonialItem
    # Description: 
    # Delete the testimonial if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteTestimonialItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['testimonial_item_id']) && !empty($_POST['testimonial_item_id'])) {
            $testimonialItemID = htmlspecialchars($_POST['testimonial_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkTestimonialItemExist = $this->testimonialModel->checkTestimonialItemExist($testimonialItemID);
            $total = $checkTestimonialItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Testimonial Item Error',
                    'message' => 'The testimonial item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $testimonialItemDetails = $this->testimonialModel->getTestimonialItem($testimonialItemID);
            $testimonialImagePath = !empty($testimonialItemDetails['testimonial_image']) ? str_replace('./components/', '../../', $testimonialItemDetails['testimonial_image']) : null;


            if(file_exists($testimonialImagePath)){
                if (!unlink($testimonialImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Testimonial Item Error',
                        'message' => 'The testimonial item cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->testimonialModel->deleteTestimonialItem($testimonialItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Testimonial Item Success',
                'message' => 'The testimonial item has been deleted successfully.',
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
    # Function: deleteMultipleTestimonial
    # Description: 
    # Delete the selected testimonials if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleTestimonial() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['testimonial_id']) && !empty($_POST['testimonial_id'])) {
            $testimonialIDs = $_POST['testimonial_id'];
    
            foreach($testimonialIDs as $testimonialID){
                $checkTestimonialExist = $this->testimonialModel->checkTestimonialExist($testimonialID);
                $total = $checkTestimonialExist['total'] ?? 0;

                if($total > 0){
                    $testimonialItemByCourselDetails = $this->testimonialModel->getTestimonialItemByTestimonialID($testimonialID);

                    foreach ($testimonialItemByCourselDetails as $row) {
                        $testimonialImagePath = !empty($row['testimonial_image']) ? str_replace('./components/', '../../', $row['testimonial_image']) : null;

                        if(file_exists($testimonialImagePath)){
                            if (!unlink($testimonialImagePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Testimonial Item Error',
                                    'message' => 'The testimonial item cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->testimonialModel->deleteTestimonial($testimonialID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Testimonials Success',
                'message' => 'The selected testimonials have been deleted successfully.',
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
    # Function: getTestimonialDetails
    # Description: 
    # Handles the retrieval of testimonial details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getTestimonialDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['testimonial_id']) && !empty($_POST['testimonial_id'])) {
            $userID = $_SESSION['user_account_id'];
            $testimonialID = htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8');

            $checkTestimonialExist = $this->testimonialModel->checkTestimonialExist($testimonialID);
            $total = $checkTestimonialExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Testimonial Details Error',
                    'message' => 'The testimonial does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $testimonialDetails = $this->testimonialModel->getTestimonial($testimonialID);

            $response = [
                'success' => true,
                'testimonialName' => $testimonialDetails['testimonial_name'] ?? null,
                'description' => $testimonialDetails['description'] ?? null,
                'blockStyleID' => $testimonialDetails['block_style_id'] ?? '',
                'blockStyleName' => $testimonialDetails['block_style_name'] ?? ''
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
    # Function: getTestimonialItemDetails
    # Description: 
    # Handles the retrieval of testimonial item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getTestimonialItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['testimonial_item_id']) && !empty($_POST['testimonial_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $testimonialItemID = htmlspecialchars($_POST['testimonial_item_id'], ENT_QUOTES, 'UTF-8');

            $checkTestimonialItemExist = $this->testimonialModel->checkTestimonialItemExist($testimonialItemID);
            $total = $checkTestimonialItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Testimonial Item Details Error',
                    'message' => 'The testimonial item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $testimonialItemDetails = $this->testimonialModel->getTestimonialItem($testimonialItemID);

            $response = [
                'success' => true,
                'testimonialTitle' => $testimonialItemDetails['testimonial_title'] ?? null,
                'testimonialClient' => $testimonialItemDetails['testimonial_client'] ?? null,
                'testimonialParagraph' => $testimonialItemDetails['testimonial_paragraph'] ?? null,
                'rating' => $testimonialItemDetails['rating'] ?? null,
                'orderSequence' => $testimonialItemDetails['order_sequence'] ?? null,
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
require_once '../../testimonial/model/testimonial-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new TestimonialController(new TestimonialModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>