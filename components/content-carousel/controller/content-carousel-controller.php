<?php
session_start();

# -------------------------------------------------------------
#
# Function: Content CarouselController
# Description: 
# The Content CarouselController class handles carousel related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ContentCarouselController {
    private $contentContentCarouselModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided contentContentCarouselModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for content carousel related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param Content CarouselModel $contentContentCarouselModel     The contentContentCarouselModel instance for content carousel related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ContentCarouselModel $contentContentCarouselModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->contentContentCarouselModel = $contentContentCarouselModel;
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
                case 'add content carousel':
                    $this->addContentCarousel();
                    break;
                case 'update content carousel':
                    $this->updateContentCarousel();
                    break;
                case 'save content carousel item':
                    $this->saveContentCarouselItem();
                    break;
                case 'get content carousel details':
                    $this->getContentCarouselDetails();
                    break;
                case 'get content carousel item details':
                    $this->getContentCarouselItemDetails();
                    break;
                case 'publish content carousel':
                    $this->publishContentCarousel();
                    break;
                case 'unpublish content carousel':
                    $this->unpublishContentCarousel();
                    break;
                case 'delete content carousel':
                    $this->deleteContentCarousel();
                    break;
                case 'delete content carousel item':
                    $this->deleteContentCarouselItem();
                    break;
                case 'delete multiple content carousel':
                    $this->deleteMultipleContentCarousel();
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
    # Function: addContentCarousel
    # Description: 
    # Inserts a content carousel.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addContentCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_name']) && !empty($_POST['content_carousel_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $contentCarouselName = $_POST['content_carousel_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $contentCarouselID = $this->contentContentCarouselModel->insertContentCarousel($contentCarouselName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'contentCarouselID' => $this->securityModel->encryptData($contentCarouselID),
                'title' => 'Insert Content Carousel Success',
                'message' => 'The content carousel has been inserted successfully.',
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
    # Function: updateContentCarousel
    # Description: 
    # Updates the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateContentCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['content_carousel_name']) && !empty($_POST['content_carousel_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $contentCarouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
            $contentCarouselName = $_POST['content_carousel_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkContentCarouselExist = $this->contentContentCarouselModel->checkContentCarouselExist($contentCarouselID);
            $total = $checkContentCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Content Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->contentContentCarouselModel->updateContentCarousel($contentCarouselID, $contentCarouselName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Content Carousel Success',
                'message' => 'The content carousel has been updated successfully.',
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
    # Function: saveContentCarouselItem
    # Description: 
    # Updates the content carousel if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveContentCarouselItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['content_carousel_item_id']) && isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $contentCarouselItemID = htmlspecialchars($_POST['content_carousel_item_id'], ENT_QUOTES, 'UTF-8');
            $contentCarouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
            $contentCarouselTitle = $_POST['content_carousel_title'];
            $contentCarouselHeading = $_POST['content_carousel_heading'];
            $contentCarouselParagraph = $_POST['content_carousel_paragraph'];
            $callToActionButton1Text = $_POST['call_to_action_button_1_text'];
            $callToActionButton1Link = $_POST['call_to_action_button_1_link'];
            $callToActionButton2Text = $_POST['call_to_action_button_2_text'];
            $callToActionButton2Link = $_POST['call_to_action_button_2_link'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkContentCarouselExist = $this->contentContentCarouselModel->checkContentCarouselExist($contentCarouselID);
            $total = $checkContentCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Content Carousel Item Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkContentCarouselItemExist = $this->contentContentCarouselModel->checkContentCarouselItemExist($contentCarouselItemID);
            $total = $checkContentCarouselItemExist['total'] ?? 0;

            if($total > 0){
                $contentCarouselImageFileName = $_FILES['content_carousel_image']['name'];
                $contentCarouselImageFileSize = $_FILES['content_carousel_image']['size'];
                $contentCarouselImageFileError = $_FILES['content_carousel_image']['error'];
                $contentCarouselImageTempName = $_FILES['content_carousel_image']['tmp_name'];
                $contentCarouselImageFileExtension = explode('.', $contentCarouselImageFileName);
                $contentCarouselImageActualFileExtension = strtolower(end($contentCarouselImageFileExtension));

                if (!empty($contentCarouselImageFileName) && $contentCarouselImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($contentCarouselImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Content Carousel Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($contentCarouselImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Content Carousel Item Error',
                            'message' => 'Please choose the content carousel item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($contentCarouselImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Content Carousel Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($contentCarouselImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Content Carousel Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $contentCarouselImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('CAROUSEL_IMAGE_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $contentCarouselID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/content-carousel/image/'. $contentCarouselID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Content Carousel Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $contentCarouselItemDetails = $this->contentContentCarouselModel->getContentCarouselItem($contentCarouselItemID);
                    $contentCarouselImagePath = !empty($contentCarouselItemDetails['content_carousel_image']) ? str_replace('./components/', '../../', $contentCarouselItemDetails['content_carousel_image']) : null;

                    if(file_exists($contentCarouselImagePath)){
                        if (!unlink($contentCarouselImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Content Carousel Item Error',
                                'message' => 'The content carousel item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($contentCarouselImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Content Carousel Item Error',
                            'message' => 'The content carousel item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->contentContentCarouselModel->updateContentCarouselItem($contentCarouselItemID, $contentCarouselID, $contentCarouselTitle, $contentCarouselHeading, $contentCarouselParagraph, $callToActionButton1Text, $callToActionButton1Link, $callToActionButton2Text, $callToActionButton2Link, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Content Carousel Item Success',
                        'message' => 'The content carousel item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->contentContentCarouselModel->updateContentCarouselItem($contentCarouselItemID, $contentCarouselID, $contentCarouselTitle, $contentCarouselHeading, $contentCarouselParagraph, $callToActionButton1Text, $callToActionButton1Link, $callToActionButton2Text, $callToActionButton2Link, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Content Carousel Item Success',
                        'message' => 'The content carousel item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $contentCarouselImageFileName = $_FILES['content_carousel_image']['name'];
                $contentCarouselImageFileSize = $_FILES['content_carousel_image']['size'];
                $contentCarouselImageFileError = $_FILES['content_carousel_image']['error'];
                $contentCarouselImageTempName = $_FILES['content_carousel_image']['tmp_name'];
                $contentCarouselImageFileExtension = explode('.', $contentCarouselImageFileName);
                $contentCarouselImageActualFileExtension = strtolower(end($contentCarouselImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($contentCarouselImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Content Carousel Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($contentCarouselImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Content Carousel Item Error',
                        'message' => 'Please choose the content carousel item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($contentCarouselImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Content Carousel Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($contentCarouselImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Content Carousel Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $contentCarouselImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CAROUSEL_IMAGE_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $contentCarouselID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/content-carousel/image/'. $contentCarouselID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Content Carousel Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($contentCarouselImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Content Carousel Item Error',
                        'message' => 'The content carousel item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->contentContentCarouselModel->insertContentCarouselItem($contentCarouselID, $contentCarouselTitle, $contentCarouselHeading, $contentCarouselParagraph, $callToActionButton1Text, $callToActionButton1Link, $callToActionButton2Text, $callToActionButton2Link, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Content Carousel Item Success',
                    'message' => 'The content carousel item has been inserted successfully.',
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
    # Function: publishContentCarousel
    # Description: 
    # Publish the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishContentCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contentCarouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContentCarouselExist = $this->contentContentCarouselModel->checkContentCarouselExist($contentCarouselID);
            $total = $checkContentCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Content Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contentContentCarouselModel->updateContentCarouselPublishStatus($contentCarouselID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Content Carousel Success',
                'message' => 'The content carousel has been published successfully.',
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
    # Function: unpublishContentCarousel
    # Description: 
    # Publish the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishContentCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contentCarouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContentCarouselExist = $this->contentContentCarouselModel->checkContentCarouselExist($contentCarouselID);
            $total = $checkContentCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Content Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contentContentCarouselModel->updateContentCarouselPublishStatus($contentCarouselID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Content Carousel Success',
                'message' => 'The content carousel has been unpublished successfully.',
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
    # Function: deleteContentCarousel
    # Description: 
    # Delete the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteContentCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $contentCarouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContentCarouselExist = $this->contentContentCarouselModel->checkContentCarouselExist($contentCarouselID);
            $total = $checkContentCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Content Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $contentCarouselItemByCourselDetails = $this->contentContentCarouselModel->getContentCarouselItemByContentCarouselID($contentCarouselID);

            foreach ($contentCarouselItemByCourselDetails as $row) {
                $contentCarouselImagePath = !empty($row['content_carousel_image']) ? str_replace('./components/', '../../', $row['content_carousel_image']) : null;

                if(file_exists($contentCarouselImagePath)){
                    if (!unlink($contentCarouselImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Content Carousel Item Error',
                            'message' => 'The content carousel item cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->contentContentCarouselModel->deleteContentCarousel($contentCarouselID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Content Carousel Success',
                'message' => 'The content carousel has been deleted successfully.',
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
    # Function: deleteContentCarouselItem
    # Description: 
    # Delete the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteContentCarouselItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_item_id']) && !empty($_POST['content_carousel_item_id'])) {
            $contentCarouselItemID = htmlspecialchars($_POST['content_carousel_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkContentCarouselItemExist = $this->contentContentCarouselModel->checkContentCarouselItemExist($contentCarouselItemID);
            $total = $checkContentCarouselItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Content Carousel Item Error',
                    'message' => 'The content carousel item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $contentCarouselItemDetails = $this->contentContentCarouselModel->getContentCarouselItem($contentCarouselItemID);
            $contentCarouselImagePath = !empty($contentCarouselItemDetails['content_carousel_image']) ? str_replace('./components/', '../../', $contentCarouselItemDetails['content_carousel_image']) : null;


            if(file_exists($contentCarouselImagePath)){
                if (!unlink($contentCarouselImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Content Carousel Item Error',
                        'message' => 'The content carousel item cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->contentContentCarouselModel->deleteContentCarouselItem($contentCarouselItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Content Carousel Item Success',
                'message' => 'The content carousel item has been deleted successfully.',
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
    # Function: deleteMultipleContentCarousel
    # Description: 
    # Delete the selected content carousels if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleContentCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $contentCarouselIDs = $_POST['content_carousel_id'];
    
            foreach($contentCarouselIDs as $contentCarouselID){
                $checkContentCarouselExist = $this->contentContentCarouselModel->checkContentCarouselExist($contentCarouselID);
                $total = $checkContentCarouselExist['total'] ?? 0;

                if($total > 0){
                    $contentCarouselItemByCourselDetails = $this->contentContentCarouselModel->getContentCarouselItemByContentCarouselID($contentCarouselID);

                    foreach ($contentCarouselItemByCourselDetails as $row) {
                        $contentCarouselImagePath = !empty($row['content_carousel_image']) ? str_replace('./components/', '../../', $row['content_carousel_image']) : null;

                        if(file_exists($contentCarouselImagePath)){
                            if (!unlink($contentCarouselImagePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Content Carousel Item Error',
                                    'message' => 'The content carousel item cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->contentContentCarouselModel->deleteContentCarousel($contentCarouselID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Content Carousels Success',
                'message' => 'The selected content carousels have been deleted successfully.',
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
    # Function: getContentCarouselDetails
    # Description: 
    # Handles the retrieval of content carousel details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getContentCarouselDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contentCarouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');

            $checkContentCarouselExist = $this->contentContentCarouselModel->checkContentCarouselExist($contentCarouselID);
            $total = $checkContentCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Content Carousel Details Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $carouselDetails = $this->contentContentCarouselModel->getContentCarousel($contentCarouselID);

            $response = [
                'success' => true,
                'contentCarouselName' => $carouselDetails['content_carousel_name'] ?? null,
                'description' => $carouselDetails['description'] ?? null,
                'blockStyleID' => $carouselDetails['block_style_id'] ?? '',
                'blockStyleName' => $carouselDetails['block_style_name'] ?? ''
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
    # Function: getContentCarouselItemDetails
    # Description: 
    # Handles the retrieval of content carousel item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getContentCarouselItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['content_carousel_item_id']) && !empty($_POST['content_carousel_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $contentCarouselItemID = htmlspecialchars($_POST['content_carousel_item_id'], ENT_QUOTES, 'UTF-8');

            $checkContentCarouselItemExist = $this->contentContentCarouselModel->checkContentCarouselItemExist($contentCarouselItemID);
            $total = $checkContentCarouselItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Content Carousel Item Details Error',
                    'message' => 'The content carousel item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $contentCarouselItemDetails = $this->contentContentCarouselModel->getContentCarouselItem($contentCarouselItemID);

            $response = [
                'success' => true,
                'contentCarouselTitle' => $contentCarouselItemDetails['content_carousel_title'] ?? null,
                'contentCarouselHeading' => $contentCarouselItemDetails['content_carousel_heading'] ?? null,
                'contentCarouselParagraph' => $contentCarouselItemDetails['content_carousel_paragraph'] ?? null,
                'callToActionButton1Text' => $contentCarouselItemDetails['call_to_action_button_1_text'] ?? null,
                'callToActionButton1Link' => $contentCarouselItemDetails['call_to_action_button_1_link'] ?? null,
                'callToActionButton2Text' => $contentCarouselItemDetails['call_to_action_button_2_text'] ?? null,
                'callToActionButton2Link' => $contentCarouselItemDetails['call_to_action_button_2_link'] ?? null,
                'orderSequence' => $contentCarouselItemDetails['order_sequence'] ?? null,
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
require_once '../../content-carousel/model/content-carousel-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ContentCarouselController(new ContentCarouselModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>