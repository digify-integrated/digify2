<?php
session_start();

# -------------------------------------------------------------
#
# Function: PricingTableController
# Description: 
# The Pricing TableController class handles carousel related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class PricingTableController {
    private $pricingTableModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided pricingTableModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for pricing table related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param PricingTableModel $pricingTableModel     The pricingTableModel instance for pricing table related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(PricingTableModel $pricingTableModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->pricingTableModel = $pricingTableModel;
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
                case 'add pricing table':
                    $this->addPricingTable();
                    break;
                case 'update pricing table':
                    $this->updatePricingTable();
                    break;
                case 'get pricing table details':
                    $this->getPricingTableDetails();
                    break;
                case 'publish pricing table':
                    $this->publishPricingTable();
                    break;
                case 'unpublish pricing table':
                    $this->unpublishPricingTable();
                    break;
                case 'delete pricing table':
                    $this->deletePricingTable();
                    break;
                case 'delete multiple pricing table':
                    $this->deleteMultiplePricingTable();
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
    # Function: addPricingTable
    # Description: 
    # Inserts a pricing table.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addPricingTable() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['pricing_table_name']) && !empty($_POST['pricing_table_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $pricingTableName = $_POST['pricing_table_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $pricingTableID = $this->pricingTableModel->insertPricingTable($pricingTableName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'pricingTableID' => $this->securityModel->encryptData($pricingTableID),
                'title' => 'Insert Pricing Table Success',
                'message' => 'The pricing table has been inserted successfully.',
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
    # Function: updatePricingTable
    # Description: 
    # Updates the pricing table if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updatePricingTable() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['pricing_table_name']) && !empty($_POST['pricing_table_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $pricingTableID = htmlspecialchars($_POST['pricing_table_id'], ENT_QUOTES, 'UTF-8');
            $pricingTableName = $_POST['pricing_table_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkPricingTableExist = $this->pricingTableModel->checkPricingTableExist($pricingTableID);
            $total = $checkPricingTableExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Pricing Table Error',
                    'message' => 'The pricing table does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->pricingTableModel->updatePricingTable($pricingTableID, $pricingTableName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Pricing Table Success',
                'message' => 'The pricing table has been updated successfully.',
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
    # Function: savePricingTableItem
    # Description: 
    # Updates the pricing table if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function savePricingTableItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['pricing_table_item_id']) && isset($_POST['pricing_table_id']) && !empty($_POST['pricing_table_id']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $pricingTableItemID = htmlspecialchars($_POST['pricing_table_item_id'], ENT_QUOTES, 'UTF-8');
            $pricingTableID = htmlspecialchars($_POST['pricing_table_id'], ENT_QUOTES, 'UTF-8');
            $pricingTableTitle = $_POST['pricing_table_title'];
            $pricingTableHeading = $_POST['pricing_table_heading'];
            $pricingTableParagraph = $_POST['pricing_table_paragraph'];
            $callToActionButtonText = $_POST['call_to_action_button_text'];
            $callToActionButtonLink = $_POST['call_to_action_button_link'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkPricingTableExist = $this->pricingTableModel->checkPricingTableExist($pricingTableID);
            $total = $checkPricingTableExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Pricing Table Item Error',
                    'message' => 'The pricing table does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkPricingTableItemExist = $this->pricingTableModel->checkPricingTableItemExist($pricingTableItemID);
            $total = $checkPricingTableItemExist['total'] ?? 0;

            if($total > 0){
                $pricingTableImageFileName = $_FILES['pricing_table_image']['name'];
                $pricingTableImageFileSize = $_FILES['pricing_table_image']['size'];
                $pricingTableImageFileError = $_FILES['pricing_table_image']['error'];
                $pricingTableImageTempName = $_FILES['pricing_table_image']['tmp_name'];
                $pricingTableImageFileExtension = explode('.', $pricingTableImageFileName);
                $pricingTableImageActualFileExtension = strtolower(end($pricingTableImageFileExtension));

                if (!empty($pricingTableImageFileName) && $pricingTableImageFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($pricingTableImageActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Pricing Table Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($pricingTableImageTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Pricing Table Item Error',
                            'message' => 'Please choose the pricing table item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($pricingTableImageFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Pricing Table Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($pricingTableImageFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Pricing Table Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $pricingTableImageActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('CAROUSEL_IMAGE_DIR', 'image/');
        
                    $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $pricingTableID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/pricing-table/image/'. $pricingTableID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Pricing Table Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $pricingTableItemDetails = $this->pricingTableModel->getPricingTableItem($pricingTableItemID);
                    $pricingTableImagePath = !empty($pricingTableItemDetails['pricing_table_image']) ? str_replace('./components/', '../../', $pricingTableItemDetails['pricing_table_image']) : null;

                    if(file_exists($pricingTableImagePath)){
                        if (!unlink($pricingTableImagePath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Pricing Table Item Error',
                                'message' => 'The pricing table item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }

                    if(!move_uploaded_file($pricingTableImageTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Pricing Table Item Error',
                            'message' => 'The pricing table item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }  

                    $this->pricingTableModel->updatePricingTableItem($pricingTableItemID, $pricingTableID, $pricingTableTitle, $pricingTableHeading, $pricingTableParagraph, $callToActionButtonText, $callToActionButtonLink, $filePath, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Pricing Table Item Success',
                        'message' => 'The pricing table item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->pricingTableModel->updatePricingTableItem($pricingTableItemID, $pricingTableID, $pricingTableTitle, $pricingTableHeading, $pricingTableParagraph, $callToActionButtonText, $callToActionButtonLink, '', $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Pricing Table Item Success',
                        'message' => 'The pricing table item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $pricingTableImageFileName = $_FILES['pricing_table_image']['name'];
                $pricingTableImageFileSize = $_FILES['pricing_table_image']['size'];
                $pricingTableImageFileError = $_FILES['pricing_table_image']['error'];
                $pricingTableImageTempName = $_FILES['pricing_table_image']['tmp_name'];
                $pricingTableImageFileExtension = explode('.', $pricingTableImageFileName);
                $pricingTableImageActualFileExtension = strtolower(end($pricingTableImageFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($pricingTableImageActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Pricing Table Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($pricingTableImageTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Pricing Table Item Error',
                        'message' => 'Please choose the pricing table item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($pricingTableImageFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Pricing Table Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($pricingTableImageFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Pricing Table Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $pricingTableImageActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CAROUSEL_IMAGE_DIR', 'image/');
    
                $directory = PROJECT_BASE_DIR. '/'. CAROUSEL_IMAGE_DIR. $pricingTableID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/pricing-table/image/'. $pricingTableID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Pricing Table Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($pricingTableImageTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Pricing Table Item Error',
                        'message' => 'The pricing table item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->pricingTableModel->insertPricingTableItem($pricingTableID, $pricingTableTitle, $pricingTableHeading, $pricingTableParagraph, $callToActionButtonText, $callToActionButtonLink, $filePath, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Pricing Table Item Success',
                    'message' => 'The pricing table item has been inserted successfully.',
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
    # Function: publishPricingTable
    # Description: 
    # Publish the pricing table if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishPricingTable() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['pricing_table_id']) && !empty($_POST['pricing_table_id'])) {
            $userID = $_SESSION['user_account_id'];
            $pricingTableID = htmlspecialchars($_POST['pricing_table_id'], ENT_QUOTES, 'UTF-8');
        
            $checkPricingTableExist = $this->pricingTableModel->checkPricingTableExist($pricingTableID);
            $total = $checkPricingTableExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Pricing Table Error',
                    'message' => 'The pricing table does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->pricingTableModel->updatePricingTablePublishStatus($pricingTableID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Pricing Table Success',
                'message' => 'The pricing table has been published successfully.',
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
    # Function: unpublishPricingTable
    # Description: 
    # Publish the pricing table if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishPricingTable() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['pricing_table_id']) && !empty($_POST['pricing_table_id'])) {
            $userID = $_SESSION['user_account_id'];
            $pricingTableID = htmlspecialchars($_POST['pricing_table_id'], ENT_QUOTES, 'UTF-8');
        
            $checkPricingTableExist = $this->pricingTableModel->checkPricingTableExist($pricingTableID);
            $total = $checkPricingTableExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Pricing Table Error',
                    'message' => 'The pricing table does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->pricingTableModel->updatePricingTablePublishStatus($pricingTableID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Pricing Table Success',
                'message' => 'The pricing table has been unpublished successfully.',
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
    # Function: deletePricingTable
    # Description: 
    # Delete the pricing table if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deletePricingTable() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['pricing_table_id']) && !empty($_POST['pricing_table_id'])) {
            $pricingTableID = htmlspecialchars($_POST['pricing_table_id'], ENT_QUOTES, 'UTF-8');
        
            $checkPricingTableExist = $this->pricingTableModel->checkPricingTableExist($pricingTableID);
            $total = $checkPricingTableExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Pricing Table Error',
                    'message' => 'The pricing table does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->pricingTableModel->deletePricingTable($pricingTableID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Pricing Table Success',
                'message' => 'The pricing table has been deleted successfully.',
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
    # Function: deleteMultiplePricingTable
    # Description: 
    # Delete the selected pricing tables if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultiplePricingTable() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['pricing_table_id']) && !empty($_POST['pricing_table_id'])) {
            $pricingTableIDs = $_POST['pricing_table_id'];
    
            foreach($pricingTableIDs as $pricingTableID){
                $checkPricingTableExist = $this->pricingTableModel->checkPricingTableExist($pricingTableID);
                $total = $checkPricingTableExist['total'] ?? 0;

                if($total > 0){
                    $this->pricingTableModel->deletePricingTable($pricingTableID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Pricing Tables Success',
                'message' => 'The selected pricing tables have been deleted successfully.',
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
    # Function: getPricingTableDetails
    # Description: 
    # Handles the retrieval of pricing table details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getPricingTableDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['pricing_table_id']) && !empty($_POST['pricing_table_id'])) {
            $userID = $_SESSION['user_account_id'];
            $pricingTableID = htmlspecialchars($_POST['pricing_table_id'], ENT_QUOTES, 'UTF-8');

            $checkPricingTableExist = $this->pricingTableModel->checkPricingTableExist($pricingTableID);
            $total = $checkPricingTableExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Pricing Table Details Error',
                    'message' => 'The pricing table does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $pricingTableDetails = $this->pricingTableModel->getPricingTable($pricingTableID);

            $response = [
                'success' => true,
                'pricingTableName' => $pricingTableDetails['pricing_table_name'] ?? null,
                'description' => $pricingTableDetails['description'] ?? null,
                'blockStyleID' => $pricingTableDetails['block_style_id'] ?? '',
                'blockStyleName' => $pricingTableDetails['block_style_name'] ?? ''
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
require_once '../../pricing-table/model/pricing-table-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new PricingTableController(new PricingTableModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>