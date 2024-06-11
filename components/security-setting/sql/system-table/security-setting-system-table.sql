/* Security Setting Table */

CREATE TABLE security_setting(
	security_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	security_setting_name VARCHAR(100) NOT NULL,
	security_setting_description VARCHAR(200) NOT NULL,
	value VARCHAR(1000) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX security_setting_index_security_setting_id ON security_setting(security_setting_id);

INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Max Failed Login Attempt', 'This sets the maximum failed login attempt before the user is locked-out.', 5, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Max Failed OTP Attempt', 'This sets the maximum failed OTP attempt before the user is needs a new OTP code.', 5, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Default Forgot Password Link', 'This sets the default forgot password link.', 'http://localhost/modernize/password-reset.php?id=', '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Password Expiry Duration', 'The duration after which user passwords expire (in days).', 180, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Session Timeout Duration', 'The duration after which a user is automatically logged out (in minutes).', 240, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('OTP Duration', 'The time window during which a one-time password (OTP) is valid for user authentication (in minutes).', 5, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Reset Password Token Duration', 'The time window during which a reset password token remains valid for user account recovery (in minutes).', 10, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */