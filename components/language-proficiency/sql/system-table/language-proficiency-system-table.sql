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

INSERT INTO language_proficiency (language_proficiency_id, language_proficiency_name, language_proficiency_description, last_log_by)
VALUES 
(1, 'Native', 'Fluent in the language, spoken at home', 1),
(2, 'Fluent', 'Able to communicate effectively and accurately in most formal and informal conversations', 1),
(3, 'Advanced', 'Able to communicate effectively and accurately in most formal and informal conversations, with some difficulty in complex situations', 1),
(4, 'Intermediate', 'Able to communicate in everyday situations, with some difficulty in formal conversations', 1),
(5, 'Basic', 'Able to communicate in very basic situations, with difficulty in everyday conversations', 1),
(6, 'Non-proficient', 'No knowledge of the language', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */