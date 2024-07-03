DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkLanguageExist(IN p_language_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM language
    WHERE language_id = p_language_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertLanguage(IN p_language_name VARCHAR(100), IN p_last_log_by INT, OUT p_language_id INT)
BEGIN
    INSERT INTO language (language_name, last_log_by) 
	VALUES(p_language_name, p_last_log_by);
	
    SET p_language_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateLanguage(IN p_language_id INT, IN p_language_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE language
    SET language_name = p_language_name,
        last_log_by = p_last_log_by
    WHERE language_id = p_language_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteLanguage(IN p_language_id INT)
BEGIN
    DELETE FROM language WHERE language_id = p_language_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getLanguage(IN p_language_id INT)
BEGIN
	SELECT * FROM language
	WHERE language_id = p_language_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateLanguageTable()
BEGIN
	SELECT language_id, language_name 
    FROM language 
    ORDER BY language_id;
END //

CREATE PROCEDURE generateLanguageOptions()
BEGIN
	SELECT language_id, language_name 
    FROM language 
    ORDER BY language_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */