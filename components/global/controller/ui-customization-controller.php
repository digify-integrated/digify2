<?php
session_start();

# -------------------------------------------------------------
#
# Function: InternalNotesController
# Description: 
# The InternalNotesController class handles global related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class InternalNotesController {
    private $globalModel;
    private $authenticationModel;
    private $securityModel;
    private $uiCustomizationSettingModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided globalModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for global related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param GlobalModel $globalModel     The GlobalModel instance for global related operations.
    # - @param UICustomizationSettingModel $uiCustomizationSettingModel     The UICustomizationSettingModel instance for UI customization setting related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(GlobalModel $globalModel, UICustomizationSettingModel $uiCustomizationSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->globalModel = $globalModel;
        $this->uiCustomizationSettingModel = $uiCustomizationSettingModel;
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
                case 'update ui customization setting':
                    $this->updateUICustomizationSetting();
                    break;
                case 'get ui customization setting details':
                    $this->getUICustomizationSettingDetails();
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
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateUICustomizationSetting
    # Description: 
    # Updates the UI Customization Setting based on the type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateUICustomizationSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['type']) && !empty($_POST['type']) && isset($_POST['customizationValue'])) {
            $userID = $_SESSION['user_account_id'];
            $type = $_POST['type'];
            $customizationValue = $_POST['customizationValue'];
            
        
            $checkUICustomizationSettingExist = $this->uiCustomizationSettingModel->checkUICustomizationSettingExist($userID);
            $total = $checkUICustomizationSettingExist['total'] ?? 0;
        
            if ($total > 0) {
                $this->uiCustomizationSettingModel->updateUICustomizationSetting($userID, $type, $customizationValue, $userID);
            } 
            else {
                $this->uiCustomizationSettingModel->insertUICustomizationSetting($userID, $type, $customizationValue, $userID);
            }

            $response = [
                'success' => true
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
    # Function: getUICustomizationSettingDetails
    # Description: 
    # Handles the retrieval of UI customization setting details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getUICustomizationSettingDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $userID = $_SESSION['user_account_id'];

        $checkUICustomizationSettingExist = $this->uiCustomizationSettingModel->checkUICustomizationSettingExist($userID);
        $total = $checkUICustomizationSettingExist['total'] ?? 0;
    
        if ($total > 0) {
            $uiCustomizationSettingDetails = $this->uiCustomizationSettingModel->getUICustomizationSetting($userID);
            $sidebarType = $uiCustomizationSettingDetails['sidebar_type'] ?? 'full';
            $boxedLayout = ($uiCustomizationSettingDetails['boxed_layout'] == 1) ? true : false;
            $theme = $uiCustomizationSettingDetails['theme'] ?? 'light';
            $colorTheme = $uiCustomizationSettingDetails['color_theme'] ?? 'Blue_Theme';
            $cardBorder = ($uiCustomizationSettingDetails['card_border'] == 1) ? true : false;

        } 
        else {
            $sidebarType = 'full';
            $boxedLayout = false;
            $theme = 'light';
            $colorTheme = 'Blue_Theme';
            $cardBorder = false;
        }
    
        $response = [
            'success' => true,
            'layout' => 'vertical',
            'direction' => 'ltr',
            'sidebarType' => $sidebarType,
            'boxedLayout' => $boxedLayout,
            'theme' => $theme,
            'colorTheme' => $colorTheme,
            'cardBorder' => $cardBorder
        ];

        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------
}
# -------------------------------------------------------------

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../global/model/global-model.php';
require_once '../../global/model/ui-customization-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new InternalNotesController(new GlobalModel(new DatabaseModel, new SecurityModel), new UICustomizationSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>