<?php
/**
* Class BookingModel
*
* The BookingModel class handles booking related operations and interactions.
*/
class BookingModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBooking
    # Description: Updates the booking.
    #
    # Parameters:
    # - $p_booking_id (int): The booking ID.
    # - $p_source_of_booking (string): The source of booking.
    # - $p_service (string): The service.
    # - $p_frequency (string): The frequency of service.
    # - $p_duration (int): The duration of service.
    # - $p_number_of_seats (int): The number of seats.
    # - $p_meters (int): The meters.
    # - $p_cleaning_materials (string): The cleaning materials.
    # - $p_booking_date (date): The booking date.
    # - $p_booking_time (string): The booking time slot.
    # - $p_number_of_professionals (int): The number of professionals.
    # - $p_number_of_hours (int): The number of hours.
    # - $p_nationality (string): The nationality.
    # - $p_first_name (string): The first name of the customer.
    # - $p_last_name (string): The last name of the customer.
    # - $p_address (string): The address of the customer.
    # - $p_phone (string): The phone of the customer.
    # - $p_email_address (string): The email address of the customer.
    # - $p_special_instructions (string): The special instructions of the customer.
    # - $p_mode_of_payment (string): The mode of payment.
    # - $p_discount_code (string): The discount code used.
    # - $p_discount_type (string): The discount type used.
    # - $p_discount_amount (double): The discount amount.
    # - $p_total_discount_amount (double): The total discount amount.
    # - $p_booking_subtotal_amount (double): The booking subtotal amount.
    # - $p_total_booking_amount (double): The total booking amount.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBooking($p_booking_id, $p_source_of_booking, $p_service, $p_frequency, $p_duration, $p_number_of_seats, $p_meters, $p_cleaning_materials, $p_booking_date, $p_booking_time, $p_number_of_professionals, $p_number_of_hours, $p_nationality, $p_first_name, $p_last_name, $p_address, $p_phone, $p_email_address, $p_special_instructions, $p_mode_of_payment, $p_discount_code, $p_discount_type, $p_discount_amount, $p_total_discount_amount, $p_booking_subtotal_amount, $p_total_booking_amount, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBooking(:p_booking_id, :p_source_of_booking, :p_service, :p_frequency, :p_duration, :p_number_of_seats, :p_meters, :p_cleaning_materials, :p_booking_date, :p_booking_time, :p_number_of_professionals, :p_number_of_hours, :p_nationality, :p_first_name, :p_last_name, :p_address, :p_phone, :p_email_address, :p_special_instructions, :p_mode_of_payment, :p_discount_code, :p_discount_type, :p_discount_amount, :p_total_discount_amount, :p_booking_subtotal_amount, :p_total_booking_amount, :p_last_log_by)');
        $stmt->bindValue(':p_booking_id', $p_booking_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_source_of_booking', $p_source_of_booking, PDO::PARAM_STR);
        $stmt->bindValue(':p_service', $p_service, PDO::PARAM_STR);
        $stmt->bindValue(':p_frequency', $p_frequency, PDO::PARAM_STR);
        $stmt->bindValue(':p_duration', $p_duration, PDO::PARAM_INT);
        $stmt->bindValue(':p_number_of_seats', $p_number_of_seats, PDO::PARAM_INT);
        $stmt->bindValue(':p_meters', $p_meters, PDO::PARAM_INT);
        $stmt->bindValue(':p_cleaning_materials', $p_cleaning_materials, PDO::PARAM_STR);
        $stmt->bindValue(':p_booking_date', $p_booking_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_booking_time', $p_booking_time, PDO::PARAM_STR);
        $stmt->bindValue(':p_number_of_professionals', $p_number_of_professionals, PDO::PARAM_INT);
        $stmt->bindValue(':p_number_of_hours', $p_number_of_hours, PDO::PARAM_INT);
        $stmt->bindValue(':p_nationality', $p_nationality, PDO::PARAM_STR);
        $stmt->bindValue(':p_first_name', $p_first_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_name', $p_last_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_email_address', $p_email_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_special_instructions', $p_special_instructions, PDO::PARAM_STR);
        $stmt->bindValue(':p_mode_of_payment', $p_mode_of_payment, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_code', $p_discount_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_type', $p_discount_type, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_amount', $p_discount_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_total_discount_amount', $p_total_discount_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_booking_subtotal_amount', $p_booking_subtotal_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_total_booking_amount', $p_total_booking_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBookingStatus
    # Description: Updates the booking status.
    #
    # Parameters:
    # - $p_booking_id (int): The booking ID.
    # - $p_booking_status (string): The booking status.
    # - $p_remarks (string): The remarks.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBookingStatus($p_booking_id, $p_booking_status, $p_remarks, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBookingStatus(:p_booking_id, :p_booking_status, :p_remarks, :p_last_log_by)');
        $stmt->bindValue(':p_booking_id', $p_booking_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_booking_status', $p_booking_status, PDO::PARAM_STR);
        $stmt->bindValue(':p_remarks', $p_remarks, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBookingPaymentStatus
    # Description: Updates the booking status.
    #
    # Parameters:
    # - $p_booking_id (int): The booking ID.
    # - $p_payment_status (string): The payment status.
    # - $p_payment_reference_number (string): The payment reference number.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBookingPaymentStatus($p_booking_id, $p_payment_status, $p_payment_reference_number, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBookingPaymentStatus(:p_booking_id, :p_payment_status, :p_payment_reference_number, :p_last_log_by)');
        $stmt->bindValue(':p_booking_id', $p_booking_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_payment_status', $p_payment_status, PDO::PARAM_STR);
        $stmt->bindValue(':p_payment_reference_number', $p_payment_reference_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBooking
    # Description: Inserts the booking.
    #
    # Parameters:
    # - $p_booking_reference_number (string): The booking reference number.
    # - $p_source_of_booking (string): The source of booking.
    # - $p_service (string): The service.
    # - $p_frequency (string): The frequency of service.
    # - $p_duration (int): The duration of service.
    # - $p_number_of_seats (int): The number of seats.
    # - $p_meters (int): The meters.
    # - $p_cleaning_materials (string): The cleaning materials.
    # - $p_booking_date (date): The booking date.
    # - $p_booking_time (string): The booking time slot.
    # - $p_number_of_professionals (int): The number of professionals.
    # - $p_number_of_hours (int): The number of hours.
    # - $p_nationality (string): The nationality.
    # - $p_first_name (string): The first name of the customer.
    # - $p_last_name (string): The last name of the customer.
    # - $p_address (string): The address of the customer.
    # - $p_phone (string): The phone of the customer.
    # - $p_email_address (string): The email address of the customer.
    # - $p_special_instructions (string): The special instructions of the customer.
    # - $p_mode_of_payment (string): The mode of payment.
    # - $p_discount_code (string): The discount code used.
    # - $p_discount_type (string): The discount type used.
    # - $p_discount_amount (double): The discount amount.
    # - $p_total_discount_amount (double): The total discount amount.
    # - $p_booking_subtotal_amount (double): The booking subtotal amount.
    # - $p_total_booking_amount (double): The total booking amount.
    # - $p_cancellation_window (datetime): The cancellation window.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertBooking($p_booking_reference_number, $p_source_of_booking, $p_service, $p_frequency, $p_duration, $p_number_of_seats, $p_meters, $p_cleaning_materials, $p_booking_date, $p_booking_time, $p_number_of_professionals, $p_number_of_hours, $p_nationality, $p_first_name, $p_last_name, $p_address, $p_phone, $p_email_address, $p_special_instructions, $p_mode_of_payment, $p_discount_code, $p_discount_type, $p_discount_amount, $p_total_discount_amount, $p_booking_subtotal_amount, $p_total_booking_amount, $p_cancellation_window, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBooking(:p_booking_reference_number, :p_source_of_booking, :p_service, :p_frequency, :p_duration, :p_number_of_seats, :p_meters, :p_cleaning_materials, :p_booking_date, :p_booking_time, :p_number_of_professionals, :p_number_of_hours, :p_nationality, :p_first_name, :p_last_name, :p_address, :p_phone, :p_email_address, :p_special_instructions, :p_mode_of_payment, :p_discount_code, :p_discount_type, :p_discount_amount, :p_total_discount_amount, :p_booking_subtotal_amount, :p_total_booking_amount, :p_cancellation_window, :p_last_log_by, @p_booking_id)');
        $stmt->bindValue(':p_booking_reference_number', $p_booking_reference_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_source_of_booking', $p_source_of_booking, PDO::PARAM_STR);
        $stmt->bindValue(':p_service', $p_service, PDO::PARAM_STR);
        $stmt->bindValue(':p_frequency', $p_frequency, PDO::PARAM_STR);
        $stmt->bindValue(':p_duration', $p_duration, PDO::PARAM_INT);
        $stmt->bindValue(':p_number_of_seats', $p_number_of_seats, PDO::PARAM_INT);
        $stmt->bindValue(':p_meters', $p_meters, PDO::PARAM_INT);
        $stmt->bindValue(':p_cleaning_materials', $p_cleaning_materials, PDO::PARAM_STR);
        $stmt->bindValue(':p_booking_date', $p_booking_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_booking_time', $p_booking_time, PDO::PARAM_STR);
        $stmt->bindValue(':p_number_of_professionals', $p_number_of_professionals, PDO::PARAM_INT);
        $stmt->bindValue(':p_number_of_hours', $p_number_of_hours, PDO::PARAM_INT);
        $stmt->bindValue(':p_nationality', $p_nationality, PDO::PARAM_STR);
        $stmt->bindValue(':p_first_name', $p_first_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_name', $p_last_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_email_address', $p_email_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_special_instructions', $p_special_instructions, PDO::PARAM_STR);
        $stmt->bindValue(':p_mode_of_payment', $p_mode_of_payment, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_code', $p_discount_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_type', $p_discount_type, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_amount', $p_discount_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_total_discount_amount', $p_total_discount_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_booking_subtotal_amount', $p_booking_subtotal_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_total_booking_amount', $p_total_booking_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_cancellation_window', $p_cancellation_window, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();

        $result = $this->db->getConnection()->query('SELECT @p_booking_id AS booking_id');
        $bookingID = $result->fetch(PDO::FETCH_ASSOC)['booking_id'];
        
        return $bookingID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBookingExist
    # Description: Checks if a booking exists.
    #
    # Parameters:
    # - $p_booking_id (int): The booking ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBookingExist($p_booking_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBookingExist(:p_booking_id)');
        $stmt->bindValue(':p_booking_id', $p_booking_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteBooking
    # Description: Deletes the booking.
    #
    # Parameters:
    # - $p_booking_id (int): The booking ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteBooking($p_booking_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteBooking(:p_booking_id)');
        $stmt->bindValue(':p_booking_id', $p_booking_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBooking
    # Description: Retrieves the details of a booking.
    #
    # Parameters:
    # - $p_booking_id (int): The booking ID.
    #
    # Returns:
    # - An array containing the booking details.
    #
    # -------------------------------------------------------------
    public function getBooking($p_booking_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBooking(:p_booking_id)');
        $stmt->bindValue(':p_booking_id', $p_booking_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>