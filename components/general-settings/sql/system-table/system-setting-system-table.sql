/* System Setting Table */

CREATE TABLE system_setting(
	system_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	system_setting_name VARCHAR(100) NOT NULL,
	system_setting_description VARCHAR(200) NOT NULL,
	value VARCHAR(1000) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX system_setting_index_system_setting_id ON system_setting(system_setting_id);

INSERT INTO system_setting (system_setting_name, value, last_log_by) VALUES ('Allow Registration', 'Yes', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */