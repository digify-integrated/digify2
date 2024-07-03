/* Gender Table */

CREATE TABLE gender (
    gender_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    gender_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX gender_index_gender_id ON gender(gender_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */