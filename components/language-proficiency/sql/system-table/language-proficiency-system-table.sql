/* Language Proficiency Table */

CREATE TABLE language_proficiency (
    language_proficiency_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    language_proficiency_name VARCHAR(100) NOT NULL,
    language_proficiency_description VARCHAR(200) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX language_proficiency_index_language_proficiency_id ON language_proficiency(language_proficiency_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */