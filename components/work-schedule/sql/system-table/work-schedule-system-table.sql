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

/* Work Hours Table */

CREATE TABLE work_hours (
    work_hours_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    work_schedule_id INT UNSIGNED NOT NULL,
    day_of_week VARCHAR(20),
    day_period VARCHAR(20),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    notes VARCHAR(500),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id),
    FOREIGN KEY (work_schedule_id) REFERENCES work_schedule(work_schedule_id)
);

CREATE INDEX work_hours_index_work_hours_id ON work_hours(work_hours_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */