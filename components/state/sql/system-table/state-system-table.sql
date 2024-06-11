/* State Table */

CREATE TABLE state (
    state_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX state_index_state_id ON state(state_id);
CREATE INDEX state_index_country_id ON state(country_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */