/* Work Schedule Table */

CREATE TABLE work_schedule (
    work_schedule_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    work_schedule_name VARCHAR(100) NOT NULL,
    schedule_type_id INT UNSIGNED NOT NULL,
    schedule_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id),
    FOREIGN KEY (schedule_type_id) REFERENCES schedule_type(schedule_type_id)
);

CREATE INDEX work_schedule_index_work_schedule_id ON work_schedule(work_schedule_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */