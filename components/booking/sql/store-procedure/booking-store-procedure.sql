DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkBookingExist(IN p_booking_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM booking
    WHERE booking_id = p_booking_id;
END //

CREATE PROCEDURE checkBookingPersonnelViaEmployeeIDExist(IN p_booking_id INT, IN p_employee_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM booking_personnel
    WHERE booking_id = p_booking_id AND employee_id = p_employee_id;
END //

CREATE PROCEDURE checkBookingPersonnelAvailability(IN p_booking_id INT, IN p_employee_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM booking_personnel bp
    JOIN booking b ON bp.booking_id = b.booking_id
    WHERE bp.job_start_date IS NOT NULL
    AND bp.job_end_date IS NULL
    AND b.booking_status != 'Cancelled'
    AND bp.booking_id != p_booking_id
    AND bp.employee_id = p_employee_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertBooking(IN p_booking_reference_number VARCHAR(100), IN p_source_of_booking VARCHAR(50), IN p_service VARCHAR(100), IN p_frequency VARCHAR(50), IN p_duration INT, IN p_number_of_seats INT, IN p_meters INT, IN p_cleaning_materials VARCHAR(10), IN p_booking_date DATE, IN p_booking_time VARCHAR(20), IN p_number_of_professionals INT, IN p_number_of_hours INT, IN p_nationality VARCHAR(50), IN p_first_name VARCHAR(500), IN p_last_name VARCHAR(500), IN p_address LONGTEXT, IN p_phone VARCHAR(50), IN p_email_address VARCHAR(500), IN p_special_instructions LONGTEXT, IN p_mode_of_payment VARCHAR(50), IN p_discount_code VARCHAR(50), IN p_discount_type VARCHAR(20), IN p_discount_amount DOUBLE, IN p_total_discount_amount DOUBLE, IN p_booking_subtotal_amount DOUBLE, IN p_total_booking_amount DOUBLE, IN p_cancellation_window DATETIME, IN p_last_log_by INT, OUT p_booking_id INT)
BEGIN
    INSERT INTO booking (booking_reference_number, source_of_booking, service, frequency, duration, number_of_seats, meters, cleaning_materials, booking_date, booking_time, number_of_professionals, number_of_hours, nationality, first_name, last_name, address, phone, email_address, special_instructions, mode_of_payment, discount_code, discount_type, discount_amount, total_discount_amount, booking_subtotal_amount, total_booking_amount, cancellation_window, last_log_by) 
	VALUES(p_booking_reference_number, p_source_of_booking, p_service, p_frequency, p_duration, p_number_of_seats, p_meters, p_cleaning_materials, p_booking_date, p_booking_time, p_number_of_professionals, p_number_of_hours, p_nationality, p_first_name, p_last_name, p_address, p_phone, p_email_address, p_special_instructions, p_mode_of_payment, p_discount_code, p_discount_type, p_discount_amount, p_total_discount_amount, p_booking_subtotal_amount, p_total_booking_amount, p_cancellation_window, p_last_log_by);

    SET p_booking_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertBookingPersonnel(IN p_booking_id INT, IN p_employee_id INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO booking_personnel (booking_id, employee_id, last_log_by) 
	VALUES(p_booking_id, p_employee_id, p_last_log_by);
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
    ELSEIF p_booking_status = 'Rejected' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            booking_for_cancellation_rejection_date = NOW(),
            booking_for_cancellation_rejection_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;

        UPDATE booking
        SET booking_status = 'Pending',
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

CREATE PROCEDURE updateBookingPaymentStatus(IN p_booking_id INT, IN p_payment_status VARCHAR(100), IN p_payment_amount DOUBLE, IN p_payment_date DATETIME, IN p_payment_reference_number VARCHAR(500), IN p_refund_amount DOUBLE, IN p_remarks LONGTEXT, IN p_last_log_by INT)
BEGIN    
    IF p_payment_status = 'Paid' THEN
        UPDATE booking
        SET payment_status = p_payment_status,
            payment_amount = p_payment_amount,
            payment_date = p_payment_date,
            payment_reference_number = p_payment_reference_number,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_payment_status = 'For Refund' THEN
        UPDATE booking
        SET payment_status = p_payment_status,
            refund_amount = p_refund_amount,
            for_refund_date = NOW(),
            for_refund_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_payment_status = 'Rejected' THEN
        UPDATE booking
        SET payment_status = p_payment_status,
            for_refund_rejection_date = NOW(),
            for_refund_rejection_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;

        UPDATE booking
        SET payment_status = 'Paid',
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

CREATE PROCEDURE updateBookingPersonnelJobTime(IN p_booking_personnel_id INT, IN p_job_type VARCHAR(20), IN p_last_log_by INT)
BEGIN    
    IF p_job_type = 'Start' THEN
        UPDATE booking_personnel
        SET job_start_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_personnel_id = p_booking_personnel_id;
    ELSE
        UPDATE booking_personnel
        SET job_end_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_personnel_id = p_booking_personnel_id;
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteBooking(IN p_booking_id INT)
BEGIN
    DELETE FROM booking_personnel WHERE booking_id = p_booking_id;
    DELETE FROM booking WHERE booking_id = p_booking_id;
END //

CREATE PROCEDURE deleteBookingPersonnel(IN p_booking_personnel_id INT)
BEGIN
    DELETE FROM booking_personnel WHERE booking_personnel_id = p_booking_personnel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getBooking(IN p_booking_id INT)
BEGIN
	SELECT * FROM booking
	WHERE booking_id = p_booking_id;
END //

CREATE PROCEDURE getBookingPersonnel(IN p_booking_personnel_id INT)
BEGIN
	SELECT * FROM booking_personnel
	WHERE booking_personnel_id = p_booking_personnel_id;
END //

CREATE PROCEDURE getBookingPersonnelViaEmployeeID(IN p_booking_id INT, IN p_employee_id INT)
BEGIN
	SELECT * FROM booking_personnel
	WHERE booking_id = p_booking_id AND employee_id = p_employee_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateBookingTable(IN p_service VARCHAR(100), IN p_booking_status VARCHAR(100), IN p_payment_status VARCHAR(100), IN p_mode_of_payment VARCHAR(500), IN p_source_of_booking VARCHAR(50), IN p_booking_start_date DATE, IN p_booking_end_date DATE, IN p_payment_start_date DATE, IN p_payment_end_date DATE, IN p_transaction_start_date DATE, IN p_transaction_end_date DATE)
BEGIN
     DECLARE query VARCHAR(5000);
    DECLARE conditionList VARCHAR(1000);

    SET query = 'SELECT * FROM booking';
    SET conditionList = ' WHERE 1';

    IF p_service IS NOT NULL AND p_service <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND service = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_service));
    END IF;

    IF p_booking_status IS NOT NULL AND p_booking_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND booking_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_status));
    END IF;

    IF p_payment_status IS NOT NULL AND p_payment_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND payment_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_status));
    END IF;

    IF p_mode_of_payment IS NOT NULL AND p_mode_of_payment <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND mode_of_payment = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_mode_of_payment));
    END IF;

    IF p_source_of_booking IS NOT NULL AND p_source_of_booking <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND source_of_booking = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_source_of_booking));
    END IF;
    
    IF p_booking_start_date IS NOT NULL AND p_booking_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (booking_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_payment_start_date IS NOT NULL AND p_payment_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (payment_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_transaction_start_date IS NOT NULL AND p_transaction_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (transaction_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;

    SET query = CONCAT(query, conditionList);
    SET query = CONCAT(query, ' ORDER BY booking_date DESC;');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateBookingCancellationTable(IN p_service VARCHAR(100), IN p_payment_status VARCHAR(100), IN p_mode_of_payment VARCHAR(500), IN p_source_of_booking VARCHAR(50), IN p_booking_start_date DATE, IN p_booking_end_date DATE, IN p_payment_start_date DATE, IN p_payment_end_date DATE, IN p_transaction_start_date DATE, IN p_transaction_end_date DATE)
BEGIN
     DECLARE query VARCHAR(5000);
    DECLARE conditionList VARCHAR(1000);

    SET query = 'SELECT * FROM booking';
    SET conditionList = ' WHERE booking_status = "For Cancellation"';

    IF p_service IS NOT NULL AND p_service <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND service = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_service));
    END IF;

    IF p_payment_status IS NOT NULL AND p_payment_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND payment_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_status));
    END IF;

    IF p_mode_of_payment IS NOT NULL AND p_mode_of_payment <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND mode_of_payment = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_mode_of_payment));
    END IF;

    IF p_source_of_booking IS NOT NULL AND p_source_of_booking <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND source_of_booking = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_source_of_booking));
    END IF;
    
    IF p_booking_start_date IS NOT NULL AND p_booking_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (booking_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_payment_start_date IS NOT NULL AND p_payment_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (payment_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_transaction_start_date IS NOT NULL AND p_transaction_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (transaction_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;

    SET query = CONCAT(query, conditionList);
    SET query = CONCAT(query, ' ORDER BY booking_date DESC;');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateBookingRefundTable(IN p_service VARCHAR(100), IN p_booking_status VARCHAR(100), IN p_mode_of_payment VARCHAR(500), IN p_source_of_booking VARCHAR(50), IN p_booking_start_date DATE, IN p_booking_end_date DATE, IN p_payment_start_date DATE, IN p_payment_end_date DATE, IN p_transaction_start_date DATE, IN p_transaction_end_date DATE)
BEGIN
     DECLARE query VARCHAR(5000);
    DECLARE conditionList VARCHAR(1000);

    SET query = 'SELECT * FROM booking';
    SET conditionList = ' WHERE payment_status = "For Refund"';

    IF p_service IS NOT NULL AND p_service <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND service = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_service));
    END IF;

    IF p_booking_status IS NOT NULL AND p_booking_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND booking_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_status));
    END IF;

    IF p_mode_of_payment IS NOT NULL AND p_mode_of_payment <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND mode_of_payment = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_mode_of_payment));
    END IF;

    IF p_source_of_booking IS NOT NULL AND p_source_of_booking <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND source_of_booking = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_source_of_booking));
    END IF;
    
    IF p_booking_start_date IS NOT NULL AND p_booking_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (booking_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_payment_start_date IS NOT NULL AND p_payment_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (payment_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_transaction_start_date IS NOT NULL AND p_transaction_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (transaction_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;

    SET query = CONCAT(query, conditionList);
    SET query = CONCAT(query, ' ORDER BY booking_date DESC;');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateBookingPersonnelList(IN p_booking_id INT)
BEGIN
    SELECT * FROM booking_personnel WHERE booking_id = p_booking_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */