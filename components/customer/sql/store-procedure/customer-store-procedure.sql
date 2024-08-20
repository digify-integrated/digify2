DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCustomerExist(IN p_customer_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer
    WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE checkCustomerAddressExist(IN p_customer_address_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer_address
    WHERE customer_address_id = p_customer_address_id;
END //

CREATE PROCEDURE checkCustomerBankAccountExist(IN p_customer_bank_account_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer_bank_account
    WHERE customer_bank_account_id = p_customer_bank_account_id;
END //

CREATE PROCEDURE checkCustomerBankCardExist(IN p_customer_bank_card_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer_bank_card
    WHERE customer_bank_card_id = p_customer_bank_card_id;
END //

CREATE PROCEDURE checkCustomerIDRecordExist(IN p_customer_id_record_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer_id_record
    WHERE customer_id_record_id = p_customer_id_record_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCustomer(IN p_full_name VARCHAR(1000), IN p_first_name VARCHAR(300), IN p_middle_name VARCHAR(300), IN p_last_name VARCHAR(300), IN p_suffix VARCHAR(10), IN p_nickname VARCHAR(100), IN p_civil_status_id INT, IN p_civil_status_name VARCHAR(100), IN p_gender_id INT, IN p_gender_name VARCHAR(100), IN p_birthday DATE, IN p_birth_place VARCHAR(1000), IN p_last_log_by INT, OUT p_customer_id INT)
BEGIN
    INSERT INTO customer (full_name, first_name, middle_name, last_name, suffix, nickname, civil_status_id, civil_status_name, gender_id, gender_name, birthday, birth_place, last_log_by) 
	VALUES(p_full_name, p_first_name, p_middle_name, p_last_name, p_suffix, p_nickname, p_civil_status_id, p_civil_status_name, p_gender_id, p_gender_name, p_birthday, p_birth_place, p_last_log_by);
	
    SET p_customer_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertCustomerAddress(IN p_customer_id INT, IN p_address_type_id INT, IN p_address_type_name VARCHAR(100), IN p_address VARCHAR(1000), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_telephone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(200), IN p_last_log_by INT)
BEGIN
    DECLARE existing_address_count INT;
    DECLARE p_default_address VARCHAR(10);

    SELECT COUNT(*) INTO existing_address_count
    FROM customer_address
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    IF existing_address_count = 0 THEN
        SET p_default_address = 'Primary';
    ELSE
        SET p_default_address = 'Alternate';
    END IF;

    INSERT INTO customer_address (customer_id, address_type_id, address_type_name, address, city_id, city_name, state_id, state_name, country_id, country_name, default_address, telephone, mobile, email, last_log_by) 
	VALUES(p_customer_id, p_address_type_id, p_address_type_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_default_address, p_telephone, p_mobile, p_email, p_last_log_by);
END //

CREATE PROCEDURE insertCustomerBankAccount(IN p_customer_id INT, IN p_bank_id INT, IN p_bank_name VARCHAR(100), IN p_bank_account_type_id INT, IN p_bank_account_type_name VARCHAR(100), IN p_account_number VARCHAR(100), IN p_last_log_by INT)
BEGIN
    INSERT INTO customer_bank_account (customer_id, bank_id, bank_name, bank_account_type_id,bank_account_type_name, account_number, last_log_by) 
	VALUES(p_customer_id, p_bank_id, p_bank_name, p_bank_account_type_id, p_bank_account_type_name, p_account_number, p_last_log_by);
END //

CREATE PROCEDURE insertCustomerBankCard(IN p_customer_id INT, IN p_name_on_card VARCHAR(255), IN p_card_number VARCHAR(255), IN p_expiry_date VARCHAR(255), IN p_cvv VARCHAR(255), IN p_last_log_by INT)
BEGIN
    INSERT INTO customer_bank_card (customer_id, name_on_card, card_number, expiry_date, cvv, last_log_by) 
	VALUES(p_customer_id, p_name_on_card, p_card_number, p_expiry_date, p_cvv, p_last_log_by);
END //

CREATE PROCEDURE insertCustomerIDRecord(IN p_customer_id INT, IN p_id_type_id INT, IN p_id_type_name VARCHAR(100), IN p_id_number VARCHAR(100), IN p_issue_date DATE, IN p_expiration_date DATE, IN p_issuing_authority VARCHAR(100), IN p_last_log_by INT)
BEGIN
    INSERT INTO customer_id_record (customer_id, id_type_id, id_type_name, id_number, issue_date, expiration_date, issuing_authority, last_log_by) 
	VALUES(p_customer_id, p_id_type_id, p_id_type_name, p_id_number, p_issue_date, p_expiration_date, p_issuing_authority, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCustomerImage(IN p_customer_id INT, IN p_customer_image VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE customer
    SET customer_image = p_customer_image,
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE updateCustomerAbout(IN p_customer_id INT, IN p_about VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE customer
    SET about = p_about,
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE updateCustomerPrivateInformation(IN p_customer_id INT, IN p_full_name VARCHAR(1000), IN p_first_name VARCHAR(300), IN p_middle_name VARCHAR(300), IN p_last_name VARCHAR(300), IN p_suffix VARCHAR(10), IN p_nickname VARCHAR(100), IN p_civil_status_id INT, IN p_civil_status_name VARCHAR(100), IN p_gender_id INT, IN p_gender_name VARCHAR(100), IN p_birthday DATE, IN p_birth_place VARCHAR(1000), IN p_last_log_by INT)
BEGIN
    UPDATE customer
    SET full_name = p_full_name,
        first_name = p_first_name,
        middle_name = p_middle_name,
        last_name = p_last_name,
        suffix = p_suffix,
        nickname = p_nickname,
        civil_status_id = p_civil_status_id,
        civil_status_name = p_civil_status_name,
        gender_id = p_gender_id,
        gender_name = p_gender_name,
        birthday = p_birthday,
        birth_place = p_birth_place,
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE updateCustomerAddress(IN p_customer_address_id INT, IN p_customer_id INT, IN p_address_type_id INT, IN p_address_type_name VARCHAR(100), IN p_address VARCHAR(1000), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_telephone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(200), IN p_last_log_by INT)
BEGIN
    UPDATE customer_address
    SET customer_id = p_customer_id,
        address_type_id = p_address_type_id,
        address_type_name = p_address_type_name,
        address = p_address,
        city_id = p_city_id,
        city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        telephone = p_telephone,
        mobile = p_mobile,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE customer_address_id = p_customer_address_id;
END //

CREATE PROCEDURE updateCustomerAddressDefault(IN p_customer_address_id INT, IN p_customer_id INT, IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE customer_address
    SET default_address = 'Alternate',
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    UPDATE customer_address
    SET default_address = 'Primary',
        last_log_by = p_last_log_by
    WHERE customer_address_id = p_customer_address_id AND customer_id = p_customer_id;

    COMMIT;
END //

CREATE PROCEDURE updateCustomerBankAccount(IN p_customer_bank_account_id INT, IN p_customer_id INT, IN p_bank_id INT, IN p_bank_name VARCHAR(100), IN p_bank_account_type_id INT, IN p_bank_account_type_name VARCHAR(100), IN p_account_number VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE customer_bank_account
    SET customer_id = p_customer_id,
        bank_id = p_bank_id,
        bank_name = p_bank_name,
        bank_account_type_id = p_bank_account_type_id,
        bank_account_type_name = p_bank_account_type_name,
        account_number = p_account_number,
        last_log_by = p_last_log_by
    WHERE customer_bank_account_id = p_customer_bank_account_id;
END //

CREATE PROCEDURE updateCustomerBankCard(IN p_customer_bank_card_id INT, IN p_customer_id INT, IN p_name_on_card VARCHAR(255), IN p_card_number VARCHAR(255), IN p_expiry_date VARCHAR(255), IN p_cvv VARCHAR(255), IN p_last_log_by INT)
BEGIN
    UPDATE customer_bank_card
    SET customer_id = p_customer_id,
        name_on_card = p_name_on_card,
        card_number = p_card_number,
        expiry_date = p_expiry_date,
        cvv = p_cvv,
        last_log_by = p_last_log_by
    WHERE customer_bank_card_id = p_customer_bank_card_id;
END //

CREATE PROCEDURE updateCustomerBankCardDefault(IN p_customer_bank_card_id INT, IN p_customer_id INT, IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE customer_bank_card
    SET default_card = 'Alternate',
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id AND default_card = 'Primary';

    UPDATE customer_bank_card
    SET default_card = 'Primary',
        last_log_by = p_last_log_by
    WHERE customer_bank_card_id = p_customer_bank_card_id AND customer_id = p_customer_id;

    COMMIT;
END //

CREATE PROCEDURE updateCustomerIDRecord(IN p_customer_id_record_id INT, IN p_customer_id INT, IN p_id_type_id INT, IN p_id_type_name VARCHAR(100), IN p_id_number VARCHAR(100), IN p_issue_date DATE, IN p_expiration_date DATE, IN p_issuing_authority VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE customer_id_record
    SET customer_id = p_customer_id,
        id_type_id = p_id_type_id,
        id_type_name = p_id_type_name,
        id_number = p_id_number,
        issue_date = p_issue_date,
        expiration_date = p_expiration_date,
        issuing_authority = p_issuing_authority,
        last_log_by = p_last_log_by
    WHERE customer_id_record_id = p_customer_id_record_id;
END //

CREATE PROCEDURE updateCustomerIDRecordImage(IN p_customer_id_record_id INT, IN p_id_image VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE customer_id_record
    SET id_image = p_id_image,
        last_log_by = p_last_log_by
    WHERE customer_id_record_id = p_customer_id_record_id;
END //

CREATE PROCEDURE updateCustomerStatus(IN p_customer_id INT, IN p_customer_status VARCHAR(50), IN p_last_log_by INT)
BEGIN
    UPDATE customer
    SET customer_status = p_customer_status,
        archive_date = NOW(),
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCustomer(IN p_customer_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM customer_address WHERE customer_id = p_customer_id;
    DELETE FROM customer_bank_account WHERE customer_id = p_customer_id;
    DELETE FROM customer_bank_card WHERE customer_id = p_customer_id;
    DELETE FROM customer_id_record WHERE customer_id = p_customer_id;
    DELETE FROM customer WHERE customer_id = p_customer_id;

    COMMIT;
END //

CREATE PROCEDURE deleteCustomerAddress(IN p_customer_address_id INT, IN p_customer_id INT)
BEGIN
    DECLARE existing_address_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    DELETE FROM customer_address
    WHERE customer_address_id = p_customer_address_id;

    SELECT COUNT(*) INTO existing_address_count
    FROM customer_address
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    IF existing_address_count = 0 THEN
        UPDATE customer_address
        SET default_address = 'Primary'
        WHERE customer_id = p_customer_id
        AND default_address = 'Alternate'
        LIMIT 1;
    END IF;   

    COMMIT;
END //

CREATE PROCEDURE deleteCustomerBankAccount(IN p_customer_bank_account_id INT)
BEGIN
   DELETE FROM customer_bank_account WHERE customer_bank_account_id = p_customer_bank_account_id;
END //

CREATE PROCEDURE deleteCustomerBankCard(IN p_customer_bank_card_id INT)
BEGIN
    DECLARE existing_bank_card_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    DELETE FROM customer_bank_card
    WHERE customer_bank_card_id = p_customer_bank_card_id;

    SELECT COUNT(*) INTO existing_bank_card_count
    FROM customer_bank_card
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    IF existing_bank_card_count = 0 THEN
        UPDATE customer_bank_card
        SET default_address = 'Primary'
        WHERE customer_id = p_customer_id
        AND default_address = 'Alternate'
        LIMIT 1;
    END IF;   

    COMMIT;
END //

CREATE PROCEDURE deleteCustomerIDRecord(IN p_customer_id_record_id INT)
BEGIN
   DELETE FROM customer_id_record WHERE customer_id_record_id = p_customer_id_record_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCustomer(IN p_customer_id INT)
BEGIN
	SELECT * FROM customer
	WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE getCustomerAddress(IN p_customer_address_id INT)
BEGIN
	SELECT * FROM customer_address
	WHERE customer_address_id = p_customer_address_id;
END //

CREATE PROCEDURE getCustomerBankAccount(IN p_customer_bank_account_id INT)
BEGIN
	SELECT * FROM customer_bank_account
	WHERE customer_bank_account_id = p_customer_bank_account_id;
END //

CREATE PROCEDURE getCustomerBankCard(IN p_customer_bank_card_id INT)
BEGIN
	SELECT * FROM customer_bank_card
	WHERE customer_bank_card_id = p_customer_bank_card_id;
END //

CREATE PROCEDURE getCustomerIDRecord(IN p_customer_id_record_id INT)
BEGIN
	SELECT * FROM customer_id_record
	WHERE customer_id_record_id = p_customer_id_record_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCustomerCard(IN p_search_value TEXT, IN p_filter_by_customer_status VARCHAR(50), IN p_filter_by_gender INT, IN p_filter_by_civil_status INT, IN p_limit INT, IN p_offset INT)
BEGIN
    DECLARE query TEXT;

    SET query = '
        SELECT customer_id, full_name, customer_status, customer_image
        FROM customer 
        WHERE 1=1';

    IF p_search_value IS NOT NULL AND p_search_value <> '' THEN
        SET query = CONCAT(query, ' AND (
            first_name LIKE ? OR
            middle_name LIKE ? OR
            last_name LIKE ? OR
            customer_status LIKE ?
        )');
    END IF;

    IF p_filter_by_customer_status IS NOT NULL AND p_filter_by_customer_status <> '' THEN
        SET query = CONCAT(query, ' AND customer_status =', QUOTE(p_filter_by_customer_status));
    END IF;

    IF p_filter_by_gender IS NOT NULL AND p_filter_by_gender <> '' THEN
        SET query = CONCAT(query, ' AND gender_id =', p_filter_by_gender);
    END IF;

    IF p_filter_by_civil_status IS NOT NULL AND p_filter_by_civil_status <> '' THEN
        SET query = CONCAT(query, ' AND civil_status_id =', p_filter_by_civil_status);
    END IF;

    SET query = CONCAT(query, ' ORDER BY full_name LIMIT ?, ?;');

    PREPARE stmt FROM query;
    IF p_search_value IS NOT NULL AND p_search_value <> '' THEN
        EXECUTE stmt USING CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), p_offset, p_limit;
    ELSE
        EXECUTE stmt USING p_offset, p_limit;
    END IF;

    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateCustomerAddress(IN p_customer_id INT)
BEGIN
	SELECT * FROM customer_address
	WHERE customer_id = p_customer_id
    ORDER BY default_address DESC;
END //

CREATE PROCEDURE generateCustomerBankAccount(IN p_customer_id INT)
BEGIN
	SELECT * FROM customer_bank_account
	WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE generateCustomerBankCard(IN p_customer_id INT)
BEGIN
	SELECT * FROM customer_bank_card
	WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE generateCustomerIDRecord(IN p_customer_id INT)
BEGIN
	SELECT * FROM customer_id_record
	WHERE customer_id = p_customer_id;
END //

CREATE PROCEDURE generateCustomerOptions(IN p_customer_id INT)
BEGIN
    IF p_customer_id IS NOT NULL AND p_customer_id != '' THEN
        SELECT customer_id, customer_status 
        FROM customer 
        WHERE customer_id != p_customer_id
        ORDER BY customer_status;
    ELSE
        SELECT customer_id, customer_status 
        FROM customer 
        ORDER BY customer_status;
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */