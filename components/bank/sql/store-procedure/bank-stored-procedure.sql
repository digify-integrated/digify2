DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkBankExist(IN p_bank_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM bank
    WHERE bank_id = p_bank_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertBank(IN p_bank_name VARCHAR(100), IN p_bank_identifier_code VARCHAR(100), IN p_last_log_by INT, OUT p_bank_id INT)
BEGIN
    INSERT INTO bank (bank_name, bank_identifier_code, last_log_by) 
	VALUES(p_bank_name, p_bank_identifier_code, p_last_log_by);
	
    SET p_bank_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateBank(IN p_bank_id INT, IN p_bank_name VARCHAR(100), IN p_bank_identifier_code VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_bank_account
    SET bank_name = p_bank_name,
        last_log_by = p_last_log_by
    WHERE bank_id = p_bank_id;

    UPDATE bank
    SET bank_name = p_bank_name,
        bank_identifier_code = p_bank_identifier_code,
        last_log_by = p_last_log_by
    WHERE bank_id = p_bank_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteBank(IN p_bank_id INT)
BEGIN
    DELETE FROM bank WHERE bank_id = p_bank_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getBank(IN p_bank_id INT)
BEGIN
	SELECT * FROM bank
	WHERE bank_id = p_bank_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateBankTable()
BEGIN
	SELECT bank_id, bank_name, bank_identifier_code
    FROM bank 
    ORDER BY bank_id;
END //

CREATE PROCEDURE generateBankOptions()
BEGIN
	SELECT bank_id, bank_name
    FROM bank 
    ORDER BY bank_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */