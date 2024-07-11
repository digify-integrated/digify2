DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkBloodTypeExist(IN p_blood_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM blood_type
    WHERE blood_type_id = p_blood_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertBloodType(IN p_blood_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_blood_type_id INT)
BEGIN
    INSERT INTO blood_type (blood_type_name, last_log_by) 
	VALUES(p_blood_type_name, p_last_log_by);
	
    SET p_blood_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateBloodType(IN p_blood_type_id INT, IN p_blood_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET blood_type_name = p_blood_type_name,
        last_log_by = p_last_log_by
    WHERE blood_type_id = p_blood_type_id;

    UPDATE blood_type
    SET blood_type_name = p_blood_type_name,
        last_log_by = p_last_log_by
    WHERE blood_type_id = p_blood_type_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteBloodType(IN p_blood_type_id INT)
BEGIN
    DELETE FROM blood_type WHERE blood_type_id = p_blood_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getBloodType(IN p_blood_type_id INT)
BEGIN
	SELECT * FROM blood_type
	WHERE blood_type_id = p_blood_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateBloodTypeTable()
BEGIN
	SELECT blood_type_id, blood_type_name 
    FROM blood_type 
    ORDER BY blood_type_id;
END //

CREATE PROCEDURE generateBloodTypeOptions()
BEGIN
	SELECT blood_type_id, blood_type_name 
    FROM blood_type 
    ORDER BY blood_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */