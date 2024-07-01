/* Departure Reason Table */

CREATE TABLE departure_reason (
    departure_reason_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    departure_reason_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX departure_reason_index_departure_reason_id ON departure_reason(departure_reason_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */