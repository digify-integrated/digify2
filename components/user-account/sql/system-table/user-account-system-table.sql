/* Users Table */

CREATE TABLE user_account (
    user_account_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    file_as VARCHAR(300) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(500) NULL,
    locked VARCHAR(5) NOT NULL DEFAULT 'No',
    active VARCHAR(5) NOT NULL DEFAULT 'No',
    last_failed_login_attempt DATETIME,
    failed_login_attempts INT NOT NULL DEFAULT 0,
    last_connection_date DATETIME,
    password_expiry_date DATE NOT NULL,
    reset_token VARCHAR(255),
    reset_token_expiry_date DATETIME,
    receive_notification VARCHAR(5) NOT NULL DEFAULT 'Yes',
    two_factor_auth VARCHAR(5) NOT NULL DEFAULT 'Yes',
    otp VARCHAR(255),
    otp_expiry_date DATETIME,
    failed_otp_attempts INT NOT NULL DEFAULT 0,
    last_password_change DATETIME,
    account_lock_duration INT NOT NULL DEFAULT 0,
    last_password_reset DATETIME,
    multiple_session VARCHAR(5) DEFAULT 'Yes',
    session_token VARCHAR(255),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX user_account_index_user_account_id ON user_account(user_account_id);
CREATE INDEX user_account_index_email ON user_account(email);

INSERT INTO user_account (file_as, email, password, locked, active, password_expiry_date, two_factor_auth, last_log_by) VALUES ('CGMI Bot', 'cgmids@christianmotors.ph', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', 'No', 'Yes', '2025-12-30', 'No', '1');
INSERT INTO user_account (file_as, email, password, locked, active, password_expiry_date, two_factor_auth, last_log_by) VALUES ('Administrator', 'lawrenceagulto.317@gmail.com', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', 'No', 'Yes', '2025-12-30', 'No', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Password History Table */

CREATE TABLE password_history (
    password_history_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_account_id INT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    password_change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id)
);

CREATE INDEX password_history_index_password_history_id ON password_history(password_history_id);
CREATE INDEX password_history_index_user_account_id ON password_history(user_account_id);
CREATE INDEX password_history_index_email ON password_history(email);

/* ----------------------------------------------------------------------------------------------------------------------------- */