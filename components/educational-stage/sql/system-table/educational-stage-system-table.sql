/* Educational Stage Table */

CREATE TABLE educational_stage (
    educational_stage_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    educational_stage_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX educational_stage_index_educational_stage_id ON educational_stage(educational_stage_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */