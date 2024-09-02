DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkSectionsExist(IN p_sections_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM sections
    WHERE sections_id = p_sections_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertSections(IN p_sections_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_sections_id INT)
BEGIN
    INSERT INTO sections (sections_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_sections_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_sections_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateSections(IN p_sections_id INT, IN p_sections_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE sections
    SET sections_name = p_sections_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE sections_id = p_sections_id;
END //

CREATE PROCEDURE updateSectionsPublishStatus(IN p_sections_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE sections
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE sections_id = p_sections_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteSections(IN p_sections_id INT)
BEGIN
    DELETE FROM sections WHERE sections_id = p_sections_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getSections(IN p_sections_id INT)
BEGIN
	SELECT * FROM sections
	WHERE sections_id = p_sections_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateSectionsTable()
BEGIN
    SELECT sections_id, sections_name, description, publish_status
    FROM sections;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */