DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkReligionExist(IN p_religion_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM religion
    WHERE religion_id = p_religion_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertReligion(IN p_religion_name VARCHAR(100), IN p_last_log_by INT, OUT p_religion_id INT)
BEGIN
    INSERT INTO religion (religion_name, last_log_by) 
	VALUES(p_religion_name, p_last_log_by);
	
    SET p_religion_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateReligion(IN p_religion_id INT, IN p_religion_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET religion_name = p_religion_name,
        last_log_by = p_last_log_by
    WHERE religion_id = p_religion_id;

    UPDATE religion
    SET religion_name = p_religion_name,
        last_log_by = p_last_log_by
    WHERE religion_id = p_religion_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteReligion(IN p_religion_id INT)
BEGIN
    DELETE FROM religion WHERE religion_id = p_religion_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getReligion(IN p_religion_id INT)
BEGIN
	SELECT * FROM religion
	WHERE religion_id = p_religion_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateReligionTable()
BEGIN
	SELECT religion_id, religion_name 
    FROM religion 
    ORDER BY religion_id;
END //

CREATE PROCEDURE generateReligionOptions()
BEGIN
	SELECT religion_id, religion_name 
    FROM religion 
    ORDER BY religion_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */