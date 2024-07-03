DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkIDTypeExist(IN p_id_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM id_type
    WHERE id_type_id = p_id_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertIDType(IN p_id_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_id_type_id INT)
BEGIN
    INSERT INTO id_type (id_type_name, last_log_by) 
	VALUES(p_id_type_name, p_last_log_by);
	
    SET p_id_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateIDType(IN p_id_type_id INT, IN p_id_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE id_type
    SET id_type_name = p_id_type_name,
        last_log_by = p_last_log_by
    WHERE id_type_id = p_id_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteIDType(IN p_id_type_id INT)
BEGIN
    DELETE FROM id_type WHERE id_type_id = p_id_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getIDType(IN p_id_type_id INT)
BEGIN
	SELECT * FROM id_type
	WHERE id_type_id = p_id_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateIDTypeTable()
BEGIN
	SELECT id_type_id, id_type_name 
    FROM id_type 
    ORDER BY id_type_id;
END //

CREATE PROCEDURE generateIDTypeOptions()
BEGIN
	SELECT id_type_id, id_type_name 
    FROM id_type 
    ORDER BY id_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */