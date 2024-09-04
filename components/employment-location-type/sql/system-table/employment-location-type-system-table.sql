/* Employment Location Type Table */

CREATE TABLE employment_location_type (
    employment_location_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employment_location_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employment_location_type_index_employment_location_type_id ON employment_location_type(employment_location_type_id);

INSERT INTO employment_location_type (employment_location_type_id, employment_location_type_name, last_log_by)
VALUES 
(1, 'Head Office', 1),
(2, 'Branch Office', 1),
(3, 'Remote Work', 1),
(4, 'Client Site', 1),
(5, 'Factory', 1),
(6, 'Warehouse', 1),
(7, 'Retail Store', 1),
(8, 'Home Office', 1),
(9, 'Field Work', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */