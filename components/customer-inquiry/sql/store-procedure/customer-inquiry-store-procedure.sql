DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCustomerInquiryExist(IN p_customer_inquiry_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer_inquiry
    WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCustomerInquiry(IN p_customer_name VARCHAR(500), IN p_email VARCHAR(500), IN p_phone VARCHAR(50), IN p_subject VARCHAR(500), IN p_message LONGTEXT, IN p_last_log_by INT, OUT p_customer_inquiry_id INT)
BEGIN
    INSERT INTO customer_inquiry (customer_name, email, phone, subject, message, last_log_by) 
	VALUES(p_customer_name, p_email, p_phone, p_subject, p_message, p_last_log_by);

     SET p_customer_inquiry_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCustomerInquiry(IN p_customer_inquiry_id INT, IN p_customer_name VARCHAR(500), IN p_email VARCHAR(500), IN p_phone VARCHAR(50), IN p_subject VARCHAR(500), IN p_message LONGTEXT, IN p_last_log_by INT)
BEGIN
    UPDATE customer_inquiry
    SET customer_name = p_customer_name,
        email = p_email,
        phone = p_phone,
        subject = p_subject,
        message = p_message,
        last_log_by = p_last_log_by
    WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

CREATE PROCEDURE updateCustomerInquiryStatus(IN p_customer_inquiry_id INT, IN p_inquiry_status VARCHAR(50), IN p_last_log_by INT)
BEGIN    
    IF p_inquiry_status = 'In-Progress' THEN
        UPDATE customer_inquiry
        SET inquiry_status = p_inquiry_status,
            in_progress_date = NOW(),
            in_progress_by = p_last_log_by,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_id = p_customer_inquiry_id;
    ELSEIF p_inquiry_status = 'Resolved' THEN
        UPDATE customer_inquiry
        SET inquiry_status = p_inquiry_status,
            resolved_date = NOW(),
            resolved_by = p_last_log_by,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_id = p_customer_inquiry_id;
    ELSE
        UPDATE customer_inquiry
        SET inquiry_status = p_inquiry_status,
            closed_date = NOW(),
            closed_by = p_last_log_by,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_id = p_customer_inquiry_id;
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCustomerInquiry(IN p_customer_inquiry_id INT)
BEGIN
    DELETE FROM customer_inquiry WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCustomerInquiry(IN p_customer_inquiry_id INT)
BEGIN
	SELECT * FROM customer_inquiry
	WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCustomerInquiryTable()
BEGIN
    SELECT customer_inquiry_id, customer_name, email, phone, subject, message, inquiry_status, created_date
    FROM customer_inquiry;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */