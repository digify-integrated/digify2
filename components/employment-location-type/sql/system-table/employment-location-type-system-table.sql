/* Employment Location Type Table */

CREATE TABLE employment_location_type (
    employment_location_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employment_location_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employment_location_type_index_employment_location_type_id ON employment_location_type(employment_location_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */