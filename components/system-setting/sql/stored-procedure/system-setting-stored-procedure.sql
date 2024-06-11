DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkSystemSettingExist(IN p_system_setting_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM system_setting
    WHERE system_setting_id = p_system_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertSystemSetting(IN p_system_setting_name VARCHAR(100), IN p_system_setting_description VARCHAR(200), IN p_value VARCHAR(1000), IN p_last_log_by INT, OUT p_system_setting_id INT)
BEGIN
    INSERT INTO system_setting (system_setting_name, system_setting_description, value, last_log_by) 
	VALUES(p_system_setting_name, p_system_setting_description, p_value, p_last_log_by);
	
    SET p_system_setting_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateSystemSetting(IN p_system_setting_id INT, IN p_system_setting_name VARCHAR(100), IN p_system_setting_description VARCHAR(200), IN p_value VARCHAR(1000), IN p_last_log_by INT)
BEGIN
    UPDATE system_setting
    SET system_setting_name = p_system_setting_name,
        system_setting_description = p_system_setting_description,
        value = p_value,
        last_log_by = p_last_log_by
    WHERE system_setting_id = p_system_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteSystemSetting(IN p_system_setting_id INT)
BEGIN
   DELETE FROM system_setting WHERE system_setting_id = p_system_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedures */

CREATE PROCEDURE getSystemSetting(IN p_system_setting_id INT)
BEGIN
	SELECT * FROM system_setting
	WHERE system_setting_id = p_system_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateSystemSettingTable()
BEGIN
    SELECT system_setting_id, system_setting_name, system_setting_description, value
    FROM system_setting
    ORDER BY system_setting_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */