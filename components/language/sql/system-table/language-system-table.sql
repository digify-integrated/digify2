/* Language Table */

CREATE TABLE language (
    language_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    language_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX language_index_language_id ON language(language_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */