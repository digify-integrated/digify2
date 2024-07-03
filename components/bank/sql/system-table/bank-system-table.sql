/* Bank Table */

CREATE TABLE bank (
    bank_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    bank_identifier_code VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX bank_index_bank_id ON bank(bank_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */