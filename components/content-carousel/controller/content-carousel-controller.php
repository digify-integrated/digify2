<?php
session_start();

# -------------------------------------------------------------
#
# Function: ContentCarouselController
# Description: 
# The ContentCarouselController class handles carousel related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ContentCarouselController {
    private $contentCarouselModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided contentCarouselModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for content carousel related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ContentCarouselModel $contentCarouselModel     The contentCarouselModel instance for content carousel related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ContentCarouselModel $contentCarouselModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->contentCarouselModel = $contentCarouselModel;
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
                    $this->addCarousel();
                    break;
                case 'update content carousel':
                    $this->updateCarousel();
                    break;
                case 'save content carousel image':
                    $this->saveCarouselImage();
                    break;
                case 'get content carousel details':
                    $this->getCarouselDetails();
                    break;
                case 'get content carousel image details':
                    $this->getCarouselImageDetails();
                    break;
                case 'publish content carousel':
                    $this->publishCarousel();
                    break;
                case 'unpublish content carousel':
                    $this->unpublishCarousel();
                    break;
                case 'delete content carousel':
                    $this->deleteCarousel();
                    break;
                case 'delete content carousel image':
                    $this->deleteCarouselImage();
                    break;
                case 'delete multiple content carousel':
                    $this->deleteMultipleCarousel();
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
    # Function: addCarousel
    # Description: 
    # Inserts a content carousel.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_name']) && !empty($_POST['content_carousel_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselName = $_POST['content_carousel_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $carouselID = $this->contentCarouselModel->insertCarousel($carouselName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'carouselID' => $this->securityModel->encryptData($carouselID),
                'title' => 'Insert Carousel Success',
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
    # Function: updateCarousel
    # Description: 
    # Updates the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['content_carousel_name']) && !empty($_POST['content_carousel_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
            $carouselName = $_POST['content_carousel_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkCarouselExist = $this->contentCarouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->contentCarouselModel->updateCarousel($carouselID, $carouselName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Carousel Success',
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
    # Function: saveCarouselImage
    # Description: 
    # Updates the content carousel if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveCarouselImage() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['content_carousel_image_id']) && isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselImageID = htmlspecialchars($_POST['content_carousel_image_id'], ENT_QUOTES, 'UTF-8');
            $carouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
            $orderSequence = $_POST['order_sequence'];
        
            $checkCarouselExist = $this->contentCarouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Carousel Image Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkCarouselImageExist = $this->contentCarouselModel->checkCarouselImageExist($carouselImageID);
            $total = $checkCarouselImageExist['total'] ?? 0;

            if($total > 0){
                $carouselImageFileName = $_FILES['content_carousel_image']['name'];
                $carouselImageFileSize = $_FILES['content_carousel_image']['size'];
                $carouselImageFileError = $_FILES['content_carousel_image']['error'];
                $carouselImageTempName = $_FILES['content_carousel_image']['tmp_name'];
                $carouselImageFileExtension = explode('.', $carouselImageFileName);
                $carouselImageActualFileExtension = strtolower(end($carouselImageFileExtension));

                if (!empty($carouselImageFileName) && $carouselImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($carouselImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Carousel Image Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($carouselImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Carousel Image Error',
                            'message' => 'Please choose the content carousel image.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($carouselImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Carousel Image Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($carouselImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Carousel Image Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $carouselImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('CAROUSEL_IMAGE_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $carouselID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/content-carousel/image/'. $carouselID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Carousel Image Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $carouselImageDetails = $this->contentCarouselModel->getCarouselImage($carouselImageID);
                    $carouselImagePath = !empty($carouselImageDetails['content_carousel_image']) ? str_replace('./components/', '../../', $carouselImageDetails['content_carousel_image']) : null;

                    if(file_exists($carouselImagePath)){
                        if (!unlink($carouselImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Carousel Image Error',
                                'message' => 'The content carousel image cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($carouselImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Carousel Image Error',
                            'message' => 'The content carousel image cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->contentCarouselModel->updateCarouselImage($carouselImageID, $carouselID, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Carousel Image Success',
                        'message' => 'The content carousel image has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->contentCarouselModel->updateCarouselImage($carouselImageID, $carouselID, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Carousel Image Success',
                        'message' => 'The content carousel image has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $carouselImageFileName = $_FILES['content_carousel_image']['name'];
                $carouselImageFileSize = $_FILES['content_carousel_image']['size'];
                $carouselImageFileError = $_FILES['content_carousel_image']['error'];
                $carouselImageTempName = $_FILES['content_carousel_image']['tmp_name'];
                $carouselImageFileExtension = explode('.', $carouselImageFileName);
                $carouselImageActualFileExtension = strtolower(end($carouselImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($carouselImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Carousel Image Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($carouselImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Carousel Image Error',
                        'message' => 'Please choose the content carousel image.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($carouselImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Carousel Image Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($carouselImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Carousel Image Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $carouselImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CAROUSEL_IMAGE_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $carouselID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/content-carousel/image/'. $carouselID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Carousel Image Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($carouselImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Carousel Image Error',
                        'message' => 'The content carousel image cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->contentCarouselModel->insertCarouselImage($carouselID, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Carousel Image Success',
                    'message' => 'The content carousel image has been inserted successfully.',
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
    # Function: publishCarousel
    # Description: 
    # Publish the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCarouselExist = $this->contentCarouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contentCarouselModel->updateCarouselPublishStatus($carouselID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Carousel Success',
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
    # Function: unpublishCarousel
    # Description: 
    # Publish the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCarouselExist = $this->contentCarouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->contentCarouselModel->updateCarouselPublishStatus($carouselID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Carousel Success',
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
    # Function: deleteCarousel
    # Description: 
    # Delete the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $carouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCarouselExist = $this->contentCarouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Carousel Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $carouselImageByCourselDetails = $this->contentCarouselModel->getCarouselImageByCarouselID($carouselID);

            foreach ($carouselImageByCourselDetails as $row) {
                $carouselImagePath = !empty($row['content_carousel_image']) ? str_replace('./components/', '../../', $row['content_carousel_image']) : null;

                if(file_exists($carouselImagePath)){
                    if (!unlink($carouselImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Carousel Image Error',
                            'message' => 'The content carousel image cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->contentCarouselModel->deleteCarousel($carouselID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Carousel Success',
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
    # Function: deleteCarouselImage
    # Description: 
    # Delete the content carousel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteCarouselImage() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_image_id']) && !empty($_POST['content_carousel_image_id'])) {
            $carouselImageID = htmlspecialchars($_POST['content_carousel_image_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCarouselImageExist = $this->contentCarouselModel->checkCarouselImageExist($carouselImageID);
            $total = $checkCarouselImageExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Carousel Image Error',
                    'message' => 'The content carousel image does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $carouselImageDetails = $this->contentCarouselModel->getCarouselImage($carouselImageID);
            $carouselImagePath = !empty($carouselImageDetails['content_carousel_image']) ? str_replace('./components/', '../../', $carouselImageDetails['content_carousel_image']) : null;

            if(file_exists($carouselImagePath)){
                if (!unlink($carouselImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Carousel Image Error',
                        'message' => 'The content carousel image cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->contentCarouselModel->deleteCarouselImage($carouselImageID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Carousel Image Success',
                'message' => 'The content carousel image has been deleted successfully.',
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
    # Function: deleteMultipleCarousel
    # Description: 
    # Delete the selected content carousels if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleCarousel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $carouselIDs = $_POST['content_carousel_id'];
    
            foreach($carouselIDs as $carouselID){
                $checkCarouselExist = $this->contentCarouselModel->checkCarouselExist($carouselID);
                $total = $checkCarouselExist['total'] ?? 0;

                if($total > 0){
                    $carouselImageByCourselDetails = $this->contentCarouselModel->getCarouselImageByCarouselID($carouselID);

                    foreach ($carouselImageByCourselDetails as $row) {
                        $carouselImagePath = !empty($row['content_carousel_image']) ? str_replace('./components/', '../../', $row['content_carousel_image']) : null;

                        if(file_exists($carouselImagePath)){
                            if (!unlink($carouselImagePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Carousel Image Error',
                                    'message' => 'The content carousel image cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->contentCarouselModel->deleteCarousel($carouselID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Carousels Success',
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
    # Function: getCarouselDetails
    # Description: 
    # Handles the retrieval of content carousel details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCarouselDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['content_carousel_id']) && !empty($_POST['content_carousel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselID = htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8');

            $checkCarouselExist = $this->contentCarouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Carousel Details Error',
                    'message' => 'The content carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $carouselDetails = $this->contentCarouselModel->getCarousel($carouselID);

            $response = [
                'success' => true,
                'carouselName' => $carouselDetails['content_carousel_name'] ?? null,
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
    # Function: getCarouselImageDetails
    # Description: 
    # Handles the retrieval of content carousel image details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getCarouselImageDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['content_carousel_image_id']) && !empty($_POST['content_carousel_image_id'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselImageID = htmlspecialchars($_POST['content_carousel_image_id'], ENT_QUOTES, 'UTF-8');

            $checkCarouselImageExist = $this->contentCarouselModel->checkCarouselImageExist($carouselImageID);
            $total = $checkCarouselImageExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Carousel Image Details Error',
                    'message' => 'The content carousel image does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $carouselImageDetails = $this->contentCarouselModel->getCarouselImage($carouselImageID);

            $response = [
                'success' => true,
                'orderSequence' => $carouselImageDetails['order_sequence'] ?? null
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

$controller = new ContentCarouselController(new CarouselModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>