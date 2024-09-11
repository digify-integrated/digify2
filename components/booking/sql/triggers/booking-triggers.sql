DELIMITER //

CREATE TRIGGER booking_trigger_update
AFTER UPDATE ON booking
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.source_of_booking <> OLD.source_of_booking THEN
        SET audit_log = CONCAT(audit_log, "Source of Booking: ", OLD.source_of_booking, " -> ", NEW.source_of_booking, "<br/>");
    END IF;

    IF NEW.service <> OLD.service THEN
        SET audit_log = CONCAT(audit_log, "Service: ", OLD.service, " -> ", NEW.service, "<br/>");
    END IF;

    IF NEW.frequency <> OLD.frequency THEN
        SET audit_log = CONCAT(audit_log, "Frequency: ", OLD.frequency, " -> ", NEW.frequency, "<br/>");
    END IF;

    IF NEW.duration <> OLD.duration THEN
        SET audit_log = CONCAT(audit_log, "Duration: ", OLD.duration, " -> ", NEW.duration, "<br/>");
    END IF;

    IF NEW.number_of_seats <> OLD.number_of_seats THEN
        SET audit_log = CONCAT(audit_log, "Number of Seats: ", OLD.number_of_seats, " -> ", NEW.number_of_seats, "<br/>");
    END IF;

    IF NEW.meters <> OLD.meters THEN
        SET audit_log = CONCAT(audit_log, "Meters: ", OLD.meters, " -> ", NEW.meters, "<br/>");
    END IF;

    IF NEW.cleaning_materials <> OLD.cleaning_materials THEN
        SET audit_log = CONCAT(audit_log, "Cleaning Materials: ", OLD.cleaning_materials, " -> ", NEW.cleaning_materials, "<br/>");
    END IF;

    IF NEW.booking_date <> OLD.booking_date THEN
        SET audit_log = CONCAT(audit_log, "Booking Date: ", OLD.booking_date, " -> ", NEW.booking_date, "<br/>");
    END IF;

    IF NEW.booking_time <> OLD.booking_time THEN
        SET audit_log = CONCAT(audit_log, "Booking Time: ", OLD.booking_time, " -> ", NEW.booking_time, "<br/>");
    END IF;

    IF NEW.number_of_professionals <> OLD.number_of_professionals THEN
        SET audit_log = CONCAT(audit_log, "Number of Professionals: ", OLD.number_of_professionals, " -> ", NEW.number_of_professionals, "<br/>");
    END IF;

    IF NEW.number_of_hours <> OLD.number_of_hours THEN
        SET audit_log = CONCAT(audit_log, "Number of Hours: ", OLD.number_of_hours, " -> ", NEW.number_of_hours, "<br/>");
    END IF;

    IF NEW.nationality <> OLD.nationality THEN
        SET audit_log = CONCAT(audit_log, "Nationality: ", OLD.nationality, " -> ", NEW.nationality, "<br/>");
    END IF;

    IF NEW.first_name <> OLD.first_name THEN
        SET audit_log = CONCAT(audit_log, "First Name: ", OLD.first_name, " -> ", NEW.first_name, "<br/>");
    END IF;

    IF NEW.last_name <> OLD.last_name THEN
        SET audit_log = CONCAT(audit_log, "Last Name: ", OLD.last_name, " -> ", NEW.last_name, "<br/>");
    END IF;

    IF NEW.address <> OLD.address THEN
        SET audit_log = CONCAT(audit_log, "Address: ", OLD.address, " -> ", NEW.address, "<br/>");
    END IF;

    IF NEW.phone <> OLD.phone THEN
        SET audit_log = CONCAT(audit_log, "Phone: ", OLD.phone, " -> ", NEW.phone, "<br/>");
    END IF;

    IF NEW.email_address <> OLD.email_address THEN
        SET audit_log = CONCAT(audit_log, "Email Address: ", OLD.email_address, " -> ", NEW.email_address, "<br/>");
    END IF;

    IF NEW.special_instructions <> OLD.special_instructions THEN
        SET audit_log = CONCAT(audit_log, "Special Instructions: ", OLD.special_instructions, " -> ", NEW.special_instructions, "<br/>");
    END IF;

    IF NEW.mode_of_payment <> OLD.mode_of_payment THEN
        SET audit_log = CONCAT(audit_log, "Mode of Payment: ", OLD.mode_of_payment, " -> ", NEW.mode_of_payment, "<br/>");
    END IF;

    IF NEW.discount_code <> OLD.discount_code THEN
        SET audit_log = CONCAT(audit_log, "Discount Code: ", OLD.discount_code, " -> ", NEW.discount_code, "<br/>");
    END IF;

    IF NEW.discount_type <> OLD.discount_type THEN
        SET audit_log = CONCAT(audit_log, "Discount Type: ", OLD.discount_type, " -> ", NEW.discount_type, "<br/>");
    END IF;

    IF NEW.discount_amount <> OLD.discount_amount THEN
        SET audit_log = CONCAT(audit_log, "Discount Amount: ", OLD.discount_amount, " -> ", NEW.discount_amount, "<br/>");
    END IF;

    IF NEW.total_discount_amount <> OLD.total_discount_amount THEN
        SET audit_log = CONCAT(audit_log, "Total Discount Amount: ", OLD.total_discount_amount, " -> ", NEW.total_discount_amount, "<br/>");
    END IF;

    IF NEW.booking_subtotal_amount <> OLD.booking_subtotal_amount THEN
        SET audit_log = CONCAT(audit_log, "Booking Subtotal Amount: ", OLD.booking_subtotal_amount, " -> ", NEW.booking_subtotal_amount, "<br/>");
    END IF;

    IF NEW.total_booking_amount <> OLD.total_booking_amount THEN
        SET audit_log = CONCAT(audit_log, "Total Booking Amount: ", OLD.total_booking_amount, " -> ", NEW.total_booking_amount, "<br/>");
    END IF;

    IF NEW.refund_amount <> OLD.refund_amount THEN
        SET audit_log = CONCAT(audit_log, "Refund Amount: ", OLD.refund_amount, " -> ", NEW.refund_amount, "<br/>");
    END IF;

    IF NEW.payment_status <> OLD.payment_status THEN
        SET audit_log = CONCAT(audit_log, "Payment Status: ", OLD.payment_status, " -> ", NEW.payment_status, "<br/>");
    END IF;

    IF NEW.booking_status <> OLD.booking_status THEN
        SET audit_log = CONCAT(audit_log, "Booking Status: ", OLD.booking_status, " -> ", NEW.booking_status, "<br/>");
    END IF;

    IF NEW.cancellation_request_date <> OLD.cancellation_request_date THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Request Date: ", OLD.cancellation_request_date, " -> ", NEW.cancellation_request_date, "<br/>");
    END IF;

    IF NEW.cancellation_window <> OLD.cancellation_window THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Window: ", OLD.cancellation_window, " -> ", NEW.cancellation_window, "<br/>");
    END IF;

    IF NEW.cancellation_reason <> OLD.cancellation_reason THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Reason: ", OLD.cancellation_reason, " -> ", NEW.cancellation_reason, "<br/>");
    END IF;

    IF NEW.payment_reference_number <> OLD.payment_reference_number THEN
        SET audit_log = CONCAT(audit_log, "Payment Reference Number: ", OLD.payment_reference_number, " -> ", NEW.payment_reference_number, "<br/>");
    END IF;

    IF NEW.payment_date <> OLD.payment_date THEN
        SET audit_log = CONCAT(audit_log, "Payment Date: ", OLD.payment_date, " -> ", NEW.payment_date, "<br/>");
    END IF;

    IF NEW.refund_date <> OLD.refund_date THEN
        SET audit_log = CONCAT(audit_log, "Refund Date: ", OLD.refund_date, " -> ", NEW.refund_date, "<br/>");
    END IF;

    IF NEW.refund_reason <> OLD.refund_reason THEN
        SET audit_log = CONCAT(audit_log, "Refund Reason: ", OLD.refund_reason, " -> ", NEW.refund_reason, "<br/>");
    END IF;

    IF NEW.in_progress_date <> OLD.in_progress_date THEN
        SET audit_log = CONCAT(audit_log, "In-Progress Date: ", OLD.in_progress_date, " -> ", NEW.in_progress_date, "<br/>");
    END IF;

    IF NEW.completed_date <> OLD.completed_date THEN
        SET audit_log = CONCAT(audit_log, "Completed Date: ", OLD.completed_date, " -> ", NEW.completed_date, "<br/>");
    END IF;

    IF NEW.cancellation_date <> OLD.cancellation_date THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Date: ", OLD.cancellation_date, " -> ", NEW.cancellation_date, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('booking', NEW.booking_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER booking_trigger_insert
AFTER INSERT ON booking
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Booking created. <br/>';

    IF NEW.booking_reference_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Reference Number: ", NEW.booking_reference_number);
    END IF;

    IF NEW.source_of_booking <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Source of Booking: ", NEW.source_of_booking);
    END IF;

    IF NEW.service <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Service: ", NEW.service);
    END IF;

    IF NEW.frequency <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Frequency: ", NEW.frequency);
    END IF;

    IF NEW.duration <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Duration: ", NEW.duration);
    END IF;

    IF NEW.number_of_seats <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Number of Seats: ", NEW.number_of_seats);
    END IF;

    IF NEW.meters <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Meters: ", NEW.meters);
    END IF;

    IF NEW.cleaning_materials <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Cleaning Materials: ", NEW.cleaning_materials);
    END IF;

    IF NEW.booking_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Date: ", NEW.booking_date);
    END IF;

    IF NEW.booking_time <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Time: ", NEW.booking_time);
    END IF;

    IF NEW.number_of_professionals <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Number of Professionals: ", NEW.number_of_professionals);
    END IF;

    IF NEW.number_of_hours <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Number of Hours: ", NEW.number_of_hours);
    END IF;

    IF NEW.nationality <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Nationality: ", NEW.nationality);
    END IF;

    IF NEW.first_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>First Name: ", NEW.first_name);
    END IF;

    IF NEW.last_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Name: ", NEW.last_name);
    END IF;

    IF NEW.address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address: ", NEW.address);
    END IF;

    IF NEW.phone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Phone: ", NEW.phone);
    END IF;

    IF NEW.email_address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Address: ", NEW.email_address);
    END IF;

    IF NEW.special_instructions <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Special Instructions: ", NEW.special_instructions);
    END IF;

    IF NEW.mode_of_payment <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mode of Payment: ", NEW.mode_of_payment);
    END IF;

    IF NEW.discount_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Code: ", NEW.discount_code);
    END IF;

    IF NEW.discount_type <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Type: ", NEW.discount_type);
    END IF;

    IF NEW.discount_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Amount: ", NEW.discount_amount);
    END IF;

    IF NEW.total_discount_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Total Discount Amount: ", NEW.total_discount_amount);
    END IF;

    IF NEW.booking_subtotal_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Subtotal Amount: ", NEW.booking_subtotal_amount);
    END IF;

    IF NEW.total_booking_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Total Booking Amount: ", NEW.total_booking_amount);
    END IF;

    IF NEW.payment_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Payment Status: ", NEW.payment_status);
    END IF;

    IF NEW.booking_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Status: ", NEW.booking_status);
    END IF;

    IF NEW.cancellation_window <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Cancellation Window: ", NEW.cancellation_window);
    END IF;

    IF NEW.payment_reference_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Payment Reference Number: ", NEW.payment_reference_number);
    END IF;

    IF NEW.payment_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Payment Date: ", NEW.payment_date);
    END IF;

    IF NEW.transaction_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Transaction Date: ", NEW.transaction_date);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('booking', NEW.booking_id, audit_log, NEW.last_log_by, NOW());
END //