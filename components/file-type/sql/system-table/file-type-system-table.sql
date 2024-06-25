/* File Type Table */

CREATE TABLE file_type(
	file_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	file_type_name VARCHAR(100) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX file_type_index_file_type_id ON file_type(file_type_id);

INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Image', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Document', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */