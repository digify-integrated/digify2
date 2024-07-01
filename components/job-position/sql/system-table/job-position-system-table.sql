/* Job Position Table */

CREATE TABLE job_position (
    job_position_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    job_position_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX job_position_index_job_position_id ON job_position(job_position_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */