/* User Account UI Setting Table */

CREATE TABLE ui_customization_setting(
	ui_customization_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	user_account_id INT UNSIGNED NOT NULL,
	sidebar_type VARCHAR(20) NOT NULL DEFAULT 'full',
	boxed_layout TINYINT(1) NOT NULL DEFAULT 0,
	theme VARCHAR(10) NOT NULL DEFAULT 'light',
	color_theme VARCHAR(20) NOT NULL DEFAULT 'Blue_Theme',
	card_border TINYINT(1) NOT NULL DEFAULT 0,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id),
	FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id)
);

CREATE INDEX ui_setting_index_ui_customization_setting_id ON ui_customization_setting(ui_customization_setting_id);
CREATE INDEX ui_setting_index_user_account_id ON ui_customization_setting(user_account_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */