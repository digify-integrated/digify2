<?php
session_start();

# -------------------------------------------------------------
#
# Function: BookingController
# Description: 
# The BookingController class handles booking related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class BookingController {
    private $bookingModel;
    private $voucherModel;
    private $authenticationModel;
    private $systemModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided bookingModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for booking related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param BookingModel $bookingModel     The bookingModel instance for booking related operations.
    # - @param VoucherModel $voucherModel     The voucherModel instance for voucher related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SystemModel $systemModel   The SystemModel instance for system related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(BookingModel $bookingModel, VoucherModel $voucherModel, AuthenticationModel $authenticationModel, SystemModel $systemModel, SecurityModel $securityModel) {
        $this->bookingModel = $bookingModel;
        $this->voucherModel = $voucherModel;
        $this->authenticationModel = $authenticationModel;
        $this->systemModel = $systemModel;
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
            
            $transaction = isset($_POST['transaction']) ? $_POST['transaction'] : null;

            switch ($transaction) {
                case 'add booking':
                    $this->addBooking();
                    break;
                default:
                    $response = [
                        'success' => false,
                        'title' => 'Error: Transaction Failed',
                        'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
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
    # Function: addBooking
    # Description: 
    # Inserts a booking.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addBooking() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['first_name']) && !empty($_POST['first_name']) && isset($_POST['last_name']) && !empty($_POST['last_name']) && isset($_POST['address']) && !empty($_POST['address']) && isset($_POST['phone']) && !empty($_POST['phone']) && isset($_POST['email_address']) && !empty($_POST['email_address']) && isset($_POST['service']) && !empty($_POST['service']) && isset($_POST['frequency']) && isset($_POST['duration']) && isset($_POST['number_of_seats']) && isset($_POST['meters']) && isset($_POST['cleaning_materials']) && isset($_POST['booking_date']) && !empty($_POST['booking_date']) && isset($_POST['booking_time']) && !empty($_POST['booking_time']) && isset($_POST['number_of_professionals']) && !empty($_POST['number_of_professionals']) && isset($_POST['number_of_hours']) && !empty($_POST['number_of_hours']) && isset($_POST['nationality']) && !empty($_POST['nationality']) && isset($_POST['special_instructions']) && isset($_POST['discount_code']) && isset($_POST['mode_of_payment']) && !empty($_POST['mode_of_payment'])) {
            $firstName = $_POST['first_name'];
            $lastName = $_POST['last_name'];
            $address = $_POST['address'];
            $phone = $_POST['phone'];
            $emailAddress = $_POST['email_address'];
            $service = $_POST['service'];
            $frequency = $_POST['frequency'];
            $duration = isset($_POST['duration']) && $_POST['duration'] !== '' ? (int)$_POST['duration'] : 0;
            $numberOfSeats = isset($_POST['number_of_seats']) && $_POST['number_of_seats'] !== '' ? (int)$_POST['number_of_seats'] : 0;
            $meters = isset($_POST['meters']) && $_POST['meters'] !== '' ? (int)$_POST['meters'] : 0;
            $cleaningMaterials = $_POST['cleaning_materials'];
            $bookingDate = $this->systemModel->checkDate('empty', $_POST['booking_date'], '', 'Y-m-d', '');
            $bookingTime = $_POST['booking_time'];
            $numberOfProfessionals = $_POST['number_of_professionals'];
            $numberOfHours = $_POST['number_of_hours'];
            $nationality = $_POST['nationality'];
            $specialInstructions = $_POST['special_instructions'];
            $modeOfPayment = $_POST['mode_of_payment'];
            $discountCode = $_POST['discount_code'];
            
            $checkVoucherCodeValidy = $this->voucherModel->checkVoucherCodeValidy($discountCode);
            $total = $checkVoucherCodeValidy['total'] ?? 0;
            $discountCode = $total === 0 ? '' : $discountCode;
    
            $servicePrices = [
                'Deep Cleaning' => [$duration, 25],
                'Regular Cleaning' => [$duration, 25],
                'Office Cleaning' => [$duration, 25],
                'Flat Cleaning' => [$duration, 25],
                'Hospital Cleaning' => [$duration, 25],
                'Sofa Cleaning' => [$numberOfSeats, 20],
                'Mattress Cleaning' => [$meters, 15],
                'Curtain Cleaning' => [$meters, 15],
                'Carpet Cleaning' => [$meters, 15],
            ];
    
            if (!isset($servicePrices[$service])) {
                $bookingSubtotal = 0;
                $serviceSubTotal = 0;
            } else {
                list($factor, $price) = $servicePrices[$service];
                $bookingSubtotal = $factor * $price;
                $serviceSubTotal = $factor * $price;
            }
    
            if($cleaningMaterials == 'Yes'){
                $bookingSubtotal = $bookingSubtotal + 10;
            }
    
            $voucherDetails = $this->voucherModel->getVoucherCode($discountCode);
            $discountType = $voucherDetails['discount_type'] ?? null;
            $discountAmount = $voucherDetails['discount_amount'] ?? 0;
    
            $totalDiscountAmount = $discountType === 'By Percentage' ? min(($discountAmount / 100) * $bookingSubtotal, $bookingSubtotal) : min($discountAmount, $bookingSubtotal);
    
            $bookingTotal = $bookingSubtotal - $totalDiscountAmount;
    
            $bookingReferenceNumber = $this->generateBookingReferenceNumber();
            $cancellationWindow = $this->calculateCancellationWindow(date('Y-m-d H:i:s'), $bookingDate, $bookingTime);
        
            $bookingID = $this->bookingModel->insertBooking($bookingReferenceNumber, 'Website', $service, $frequency, $duration, $numberOfSeats, $meters, $cleaningMaterials, $bookingDate, $bookingTime, $numberOfProfessionals, $numberOfHours, $nationality, $firstName, $lastName, $address, $phone, $emailAddress, $specialInstructions, $modeOfPayment, $discountCode, $discountType, $discountAmount, $totalDiscountAmount, $bookingSubtotal, $bookingTotal, $cancellationWindow, 1);
            $bookingIDEncrypted = $this->securityModel->encryptData($bookingID);
    
            if($modeOfPayment == 'Cash'){
                $response = [
                    'success' => true,
                    'redirectLink' => null,
                    'title' => 'Insert Booking Success',
                    'message' => 'The booking has been inserted successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
            else{
                \Stripe\Stripe::setApiKey(STRIPE_API_KEY);

                // Calculate total amount after discount
                $serviceTotal = $serviceSubTotal;

                // Apply the discount
                $serviceTotal -= $totalDiscountAmount; 

                // Ensure the total amount is not negative
                if ($serviceTotal < 0) {
                    $serviceTotal = 0;
                }

                $line_items = [];

                // Define the main service line item
                if (in_array($service, ['Deep Cleaning', 'Regular Cleaning', 'Office Cleaning', 'Flat Cleaning', 'Hospital Cleaning'])) {
                    $line_items[] = [
                        "price_data" => [
                            "currency" => "aed",
                            "unit_amount" => $serviceTotal * 100, // Amount in cents
                            "product_data" => [
                                "name" => $service,
                                "description" => "Frequency: $frequency, Duration: $duration hour(s)"
                            ]
                        ],
                        "quantity" => 1
                    ];
                } elseif ($service === 'Sofa Cleaning') {
                    $line_items[] = [
                        "price_data" => [
                            "currency" => "aed",
                            "unit_amount" => $serviceTotal * 100, // Amount in cents
                            "product_data" => [
                                "name" => $service,
                                "description" => "Number of Seats: $numberOfSeats"
                            ]
                        ],
                        "quantity" => 1
                    ];
                } elseif (in_array($service, ['Mattress Cleaning', 'Curtain Cleaning', 'Carpet Cleaning'])) {
                    $line_items[] = [
                        "price_data" => [
                            "currency" => "aed",
                            "unit_amount" => $serviceTotal * 100, // Amount in cents
                            "product_data" => [
                                "name" => $service,
                                "description" => "Meters: $meters"
                            ]
                        ],
                        "quantity" => 1
                    ];
                }

                // Add a line item for cleaning materials if applicable
                if ($cleaningMaterials === 'Yes') {
                    $line_items[] = [
                        "price_data" => [
                            "currency" => "aed",
                            "unit_amount" => 1000, // 10 AED in cents
                            "product_data" => [
                                "name" => "Cleaning Materials"
                            ]
                        ],
                        "quantity" => 1
                    ];
                }

                // Create the checkout session with the constructed line items
                $checkout_session = \Stripe\Checkout\Session::create([
                    "mode" => "payment",
                    "success_url" => "http://digify.x10.bz/components/al-thabitah/page/_booking_success.php?session_id={CHECKOUT_SESSION_ID}&booking_id=" . $bookingIDEncrypted,
                    "cancel_url" => "http://digify.x10.bz/althabitah.php?page=booking",
                    "locale" => "auto",
                    "line_items" => $line_items
                ]);

                $response = [
                    'success' => true,
                    'redirectLink' => $checkout_session->url,
                    'title' => 'Insert Booking Success',
                    'message' => 'The booking has been inserted successfully.',
                    'messageType' => 'success'
                ];
                
                echo json_encode($response);
                exit;
            }
        } else {
            $response = [
                'success' => false,
                'title' => 'Error: Transaction Failed',
                'message' => 'An error occurred while processing your transaction. Please try again contact our support team for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Custom methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: calculateCancellationWindow
    # Description: 
    # Handles the calculation of cancellation window.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function calculateCancellationWindow($transactionDateTime, $bookingDate, $bookingTime) {
        // Convert the booking date and time to a DateTime object
        $bookingDateTime = new DateTime($bookingDate . ' ' . $bookingTime);
    
        // Convert the transaction date and time to a DateTime object
        $transactionDateTime = new DateTime($transactionDateTime);
    
        // Calculate the difference in hours between the transaction time and the booking time
        $interval = $transactionDateTime->diff($bookingDateTime);
        $hoursDifference = ($interval->days * 24) + $interval->h;
    
        // Determine the cancellation window datetime
        if ($hoursDifference > 24) {
            // Cancellation window is 24 hours before the booking datetime
            $cancellationWindow = clone $bookingDateTime;
            $cancellationWindow->modify('-24 hours');
        } elseif ($hoursDifference >= 2) {
            // Cancellation window is 2 hours before the booking datetime for same-day bookings
            $cancellationWindow = clone $bookingDateTime;
            $cancellationWindow->modify('-2 hours');
        } else {
            // No cancellation allowed if less than 2 hours remain
            return "No cancellation allowed";
        }
    
        return $cancellationWindow->format('Y-m-d H:i:s');
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateBookingReferenceNumber
    # Description: 
    # Handles the generation of booking reference number.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function generateBookingReferenceNumber($length = 8) {
        // Define the prefix for the booking reference number
        $prefix = 'ALTH';
        
        // Define the characters to use in the booking reference
        $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        $charactersLength = strlen($characters);
        $bookingReferenceNumber = '';
        
        // Generate a random part of the booking reference
        for ($i = 0; $i < $length; $i++) {
            $bookingReferenceNumber .= $characters[rand(0, $charactersLength - 1)];
        }
        
        // Combine the prefix with the reference number
        $finalReference = $prefix . $bookingReferenceNumber;
        
        return $finalReference;
    }
    # -------------------------------------------------------------
}
# -------------------------------------------------------------

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../booking/model/booking-model.php';
require_once '../../voucher/model/voucher-model.php';
require_once '../../authentication/model/authentication-model.php';
require_once '../../../assets/libs/stripe-php-master/init.php';

$controller = new BookingController(new BookingModel(new DatabaseModel), new VoucherModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SystemModel(), new SecurityModel());
$controller->handleRequest();

?>