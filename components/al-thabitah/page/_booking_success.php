<?php
    require_once '../../global/config/config.php';
    require_once '../../global/model/database-model.php';
    require_once '../../global/model/security-model.php';
    require_once '../../booking/model/booking-model.php';
    require_once '../../voucher/model/voucher-model.php';
    
    require_once '../../../assets/libs/stripe-php-master/init.php'; // Ensure you have included Stripe's PHP library 

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $bookingModel = new BookingModel($databaseModel);
    $voucherModel = new VoucherModel($databaseModel);

    if (isset($_GET['session_id']) && !empty($_GET['session_id']) && isset($_GET['booking_id']) && !empty($_GET['booking_id'])) {
        $sessionID = $_GET['session_id'];
        $bookingID = $securityModel->decryptData($_GET['booking_id']);

        try {
            \Stripe\Stripe::setApiKey(STRIPE_API_KEY);
            $checkout_session = \Stripe\Checkout\Session::retrieve($sessionID);
            $payment_intent = \Stripe\PaymentIntent::retrieve($checkout_session->payment_intent);

            if ($payment_intent->status === 'succeeded') {
                $paymentReferenceNumber = $payment_intent->id;
                $paymentAmount = $payment_intent->amount / 100; // Convert from cents to dollars (or the equivalent for your currency)
                
                // Update the booking status with the payment amount
                $bookingModel->updateBookingPaymentStatus($bookingID, 'Paid', $paymentAmount, date('Y-m-d H:i:s'), $paymentReferenceNumber, '', '', '1');
                
                // Redirect upon successful payment
                header('Location:http://localhost/digify2/althabitah.php?page=booking');
                exit;
            }
        } catch (Exception $e) {
            echo 'Error: ' . $e->getMessage();
        }
    }
    
?>