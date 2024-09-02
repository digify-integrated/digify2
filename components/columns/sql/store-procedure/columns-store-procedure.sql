DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkColumnsExist(IN p_columns_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM columns
    WHERE columns_id = p_columns_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertColumns(IN p_columns_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_columns_id INT)
BEGIN
    INSERT INTO columns (columns_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_columns_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_columns_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateColumns(IN p_columns_id INT, IN p_columns_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE columns
    SET columns_name = p_columns_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE columns_id = p_columns_id;
END //

CREATE PROCEDURE updateColumnsPublishStatus(IN p_columns_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE columns
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE columns_id = p_columns_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteColumns(IN p_columns_id INT)
BEGIN
    DELETE FROM columns WHERE columns_id = p_columns_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getColumns(IN p_columns_id INT)
BEGIN
	SELECT * FROM columns
	WHERE columns_id = p_columns_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateColumnsTable()
BEGIN
    SELECT columns_id, columns_name, description, publish_status
    FROM columns;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */