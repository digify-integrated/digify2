DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCompanyExist(IN p_company_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM company
    WHERE company_id = p_company_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCompany(IN p_company_name VARCHAR(100), IN p_legal_name VARCHAR(100), IN p_address VARCHAR(500), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_currency_id INT, IN p_currency_name VARCHAR(500), IN p_currency_symbol VARCHAR(10), IN p_tax_id VARCHAR(50), IN p_phone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(500), IN p_website VARCHAR(500), IN p_last_log_by INT, OUT p_company_id INT)
BEGIN
    INSERT INTO company (company_name, legal_name, address, city_id, city_name, state_id, state_name, country_id, country_name, currency_id, currency_name, currency_symbol, tax_id, phone, mobile, email, website, last_log_by) 
	VALUES(p_company_name, p_legal_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_currency_id, p_currency_name, p_currency_symbol, p_tax_id, p_phone, p_mobile, p_email, p_website, p_last_log_by);
	
    SET p_company_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCompany(IN p_company_id INT, IN p_company_name VARCHAR(100), IN p_legal_name VARCHAR(100), IN p_address VARCHAR(500), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_currency_id INT, IN p_currency_name VARCHAR(500), IN p_currency_symbol VARCHAR(10), IN p_tax_id VARCHAR(50), IN p_phone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(500), IN p_website VARCHAR(500), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET company_name = p_company_name,
        legal_name = p_legal_name,
        address = p_address,
        city_id = p_city_id,
        city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        currency_id = p_currency_id,
        currency_name = p_currency_name,
        currency_symbol = p_currency_symbol,
        tax_id = p_tax_id,
        phone = p_phone,
        mobile = p_mobile,
        email = p_email,
        website = p_website,
        last_log_by = p_last_log_by
    WHERE company_id = p_company_id;

    COMMIT;
END //

CREATE PROCEDURE updateCompanyLogo(IN p_company_id INT, IN p_company_logo VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE company
    SET company_logo = p_company_logo,
        last_log_by = p_last_log_by
    WHERE company_id = p_company_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCompany(IN p_company_id INT)
BEGIN
    DELETE FROM company WHERE company_id = p_company_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCompany(IN p_company_id INT)
BEGIN
	SELECT * FROM company
	WHERE company_id = p_company_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCompanyTable(IN p_filter_by_city INT, IN p_filter_by_state INT, IN p_filter_by_country INT)
BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT company_id, company_name, address, city_name, state_name, country_name, company_logo
        FROM company 
        WHERE 1');

    IF p_filter_by_city IS NOT NULL THEN
        SET query = CONCAT(query, ' AND city_id = ', p_filter_by_city);
    END IF;

    IF p_filter_by_state IS NOT NULL THEN
        SET query = CONCAT(query, ' AND state_id = ', p_filter_by_state);
    END IF;

    IF p_filter_by_country IS NOT NULL THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY company_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateCompanyOptions()
BEGIN
	SELECT company_id, company_name 
    FROM company 
    ORDER BY company_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */