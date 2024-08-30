DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkHeaderExist(IN p_header_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM header
    WHERE header_id = p_header_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertHeader(IN p_header_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_header_id INT)
BEGIN
    INSERT INTO header (header_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_header_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_header_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateHeader(IN p_header_id INT, IN p_header_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE header
    SET header_name = p_header_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE header_id = p_header_id;
END //

CREATE PROCEDURE updateHeaderPublishStatus(IN p_header_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE header
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE header_id = p_header_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteHeader(IN p_header_id INT)
BEGIN
    DELETE FROM header WHERE header_id = p_header_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getHeader(IN p_header_id INT)
BEGIN
	SELECT * FROM header
	WHERE header_id = p_header_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateHeaderTable()
BEGIN
    SELECT header_id, header_name, description, publish_status
    FROM header;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */