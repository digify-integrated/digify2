<?php
session_start();

# -------------------------------------------------------------
#
# Function: CarouselController
# Description: 
# The CarouselController class handles carousel related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class CarouselController {
    private $carouselModel;
    private $authenticationModel;
    private $securityModel;
    private $systemModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided CarouselModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for carousel related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param CarouselModel $carouselModel     The CarouselModel instance for carousel related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(CarouselModel $carouselModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel, SystemModel $systemModel) {
        $this->carouselModel = $carouselModel;
        $this->authenticationModel = $authenticationModel;
        $this->securityModel = $securityModel;
        $this->systemModel = $systemModel;
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
                case 'add carousel':
                    $this->addCarousel();
                    break;
                case 'update carousel':
                    $this->updateCarousel();
                    break;
                case 'get carousel details':
                    $this->getCarouselDetails();
                    break;
                case 'delete carousel':
                    $this->deleteCarousel();
                    break;
                case 'delete multiple carousel':
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
    # Inserts a carousel.
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

        if (isset($_POST['carousel_name']) && !empty($_POST['carousel_name']) && isset($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselName = $_POST['carousel_name'];
            $description = $_POST['description'];
        
            $carouselID = $this->carouselModel->insertCarousel($carouselName, $description, $userID);
    
            $response = [
                'success' => true,
                'carouselID' => $this->securityModel->encryptData($carouselID),
                'title' => 'Insert Carousel Success',
                'message' => 'The carousel has been inserted successfully.',
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
    # Updates the carousel if it exists; otherwise, return an error message.
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
        
        if (isset($_POST['carousel_id']) && !empty($_POST['carousel_id']) && isset($_POST['carousel_name']) && !empty($_POST['carousel_name']) && isset($_POST['description'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselID = htmlspecialchars($_POST['carousel_id'], ENT_QUOTES, 'UTF-8');
            $carouselName = $_POST['carousel_name'];
            $description = $_POST['description'];
        
            $checkCarouselExist = $this->carouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Carousel Error',
                    'message' => 'The carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->carouselModel->updateCarousel($carouselID, $carouselName, $description, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Carousel Success',
                'message' => 'The carousel has been updated successfully.',
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
    # Delete the carousel if it exists; otherwise, return an error message.
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

        if (isset($_POST['carousel_id']) && !empty($_POST['carousel_id'])) {
            $carouselID = htmlspecialchars($_POST['carousel_id'], ENT_QUOTES, 'UTF-8');
        
            $checkCarouselExist = $this->carouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Carousel Error',
                    'message' => 'The carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->carouselModel->deleteCarousel($carouselID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Carousel Success',
                'message' => 'The carousel has been deleted successfully.',
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
    # Delete the selected carousel if it exists; otherwise, skip it.
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

        if (isset($_POST['carousel_id']) && !empty($_POST['carousel_id'])) {
            $carouselIDs = $_POST['carousel_id'];
    
            foreach($carouselIDs as $carouselID){
                $checkCarouselExist = $this->carouselModel->checkCarouselExist($carouselID);
                $total = $checkCarouselExist['total'] ?? 0;

                if($total > 0){                    
                    $this->carouselModel->deleteCarousel($carouselID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Carousels Success',
                'message' => 'The selected carousels have been deleted successfully.',
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
    # Handles the retrieval of carousel details.
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
    
        if (isset($_POST['carousel_id']) && !empty($_POST['carousel_id'])) {
            $userID = $_SESSION['user_account_id'];
            $carouselID = htmlspecialchars($_POST['carousel_id'], ENT_QUOTES, 'UTF-8');

            $checkCarouselExist = $this->carouselModel->checkCarouselExist($carouselID);
            $total = $checkCarouselExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Carousel Details Error',
                    'message' => 'The carousel does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $carouselDetails = $this->carouselModel->getCarousel($carouselID);

            $response = [
                'success' => true,
                'carouselName' => $carouselDetails['carousel_name'] ?? null,
                'description' => $carouselDetails['description'] ?? null
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
require_once '../../carousel/model/carousel-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new CarouselController(new CarouselModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();

?>