/* Role Table */

CREATE TABLE role(
	role_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	role_description VARCHAR(200) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_index_role_id ON role(role_id);

INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Administrator', 'Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Role Permission Table */

CREATE TABLE role_permission(
	role_permission_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_id INT UNSIGNED NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	menu_item_id INT UNSIGNED NOT NULL,
	menu_item_name VARCHAR(100) NOT NULL,
	read_access TINYINT(1) NOT NULL DEFAULT 0,
    write_access TINYINT(1) NOT NULL DEFAULT 0,
    create_access TINYINT(1) NOT NULL DEFAULT 0,
    delete_access TINYINT(1) NOT NULL DEFAULT 0,
    date_assigned DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES menu_item(menu_item_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_permission_index_role_permission_id ON role_permission(role_permission_id);
CREATE INDEX role_permission_index_menu_item_id ON role_permission(menu_item_id);
CREATE INDEX role_permission_index_role_id ON role_permission(role_id);

INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, last_log_by) VALUES (1, 'Administrator', 1, 'General Setting', 1, 0, 0, 0, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, last_log_by) VALUES (1, 'Administrator', 2, 'Users & Companies', 1, 0, 0, 0, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, last_log_by) VALUES (1, 'Administrator', 2, 'User Account', 1, 1, 1, 1, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, last_log_by) VALUES (1, 'Administrator', 2, 'Company', 1, 1, 1, 1, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Role System Action Permission Table */

CREATE TABLE role_system_action_permission(
	role_system_action_permission_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_id INT UNSIGNED NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	system_action_id INT UNSIGNED NOT NULL,
	system_action_name VARCHAR(100) NOT NULL,
	system_action_access TINYINT(1) NOT NULL DEFAULT 0,
    date_assigned DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (system_action_id) REFERENCES system_action(system_action_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_system_action_permission_index_system_action_permission_id ON role_system_action_permission(role_system_action_permission_id);
CREATE INDEX role_system_action_permission_index_system_action_id ON role_system_action_permission(system_action_id);
CREATE INDEX role_system_action_permissionn_index_role_id ON role_system_action_permission(role_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Role User Account Table */

CREATE TABLE role_user_account(
	role_user_account_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_id INT UNSIGNED NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	user_account_id INT UNSIGNED NOT NULL,
	file_as VARCHAR(300) NOT NULL,
    date_assigned DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_user_account_index_role_user_account_id ON role_user_account(role_user_account_id);
CREATE INDEX role_user_account_permission_index_user_account_id ON role_user_account(user_account_id);
CREATE INDEX role_user_account_permissionn_index_role_id ON role_user_account(role_id);

INSERT INTO role_user_account (role_id, role_name, user_account_id, file_as, last_log_by) VALUES (1, 'Administrator', 2, 'Administrator', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */