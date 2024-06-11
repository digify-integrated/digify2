DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkLoginCredentialsExist(IN p_user_account_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getLoginCredentials(IN p_user_account_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END //

CREATE PROCEDURE getPasswordHistory(IN p_user_account_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM password_history
	WHERE user_account_id = p_user_account_id OR email = BINARY p_email;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateLoginAttempt(IN p_user_account_id INT, IN p_failed_login_attempts INT, IN p_last_failed_login_attempt DATETIME)
BEGIN
	UPDATE user_account 
    SET failed_login_attempts = p_failed_login_attempts, last_failed_login_attempt = p_last_failed_login_attempt
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateAccountLock(IN p_user_account_id INT, IN p_locked VARCHAR(5), IN p_account_lock_duration INT)
BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateOTP(IN p_user_account_id INT, IN p_otp VARCHAR(255), IN p_otp_expiry_date DATETIME)
BEGIN
	UPDATE user_account 
    SET otp = p_otp, otp_expiry_date = p_otp_expiry_date, failed_otp_attempts = 0
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateLastConnection(IN p_user_account_id INT, IN p_session_token VARCHAR(255), IN p_last_connection_date DATETIME)
BEGIN
	UPDATE user_account 
    SET session_token = p_session_token, last_connection_date = p_last_connection_date
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateFailedOTPAttempts(IN p_user_account_id INT, IN p_failed_otp_attempts INT)
BEGIN
	UPDATE user_account 
    SET failed_otp_attempts = p_failed_otp_attempts
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateOTPAsExpired(IN p_user_account_id INT, IN p_otp_expiry_date DATETIME)
BEGIN
	UPDATE user_account 
    SET otp_expiry_date = p_otp_expiry_date
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateResetToken(IN p_user_account_id INT, IN p_reset_token VARCHAR(255), IN p_reset_token_expiry_date DATETIME)
BEGIN
	UPDATE user_account 
    SET reset_token = p_reset_token, reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateUserPassword(IN p_user_account_id INT, IN p_email VARCHAR(255), IN p_password VARCHAR(255), IN p_password_expiry_date DATE)
BEGIN
	UPDATE user_account 
    SET password = p_password, 
        password_expiry_date = p_password_expiry_date, 
        last_password_change = NOW(), 
        locked = 'No',
        failed_login_attempts = 0, 
        account_lock_duration = 0,
        last_log_by = p_user_account_id
    WHERE p_user_account_id = user_account_id OR email = BINARY p_email;
END //

CREATE PROCEDURE updateResetTokenAsExpired(IN p_user_account_id INT, IN p_reset_token_expiry_date DATETIME)
BEGIN
	UPDATE user_account 
    SET reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertPasswordHistory(IN p_user_account_id INT, IN p_email VARCHAR(255), IN p_password VARCHAR(255))
BEGIN
    INSERT INTO password_history (user_account_id, email, password, password_change_date) 
    VALUES (p_user_account_id, p_email, p_password, NOW());
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */