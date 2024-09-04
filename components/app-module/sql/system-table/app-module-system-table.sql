/* App Module Table */

CREATE TABLE app_module (
    app_module_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    app_module_name VARCHAR(100) NOT NULL,
    app_module_description VARCHAR(500) NOT NULL,
    app_logo VARCHAR(500),
    app_version VARCHAR(50) NOT NULL DEFAULT '1.0.0',
    menu_item_id INT UNSIGNED NOT NULL,
    menu_item_name VARCHAR(100) NOT NULL,
    order_sequence TINYINT(10) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX app_module_index_app_module_id ON app_module(app_module_id);
CREATE INDEX app_module_index_menu_item_id ON app_module(menu_item_id);

INSERT INTO app_module (app_module_id, app_module_name, app_module_description, app_logo, app_version, menu_item_id, menu_item_name, order_sequence, last_log_by) VALUES
(1, 'Settings', 'Centralized management hub for comprehensive organizational oversight and control', './components/app-module/image/logo/1/setting.png', '1.0.0', 22, 'Account Setting', 100, 1),
(2, 'Employees', 'Centralize employee information', './components/app-module/image/logo/2/kwDc.png', '1.0.0', 23, 'Inventory Overview', 1, 1),
(3, 'Customer', 'Bring all your customer information into one easy-to-access location', './components/app-module/image/logo/3/rL4r.png', '1.0.0', 50, 'Customer', 3, 1),
(4, 'Website Studio', 'Create and customize your website', './components/app-module/image/logo/4/TnX0.png', '1.0.0', 54, 'Websites', 1, 1),
(5, 'CRM', 'Track leads and close opportunities', './components/app-module/image/logo/5/CxLn.png', '1.0.0', 73, 'My Bookings', 3, 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */