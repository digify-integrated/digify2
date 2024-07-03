/* Civil Status Table */

CREATE TABLE civil_status (
    civil_status_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    civil_status_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX civil_status_index_civil_status_id ON civil_status(civil_status_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */