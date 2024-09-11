DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkBookingExist(IN p_booking_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM booking
    WHERE booking_id = p_booking_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertBooking(IN p_booking_reference_number VARCHAR(100), IN p_source_of_booking VARCHAR(50), IN p_service VARCHAR(100), IN p_frequency VARCHAR(50), IN p_duration INT, IN p_number_of_seats INT, IN p_meters INT, IN p_cleaning_materials VARCHAR(10), IN p_booking_date DATE, IN p_booking_time VARCHAR(20), IN p_number_of_professionals INT, IN p_number_of_hours INT, IN p_nationality VARCHAR(50), IN p_first_name VARCHAR(500), IN p_last_name VARCHAR(500), IN p_address LONGTEXT, IN p_phone VARCHAR(50), IN p_email_address VARCHAR(500), IN p_special_instructions LONGTEXT, IN p_mode_of_payment VARCHAR(50), IN p_discount_code VARCHAR(50), IN p_discount_type VARCHAR(20), IN p_discount_amount DOUBLE, IN p_total_discount_amount DOUBLE, IN p_booking_subtotal_amount DOUBLE, IN p_total_booking_amount DOUBLE, IN p_cancellation_window DATETIME, IN p_last_log_by INT, OUT p_booking_id INT)
BEGIN
    INSERT INTO booking (booking_reference_number, source_of_booking, service, frequency, duration, number_of_seats, meters, cleaning_materials, booking_date, booking_time, number_of_professionals, number_of_hours, nationality, first_name, last_name, address, phone, email_address, special_instructions, mode_of_payment, discount_code, discount_type, discount_amount, total_discount_amount, booking_subtotal_amount, total_booking_amount, cancellation_window, last_log_by) 
	VALUES(p_booking_reference_number, p_source_of_booking, p_service, p_frequency, p_duration, p_number_of_seats, p_meters, p_cleaning_materials, p_booking_date, p_booking_time, p_number_of_professionals, p_number_of_hours, p_nationality, p_first_name, p_last_name, p_address, p_phone, p_email_address, p_special_instructions, p_mode_of_payment, p_discount_code, p_discount_type, p_discount_amount, p_total_discount_amount, p_booking_subtotal_amount, p_total_booking_amount, p_cancellation_window, p_last_log_by);

    SET p_booking_id = LAST_INSERT_ID();
END //
/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateBooking(IN p_booking_id INT, IN p_source_of_booking VARCHAR(50), IN p_service VARCHAR(100), IN p_frequency VARCHAR(50), IN p_duration INT, IN p_number_of_seats INT, IN p_meters INT, IN p_cleaning_materials VARCHAR(10), IN p_booking_date DATE, IN p_booking_time VARCHAR(20), IN p_number_of_professionals INT, IN p_number_of_hours INT, IN p_nationality VARCHAR(50), IN p_first_name VARCHAR(500), IN p_last_name VARCHAR(500), IN p_address LONGTEXT, IN p_phone VARCHAR(50), IN p_email_address VARCHAR(500), IN p_special_instructions LONGTEXT, IN p_mode_of_payment VARCHAR(50), IN p_discount_code VARCHAR(50), IN p_discount_type VARCHAR(20), IN p_discount_amount DOUBLE, IN p_total_discount_amount DOUBLE, IN p_booking_subtotal_amount DOUBLE, IN p_total_booking_amount DOUBLE, IN p_last_log_by INT)
BEGIN
    UPDATE booking
    SET source_of_booking = p_source_of_booking,
        service = p_service,
        frequency = p_frequency,
        duration = p_duration,
        number_of_seats = p_number_of_seats,
        meters = p_meters, 
        cleaning_materials = p_cleaning_materials, 
        booking_date = p_booking_date, 
        booking_time = p_booking_time, 
        number_of_professionals = p_number_of_professionals, 
        number_of_hours = p_number_of_hours, 
        nationality = p_nationality, 
        first_name = p_first_name, 
        last_name = p_last_name, 
        address = p_address, 
        phone = p_phone, 
        email_address = p_email_address, 
        special_instructions = p_special_instructions, 
        mode_of_payment = p_mode_of_payment, 
        discount_code = p_discount_code, 
        discount_type = p_discount_type, 
        discount_amount = p_discount_amount, 
        total_discount_amount = p_total_discount_amount, 
        booking_subtotal_amount = p_booking_subtotal_amount, 
        total_booking_amount = p_total_booking_amount,
        last_log_by = p_last_log_by
    WHERE booking_id = p_booking_id;
END //

CREATE PROCEDURE updateBookingStatus(IN p_booking_id INT, IN p_booking_status VARCHAR(100), IN p_remarks LONGTEXT, IN p_last_log_by INT)
BEGIN    
    IF p_booking_status = 'In-Progress' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            in_progress_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_booking_status = 'Completed' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            completed_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_booking_status = 'For Cancellation' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            cancellation_request_date = NOW(),
            cancellation_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSE
        UPDATE booking
        SET booking_status = p_booking_status,
            cancellation_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    END IF;
END //

CREATE PROCEDURE updateBookingPaymentStatus(IN p_booking_id INT, IN p_payment_status VARCHAR(100), IN p_payment_reference_number VARCHAR(500), IN p_last_log_by INT)
BEGIN    
    IF p_payment_status = 'Paid' THEN
        UPDATE booking
        SET payment_status = p_payment_status,
            payment_date = NOW(),
            payment_reference_number = p_payment_reference_number,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSE
        UPDATE booking
        SET payment_status = p_payment_status,
            refund_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteBooking(IN p_booking_id INT)
BEGIN
    DELETE FROM booking WHERE booking_id = p_booking_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getBooking(IN p_booking_id INT)
BEGIN
	SELECT * FROM booking
	WHERE booking_id = p_booking_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateBookingTable(IN p_service LONGTEXT, IN p_frequency VARCHAR(500), IN p_cleaning_materials VARCHAR(10), IN p_nationality VARCHAR(500), IN p_booking_status VARCHAR(500), IN p_payment_status VARCHAR(500), IN p_mode_of_payment VARCHAR(500), IN p_booking_start_date DATE, IN p_booking_end_date DATE, IN p_payment_start_date DATE, IN p_payment_end_date DATE, IN p_refund_start_date DATE, IN p_refund_end_date DATE, IN p_in_progress_start_date DATE, IN p_in_progress_end_date DATE, IN p_completed_start_date DATE, IN p_completed_end_date DATE, IN p_cancellation_start_date DATE, IN p_cancellation_end_date DATE, IN p_transaction_start_date DATE, IN p_transaction_end_date DATE)
BEGIN
    
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */