/* Departure Reasons Table */

CREATE TABLE employment_types (
    employment_types_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employment_types_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employment_types_index_employment_types_id ON employment_types(employment_types_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */