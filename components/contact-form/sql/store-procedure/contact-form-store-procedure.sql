DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkContactFormExist(IN p_contact_form_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM contact_form
    WHERE contact_form_id = p_contact_form_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertContactForm(IN p_contact_form_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_contact_form_id INT)
BEGIN
    INSERT INTO contact_form (contact_form_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_contact_form_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_contact_form_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateContactForm(IN p_contact_form_id INT, IN p_contact_form_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE contact_form
    SET contact_form_name = p_contact_form_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE contact_form_id = p_contact_form_id;
END //

CREATE PROCEDURE updateContactFormPublishStatus(IN p_contact_form_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE contact_form
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE contact_form_id = p_contact_form_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteContactForm(IN p_contact_form_id INT)
BEGIN
    DELETE FROM contact_form WHERE contact_form_id = p_contact_form_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getContactForm(IN p_contact_form_id INT)
BEGIN
	SELECT * FROM contact_form
	WHERE contact_form_id = p_contact_form_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateContactFormTable()
BEGIN
    SELECT contact_form_id, contact_form_name, description, publish_status
    FROM contact_form;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */