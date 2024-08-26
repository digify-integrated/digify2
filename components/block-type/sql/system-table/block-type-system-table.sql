/* Block Type Table */

CREATE TABLE block_type (
    block_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    block_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX block_type_index_block_type_id ON block_type(block_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */