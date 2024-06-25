/* File Extension Table */

CREATE TABLE file_extension (
    file_extension_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    file_extension_name VARCHAR(100) NOT NULL,
    file_extension VARCHAR(10) NOT NULL,
    file_type_id INT NOT NULL,
    file_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX file_extension_index_file_extension_id ON file_extension(file_extension_id);
CREATE INDEX file_extension_index_file_type_id ON file_extension(file_type_id);

INSERT INTO file_extension (file_extension_name, file_extension, file_type_id, file_type_name, last_log_by) VALUES ('PNG', 'png', 1, 'Image', 1);
INSERT INTO file_extension (file_extension_name, file_extension, file_type_id, file_type_name, last_log_by) VALUES ('JPG', 'jpg', 1, 'Image', 1);
INSERT INTO file_extension (file_extension_name, file_extension, file_type_id, file_type_name, last_log_by) VALUES ('JPEG', 'jpeg', 1, 'Image', 1);
INSERT INTO file_extension (file_extension_name, file_extension, file_type_id, file_type_name, last_log_by) VALUES ('PDF', 'pdf', 2, 'Document', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */