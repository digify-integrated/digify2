<?php
session_start();

# -------------------------------------------------------------
#
# Function: ServicesBoxController
# Description: 
# The Customer InquiryController class handles carousel related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ServicesBoxController {
    private $servicesBoxModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided servicesBoxModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for customer inquiry related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ServicesBoxModel $servicesBoxModel     The servicesBoxModel instance for customer inquiry related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ServicesBoxModel $servicesBoxModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->servicesBoxModel = $servicesBoxModel;
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
                case 'add customer inquiry':
                    $this->addServicesBox();
                    break;
                case 'update customer inquiry':
                    $this->updateServicesBox();
                    break;
                case 'save customer inquiry item':
                    $this->saveServicesBoxItem();
                    break;
                case 'get customer inquiry details':
                    $this->getServicesBoxDetails();
                    break;
                case 'get customer inquiry item details':
                    $this->getServicesBoxItemDetails();
                    break;
                case 'publish customer inquiry':
                    $this->publishServicesBox();
                    break;
                case 'unpublish customer inquiry':
                    $this->unpublishServicesBox();
                    break;
                case 'delete customer inquiry':
                    $this->deleteServicesBox();
                    break;
                case 'delete customer inquiry item':
                    $this->deleteServicesBoxItem();
                    break;
                case 'delete multiple customer inquiry':
                    $this->deleteMultipleServicesBox();
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
    # Function: addServicesBox
    # Description: 
    # Inserts a customer inquiry.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addServicesBox() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_name']) && !empty($_POST['customer_inquiry_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $servicesBoxName = $_POST['customer_inquiry_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $servicesBoxID = $this->servicesBoxModel->insertServicesBox($servicesBoxName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'servicesBoxID' => $this->securityModel->encryptData($servicesBoxID),
                'title' => 'Insert Customer Inquiry Success',
                'message' => 'The customer inquiry has been inserted successfully.',
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
    # Function: updateServicesBox
    # Description: 
    # Updates the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateServicesBox() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_inquiry_name']) && !empty($_POST['customer_inquiry_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $servicesBoxID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
            $servicesBoxName = $_POST['customer_inquiry_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkServicesBoxExist = $this->servicesBoxModel->checkServicesBoxExist($servicesBoxID);
            $total = $checkServicesBoxExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Customer Inquiry Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->servicesBoxModel->updateServicesBox($servicesBoxID, $servicesBoxName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Customer Inquiry Success',
                'message' => 'The customer inquiry has been updated successfully.',
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
    # Function: saveServicesBoxItem
    # Description: 
    # Updates the customer inquiry if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveServicesBoxItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['customer_inquiry_item_id']) && isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $servicesBoxItemID = htmlspecialchars($_POST['customer_inquiry_item_id'], ENT_QUOTES, 'UTF-8');
            $servicesBoxID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
            $servicesBoxTitle = $_POST['customer_inquiry_title'];
            $servicesBoxHeading = $_POST['customer_inquiry_heading'];
            $servicesBoxParagraph = $_POST['customer_inquiry_paragraph'];
            $callToActionButtonText = $_POST['call_to_action_button_text'];
            $callToActionButtonLink = $_POST['call_to_action_button_link'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkServicesBoxExist = $this->servicesBoxModel->checkServicesBoxExist($servicesBoxID);
            $total = $checkServicesBoxExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Customer Inquiry Item Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkServicesBoxItemExist = $this->servicesBoxModel->checkServicesBoxItemExist($servicesBoxItemID);
            $total = $checkServicesBoxItemExist['total'] ?? 0;

            if($total > 0){
                $servicesBoxImageFileName = $_FILES['customer_inquiry_image']['name'];
                $servicesBoxImageFileSize = $_FILES['customer_inquiry_image']['size'];
                $servicesBoxImageFileError = $_FILES['customer_inquiry_image']['error'];
                $servicesBoxImageTempName = $_FILES['customer_inquiry_image']['tmp_name'];
                $servicesBoxImageFileExtension = explode('.', $servicesBoxImageFileName);
                $servicesBoxImageActualFileExtension = strtolower(end($servicesBoxImageFileExtension));

                if (!empty($servicesBoxImageFileName) && $servicesBoxImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($servicesBoxImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Customer Inquiry Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($servicesBoxImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Customer Inquiry Item Error',
                            'message' => 'Please choose the customer inquiry item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($servicesBoxImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Customer Inquiry Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($servicesBoxImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Customer Inquiry Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $servicesBoxImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('CAROUSEL_IMAGE_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $servicesBoxID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/customer-inquiry/image/'. $servicesBoxID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Customer Inquiry Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $servicesBoxItemDetails = $this->servicesBoxModel->getServicesBoxItem($servicesBoxItemID);
                    $servicesBoxImagePath = !empty($servicesBoxItemDetails['customer_inquiry_image']) ? str_replace('./components/', '../../', $servicesBoxItemDetails['customer_inquiry_image']) : null;

                    if(file_exists($servicesBoxImagePath)){
                        if (!unlink($servicesBoxImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Customer Inquiry Item Error',
                                'message' => 'The customer inquiry item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($servicesBoxImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Customer Inquiry Item Error',
                            'message' => 'The customer inquiry item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->servicesBoxModel->updateServicesBoxItem($servicesBoxItemID, $servicesBoxID, $servicesBoxTitle, $servicesBoxHeading, $servicesBoxParagraph, $callToActionButtonText, $callToActionButtonLink, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Customer Inquiry Item Success',
                        'message' => 'The customer inquiry item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->servicesBoxModel->updateServicesBoxItem($servicesBoxItemID, $servicesBoxID, $servicesBoxTitle, $servicesBoxHeading, $servicesBoxParagraph, $callToActionButtonText, $callToActionButtonLink, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Customer Inquiry Item Success',
                        'message' => 'The customer inquiry item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $servicesBoxImageFileName = $_FILES['customer_inquiry_image']['name'];
                $servicesBoxImageFileSize = $_FILES['customer_inquiry_image']['size'];
                $servicesBoxImageFileError = $_FILES['customer_inquiry_image']['error'];
                $servicesBoxImageTempName = $_FILES['customer_inquiry_image']['tmp_name'];
                $servicesBoxImageFileExtension = explode('.', $servicesBoxImageFileName);
                $servicesBoxImageActualFileExtension = strtolower(end($servicesBoxImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($servicesBoxImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Customer Inquiry Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($servicesBoxImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Customer Inquiry Item Error',
                        'message' => 'Please choose the customer inquiry item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($servicesBoxImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Customer Inquiry Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($servicesBoxImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Customer Inquiry Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $servicesBoxImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CAROUSEL_IMAGE_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $servicesBoxID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/customer-inquiry/image/'. $servicesBoxID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Customer Inquiry Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($servicesBoxImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Customer Inquiry Item Error',
                        'message' => 'The customer inquiry item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->servicesBoxModel->insertServicesBoxItem($servicesBoxID, $servicesBoxTitle, $servicesBoxHeading, $servicesBoxParagraph, $callToActionButtonText, $callToActionButtonLink, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Customer Inquiry Item Success',
                    'message' => 'The customer inquiry item has been inserted successfully.',
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
    # Function: publishServicesBox
    # Description: 
    # Publish the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishServicesBox() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $servicesBoxID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkServicesBoxExist = $this->servicesBoxModel->checkServicesBoxExist($servicesBoxID);
            $total = $checkServicesBoxExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Customer Inquiry Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->servicesBoxModel->updateServicesBoxPublishStatus($servicesBoxID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Customer Inquiry Success',
                'message' => 'The customer inquiry has been published successfully.',
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
    # Function: unpublishServicesBox
    # Description: 
    # Publish the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishServicesBox() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $servicesBoxID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkServicesBoxExist = $this->servicesBoxModel->checkServicesBoxExist($servicesBoxID);
            $total = $checkServicesBoxExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Customer Inquiry Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->servicesBoxModel->updateServicesBoxPublishStatus($servicesBoxID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Customer Inquiry Success',
                'message' => 'The customer inquiry has been unpublished successfully.',
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
    # Function: deleteServicesBox
    # Description: 
    # Delete the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteServicesBox() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $servicesBoxID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');
        
            $checkServicesBoxExist = $this->servicesBoxModel->checkServicesBoxExist($servicesBoxID);
            $total = $checkServicesBoxExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Customer Inquiry Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $servicesBoxItemByCourselDetails = $this->servicesBoxModel->getServicesBoxItemByServicesBoxID($servicesBoxID);

            foreach ($servicesBoxItemByCourselDetails as $row) {
                $servicesBoxImagePath = !empty($row['customer_inquiry_image']) ? str_replace('./components/', '../../', $row['customer_inquiry_image']) : null;

                if(file_exists($servicesBoxImagePath)){
                    if (!unlink($servicesBoxImagePath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Customer Inquiry Item Error',
                            'message' => 'The customer inquiry item cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->servicesBoxModel->deleteServicesBox($servicesBoxID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Customer Inquiry Success',
                'message' => 'The customer inquiry has been deleted successfully.',
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
    # Function: deleteServicesBoxItem
    # Description: 
    # Delete the customer inquiry if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteServicesBoxItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_item_id']) && !empty($_POST['customer_inquiry_item_id'])) {
            $servicesBoxItemID = htmlspecialchars($_POST['customer_inquiry_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkServicesBoxItemExist = $this->servicesBoxModel->checkServicesBoxItemExist($servicesBoxItemID);
            $total = $checkServicesBoxItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Customer Inquiry Item Error',
                    'message' => 'The customer inquiry item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $servicesBoxItemDetails = $this->servicesBoxModel->getServicesBoxItem($servicesBoxItemID);
            $servicesBoxImagePath = !empty($servicesBoxItemDetails['customer_inquiry_image']) ? str_replace('./components/', '../../', $servicesBoxItemDetails['customer_inquiry_image']) : null;


            if(file_exists($servicesBoxImagePath)){
                if (!unlink($servicesBoxImagePath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Customer Inquiry Item Error',
                        'message' => 'The customer inquiry item cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->servicesBoxModel->deleteServicesBoxItem($servicesBoxItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Customer Inquiry Item Success',
                'message' => 'The customer inquiry item has been deleted successfully.',
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
    # Function: deleteMultipleServicesBox
    # Description: 
    # Delete the selected customer inquirys if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleServicesBox() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $servicesBoxIDs = $_POST['customer_inquiry_id'];
    
            foreach($servicesBoxIDs as $servicesBoxID){
                $checkServicesBoxExist = $this->servicesBoxModel->checkServicesBoxExist($servicesBoxID);
                $total = $checkServicesBoxExist['total'] ?? 0;

                if($total > 0){
                    $servicesBoxItemByCourselDetails = $this->servicesBoxModel->getServicesBoxItemByServicesBoxID($servicesBoxID);

                    foreach ($servicesBoxItemByCourselDetails as $row) {
                        $servicesBoxImagePath = !empty($row['customer_inquiry_image']) ? str_replace('./components/', '../../', $row['customer_inquiry_image']) : null;

                        if(file_exists($servicesBoxImagePath)){
                            if (!unlink($servicesBoxImagePath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Customer Inquiry Item Error',
                                    'message' => 'The customer inquiry item cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->servicesBoxModel->deleteServicesBox($servicesBoxID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Customer Inquirys Success',
                'message' => 'The selected customer inquirys have been deleted successfully.',
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
    # Function: getServicesBoxDetails
    # Description: 
    # Handles the retrieval of customer inquiry details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getServicesBoxDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_inquiry_id']) && !empty($_POST['customer_inquiry_id'])) {
            $userID = $_SESSION['user_account_id'];
            $servicesBoxID = htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8');

            $checkServicesBoxExist = $this->servicesBoxModel->checkServicesBoxExist($servicesBoxID);
            $total = $checkServicesBoxExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Customer Inquiry Details Error',
                    'message' => 'The customer inquiry does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $servicesBoxDetails = $this->servicesBoxModel->getServicesBox($servicesBoxID);

            $response = [
                'success' => true,
                'servicesBoxName' => $servicesBoxDetails['customer_inquiry_name'] ?? null,
                'description' => $servicesBoxDetails['description'] ?? null,
                'blockStyleID' => $servicesBoxDetails['block_style_id'] ?? '',
                'blockStyleName' => $servicesBoxDetails['block_style_name'] ?? ''
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
    # Function: getServicesBoxItemDetails
    # Description: 
    # Handles the retrieval of customer inquiry item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getServicesBoxItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['customer_inquiry_item_id']) && !empty($_POST['customer_inquiry_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $servicesBoxItemID = htmlspecialchars($_POST['customer_inquiry_item_id'], ENT_QUOTES, 'UTF-8');

            $checkServicesBoxItemExist = $this->servicesBoxModel->checkServicesBoxItemExist($servicesBoxItemID);
            $total = $checkServicesBoxItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Customer Inquiry Item Details Error',
                    'message' => 'The customer inquiry item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $servicesBoxItemDetails = $this->servicesBoxModel->getServicesBoxItem($servicesBoxItemID);

            $response = [
                'success' => true,
                'servicesBoxTitle' => $servicesBoxItemDetails['customer_inquiry_title'] ?? null,
                'servicesBoxHeading' => $servicesBoxItemDetails['customer_inquiry_heading'] ?? null,
                'servicesBoxParagraph' => $servicesBoxItemDetails['customer_inquiry_paragraph'] ?? null,
                'callToActionButtonText' => $servicesBoxItemDetails['call_to_action_button_text'] ?? null,
                'callToActionButtonLink' => $servicesBoxItemDetails['call_to_action_button_link'] ?? null,
                'orderSequence' => $servicesBoxItemDetails['order_sequence'] ?? null,
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
require_once '../../customer-inquiry/model/customer-inquiry-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ServicesBoxController(new ServicesBoxModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>