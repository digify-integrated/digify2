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

INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Administrator', 'Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', 1);
INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Customer', 'Customized access to system features and data, designed to meet the unique requirements and privileges of the Customer role.', 1);

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
    created_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES menu_item(menu_item_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_permission_index_role_permission_id ON role_permission(role_permission_id);
CREATE INDEX role_permission_index_menu_item_id ON role_permission(menu_item_id);
CREATE INDEX role_permission_index_role_id ON role_permission(role_id);

INSERT INTO role_permission (role_permission_id, role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, last_log_by) VALUES
(2, 1, 'Administrator', 1, 'App Module', 1, 1, 1, 1, 1),
(3, 1, 'Administrator', 2, 'General Settings', 1, 1, 1, 1, 1),
(4, 1, 'Administrator', 3, 'Users & Companies', 1, 0, 0, 0, 1),
(5, 1, 'Administrator', 4, 'User Account', 1, 1, 1, 1, 1),
(6, 1, 'Administrator', 5, 'Company', 1, 1, 1, 1, 1),
(7, 1, 'Administrator', 6, 'Role', 1, 1, 1, 1, 1),
(8, 1, 'Administrator', 7, 'User Interface', 1, 0, 0, 0, 1),
(9, 1, 'Administrator', 8, 'Menu Group', 1, 1, 1, 1, 1),
(10, 1, 'Administrator', 9, 'Menu Item', 1, 1, 1, 1, 1),
(11, 1, 'Administrator', 10, 'System Action', 1, 1, 1, 1, 1),
(12, 1, 'Administrator', 11, 'Localization', 1, 0, 0, 0, 1),
(13, 1, 'Administrator', 12, 'City', 1, 1, 1, 1, 1),
(14, 1, 'Administrator', 13, 'Country', 1, 1, 1, 1, 1),
(15, 1, 'Administrator', 14, 'State', 1, 1, 1, 1, 1),
(16, 1, 'Administrator', 15, 'Currency', 1, 1, 1, 1, 1),
(17, 1, 'Administrator', 16, 'File Configuration', 1, 0, 0, 0, 1),
(18, 1, 'Administrator', 17, 'Upload Setting', 1, 1, 1, 1, 1),
(19, 1, 'Administrator', 18, 'File Type', 1, 1, 1, 1, 1),
(20, 1, 'Administrator', 19, 'File Extension', 1, 1, 1, 1, 1),
(21, 1, 'Administrator', 20, 'Email Setting', 1, 1, 1, 1, 1),
(22, 1, 'Administrator', 21, 'Notification Setting', 1, 1, 1, 1, 1),
(23, 1, 'Administrator', 22, 'Account Setting', 1, 1, 0, 0, 1),
(24, 1, 'Administrator', 23, 'Employee', 1, 1, 1, 1, 1),
(25, 1, 'Administrator', 24, 'Department', 1, 1, 1, 1, 1),
(26, 1, 'Administrator', 25, 'Work Location', 1, 1, 1, 1, 1),
(27, 1, 'Administrator', 26, 'Work Schedule', 1, 1, 1, 1, 1),
(28, 1, 'Administrator', 27, 'Employment Type', 1, 1, 1, 1, 1),
(29, 1, 'Administrator', 28, 'Departure Reason', 1, 1, 1, 1, 1),
(30, 1, 'Administrator', 29, 'Job Position', 1, 1, 1, 1, 1),
(31, 1, 'Administrator', 30, 'Schedule Type', 1, 1, 1, 1, 1),
(32, 1, 'Administrator', 31, 'Scheduling', 1, 0, 0, 0, 1),
(33, 1, 'Administrator', 32, 'Contact Info Type', 1, 1, 1, 1, 1),
(34, 1, 'Administrator', 33, 'ID Type', 1, 1, 1, 1, 1),
(35, 1, 'Administrator', 34, 'Bank', 1, 1, 1, 1, 1),
(36, 1, 'Administrator', 35, 'Bank Account Type', 1, 1, 1, 1, 1),
(37, 1, 'Administrator', 36, 'Relation', 1, 1, 1, 1, 1),
(38, 1, 'Administrator', 37, 'Educational Stage', 1, 1, 1, 1, 1),
(39, 1, 'Administrator', 38, 'Language', 1, 1, 1, 1, 1),
(40, 1, 'Administrator', 39, 'Language Proficiency', 1, 1, 1, 1, 1),
(41, 1, 'Administrator', 40, 'Civil Status', 1, 1, 1, 1, 1),
(42, 1, 'Administrator', 41, 'Gender', 1, 1, 1, 1, 1),
(43, 1, 'Administrator', 42, 'Blood Type', 1, 1, 1, 1, 1),
(44, 1, 'Administrator', 43, 'Religion', 1, 1, 1, 1, 1),
(45, 1, 'Administrator', 44, 'Address Type', 1, 1, 1, 1, 1),
(46, 1, 'Administrator', 45, 'User Identity', 1, 0, 0, 0, 1),
(47, 1, 'Administrator', 46, 'Contact Information', 1, 0, 0, 0, 1),
(48, 1, 'Administrator', 47, 'Language Settings', 1, 0, 0, 0, 1),
(49, 1, 'Administrator', 48, 'Banking Configuration', 1, 0, 0, 0, 1),
(50, 1, 'Administrator', 49, 'Employment Location Type', 1, 1, 1, 1, 1),
(51, 1, 'Administrator', 50, 'Customer', 1, 1, 1, 1, 1),
(52, 1, 'Administrator', 51, 'My Addresses', 1, 1, 1, 1, 1),
(53, 1, 'Administrator', 52, 'Employee Address', 1, 1, 1, 1, 1),
(54, 2, 'Customer', 22, 'Account Setting', 1, 1, 1, 1, 1),
(55, 2, 'Customer', 51, 'My Addresses', 1, 1, 1, 1, 1),
(56, 2, 'Customer', 52, 'Employee Address', 1, 1, 1, 1, 1),
(57, 1, 'Administrator', 53, ' Banks & Cards', 1, 1, 1, 1, 1),
(58, 2, 'Customer', 53, ' Banks & Cards', 1, 1, 1, 1, 1),
(59, 1, 'Administrator', 54, 'Website', 1, 1, 1, 1, 1),
(60, 1, 'Administrator', 55, 'Block Type', 1, 1, 1, 1, 1),
(61, 1, 'Administrator', 56, 'Block Style', 1, 1, 1, 1, 1),
(62, 1, 'Administrator', 57, 'Accordion', 1, 1, 1, 1, 1),
(63, 1, 'Administrator', 58, 'Call to Action', 1, 1, 1, 1, 1),
(64, 1, 'Administrator', 59, 'Client Style', 1, 1, 1, 1, 1),
(65, 1, 'Administrator', 60, 'Client', 1, 1, 1, 1, 1),
(66, 1, 'Administrator', 61, 'Services Box Style', 1, 1, 1, 1, 1),
(67, 1, 'Administrator', 62, 'Pricing Table Style', 1, 1, 1, 1, 1),
(68, 1, 'Administrator', 64, 'Image Gallery Style', 1, 1, 1, 1, 1),
(69, 1, 'Administrator', 63, 'Contact Form Style', 1, 1, 1, 1, 1),
(70, 1, 'Administrator', 65, 'Process Step Style', 1, 1, 1, 1, 1),
(71, 1, 'Administrator', 66, 'Slider Style', 1, 1, 1, 1, 1),
(72, 1, 'Administrator', 67, 'Header Style', 1, 1, 1, 1, 1),
(73, 1, 'Administrator', 68, 'Footer Style', 1, 1, 1, 1, 1),
(74, 1, 'Administrator', 69, 'Page Title Style', 1, 1, 1, 1, 1),
(75, 1, 'Administrator', 70, 'Call To Action Style', 1, 1, 1, 1, 1),
(76, 1, 'Administrator', 71, 'Testimonial', 1, 1, 1, 1, 1),
(77, 1, 'Administrator', 72, 'Sections', 1, 1, 1, 1, 1),
(78, 1, 'Administrator', 73, 'My Bookings', 1, 1, 1, 1, 1),
(79, 1, 'Administrator', 74, 'Customer Inquiry', 1, 1, 1, 1, 1),
(80, 1, 'Administrator', 75, 'Vouchers', 1, 1, 1, 1, 1);


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
    created_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (system_action_id) REFERENCES system_action(system_action_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_system_action_permission_index_system_action_permission_id ON role_system_action_permission(role_system_action_permission_id);
CREATE INDEX role_system_action_permission_index_system_action_id ON role_system_action_permission(system_action_id);
CREATE INDEX role_system_action_permissionn_index_role_id ON role_system_action_permission(role_id);

INSERT INTO role_system_action_permission (role_system_action_permission_id, role_id, role_name, system_action_id, system_action_name, system_action_access, last_log_by) VALUES
(1, 1, 'Administrator', 1, 'Update System Settings', 1, 1),
(2, 1, 'Administrator', 2, 'Update Security Settings', 1, 1),
(3, 1, 'Administrator', 3, 'Activate User Account', 1, 1),
(4, 1, 'Administrator', 4, 'Deactivate User Account', 1, 1),
(5, 1, 'Administrator', 5, 'Lock User Account', 1, 1),
(6, 1, 'Administrator', 6, 'Unlock User Account', 1, 1),
(7, 1, 'Administrator', 7, 'Add Role User Account', 1, 1),
(8, 1, 'Administrator', 8, 'Delete Role User Account', 1, 1),
(9, 1, 'Administrator', 9, 'Add Role Access', 1, 1),
(10, 1, 'Administrator', 10, 'Update Role Access', 1, 1),
(11, 1, 'Administrator', 11, 'Delete Role Access', 1, 1),
(12, 1, 'Administrator', 12, 'Add Role System Action Access', 1, 1),
(13, 1, 'Administrator', 13, 'Update Role System Action Access', 1, 1),
(14, 1, 'Administrator', 14, 'Delete Role System Action Access', 1, 1),
(15, 1, 'Administrator', 15, 'Add File Extension Access', 1, 1),
(16, 1, 'Administrator', 16, 'Delete File Extension Access', 1, 1),
(17, 1, 'Administrator', 17, 'Add Work Hours', 1, 1),
(18, 1, 'Administrator', 18, 'Update Work Hours', 1, 1),
(19, 1, 'Administrator', 19, 'Delete Work Hours', 1, 1),
(20, 1, 'Administrator', 20, 'Archive Employee', 1, 1),
(21, 1, 'Administrator', 21, 'Unarchive Employee', 1, 1),
(22, 1, 'Administrator', 22, 'Archive Customer', 1, 1),
(23, 1, 'Administrator', 23, 'Unarchive Customer', 1, 1),
(24, 1, 'Administrator', 24, 'Send Registration Verification Link', 1, 1),
(25, 1, 'Administrator', 25, 'Verify User Registration', 1, 1),
(26, 1, 'Administrator', 26, 'Link User Account', 1, 1),
(27, 1, 'Administrator', 27, 'Unlink User Account', 1, 1),
(28, 1, 'Administrator', 28, 'Publish Website Element', 1, 1),
(29, 1, 'Administrator', 29, 'Unpublish Website Element', 1, 1),
(30, 1, 'Administrator', 30, 'Tag Customer Inquiry As In-Progress', 1, 1),
(31, 1, 'Administrator', 32, 'Tag Customer Inquiry As Closed', 1, 1),
(32, 1, 'Administrator', 31, 'Tag Customer Inquiry As Resolved', 1, 1);

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

INSERT INTO role_user_account (role_id, role_name, user_account_id, file_as, last_log_by) VALUES (1, 'Administrator', 2, 'Administrator', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */