/* Blood Type Table */

CREATE TABLE blood_type (
    blood_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    blood_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX blood_type_index_blood_type_id ON blood_type(blood_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */