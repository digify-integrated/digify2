/* Schedule Type Table */

CREATE TABLE schedule_type (
    schedule_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    schedule_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX schedule_type_index_schedule_type_id ON schedule_type(schedule_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */