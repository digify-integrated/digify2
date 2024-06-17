DELIMITER //

/* Update Stored Procedure */

CREATE PROCEDURE updateSecuritySetting(IN p_max_failed_login INT, IN p_max_failed_otp_attempt INT, IN p_password_expiry_duration INT, IN p_otp_duration INT, IN p_reset_password_token_duration INT, IN p_session_inactivity_limit INT, IN p_password_recovery_link VARCHAR(1000), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE security_setting
    SET value = p_max_failed_login,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 1;

    UPDATE security_setting
    SET value = p_max_failed_otp_attempt,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 2;

    UPDATE security_setting
    SET value = p_password_recovery_link,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 3;

    UPDATE security_setting
    SET value = p_password_expiry_duration,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 4;

    UPDATE security_setting
    SET value = p_session_inactivity_limit,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 5;

    UPDATE security_setting
    SET value = p_otp_duration,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 6;

    UPDATE security_setting
    SET value = p_reset_password_token_duration,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 7;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedures */

CREATE PROCEDURE getSecuritySetting(IN p_security_setting_id INT)
BEGIN
	SELECT * FROM security_setting
	WHERE security_setting_id = p_security_setting_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */