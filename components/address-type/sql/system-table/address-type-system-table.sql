/* Address Type Table */

CREATE TABLE address_type (
    address_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    address_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX address_type_index_address_type_id ON address_type(address_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */