<?php
session_start();

# -------------------------------------------------------------
#
# Function: ClientController
# Description: 
# The ClientController class handles client related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class ClientController {
    private $clientModel;
    private $blockStyleModel;
    private $uploadSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided clientModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for client related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param ClientModel $clientModel     The clientModel instance for client related operations.
    # - @param BlockStyleModel $blockStyleModel     The blockStyleModel instance for block style related operations.
    # - @param UploadSettingModel $uploadSettingModel     The UploadSettingModel instance for upload setting operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(ClientModel $clientModel, BlockStyleModel $blockStyleModel, UploadSettingModel $uploadSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->clientModel = $clientModel;
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
                case 'add client':
                    $this->addClient();
                    break;
                case 'update client':
                    $this->updateClient();
                    break;
                case 'save client item':
                    $this->saveClientItem();
                    break;
                case 'get client details':
                    $this->getClientDetails();
                    break;
                case 'get client item details':
                    $this->getClientItemDetails();
                    break;
                case 'publish client':
                    $this->publishClient();
                    break;
                case 'unpublish client':
                    $this->unpublishClient();
                    break;
                case 'delete client':
                    $this->deleteClient();
                    break;
                case 'delete client item':
                    $this->deleteClientItem();
                    break;
                case 'delete multiple client':
                    $this->deleteMultipleClient();
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
    # Function: addClient
    # Description: 
    # Inserts a client.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addClient() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['client_name']) && !empty($_POST['client_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $clientName = $_POST['client_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';
        
            $clientID = $this->clientModel->insertClient($clientName, $description, $blockStyleID, $blockStyleName, $userID);
    
            $response = [
                'success' => true,
                'clientID' => $this->securityModel->encryptData($clientID),
                'title' => 'Insert Client Success',
                'message' => 'The client has been inserted successfully.',
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
    # Function: updateClient
    # Description: 
    # Updates the client if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateClient() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['client_name']) && !empty($_POST['client_name']) && isset($_POST['block_style_id']) && !empty($_POST['block_style_id']) && isset($_POST['description']) && !empty($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $clientID = htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8');
            $clientName = $_POST['client_name'];
            $blockStyleID = htmlspecialchars($_POST['block_style_id'], ENT_QUOTES, 'UTF-8');
            $description = $_POST['description'];
        
            $checkClientExist = $this->clientModel->checkClientExist($clientID);
            $total = $checkClientExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Client Error',
                    'message' => 'The client does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $blockStyleDetails = $this->blockStyleModel->getBlockStyle($blockStyleID);
            $blockStyleName = $blockStyleDetails['block_style_name'] ?? '';

            $this->clientModel->updateClient($clientID, $clientName, $description, $blockStyleID, $blockStyleName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Client Success',
                'message' => 'The client has been updated successfully.',
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
    # Function: saveClientItem
    # Description: 
    # Updates the client if it exists; otherwise, insert.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function saveClientItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['client_item_id']) && isset($_POST['client_id']) && !empty($_POST['client_id']) && isset($_POST['client_url']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $clientItemID = htmlspecialchars($_POST['client_item_id'], ENT_QUOTES, 'UTF-8');
            $clientID = htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8');
            $clientURL = $_POST['client_url'];
            $orderSequence = $_POST['order_sequence'];
        
            $checkClientExist = $this->clientModel->checkClientExist($clientID);
            $total = $checkClientExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Save Client Item Error',
                    'message' => 'The client does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $checkClientItemExist = $this->clientModel->checkClientItemExist($clientItemID);
            $total = $checkClientItemExist['total'] ?? 0;

            if($total > 0){
                $clientLogoFileName = $_FILES['client_logo']['name'];
                $clientLogoFileSize = $_FILES['client_logo']['size'];
                $clientLogoFileError = $_FILES['client_logo']['error'];
                $clientLogoTempName = $_FILES['client_logo']['tmp_name'];
                $clientLogoFileExtension = explode('.', $clientLogoFileName);
                $clientLogoActualFileExtension = strtolower(end($clientLogoFileExtension));

                if (!empty($clientLogoFileName) && $clientLogoFileSize > 0) {
                    $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                    $maxFileSize = $uploadSetting['max_file_size'];
        
                    $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                    $allowedFileExtensions = [];
        
                    foreach ($uploadSettingFileExtension as $row) {
                        $allowedFileExtensions[] = $row['file_extension'];
                    }
        
                    if (!in_array($clientLogoActualFileExtension, $allowedFileExtensions)) {
                        $response = [
                            'success' => false,
                            'title' => 'Update Client Item Error',
                            'message' => 'The file uploaded is not supported.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if(empty($clientLogoTempName)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Client Item Error',
                            'message' => 'Please choose the client item.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($clientLogoFileError){
                        $response = [
                            'success' => false,
                            'title' => 'Update Client Item Error',
                            'message' => 'An error occurred while uploading the file.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                    
                    if($clientLogoFileSize > ($maxFileSize * 1024)){
                        $response = [
                            'success' => false,
                            'title' => 'Update Client Item Error',
                            'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
        
                    $fileName = $this->securityModel->generateFileName();
                    $fileNew = $fileName . '.' . $clientLogoActualFileExtension;
                    
                    define('PROJECT_BASE_DIR', dirname(__DIR__));
                    define('CLIENT_LOGO_DIR', 'logo/');
        
                    $directory = PROJECT_BASE_DIR. '/'. CLIENT_LOGO_DIR. $clientID. '/';
                    $fileDestination = $directory. $fileNew;
                    $filePath = './components/client/logo/'. $clientID . '/' . $fileNew;
        
                    $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
        
                    if(!$directoryChecker){
                        $response = [
                            'success' => false,
                            'title' => 'Update Client Item Error',
                            'message' => $directoryChecker,
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }

                    $clientItemDetails = $this->clientModel->getClientItem($clientItemID);
                    $clientItemPath = !empty($clientItemDetails['client_logo']) ? str_replace('./components/', '../../', $clientItemDetails['client_logo']) : null;

                    if(file_exists($clientItemPath)){
                        if (!unlink($clientItemPath)) {
                            $response = [
                                'success' => false,
                                'title' => 'Update Client Item Error',
                                'message' => 'The client item cannot be deleted due to an error.',
                                'messageType' => 'error'
                            ];
                            
                            echo json_encode($response);
                            exit;
                        }
                    }
                    
                    if(!move_uploaded_file($clientLogoTempName, $fileDestination)){
                        $response = [
                            'success' => false,
                            'title' => 'Insert Client Item Error',
                            'message' => 'The client item cannot be uploaded due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;           
                    }

                    $this->clientModel->updateClientItem($clientItemID, $clientID, $filePath, $clientURL, $orderSequence, $userID);
                    
                    $response = [
                        'success' => true,
                        'title' => 'Update Client Item Success',
                        'message' => 'The client item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                } 
                else {
                    $this->clientModel->updateClientItem($clientItemID, $clientID, '', $clientURL, $orderSequence, $userID);

                    $response = [
                        'success' => true,
                        'title' => 'Update Client Item Success',
                        'message' => 'The client item has been inserted successfully.',
                        'messageType' => 'success'
                    ];
                    
                    echo json_encode($response);
                    exit;   
                }
            }
            else{
                $clientLogoFileName = $_FILES['client_logo']['name'];
                $clientLogoFileSize = $_FILES['client_logo']['size'];
                $clientLogoFileError = $_FILES['client_logo']['error'];
                $clientLogoTempName = $_FILES['client_logo']['tmp_name'];
                $clientLogoFileExtension = explode('.', $clientLogoFileName);
                $clientLogoActualFileExtension = strtolower(end($clientLogoFileExtension));
    
                $uploadSetting = $this->uploadSettingModel->getUploadSetting(5);
                $maxFileSize = $uploadSetting['max_file_size'];
    
                $uploadSettingFileExtension = $this->uploadSettingModel->getUploadSettingFileExtension(5);
                $allowedFileExtensions = [];
    
                foreach ($uploadSettingFileExtension as $row) {
                    $allowedFileExtensions[] = $row['file_extension'];
                }
    
                if (!in_array($clientLogoActualFileExtension, $allowedFileExtensions)) {
                    $response = [
                        'success' => false,
                        'title' => 'Insert Client Item Error',
                        'message' => 'The file uploaded is not supported.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if(empty($clientLogoTempName)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Client Item Error',
                        'message' => 'Please choose the client item.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($clientLogoFileError){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Client Item Error',
                        'message' => 'An error occurred while uploading the file.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
                
                if($clientLogoFileSize > ($maxFileSize * 1024)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Client Item Error',
                        'message' => 'The file exceeds the maximum allowed size of ' . number_format($maxFileSize) . ' kb.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
    
                $fileName = $this->securityModel->generateFileName();
                $fileNew = $fileName . '.' . $clientLogoActualFileExtension;
                
                define('PROJECT_BASE_DIR', dirname(__DIR__));
                define('CLIENT_LOGO_DIR', 'logo/');
    
                $directory = PROJECT_BASE_DIR. '/'. CLIENT_LOGO_DIR. $clientID. '/';
                $fileDestination = $directory. $fileNew;
                $filePath = './components/client/logo/'. $clientID . '/' . $fileNew;
    
                $directoryChecker = $this->securityModel->directoryChecker(str_replace('./', '../../', $directory));
    
                if(!$directoryChecker){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Client Item Error',
                        'message' => $directoryChecker,
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }

                if(!move_uploaded_file($clientLogoTempName, $fileDestination)){
                    $response = [
                        'success' => false,
                        'title' => 'Insert Client Item Error',
                        'message' => 'The client item cannot be uploaded due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;           
                }    

                $this->clientModel->insertClientItem($clientID, $filePath, $clientURL, $orderSequence, $userID);
                
                $response = [
                    'success' => true,
                    'title' => 'Insert Client Item Success',
                    'message' => 'The client item has been inserted successfully.',
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
    # Function: publishClient
    # Description: 
    # Publish the client if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function publishClient() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['client_id']) && !empty($_POST['client_id'])) {
            $userID = $_SESSION['user_account_id'];
            $clientID = htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8');
        
            $checkClientExist = $this->clientModel->checkClientExist($clientID);
            $total = $checkClientExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Publish Client Error',
                    'message' => 'The client does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->clientModel->updateClientPublishStatus($clientID, 'Yes', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Publish Client Success',
                'message' => 'The client has been published successfully.',
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
    # Function: unpublishClient
    # Description: 
    # Publish the client if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function unpublishClient() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['client_id']) && !empty($_POST['client_id'])) {
            $userID = $_SESSION['user_account_id'];
            $clientID = htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8');
        
            $checkClientExist = $this->clientModel->checkClientExist($clientID);
            $total = $checkClientExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Unpublish Client Error',
                    'message' => 'The client does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->clientModel->updateClientPublishStatus($clientID, 'No', $userID);
                
            $response = [
                'success' => true,
                'title' => 'Unpublish Client Success',
                'message' => 'The client has been unpublished successfully.',
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
    # Function: deleteClient
    # Description: 
    # Delete the client if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteClient() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['client_id']) && !empty($_POST['client_id'])) {
            $clientID = htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8');
        
            $checkClientExist = $this->clientModel->checkClientExist($clientID);
            $total = $checkClientExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Client Error',
                    'message' => 'The client does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $clientItemByClientDetails = $this->clientModel->getClientItemByClientID($clientID);

            foreach ($clientItemByClientDetails as $row) {
                $clientItemPath = !empty($row['client_logo']) ? str_replace('./components/', '../../', $row['client_logo']) : null;

                if(file_exists($clientItemPath)){
                    if (!unlink($clientItemPath)) {
                        $response = [
                            'success' => false,
                            'title' => 'Delete Client Item Error',
                            'message' => 'The client item cannot be deleted due to an error.',
                            'messageType' => 'error'
                        ];
                        
                        echo json_encode($response);
                        exit;
                    }
                }
            }

            $this->clientModel->deleteClient($clientID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Client Success',
                'message' => 'The client has been deleted successfully.',
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
    # Function: deleteClientItem
    # Description: 
    # Delete the client if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteClientItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['client_item_id']) && !empty($_POST['client_item_id'])) {
            $clientItemID = htmlspecialchars($_POST['client_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkClientItemExist = $this->clientModel->checkClientItemExist($clientItemID);
            $total = $checkClientItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Delete Client Item Error',
                    'message' => 'The client item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $clientItemDetails = $this->clientModel->getClientItem($clientItemID);
            $clientItemPath = !empty($clientItemDetails['client_logo']) ? str_replace('./components/', '../../', $clientItemDetails['client_logo']) : null;

            if(file_exists($clientItemPath)){
                if (!unlink($clientItemPath)) {
                    $response = [
                        'success' => false,
                        'title' => 'Delete Client Item Error',
                        'message' => 'The client item cannot be deleted due to an error.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
                }
            }

            $this->clientModel->deleteClientItem($clientItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Client Item Success',
                'message' => 'The client item has been deleted successfully.',
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
    # Function: deleteMultipleClient
    # Description: 
    # Delete the selected clients if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleClient() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['client_id']) && !empty($_POST['client_id'])) {
            $clientIDs = $_POST['client_id'];
    
            foreach($clientIDs as $clientID){
                $checkClientExist = $this->clientModel->checkClientExist($clientID);
                $total = $checkClientExist['total'] ?? 0;

                if($total > 0){
                    $clientItemByClientDetails = $this->clientModel->getClientItemByClientID($clientID);

                    foreach ($clientItemByClientDetails as $row) {
                        $clientItemPath = !empty($row['client_logo']) ? str_replace('./components/', '../../', $row['client_logo']) : null;

                        if(file_exists($clientItemPath)){
                            if (!unlink($clientItemPath)) {
                                $response = [
                                    'success' => false,
                                    'title' => 'Delete Client Item Error',
                                    'message' => 'The client item cannot be deleted due to an error.',
                                    'messageType' => 'error'
                                ];
                                
                                echo json_encode($response);
                                exit;
                            }
                        }
                    }

                    $this->clientModel->deleteClient($clientID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Clients Success',
                'message' => 'The selected clients have been deleted successfully.',
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
    # Function: getClientDetails
    # Description: 
    # Handles the retrieval of client details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getClientDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['client_id']) && !empty($_POST['client_id'])) {
            $userID = $_SESSION['user_account_id'];
            $clientID = htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8');

            $checkClientExist = $this->clientModel->checkClientExist($clientID);
            $total = $checkClientExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Client Details Error',
                    'message' => 'The client does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $clientDetails = $this->clientModel->getClient($clientID);

            $response = [
                'success' => true,
                'clientName' => $clientDetails['client_name'] ?? null,
                'description' => $clientDetails['description'] ?? null,
                'blockStyleID' => $clientDetails['block_style_id'] ?? '',
                'blockStyleName' => $clientDetails['block_style_name'] ?? ''
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
    # Function: getClientItemDetails
    # Description: 
    # Handles the retrieval of client item details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getClientItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['client_item_id']) && !empty($_POST['client_item_id'])) {
            $userID = $_SESSION['user_account_id'];
            $clientItemID = htmlspecialchars($_POST['client_item_id'], ENT_QUOTES, 'UTF-8');

            $checkClientItemExist = $this->clientModel->checkClientItemExist($clientItemID);
            $total = $checkClientItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'title' => 'Get Client Item Details Error',
                    'message' => 'The client item does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $clientItemDetails = $this->clientModel->getClientItem($clientItemID);

            $response = [
                'success' => true,
                'clientURL' => $clientItemDetails['client_url'] ?? null,
                'orderSequence' => $clientItemDetails['order_sequence'] ?? null
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
require_once '../../client/model/client-model.php';
require_once '../../block-style/model/block-style-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new ClientController(new ClientModel(new DatabaseModel), new BlockStyleModel(new DatabaseModel), new UploadSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>