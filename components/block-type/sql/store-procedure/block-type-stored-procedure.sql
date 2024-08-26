DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkBlockTypeExist(IN p_block_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM block_type
    WHERE block_type_id = p_block_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertBlockType(IN p_block_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_block_type_id INT)
BEGIN
    INSERT INTO block_type (block_type_name, last_log_by) 
	VALUES(p_block_type_name, p_last_log_by);
	
    SET p_block_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateBlockType(IN p_block_type_id INT, IN p_block_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE block_style
    SET block_type_name = p_block_type_name,
        last_log_by = p_last_log_by
    WHERE block_type_id = p_block_type_id;

    UPDATE block_type
    SET block_type_name = p_block_type_name,
        last_log_by = p_last_log_by
    WHERE block_type_id = p_block_type_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteBlockType(IN p_block_type_id INT)
BEGIN
    DELETE FROM block_type WHERE block_type_id = p_block_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getBlockType(IN p_block_type_id INT)
BEGIN
	SELECT * FROM block_type
	WHERE block_type_id = p_block_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateBlockTypeTable()
BEGIN
	SELECT block_type_id, block_type_name 
    FROM block_type 
    ORDER BY block_type_id;
END //

CREATE PROCEDURE generateBlockTypeOptions()
BEGIN
	SELECT block_type_id, block_type_name 
    FROM block_type 
    ORDER BY block_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */