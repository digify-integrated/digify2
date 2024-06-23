/* System Action Table */

CREATE TABLE system_action(
	system_action_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	system_action_name VARCHAR(100) NOT NULL,
	system_action_description VARCHAR(200) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX system_action_index_system_action_id ON system_action(system_action_id);

INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Update System Settings', 'Access to update the system settings.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Update Security Settings', 'Access to update the security settings.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Activate User Account', 'Access to activate the user account.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Deactivate User Account', 'Access to deactivate the user account.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Lock User Account', 'Access to lock the user account.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Unlock User Account', 'Access to unlock the user account.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Add Role User Account', 'Access to assign roles to user account.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Delete Role User Account', 'Access to delete roles to user account.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Add Role Access', 'Access to add role access.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Update Role Access', 'Access to update role access.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Delete Role Access', 'Access to delete role access.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Add Role System Action Access', 'Access to add the role system action access.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Update Role System Action Access', 'Access to update the role system action access.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Delete Role System Action Access', 'Access to delete the role system action access.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Add File Extension Access', 'Access to assign the file extension to the upload setting.', '1');
INSERT INTO system_action (system_action_name, system_action_description, last_log_by) VALUES ('Delete File Extension Access', 'Access to delete the file extension to the upload setting.', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */