DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkBankAccountTypeExist(IN p_bank_account_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM bank_account_type
    WHERE bank_account_type_id = p_bank_account_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertBankAccountType(IN p_bank_account_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_bank_account_type_id INT)
BEGIN
    INSERT INTO bank_account_type (bank_account_type_name, last_log_by) 
	VALUES(p_bank_account_type_name, p_last_log_by);
	
    SET p_bank_account_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateBankAccountType(IN p_bank_account_type_id INT, IN p_bank_account_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE bank_account_type
    SET bank_account_type_name = p_bank_account_type_name,
        last_log_by = p_last_log_by
    WHERE bank_account_type_id = p_bank_account_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteBankAccountType(IN p_bank_account_type_id INT)
BEGIN
    DELETE FROM bank_account_type WHERE bank_account_type_id = p_bank_account_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getBankAccountType(IN p_bank_account_type_id INT)
BEGIN
	SELECT * FROM bank_account_type
	WHERE bank_account_type_id = p_bank_account_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateBankAccountTypeTable()
BEGIN
	SELECT bank_account_type_id, bank_account_type_name 
    FROM bank_account_type 
    ORDER BY bank_account_type_id;
END //

CREATE PROCEDURE generateBankAccountTypeOptions()
BEGIN
	SELECT bank_account_type_id, bank_account_type_name 
    FROM bank_account_type 
    ORDER BY bank_account_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */