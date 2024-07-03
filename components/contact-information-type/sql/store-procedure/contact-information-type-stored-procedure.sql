DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkContactInformationTypeExist(IN p_contact_information_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM contact_information_type
    WHERE contact_information_type_id = p_contact_information_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertContactInformationType(IN p_contact_information_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_contact_information_type_id INT)
BEGIN
    INSERT INTO contact_information_type (contact_information_type_name, last_log_by) 
	VALUES(p_contact_information_type_name, p_last_log_by);
	
    SET p_contact_information_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateContactInformationType(IN p_contact_information_type_id INT, IN p_contact_information_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE contact_information_type
    SET contact_information_type_name = p_contact_information_type_name,
        last_log_by = p_last_log_by
    WHERE contact_information_type_id = p_contact_information_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteContactInformationType(IN p_contact_information_type_id INT)
BEGIN
    DELETE FROM contact_information_type WHERE contact_information_type_id = p_contact_information_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getContactInformationType(IN p_contact_information_type_id INT)
BEGIN
	SELECT * FROM contact_information_type
	WHERE contact_information_type_id = p_contact_information_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateContactInformationTypeTable()
BEGIN
	SELECT contact_information_type_id, contact_information_type_name 
    FROM contact_information_type 
    ORDER BY contact_information_type_id;
END //

CREATE PROCEDURE generateContactInformationTypeOptions()
BEGIN
	SELECT contact_information_type_id, contact_information_type_name 
    FROM contact_information_type 
    ORDER BY contact_information_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */