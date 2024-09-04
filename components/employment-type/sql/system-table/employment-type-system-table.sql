/* Employment Type Table */

CREATE TABLE employment_type (
    employment_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employment_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employment_type_index_employment_type_id ON employment_type(employment_type_id);

INSERT INTO employment_type (employment_type_id, employment_type_name, last_log_by)
VALUES 
(1, 'Full-time', 1),
(2, 'Part-time', 1),
(3, 'Contract', 1),
(4, 'Internship', 1),
(5, 'Freelance', 1),
(6, 'Temporary', 1),
(7, 'Seasonal', 1),
(8, 'Apprenticeship', 1),
(9, 'Volunteer', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */