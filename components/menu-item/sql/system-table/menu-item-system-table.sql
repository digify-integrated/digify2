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
    FOREIGN KEY (last_log_by) REFERENCES menu_group(menu_group_id),
    FOREIGN KEY (last_log_by) REFERENCES app_module(app_module_id)
);

CREATE INDEX menu_item_index_menu_item_id ON menu_item(menu_item_id);
CREATE INDEX menu_item_index_app_module_id ON menu_item(app_module_id);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) VALUES ('General Settings', 'general-settings.php', 'ti ti-settings', 1, 'Technical', 1, 'Settings', '', '', 21, 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */