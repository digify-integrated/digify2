<?php
session_start();

# -------------------------------------------------------------
#
# Function: Image GalleryController
# Description: 
# The Image GalleryController class handles carousel related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ImageGalleryController {
    private $imageGalleryModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided imageGalleryModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for image gallery related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param Image GalleryModel $imageGalleryModel     The imageGalleryModel instance for image gallery related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ImageGalleryModel $imageGalleryModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->imageGalleryModel = $imageGalleryModel;
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
                case 'add image gallery':
                    $this->addImageGallery();
                    break;
                case 'update image gallery':
                    $this->updateImageGallery();
                    break;
                case 'save image gallery item':
                    $this->saveImageGalleryItem();
                    break;
                case 'get image gallery details':
                    $this->getImageGalleryDetails();
                    break;
                case 'get image gallery item details':
                    $this->getImageGalleryItemDetails();
                    break;
                case 'publish image gallery':
                    $this->publishImageGallery();
                    break;
                case 'unpublish image gallery':
                    $this->unpublishImageGallery();
                    break;
                case 'delete image gallery':
                    $this->deleteImageGallery();
                    break;
                case 'delete image gallery item':
                    $this->deleteImageGalleryItem();
                    break;
                case 'delete multiple image gallery':
                    $this->deleteMultipleImageGallery();
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
    # Function: addImageGallery
    # Description: 
    # Inserts a image gallery.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addImageGallery() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['image_gallery_name']) && !empty($_POST['image_gallery_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $imageGalleryName = $_POST['image_gallery_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $imageGalleryID = $this->imageGalleryModel->insertImageGallery($imageGalleryName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'imageGalleryID' => $this->securityModel->encryptData($imageGalleryID),
                'title' => 'Insert Image Gallery Success',
                'message' => 'The image gallery has been inserted successfully.',
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
    # Function: updateImageGallery
    # Description: 
    # Updates the image gallery if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateImageGallery() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['image_gallery_name']) && !empty($_POST['image_gallery_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $imageGalleryID = htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8');
            $imageGalleryName = $_POST['image_gallery_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkImageGalleryExist = $this->imageGalleryModel->checkImageGalleryExist($imageGalleryID);
            $total = $checkImageGalleryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Image Gallery Error',
                    'message' => 'The image gallery does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->imageGalleryModel->updateImageGallery($imageGalleryID, $imageGalleryName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Image Gallery Success',
                'message' => 'The image gallery has been updated successfully.',
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
    # Function: saveImageGalleryItem
    # Description: 
    # Updates the image gallery if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveImageGalleryItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['image_gallery_item_id']) && isset($_POST['image_gallery_id']) && !empty($_POST['image_gallery_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $imageGalleryItemID = htmlspecialchars($_POST['image_gallery_item_id'], ENT_QUOTES, 'UTF-8');
            $imageGalleryID = htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8');
            $imageGalleryTitle = $_POST['image_gallery_title'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkImageGalleryExist = $this->imageGalleryModel->checkImageGalleryExist($imageGalleryID);
            $total = $checkImageGalleryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Image Gallery Item Error',
                    'message' => 'The image gallery does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkImageGalleryItemExist = $this->imageGalleryModel->checkImageGalleryItemExist($imageGalleryItemID);
            $total = $checkImageGalleryItemExist['total'] ?? 0;

            if($total > 0){
                $imageGalleryImageFileName = $_FILES['image_gallery_image']['name'];
                $imageGalleryImageFileSize = $_FILES['image_gallery_image']['size'];
                $imageGalleryImageFileError = $_FILES['image_gallery_image']['error'];
                $imageGalleryImageTempName = $_FILES['image_gallery_image']['tmp_name'];
                $imageGalleryImageFileExtension = explode('.', $imageGalleryImageFileName);
                $imageGalleryImageActualFileExtension = strtolower(end($imageGalleryImageFileExtension));

                if (!empty($imageGalleryImageFileName) && $imageGalleryImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($imageGalleryImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Image Gallery Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($imageGalleryImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Image Gallery Item Error',
                            'message' => 'Please choose the image gallery item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($imageGalleryImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Image Gallery Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($imageGalleryImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Image Gallery Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $imageGalleryImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('CAROUSEL_IMAGE_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $imageGalleryID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/image-gallery/image/'. $imageGalleryID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Image Gallery Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $imageGalleryItemDetails = $this->imageGalleryModel->getImageGalleryItem($imageGalleryItemID);
                    $imageGalleryImagePath = !empty($imageGalleryItemDetails['image_gallery_image']) ? str_replace('./components/', '../../', $imageGalleryItemDetails['image_gallery_image']) : null;

                    if(file_exists($imageGalleryImagePath)){
                        if (!unlink($imageGalleryImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Image Gallery Item Error',
                                'message' => 'The image gallery item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($imageGalleryImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Image Gallery Item Error',
                            'message' => 'The image gallery item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->imageGalleryModel->updateImageGalleryItem($imageGalleryItemID, $imageGalleryID, $imageGalleryTitle, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Image Gallery Item Success',
                        'message' => 'The image gallery item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->imageGalleryModel->updateImageGalleryItem($imageGalleryItemID, $imageGalleryID, $imageGalleryTitle, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Image Gallery Item Success',
                        'message' => 'The image gallery item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $imageGalleryImageFileName = $_FILES['image_gallery_image']['name'];
                $imageGalleryImageFileSize = $_FILES['image_gallery_image']['size'];
                $imageGalleryImageFileError = $_FILES['image_gallery_image']['error'];
                $imageGalleryImageTempName = $_FILES['image_gallery_image']['tmp_name'];
                $imageGalleryImageFileExtension = explode('.', $imageGalleryImageFileName);
                $imageGalleryImageActualFileExtension = strtolower(end($imageGalleryImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($imageGalleryImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Image Gallery Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($imageGalleryImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Image Gallery Item Error',
                        'message' => 'Please choose the image gallery item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($imageGalleryImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Image Gallery Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($imageGalleryImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Image Gallery Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $imageGalleryImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CAROUSEL_IMAGE_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $imageGalleryID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/image-gallery/image/'. $imageGalleryID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Image Gallery Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($imageGalleryImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Image Gallery Item Error',
                        'message' => 'The image gallery item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->imageGalleryModel->insertImageGalleryItem($imageGalleryID, $imageGalleryTitle, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Image Gallery Item Success',
                    'message' => 'The image gallery item has been inserted successfully.',
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
    # Function: publishImageGallery
    # Description: 
    # Publish the image gallery if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishImageGallery() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['image_gallery_id']) && !empty($_POST['image_gallery_id'])) {
            $userID = $_SESSION['user_account_id'];
            $imageGalleryID = htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8');
        
            $checkImageGalleryExist = $this->imageGalleryModel->checkImageGalleryExist($imageGalleryID);
            $total = $checkImageGalleryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Image Gallery Error',
                    'message' => 'The image gallery does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->imageGalleryModel->updateImageGalleryPublishStatus($imageGalleryID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Image Gallery Success',
                'message' => 'The image gallery has been published successfully.',
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
    # Function: unpublishImageGallery
    # Description: 
    # Publish the image gallery if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishImageGallery() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['image_gallery_id']) && !empty($_POST['image_gallery_id'])) {
            $userID = $_SESSION['user_account_id'];
            $imageGalleryID = htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8');
        
            $checkImageGalleryExist = $this->imageGalleryModel->checkImageGalleryExist($imageGalleryID);
            $total = $checkImageGalleryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Image Gallery Error',
                    'message' => 'The image gallery does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->imageGalleryModel->updateImageGalleryPublishStatus($imageGalleryID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Image Gallery Success',
                'message' => 'The image gallery has been unpublished successfully.',
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
    # Function: deleteImageGallery
    # Description: 
    # Delete the image gallery if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteImageGallery() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['image_gallery_id']) && !empty($_POST['image_gallery_id'])) {
            $imageGalleryID = htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8');
        
            $checkImageGalleryExist = $this->imageGalleryModel->checkImageGalleryExist($imageGalleryID);
            $total = $checkImageGalleryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Image Gallery Error',
                    'message' => 'The image gallery does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $imageGalleryItemByCourselDetails = $this->imageGalleryModel->getImageGalleryItemByImageGalleryID($imageGalleryID);

            foreach ($imageGalleryItemByCourselDetails as $row) {
                $imageGalleryImagePath = !empty($row['image_gallery_image']) ? str_replace('./components/', '../../', $row['image_gallery_image']) : null;

                if(file_exists($imageGalleryImagePath)){
                    if (!unlink($imageGalleryImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Image Gallery Item Error',
                            'message' => 'The image gallery item cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->imageGalleryModel->deleteImageGallery($imageGalleryID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Image Gallery Success',
                'message' => 'The image gallery has been deleted successfully.',
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
    # Function: deleteImageGalleryItem
    # Description: 
    # Delete the image gallery if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteImageGalleryItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['image_gallery_item_id']) && !empty($_POST['image_gallery_item_id'])) {
            $imageGalleryItemID = htmlspecialchars($_POST['image_gallery_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkImageGalleryItemExist = $this->imageGalleryModel->checkImageGalleryItemExist($imageGalleryItemID);
            $total = $checkImageGalleryItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Image Gallery Item Error',
                    'message' => 'The image gallery item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $imageGalleryItemDetails = $this->imageGalleryModel->getImageGalleryItem($imageGalleryItemID);
            $imageGalleryImagePath = !empty($imageGalleryItemDetails['image_gallery_image']) ? str_replace('./components/', '../../', $imageGalleryItemDetails['image_gallery_image']) : null;


            if(file_exists($imageGalleryImagePath)){
                if (!unlink($imageGalleryImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Image Gallery Item Error',
                        'message' => 'The image gallery item cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->imageGalleryModel->deleteImageGalleryItem($imageGalleryItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Image Gallery Item Success',
                'message' => 'The image gallery item has been deleted successfully.',
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
    # Function: deleteMultipleImageGallery
    # Description: 
    # Delete the selected image gallerys if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleImageGallery() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['image_gallery_id']) && !empty($_POST['image_gallery_id'])) {
            $imageGalleryIDs = $_POST['image_gallery_id'];
    
            foreach($imageGalleryIDs as $imageGalleryID){
                $checkImageGalleryExist = $this->imageGalleryModel->checkImageGalleryExist($imageGalleryID);
                $total = $checkImageGalleryExist['total'] ?? 0;

                if($total > 0){
                    $imageGalleryItemByCourselDetails = $this->imageGalleryModel->getImageGalleryItemByImageGalleryID($imageGalleryID);

                    foreach ($imageGalleryItemByCourselDetails as $row) {
                        $imageGalleryImagePath = !empty($row['image_gallery_image']) ? str_replace('./components/', '../../', $row['image_gallery_image']) : null;

                        if(file_exists($imageGalleryImagePath)){
                            if (!unlink($imageGalleryImagePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Image Gallery Item Error',
                                    'message' => 'The image gallery item cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->imageGalleryModel->deleteImageGallery($imageGalleryID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Image Gallerys Success',
                'message' => 'The selected image gallerys have been deleted successfully.',
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
    # Function: getImageGalleryDetails
    # Description: 
    # Handles the retrieval of image gallery details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getImageGalleryDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['image_gallery_id']) && !empty($_POST['image_gallery_id'])) {
            $userID = $_SESSION['user_account_id'];
            $imageGalleryID = htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8');

            $checkImageGalleryExist = $this->imageGalleryModel->checkImageGalleryExist($imageGalleryID);
            $total = $checkImageGalleryExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Image Gallery Details Error',
                    'message' => 'The image gallery does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $carouselDetails = $this->imageGalleryModel->getImageGallery($imageGalleryID);

            $response = [
                'success' => true,
                'imageGalleryName' => $carouselDetails['image_gallery_name'] ?? null,
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
    # Function: getImageGalleryItemDetails
    # Description: 
    # Handles the retrieval of image gallery item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getImageGalleryItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['image_gallery_item_id']) && !empty($_POST['image_gallery_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $imageGalleryItemID = htmlspecialchars($_POST['image_gallery_item_id'], ENT_QUOTES, 'UTF-8');

            $checkImageGalleryItemExist = $this->imageGalleryModel->checkImageGalleryItemExist($imageGalleryItemID);
            $total = $checkImageGalleryItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Image Gallery Item Details Error',
                    'message' => 'The image gallery item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $imageGalleryItemDetails = $this->imageGalleryModel->getImageGalleryItem($imageGalleryItemID);

            $response = [
                'success' => true,
                'imageGalleryTitle' => $imageGalleryItemDetails['image_gallery_title'] ?? null,
                'imageGalleryHeading' => $imageGalleryItemDetails['image_gallery_heading'] ?? null,
                'imageGalleryParagraph' => $imageGalleryItemDetails['image_gallery_paragraph'] ?? null,
                'callToActionButton1Text' => $imageGalleryItemDetails['call_to_action_button_1_text'] ?? null,
                'callToActionButton1Link' => $imageGalleryItemDetails['call_to_action_button_1_link'] ?? null,
                'callToActionButton2Text' => $imageGalleryItemDetails['call_to_action_button_2_text'] ?? null,
                'callToActionButton2Link' => $imageGalleryItemDetails['call_to_action_button_2_link'] ?? null,
                'orderSequence' => $imageGalleryItemDetails['order_sequence'] ?? null,
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
require_once '../../image-gallery/model/image-gallery-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ImageGalleryController(new ImageGalleryModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>