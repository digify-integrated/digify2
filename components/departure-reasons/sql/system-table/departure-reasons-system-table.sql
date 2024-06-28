/* Departure Reasons Table */

CREATE TABLE departure_reasons (
    departure_reasons_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    departure_reasons_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX departure_reasons_index_departure_reasons_id ON departure_reasons(departure_reasons_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */