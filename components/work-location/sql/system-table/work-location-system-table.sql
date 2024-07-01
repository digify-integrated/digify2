/* Work Location Table */

CREATE TABLE work_location (
    work_location_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    work_location_name VARCHAR(100) NOT NULL,
    address VARCHAR(500) NOT NULL,
    city_id INT UNSIGNED NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    state_id INT UNSIGNED NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    phone VARCHAR(50),
    mobile VARCHAR(50),
    email VARCHAR(500),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX work_location_index_work_location_id ON work_location(work_location_id);
CREATE INDEX work_location_index_city_id ON work_location(city_id);
CREATE INDEX work_location_index_state_id ON work_location(state_id);
CREATE INDEX work_location_index_country_id ON work_location(country_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */