DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCurrencyExist(IN p_currency_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM currency
    WHERE currency_id = p_currency_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCurrency(IN p_currency_name VARCHAR(100), IN p_currency_code VARCHAR(10), IN p_currency_symbol VARCHAR(10), IN p_exchange_rate DOUBLE, IN p_last_log_by INT, OUT p_currency_id INT)
BEGIN
    INSERT INTO currency (currency_name, currency_code, currency_symbol, exchange_rate, last_log_by) 
	VALUES(p_currency_name, p_currency_code, p_currency_symbol, p_exchange_rate, p_last_log_by);
	
    SET p_currency_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCurrency(IN p_currency_id INT, IN p_currency_name VARCHAR(100), IN p_currency_code VARCHAR(10), IN p_currency_symbol VARCHAR(10), IN p_exchange_rate DOUBLE, IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET currency_name = p_currency_name,
        currency_symbol = p_currency_symbol,
        last_log_by = p_last_log_by
    WHERE currency_id = p_currency_id;

    UPDATE currency
    SET currency_name = p_currency_name,
        currency_code = p_currency_code,
        currency_symbol = p_currency_symbol,
        exchange_rate = p_exchange_rate,
        last_log_by = p_last_log_by
    WHERE currency_id = p_currency_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCurrency(IN p_currency_id INT)
BEGIN
    DELETE FROM currency WHERE currency_id = p_currency_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCurrency(IN p_currency_id INT)
BEGIN
	SELECT * FROM currency
	WHERE currency_id = p_currency_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCurrencyTable()
BEGIN
    SELECT currency_id, currency_name, currency_symbol FROM currency;
END //

CREATE PROCEDURE generateCurrencyOptions()
BEGIN
	SELECT currency_id, currency_name, currency_symbol FROM currency 
    ORDER BY currency_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */