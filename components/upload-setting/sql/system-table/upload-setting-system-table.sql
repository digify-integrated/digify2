/* Upload Setting Table */

CREATE TABLE upload_setting(
	upload_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	upload_setting_name VARCHAR(100) NOT NULL,
	upload_setting_description VARCHAR(200) NOT NULL,
	max_file_size DOUBLE NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX upload_setting_index_upload_setting_id ON upload_setting(upload_setting_id);

INSERT INTO upload_setting (upload_setting_id, upload_setting_name, upload_setting_description, max_file_size, last_log_by) VALUES
(1, 'App Logo', 'Sets the upload setting when uploading app logo.', 800, 1),
(2, 'Internal Notes Attachment', 'Sets the upload setting when uploading internal notes attachement.', 800, 1),
(3, 'Employee Image', 'Sets the upload setting when uploading employee image.', 800, 2),
(4, 'Employee ID Record', 'Sets the upload setting when uploading employee ID record.', 800, 2),
(5, 'Website Elements Images', 'Sets the upload setting when uploading website elements image.', 500, 2);


/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Upload Setting File Extension Table */

CREATE TABLE upload_setting_file_extension(
    upload_setting_file_extension_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	upload_setting_id INT UNSIGNED NOT NULL,
	upload_setting_name VARCHAR(100) NOT NULL,
	file_extension_id INT UNSIGNED NOT NULL,
	file_extension_name VARCHAR(100) NOT NULL,
	file_extension VARCHAR(10) NOT NULL,
	date_assigned DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
	FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX upload_setting_file_ext_index_upload_setting_file_extension_id ON upload_setting_file_extension(upload_setting_file_extension_id);
CREATE INDEX upload_setting_file_ext_index_upload_setting_id ON upload_setting_file_extension(upload_setting_id);
CREATE INDEX upload_setting_file_ext_index_file_extension_id ON upload_setting_file_extension(file_extension_id);

INSERT INTO upload_setting_file_extension (upload_setting_file_extension_id, upload_setting_id, upload_setting_name, file_extension_id, file_extension_name, file_extension, last_log_by) VALUES
(1, 1, 'App Logo', 63, 'PNG', 'png', 1),
(2, 1, 'App Logo', 61, 'JPG', 'jpg', 1),
(3, 1, 'App Logo', 62, 'JPEG', 'jpeg', 1),
(4, 2, 'Internal Notes Attachment', 63, 'PNG', 'png', 1),
(5, 2, 'Internal Notes Attachment', 61, 'JPG', 'jpg', 1),
(6, 2, 'Internal Notes Attachment', 62, 'JPEG', 'jpeg', 1),
(7, 2, 'Internal Notes Attachment', 127, 'PDF', 'pdf', 1),
(8, 2, 'Internal Notes Attachment', 125, 'DOC', 'doc', 1),
(9, 2, 'Internal Notes Attachment', 125, 'DOCX', 'docx', 1),
(10, 2, 'Internal Notes Attachment', 130, 'TXT', 'txt', 1),
(11, 2, 'Internal Notes Attachment', 92, 'XLS', 'xls', 1),
(12, 2, 'Internal Notes Attachment', 94, 'XLSX', 'xlsx', 1),
(13, 2, 'Internal Notes Attachment', 89, 'PPT', 'ppt', 1),
(14, 2, 'Internal Notes Attachment', 90, 'PPTX', 'pptx', 1),
(15, 3, 'Employee Image', 62, 'JPEG', 'jpeg', 2),
(16, 3, 'Employee Image', 61, 'JPG', 'jpg', 2),
(17, 3, 'Employee Image', 63, 'PNG', 'png', 2),
(19, 4, 'Employee ID Record', 62, 'JPEG', 'jpeg', 2),
(20, 4, 'Employee ID Record', 61, 'JPG', 'jpg', 2),
(21, 4, 'Employee ID Record', 63, 'PNG', 'png', 2),
(22, 5, 'Website Elements Images', 62, 'JPEG', 'jpeg', 2),
(23, 5, 'Website Elements Images', 61, 'JPG', 'jpg', 2),
(24, 5, 'Website Elements Images', 63, 'PNG', 'png', 2),
(25, 5, 'Website Elements Images', 66, 'SVG', 'svg', 2);

/* ----------------------------------------------------------------------------------------------------------------------------- */