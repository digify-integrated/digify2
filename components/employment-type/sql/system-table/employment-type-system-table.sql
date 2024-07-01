/* Employment Type Table */

CREATE TABLE employment_type (
    employment_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employment_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employment_type_index_employment_type_id ON employment_type(employment_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */