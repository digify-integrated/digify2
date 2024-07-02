DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkAddressTypeExist(IN p_address_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM address_type
    WHERE address_type_id = p_address_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertAddressType(IN p_address_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_address_type_id INT)
BEGIN
    INSERT INTO address_type (address_type_name, last_log_by) 
	VALUES(p_address_type_name, p_last_log_by);
	
    SET p_address_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateAddressType(IN p_address_type_id INT, IN p_address_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE address_type
    SET address_type_name = p_address_type_name,
        last_log_by = p_last_log_by
    WHERE address_type_id = p_address_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteAddressType(IN p_address_type_id INT)
BEGIN
    DELETE FROM address_type WHERE address_type_id = p_address_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getAddressType(IN p_address_type_id INT)
BEGIN
	SELECT * FROM address_type
	WHERE address_type_id = p_address_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateAddressTypeTable()
BEGIN
	SELECT address_type_id, address_type_name 
    FROM address_type 
    ORDER BY address_type_id;
END //

CREATE PROCEDURE generateAddressTypeOptions()
BEGIN
	SELECT address_type_id, address_type_name 
    FROM address_type 
    ORDER BY address_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */