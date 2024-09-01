<?php
session_start();

# -------------------------------------------------------------
#
# Function: SliderController
# Description: 
# The SliderController class handles slider related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class SliderController {
    private $sliderModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided sliderModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for slider related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param SliderModel $sliderModel     The sliderModel instance for slider related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(SliderModel $sliderModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->sliderModel = $sliderModel;
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
                case 'add slider':
                    $this->addSlider();
                    break;
                case 'update slider':
                    $this->updateSlider();
                    break;
                case 'save slider item':
                    $this->saveSliderItem();
                    break;
                case 'get slider details':
                    $this->getSliderDetails();
                    break;
                case 'get slider item details':
                    $this->getSliderItemDetails();
                    break;
                case 'publish slider':
                    $this->publishSlider();
                    break;
                case 'unpublish slider':
                    $this->unpublishSlider();
                    break;
                case 'delete slider':
                    $this->deleteSlider();
                    break;
                case 'delete slider item':
                    $this->deleteSliderItem();
                    break;
                case 'delete multiple slider':
                    $this->deleteMultipleSlider();
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
    # Function: addSlider
    # Description: 
    # Inserts a slider.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addSlider() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['slider_name']) && !empty($_POST['slider_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $sliderName = $_POST['slider_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $sliderID = $this->sliderModel->insertSlider($sliderName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'sliderID' => $this->securityModel->encryptData($sliderID),
                'title' => 'Insert Slider Success',
                'message' => 'The slider has been inserted successfully.',
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
    # Function: updateSlider
    # Description: 
    # Updates the slider if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateSlider() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['slider_name']) && !empty($_POST['slider_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $sliderID = htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8');
            $sliderName = $_POST['slider_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkSliderExist = $this->sliderModel->checkSliderExist($sliderID);
            $total = $checkSliderExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Slider Error',
                    'message' => 'The slider does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->sliderModel->updateSlider($sliderID, $sliderName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Slider Success',
                'message' => 'The slider has been updated successfully.',
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
    # Function: saveSliderItem
    # Description: 
    # Updates the slider if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveSliderItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['slider_item_id']) && isset($_POST['slider_id']) && !empty($_POST['slider_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $sliderItemID = htmlspecialchars($_POST['slider_item_id'], ENT_QUOTES, 'UTF-8');
            $sliderID = htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8');
            $sliderTitle = $_POST['slider_title'];
            $sliderHeading = $_POST['slider_heading'];
            $sliderParagraph = $_POST['slider_paragraph'];
            $callToActionButton1Text = $_POST['call_to_action_button_1_text'];
            $callToActionButton1Link = $_POST['call_to_action_button_1_link'];
            $callToActionButton2Text = $_POST['call_to_action_button_2_text'];
            $callToActionButton2Link = $_POST['call_to_action_button_2_link'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkSliderExist = $this->sliderModel->checkSliderExist($sliderID);
            $total = $checkSliderExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Slider Item Error',
                    'message' => 'The slider does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkSliderItemExist = $this->sliderModel->checkSliderItemExist($sliderItemID);
            $total = $checkSliderItemExist['total'] ?? 0;

            if($total > 0){
                $sliderImageFileName = $_FILES['slider_image']['name'];
                $sliderImageFileSize = $_FILES['slider_image']['size'];
                $sliderImageFileError = $_FILES['slider_image']['error'];
                $sliderImageTempName = $_FILES['slider_image']['tmp_name'];
                $sliderImageFileExtension = explode('.', $sliderImageFileName);
                $sliderImageActualFileExtension = strtolower(end($sliderImageFileExtension));

                if (!empty($sliderImageFileName) && $sliderImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($sliderImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Slider Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($sliderImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Slider Item Error',
                            'message' => 'Please choose the slider item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($sliderImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Slider Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($sliderImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Slider Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $sliderImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('SLIDER_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. SLIDER_DIR. $sliderID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/slider/image/'. $sliderID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Slider Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $sliderItemDetails = $this->sliderModel->getSliderItem($sliderItemID);
                    $sliderImagePath = !empty($sliderItemDetails['slider_image']) ? str_replace('./components/', '../../', $sliderItemDetails['slider_image']) : null;

                    if(file_exists($sliderImagePath)){
                        if (!unlink($sliderImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Slider Item Error',
                                'message' => 'The slider item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($sliderImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Slider Item Error',
                            'message' => 'The slider item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->sliderModel->updateSliderItem($sliderItemID, $sliderID, $sliderTitle, $sliderHeading, $sliderParagraph, $callToActionButton1Text, $callToActionButton1Link, $callToActionButton2Text, $callToActionButton2Link, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Slider Item Success',
                        'message' => 'The slider item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->sliderModel->updateSliderItem($sliderItemID, $sliderID, $sliderTitle, $sliderHeading, $sliderParagraph, $callToActionButton1Text, $callToActionButton1Link, $callToActionButton2Text, $callToActionButton2Link, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Slider Item Success',
                        'message' => 'The slider item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $sliderImageFileName = $_FILES['slider_image']['name'];
                $sliderImageFileSize = $_FILES['slider_image']['size'];
                $sliderImageFileError = $_FILES['slider_image']['error'];
                $sliderImageTempName = $_FILES['slider_image']['tmp_name'];
                $sliderImageFileExtension = explode('.', $sliderImageFileName);
                $sliderImageActualFileExtension = strtolower(end($sliderImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($sliderImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Slider Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($sliderImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Slider Item Error',
                        'message' => 'Please choose the slider item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($sliderImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Slider Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($sliderImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Slider Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $sliderImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('SLIDER_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. SLIDER_DIR. $sliderID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/slider/image/'. $sliderID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Slider Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($sliderImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Slider Item Error',
                        'message' => 'The slider item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->sliderModel->insertSliderItem($sliderID, $sliderTitle, $sliderHeading, $sliderParagraph, $callToActionButton1Text, $callToActionButton1Link, $callToActionButton2Text, $callToActionButton2Link, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Slider Item Success',
                    'message' => 'The slider item has been inserted successfully.',
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
    # Function: publishSlider
    # Description: 
    # Publish the slider if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishSlider() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['slider_id']) && !empty($_POST['slider_id'])) {
            $userID = $_SESSION['user_account_id'];
            $sliderID = htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSliderExist = $this->sliderModel->checkSliderExist($sliderID);
            $total = $checkSliderExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Slider Error',
                    'message' => 'The slider does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->sliderModel->updateSliderPublishStatus($sliderID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Slider Success',
                'message' => 'The slider has been published successfully.',
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
    # Function: unpublishSlider
    # Description: 
    # Publish the slider if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishSlider() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['slider_id']) && !empty($_POST['slider_id'])) {
            $userID = $_SESSION['user_account_id'];
            $sliderID = htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSliderExist = $this->sliderModel->checkSliderExist($sliderID);
            $total = $checkSliderExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Slider Error',
                    'message' => 'The slider does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->sliderModel->updateSliderPublishStatus($sliderID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Slider Success',
                'message' => 'The slider has been unpublished successfully.',
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
    # Function: deleteSlider
    # Description: 
    # Delete the slider if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteSlider() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['slider_id']) && !empty($_POST['slider_id'])) {
            $sliderID = htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSliderExist = $this->sliderModel->checkSliderExist($sliderID);
            $total = $checkSliderExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Slider Error',
                    'message' => 'The slider does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $sliderItemByCourselDetails = $this->sliderModel->getSliderItemBySliderID($sliderID);

            foreach ($sliderItemByCourselDetails as $row) {
                $sliderImagePath = !empty($row['slider_image']) ? str_replace('./components/', '../../', $row['slider_image']) : null;

                if(file_exists($sliderImagePath)){
                    if (!unlink($sliderImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Slider Item Error',
                            'message' => 'The slider item cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->sliderModel->deleteSlider($sliderID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Slider Success',
                'message' => 'The slider has been deleted successfully.',
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
    # Function: deleteSliderItem
    # Description: 
    # Delete the slider if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteSliderItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['slider_item_id']) && !empty($_POST['slider_item_id'])) {
            $sliderItemID = htmlspecialchars($_POST['slider_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkSliderItemExist = $this->sliderModel->checkSliderItemExist($sliderItemID);
            $total = $checkSliderItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Slider Item Error',
                    'message' => 'The slider item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $sliderItemDetails = $this->sliderModel->getSliderItem($sliderItemID);
            $sliderImagePath = !empty($sliderItemDetails['slider_image']) ? str_replace('./components/', '../../', $sliderItemDetails['slider_image']) : null;


            if(file_exists($sliderImagePath)){
                if (!unlink($sliderImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Slider Item Error',
                        'message' => 'The slider item cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->sliderModel->deleteSliderItem($sliderItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Slider Item Success',
                'message' => 'The slider item has been deleted successfully.',
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
    # Function: deleteMultipleSlider
    # Description: 
    # Delete the selected sliders if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleSlider() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['slider_id']) && !empty($_POST['slider_id'])) {
            $sliderIDs = $_POST['slider_id'];
    
            foreach($sliderIDs as $sliderID){
                $checkSliderExist = $this->sliderModel->checkSliderExist($sliderID);
                $total = $checkSliderExist['total'] ?? 0;

                if($total > 0){
                    $sliderItemByCourselDetails = $this->sliderModel->getSliderItemBySliderID($sliderID);

                    foreach ($sliderItemByCourselDetails as $row) {
                        $sliderImagePath = !empty($row['slider_image']) ? str_replace('./components/', '../../', $row['slider_image']) : null;

                        if(file_exists($sliderImagePath)){
                            if (!unlink($sliderImagePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Slider Item Error',
                                    'message' => 'The slider item cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->sliderModel->deleteSlider($sliderID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Sliders Success',
                'message' => 'The selected sliders have been deleted successfully.',
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
    # Function: getSliderDetails
    # Description: 
    # Handles the retrieval of slider details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getSliderDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['slider_id']) && !empty($_POST['slider_id'])) {
            $userID = $_SESSION['user_account_id'];
            $sliderID = htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8');

            $checkSliderExist = $this->sliderModel->checkSliderExist($sliderID);
            $total = $checkSliderExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Slider Details Error',
                    'message' => 'The slider does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $sliderDetails = $this->sliderModel->getSlider($sliderID);

            $response = [
                'success' => true,
                'sliderName' => $sliderDetails['slider_name'] ?? null,
                'description' => $sliderDetails['description'] ?? null,
                'blockStyleID' => $sliderDetails['block_style_id'] ?? '',
                'blockStyleName' => $sliderDetails['block_style_name'] ?? ''
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
    # Function: getSliderItemDetails
    # Description: 
    # Handles the retrieval of slider item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getSliderItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['slider_item_id']) && !empty($_POST['slider_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $sliderItemID = htmlspecialchars($_POST['slider_item_id'], ENT_QUOTES, 'UTF-8');

            $checkSliderItemExist = $this->sliderModel->checkSliderItemExist($sliderItemID);
            $total = $checkSliderItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Slider Item Details Error',
                    'message' => 'The slider item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $sliderItemDetails = $this->sliderModel->getSliderItem($sliderItemID);

            $response = [
                'success' => true,
                'sliderTitle' => $sliderItemDetails['slider_title'] ?? null,
                'sliderHeading' => $sliderItemDetails['slider_heading'] ?? null,
                'sliderParagraph' => $sliderItemDetails['slider_paragraph'] ?? null,
                'callToActionButton1Text' => $sliderItemDetails['call_to_action_button_1_text'] ?? null,
                'callToActionButton1Link' => $sliderItemDetails['call_to_action_button_1_link'] ?? null,
                'callToActionButton2Text' => $sliderItemDetails['call_to_action_button_2_text'] ?? null,
                'callToActionButton2Link' => $sliderItemDetails['call_to_action_button_2_link'] ?? null,
                'orderSequence' => $sliderItemDetails['order_sequence'] ?? null,
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
require_once '../../slider/model/slider-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new SliderController(new SliderModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>