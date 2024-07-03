DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkGenderExist(IN p_gender_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM gender
    WHERE gender_id = p_gender_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertGender(IN p_gender_name VARCHAR(100), IN p_last_log_by INT, OUT p_gender_id INT)
BEGIN
    INSERT INTO gender (gender_name, last_log_by) 
	VALUES(p_gender_name, p_last_log_by);
	
    SET p_gender_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateGender(IN p_gender_id INT, IN p_gender_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE gender
    SET gender_name = p_gender_name,
        last_log_by = p_last_log_by
    WHERE gender_id = p_gender_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteGender(IN p_gender_id INT)
BEGIN
    DELETE FROM gender WHERE gender_id = p_gender_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getGender(IN p_gender_id INT)
BEGIN
	SELECT * FROM gender
	WHERE gender_id = p_gender_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateGenderTable()
BEGIN
	SELECT gender_id, gender_name 
    FROM gender 
    ORDER BY gender_id;
END //

CREATE PROCEDURE generateGenderOptions()
BEGIN
	SELECT gender_id, gender_name 
    FROM gender 
    ORDER BY gender_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */