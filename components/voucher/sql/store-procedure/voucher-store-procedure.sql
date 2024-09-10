DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkVoucherExist(IN p_voucher_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM voucher
    WHERE voucher_id = p_voucher_id;
END //

CREATE PROCEDURE checkVoucherCodeExist(IN p_voucher_code VARCHAR(20))
BEGIN
	SELECT COUNT(*) AS total
    FROM voucher
    WHERE voucher_code = p_voucher_code;
END //

CREATE PROCEDURE checkVoucherCodeValidy(IN p_voucher_code VARCHAR(20))
BEGIN
	SELECT COUNT(*) AS total
    FROM voucher
    WHERE voucher_code = p_voucher_code AND voucher_usage_start_date <= NOW() AND voucher_usage_end_date >= NOW() AND available_voucher > 0;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertVoucher(IN p_voucher_name VARCHAR(100), IN p_voucher_code VARCHAR(20), IN p_voucher_usage_start_date DATE, IN p_voucher_usage_end_date DATE, IN p_discount_type VARCHAR(20), IN p_discount_amount DOUBLE, IN p_minimum_booking_amount DOUBLE, IN p_voucher_quantity INT, IN p_available_voucher INT, IN p_last_log_by INT, OUT p_voucher_id INT)
BEGIN
    INSERT INTO voucher (voucher_name, voucher_code, voucher_usage_start_date, voucher_usage_end_date, discount_type, discount_amount, minimum_booking_amount, voucher_quantity, available_voucher, last_log_by) 
	VALUES(p_voucher_name, p_voucher_code, p_voucher_usage_start_date, p_voucher_usage_end_date, p_discount_type, p_discount_amount, p_minimum_booking_amount, p_voucher_quantity, p_available_voucher, p_last_log_by);
	
    SET p_voucher_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateVoucher(IN p_voucher_id INT, IN p_voucher_name VARCHAR(100), IN p_voucher_code VARCHAR(20), IN p_voucher_usage_start_date DATE, IN p_voucher_usage_end_date DATE, IN p_discount_type VARCHAR(20), IN p_discount_amount DOUBLE, IN p_minimum_booking_amount DOUBLE, IN p_voucher_quantity INT, IN p_available_voucher INT, IN p_last_log_by INT)
BEGIN
    UPDATE voucher
    SET voucher_name = p_voucher_name,
        voucher_code = p_voucher_code,
        voucher_usage_start_date = p_voucher_usage_start_date,
        voucher_usage_end_date = p_voucher_usage_end_date,
        discount_type = p_discount_type,
        discount_amount = p_discount_amount,
        minimum_booking_amount = p_minimum_booking_amount,
        voucher_quantity = p_voucher_quantity,
        available_voucher = p_available_voucher,
        last_log_by = p_last_log_by
    WHERE voucher_id = p_voucher_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteVoucher(IN p_voucher_id INT)
BEGIN
    DELETE FROM voucher WHERE voucher_id = p_voucher_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getVoucher(IN p_voucher_id INT)
BEGIN
	SELECT * FROM voucher
	WHERE voucher_id = p_voucher_id;
END //

CREATE PROCEDURE getVoucherCode(IN p_voucher_code VARCHAR(20))
BEGIN
	SELECT * FROM voucher
	WHERE voucher_code = p_voucher_code;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateVoucherTable()
BEGIN
    SELECT voucher_id, voucher_name, voucher_code, voucher_usage_start_date, voucher_usage_end_date, discount_type, discount_amount, minimum_booking_amount, voucher_quantity, available_voucher
    FROM voucher;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */