DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkSecuritySettingExist(IN p_security_setting_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM security_setting
    WHERE security_setting_id = p_security_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertSecuritySetting(IN p_security_setting_name VARCHAR(100), IN p_security_setting_description VARCHAR(200), IN p_value VARCHAR(1000), IN p_last_log_by INT, OUT p_security_setting_id INT)
BEGIN
    INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) 
	VALUES(p_security_setting_name, p_security_setting_description, p_value, p_last_log_by);
	
    SET p_security_setting_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateSecuritySetting(IN p_security_setting_id INT, IN p_security_setting_name VARCHAR(100), IN p_security_setting_description VARCHAR(200), IN p_value VARCHAR(1000), IN p_last_log_by INT)
BEGIN
    UPDATE security_setting
    SET security_setting_name = p_security_setting_name,
        security_setting_description = p_security_setting_description,
        value = p_value,
        last_log_by = p_last_log_by
    WHERE security_setting_id = p_security_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteSecuritySetting(IN p_security_setting_id INT)
BEGIN
   DELETE FROM security_setting WHERE security_setting_id = p_security_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedures */

CREATE PROCEDURE getSecuritySetting(IN p_security_setting_id INT)
BEGIN
	SELECT * FROM security_setting
	WHERE security_setting_id = p_security_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateSecuritySettingTable()
BEGIN
    SELECT security_setting_id, security_setting_name, security_setting_description, value
    FROM security_setting
    ORDER BY security_setting_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */