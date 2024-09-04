/* Departure Reason Table */

CREATE TABLE departure_reason (
    departure_reason_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    departure_reason_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX departure_reason_index_departure_reason_id ON departure_reason(departure_reason_id);

INSERT INTO departure_reason (departure_reason_id, departure_reason_name, last_log_by)
VALUES 
(1, 'Resigned', 1),
(2, 'Terminated', 1),
(3, 'Retired', 1),
(4, 'Laid Off', 1),
(5, 'End of Contract', 1),
(6, 'Redundancy', 1),
(7, 'Death', 1),
(8, 'Disability', 1),
(9, 'Pregnancy', 1),
(10, 'Maternity Leave', 1),
(11, 'Paternity Leave', 1),
(12, 'Study Leave', 1),
(13, 'Sabbatical', 1),
(14, 'Career Break', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */