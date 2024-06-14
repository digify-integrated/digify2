/* App Module Table */

CREATE TABLE app_module (
    app_module_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    app_module_name VARCHAR(100) NOT NULL,
    app_module_description VARCHAR(500) NOT NULL,
    app_logo VARCHAR(500),
    app_version VARCHAR(50) NOT NULL DEFAULT '1.0.0',
    menu_item_id INT UNSIGNED NOT NULL,
    order_sequence TINYINT(10) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX app_module_index_app_module_id ON app_module(app_module_id);
CREATE INDEX app_module_index_menu_item_id ON app_module(menu_item_id);

INSERT INTO app_module (app_module_name, app_module_description, app_logo, menu_item_id, order_sequence, last_log_by) VALUES ('Settings', 'Centralized management hub for comprehensive organizational oversight and control', './components/app-module/image/logo/1/setting.png', 1, 100, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */