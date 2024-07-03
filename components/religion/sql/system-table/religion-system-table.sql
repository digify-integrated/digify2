/* Religion Table */

CREATE TABLE religion (
    religion_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    religion_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX religion_index_religion_id ON religion(religion_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */