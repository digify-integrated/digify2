/* Notification Setting Table */

CREATE TABLE notification_setting(
	notification_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	notification_setting_name VARCHAR(100) NOT NULL,
	notification_setting_description VARCHAR(200) NOT NULL,
	system_notification INT(1) NOT NULL DEFAULT 1,
	email_notification INT(1) NOT NULL DEFAULT 0,
	sms_notification INT(1) NOT NULL DEFAULT 0,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX notification_setting_index_notification_setting_id ON notification_setting(notification_setting_id);

CREATE TABLE notification_setting_email_template(
	notification_setting_email_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	notification_setting_id INT UNSIGNED NOT NULL,
	email_notification_subject VARCHAR(200) NOT NULL,
	email_notification_body LONGTEXT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (notification_setting_id) REFERENCES notification_setting(notification_setting_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX notification_setting_email_index_notification_setting_email_id ON notification_setting_email_template(notification_setting_email_id);
CREATE INDEX notification_setting_email_index_notification_setting_id ON notification_setting_email_template(notification_setting_id);

CREATE TABLE notification_setting_system_template(
	notification_setting_system_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	notification_setting_id INT UNSIGNED NOT NULL,
	system_notification_title VARCHAR(200) NOT NULL,
	system_notification_message VARCHAR(500) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (notification_setting_id) REFERENCES notification_setting(notification_setting_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX notification_setting_system_index_notification_setting_system_id ON notification_setting_system_template(notification_setting_system_id);
CREATE INDEX notification_setting_system_index_notification_setting_id ON notification_setting_system_template(notification_setting_id);

CREATE TABLE notification_setting_sms_template(
	notification_setting_sms_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	notification_setting_id INT UNSIGNED NOT NULL,
	sms_notification_message VARCHAR(500) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (notification_setting_id) REFERENCES notification_setting(notification_setting_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX notification_setting_sms_index_notification_setting_sms_id ON notification_setting_sms_template(notification_setting_sms_id);
CREATE INDEX notification_setting_sms_index_notification_setting_id ON notification_setting_sms_template(notification_setting_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */