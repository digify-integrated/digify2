DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkWebsiteExist(IN p_website_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM website
    WHERE website_id = p_website_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertWebsite(IN p_website_name VARCHAR(100), IN p_description VARCHAR(500), IN p_url VARCHAR(255), IN p_last_log_by INT, OUT p_website_id INT)
BEGIN
    INSERT INTO website (website_name, description, url, last_log_by) 
	VALUES(p_website_name, p_description, p_url, p_last_log_by);
	
    SET p_website_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateWebsite(IN p_website_id INT, IN p_website_name VARCHAR(100), IN p_description VARCHAR(500), IN p_url VARCHAR(255), IN p_last_log_by INT)
BEGIN
    UPDATE website
    SET website_name = p_website_name,
        description = p_description,
        url = p_url,
        last_log_by = p_last_log_by
    WHERE website_id = p_website_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteWebsite(IN p_website_id INT)
BEGIN
    DELETE FROM website WHERE website_id = p_website_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getWebsite(IN p_website_id INT)
BEGIN
	SELECT * FROM website
	WHERE website_id = p_website_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateWebsiteTable()
BEGIN
	SELECT website_id, website_name, description, url
    FROM website 
    ORDER BY website_id;
END //

CREATE PROCEDURE generateWebsiteOptions()
BEGIN
	SELECT website_id, website_name 
    FROM website 
    ORDER BY website_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */