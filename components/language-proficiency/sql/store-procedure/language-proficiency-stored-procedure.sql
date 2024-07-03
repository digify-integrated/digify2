DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkLanguageProficiencyExist(IN p_language_proficiency_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM language_proficiency
    WHERE language_proficiency_id = p_language_proficiency_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertLanguageProficiency(IN p_language_proficiency_name VARCHAR(100), IN p_language_proficiency_description VARCHAR(200), IN p_last_log_by INT, OUT p_language_proficiency_id INT)
BEGIN
    INSERT INTO language_proficiency (language_proficiency_name, language_proficiency_description, last_log_by) 
	VALUES(p_language_proficiency_name, p_language_proficiency_description, p_last_log_by);
	
    SET p_language_proficiency_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateLanguageProficiency(IN p_language_proficiency_id INT, IN p_language_proficiency_name VARCHAR(100), IN p_language_proficiency_description VARCHAR(200), IN p_last_log_by INT)
BEGIN
    UPDATE language_proficiency
    SET language_proficiency_name = p_language_proficiency_name,
        language_proficiency_description = p_language_proficiency_description,
        last_log_by = p_last_log_by
    WHERE language_proficiency_id = p_language_proficiency_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteLanguageProficiency(IN p_language_proficiency_id INT)
BEGIN
    DELETE FROM language_proficiency WHERE language_proficiency_id = p_language_proficiency_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getLanguageProficiency(IN p_language_proficiency_id INT)
BEGIN
	SELECT * FROM language_proficiency
	WHERE language_proficiency_id = p_language_proficiency_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateLanguageProficiencyTable()
BEGIN
	SELECT language_proficiency_id, language_proficiency_name, language_proficiency_description
    FROM language_proficiency 
    ORDER BY language_proficiency_id;
END //

CREATE PROCEDURE generateLanguageProficiencyOptions()
BEGIN
	SELECT language_proficiency_id, language_proficiency_name, language_proficiency_description
    FROM language_proficiency 
    ORDER BY language_proficiency_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */