/* ID Type Table */

CREATE TABLE id_type (
    id_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    id_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX id_type_index_id_type_id ON id_type(id_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */