DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCountryExist(IN p_country_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM country
    WHERE country_id = p_country_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCountry(IN p_country_name VARCHAR(100), IN p_last_log_by INT, OUT p_country_id INT)
BEGIN
    INSERT INTO country (country_name, last_log_by) 
	VALUES(p_country_name, p_last_log_by);
	
    SET p_country_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCountry(IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    UPDATE city
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    UPDATE state
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    UPDATE country
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCountry(IN p_country_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM city WHERE country_id = p_country_id;
    DELETE FROM state WHERE country_id = p_country_id;
    DELETE FROM country WHERE country_id = p_country_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCountry(IN p_country_id INT)
BEGIN
	SELECT * FROM country
	WHERE country_id = p_country_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCountryTable()
BEGIN
	SELECT country_id, country_name 
    FROM country 
    ORDER BY country_id;
END //

CREATE PROCEDURE generateCountryOptions()
BEGIN
	SELECT country_id, country_name 
    FROM country 
    ORDER BY country_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */