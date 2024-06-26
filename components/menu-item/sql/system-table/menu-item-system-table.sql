/* Menu Item Table */

CREATE TABLE menu_item (
    menu_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    menu_item_name VARCHAR(100) NOT NULL,
    menu_item_url VARCHAR(50),
	menu_item_icon VARCHAR(50),
    menu_group_id INT UNSIGNED NOT NULL,
    menu_group_name VARCHAR(100) NOT NULL,
    app_module_id INT UNSIGNED NOT NULL,
    app_module_name VARCHAR(100) NOT NULL,
	parent_id INT UNSIGNED,
    parent_name VARCHAR(100),
    order_sequence TINYINT(10) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id),
    FOREIGN KEY (menu_group_id) REFERENCES menu_group(menu_group_id),
    FOREIGN KEY (app_module_id) REFERENCES app_module(app_module_id)
);

CREATE INDEX menu_item_index_menu_item_id ON menu_item(menu_item_id);
CREATE INDEX menu_item_index_app_module_id ON menu_item(app_module_id);


INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('App Module', 'app-module.php', 'ti ti-box', 1, 'Technical', 1, 'Settings', '', '', 1, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('General Settings', 'general-settings.php', 'ti ti-settings', 1, 'Technical', 1, 'Settings', '', '', 7, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Users & Companies', '', 'ti ti-users', 2, 'Administration', 1, 'Settings', '', '', 21, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('User Account', 'user-account.php', '', 2, 'Administration', 1, 'Settings', 3, 'Users & Companies', 21, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Company', 'company.php', '', 2, 'Administration', 1, 'Settings', 3, 'Users & Companies', 3, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Role', 'role.php', 'ti ti-hierarchy-2', 2, 'Administration', 1, 'Settings', '', '', 3, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('User Interface', '', 'ti ti-layout-sidebar', 1, 'Technical', 1, 'Settings', '', '', 16, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Menu Group', 'menu-group.php', '', 1, 'Technical', 1, 'Settings', 7, 'User Interface', 1, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Menu Item', 'menu-item.php', '', 1, 'Technical', 1, 'Settings', 7, 'User Interface', 2, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('System Action', 'system-action.php', '', 1, 'Technical', 1, 'Settings', 7, 'User Interface', 2, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Localization', '', 'ti ti-map-pin', 1, 'Technical', 1, 'Settings', '', '', 12, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('City', 'city.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 12, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Country', 'country.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 13, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('State', 'state.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 19, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Currency', 'currency.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 14, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('File Configuration', '', 'ti ti-file-symlink', 1, 'Technical', 1, 'Settings', '', '', 6, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Upload Setting', 'upload-setting.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 21, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('File Type', 'file-type.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 6, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('File Extension', 'file-extension.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 7, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Email Setting', 'email-setting.php', 'ti ti-mail-forward', 1, 'Technical', 1, 'Settings', '', '', 5, 1);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('Notification Setting', 'notification-setting.php', 'ti ti-bell', 1, 'Technical', 1, 'Settings', '', '', 14, 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */