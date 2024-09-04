/* Educational Stage Table */

CREATE TABLE educational_stage (
    educational_stage_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    educational_stage_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX educational_stage_index_educational_stage_id ON educational_stage(educational_stage_id);

INSERT INTO educational_stage (educational_stage_id, educational_stage_name, last_log_by)
VALUES 
(1, 'Primary Education', 1),
(2, 'Middle School', 1),
(3, 'High School', 1),
(4, 'Diploma', 1),
(5, 'Bachelor', 1),
(6, 'Master', 1),
(7, 'Doctorate', 1),
(8, 'Post-Doctorate', 1),
(9, 'Vocational Training', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */