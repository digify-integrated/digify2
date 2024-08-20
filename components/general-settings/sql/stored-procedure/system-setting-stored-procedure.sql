DELIMITER //

/* Update Stored Procedure */

CREATE PROCEDURE updateSystemSetting(IN p_allow_registration VARCHAR(5), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE system_setting
    SET value = p_allow_registration,
        last_log_by = p_last_log_by
    WHERE system_setting_id = 1;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedures */

CREATE PROCEDURE getSystemSetting(IN p_system_setting_id INT)
BEGIN
	SELECT * FROM system_setting
	WHERE system_setting_id = p_system_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */