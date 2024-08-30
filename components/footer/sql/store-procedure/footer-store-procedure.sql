DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkFooterExist(IN p_footer_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM footer
    WHERE footer_id = p_footer_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertFooter(IN p_footer_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_footer_id INT)
BEGIN
    INSERT INTO footer (footer_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_footer_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_footer_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateFooter(IN p_footer_id INT, IN p_footer_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE footer
    SET footer_name = p_footer_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE footer_id = p_footer_id;
END //

CREATE PROCEDURE updateFooterPublishStatus(IN p_footer_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE footer
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE footer_id = p_footer_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteFooter(IN p_footer_id INT)
BEGIN
    DELETE FROM footer WHERE footer_id = p_footer_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getFooter(IN p_footer_id INT)
BEGIN
	SELECT * FROM footer
	WHERE footer_id = p_footer_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateFooterTable()
BEGIN
    SELECT footer_id, footer_name, description, publish_status
    FROM footer;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */