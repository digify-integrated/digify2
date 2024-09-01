DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkPageTitleExist(IN p_page_title_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM page_title
    WHERE page_title_id = p_page_title_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertPageTitle(IN p_page_title_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_page_title VARCHAR(500), IN p_page_heading VARCHAR(500), IN p_last_log_by INT, OUT p_page_title_id INT)
BEGIN
    INSERT INTO page_title (page_title_name, description, block_style_id, block_style_name, page_title, page_heading, last_log_by) 
	VALUES(p_page_title_name, p_description, p_block_style_id, p_block_style_name, p_page_title, p_page_heading, p_last_log_by);
	
    SET p_page_title_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updatePageTitle(IN p_page_title_id INT, IN p_page_title_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_page_title VARCHAR(500), IN p_page_heading VARCHAR(500), IN p_page_title_image VARCHAR(500), IN p_last_log_by INT)
BEGIN
    IF p_page_title_image IS NOT NULL AND p_page_title_image != '' THEN
        UPDATE page_title
        SET page_title_name = p_page_title_name,
            description = p_description,
            block_style_id = p_block_style_id,
            block_style_name = p_block_style_name,
            page_title = p_page_title,
            page_heading = p_page_heading,
            page_title_image = p_page_title_image,
            last_log_by = p_last_log_by
        WHERE page_title_id = p_page_title_id;
    ELSE
        UPDATE page_title
        SET page_title_name = p_page_title_name,
            description = p_description,
            block_style_id = p_block_style_id,
            block_style_name = p_block_style_name,
            page_title = p_page_title,
            page_heading = p_page_heading,
            last_log_by = p_last_log_by
        WHERE page_title_id = p_page_title_id;
    END IF;  
END //

CREATE PROCEDURE updatePageTitlePublishStatus(IN p_page_title_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE page_title
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE page_title_id = p_page_title_id;
END //

CREATE PROCEDURE updatePageTitleImage(IN p_page_title_id INT, IN p_page_title_image VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE page_title
    SET page_title_image = p_page_title_image,
        last_log_by = p_last_log_by
    WHERE page_title_id = p_page_title_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deletePageTitle(IN p_page_title_id INT)
BEGIN
    DELETE FROM page_title WHERE page_title_id = p_page_title_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getPageTitle(IN p_page_title_id INT)
BEGIN
	SELECT * FROM page_title
	WHERE page_title_id = p_page_title_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generatePageTitleTable()
BEGIN
    SELECT page_title_id, page_title_name, description, page_title, page_heading, page_title_image, publish_status
    FROM page_title;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */